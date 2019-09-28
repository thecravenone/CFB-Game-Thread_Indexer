<?php

log_it("GTI run begining.");

$timerstart = microtime(true);		//Used for tracking generation time
require_once("phapper/src/phapper.php");	//Reddit API wrapper
$r = new Phapper();					//Reddit API wrapper
$now		= time();
$num_threads = 100;	//Number of threads to scrape. API defaults to 25. Max is 100.

//Setting up the database because I didn't document that shit
//$conn = new PDO('mysql:host=SOME_HOST;dbname=SOME_DATABASE', 'SOME_USER', 'SOME_PASSWORD');
require_once("database_connection.php");

//Setup week
$GET_WEEK=$conn->prepare("SELECT `VALUE` from `config` WHERE `setting` = 'week'");
$GET_WEEK->execute();
$week = $GET_WEEK->fetch()['0'];

//Figure out which thread to post to
$GET_WEEKLY_THREAD=$conn->prepare("SELECT `value` FROM `config` WHERE `setting` = :week");
$week_thread = "week" . $week . "thread";
$GET_WEEKLY_THREAD->bindParam(':week', $week_thread);
$GET_WEEKLY_THREAD->execute();
$thread = $GET_WEEKLY_THREAD->fetch()['0'];
$thread_name = "t3_" . $thread;


/****************************
Set up database queries
****************************/

//Get existing game threads
$GET_GAME_THREADS=$conn->prepare("SELECT `game` FROM `threads` WHERE `week` = :week");
//Adds a game to the database for the first time
$game_create		=$conn->prepare("INSERT INTO threads (`game`, `time`, `visitor`, `home`, `week`)
					VALUES (:game, :time, :visitor, :home, :week)");
//Locates games that are alreadya ssigned a postgame thread
$GET_POSTGAME_THREADS=$conn->prepare("SELECT `postgame` from `threads` WHERE `week` = :week AND `postgame` IS NOT NULL");
//Locates a game in the database by team names
$FIND_GAME_THREAD	=$conn->prepare("SELECT `game` from `threads` WHERE (`visitor` = :team1 AND `home` = :team2 AND `week` = :week)
					OR (`visitor` = :team2 AND `home` = :team1 AND `week` = :week)");
//Adds a postgame thread to a game
$postgame_update	=$conn->prepare("UPDATE threads SET `postgame` = :postgame WHERE `game` = :game");
//Retreive all known information for output
$GET_ALL_THREADS=$conn->prepare("SELECT `game`, `visitor`, `home`, `postgame` FROM `threads` WHERE `week` = :week ORDER BY `time` DESC");
// Interacting with the config table
// This was created for the Non-FBS thread but I'm making it generic for other possible future uses
$INSERT_CONFIG_VALUE=$conn->prepare("INSERT INTO config (`setting`, `value`) VALUES (:setting, :value)");
$GET_CONFIG_VALUE	=$conn->prepare("SELECT `value` FROM `config` WHERE `setting` = :setting");

//Load existing threads into array
$GET_GAME_THREADS->bindParam(':week', $week);
$GET_GAME_THREADS->execute();
$GAME_THREADS = $GET_GAME_THREADS->fetchAll();
$game_array = array();
foreach ($GAME_THREADS as $thread) {
	$to_insert = preg_replace("/t3_/", "", $thread['game']);
	$game_array[] = $to_insert;
}

//Load postgame threads into array
$GET_POSTGAME_THREADS->bindParam(':week', $week);
$GET_POSTGAME_THREADS->execute();
$POSTGAME_THREADS = $GET_POSTGAME_THREADS->fetchAll();
$postgame_array = array();


foreach ($POSTGAME_THREADS as $thread) {
	$to_insert = preg_replace("/t3_/", "", $thread['postgame']);
	$postgame_array[] = $to_insert;
}

//Scrape /r/CFB/new
$listing = $r->getNew("cfb", $num_threads, null, null);
$posts=$listing->data->children;

//Primary functionality loop
foreach ($posts as $thread) {
	//Pull this data into variables to make this easier to read
	$title		= $thread->data->title;
	$created	= $thread->data->created_utc;
	$id			= preg_replace("/t3_/", "", $thread->data->name);
	$url		= $thread->data->url;

	//Send thread through parser
	$parsed_title = parse_thread($title);
	//Game thread handling
	if($parsed_title->is_gamethread) {
		if (!in_array($id, $game_array)) {
			if ($created +300 <= $now) {
				//INSERT INTO DATABASE
				//$game_create		=$conn->prepare("INSERT INTO threads (`game`, `time`, `visitor`, `home`, `week`)
				//	VALUES (:game, :time, :visitor, :home, :week)");
				$game_create->bindParam(':game', $id);
				$game_create->bindParam(':time', $created);
				$game_create->bindParam(':visitor', $parsed_title->team1);
				$game_create->bindParam(':home', $parsed_title->team2);
				$game_create->bindParam(':week', $week);
				log_it("Added game thread https://redd.it/" . $id);
				$game_create->execute();
			}
		}
	//Postgame thread handling	
	} else if ($parsed_title->is_postgame) {
		if (!in_array($id, $postgame_array)) {
			if ($created +300 <= $now) {
				//$FIND_GAME_THREAD	=$conn->prepare("SELECT `game` from `threads` WHERE (`visitor` = :team1 AND `home` = :team2 AND `week` = :week)
				//	OR (`visitor` = :team2 AND `home` = :team1 AND `week` = :week)");
				$FIND_GAME_THREAD->bindParam(':team1', $parsed_title->team1);
				$FIND_GAME_THREAD->bindParam(':team2', $parsed_title->team2);
				$FIND_GAME_THREAD->bindParam(':week', $week);
				$FIND_GAME_THREAD->execute();
				$game = $FIND_GAME_THREAD->fetch()['game'];

				//$postgame_update	=$conn->prepare("UPDATE threads SET `postgame` = :postgame WHERE `game` = :game");
				$postgame_update->bindParam(':postgame', $id);
				$postgame_update->bindParam(':game', $game);
				$postgame_update->execute();
				log_it("Added postgame thread https://redd.it/" . $id);


			}
		}
	} else if ($parsed_title->other == "Non-FBS") {
		$setting_name = "week" . $week . "NonFBS";
		$GET_CONFIG_VALUE->bindParam(':setting', $setting_name);
		$GET_CONFIG_VALUE->execute();

		if($GET_CONFIG_VALUE->rowCount() == 0) {	// If the Non-FBS thread wasn't previously logged
			$INSERT_CONFIG_VALUE=$conn->prepare("INSERT INTO config (`setting`, `value`) VALUES (:setting, :value)");
			$INSERT_CONFIG_VALUE->bindParam(':setting', $setting_name);
			$INSERT_CONFIG_VALUE->execute();
			log_it("Added Non-FBS Thread: ". $id)
		}
		$NonFBS = $id;
	}
	// else { It's not a thread we care about unless further functionality is added }
}

//Preparing output
//Load all threads and info from DB into array
$GET_ALL_THREADS->bindParam(':week', $week);
$GET_ALL_THREADS->execute();
$all_threads = $GET_ALL_THREADS->fetchAll();

//print_r($all_threads); //DEBUG

//Create pre-table intro and table header
$output = "Scroll to bottom for FAQ.\n\n";

if(isset($NonFBS)) {	// Only link the non-FBS thread if it exists
	$output = $output . "Don't forget we have a weekly thread for Non-FBS Games! [[Click Here!]](/r/CFB/comments/" . $NonFBS . ")\n\n";
}

$output = $output . "|Visitor|Home|Game Thread|Postgame Thread|\n|-|-|-|-|\n";

//Generate rows
foreach ($all_threads as $this_one) {
	$output = $output . "| " . $this_one['visitor'] . " | " . $this_one['home'] . " | [GAME THREAD](/r/CFB/comments/" . 
		$this_one['game'] . ") | ";
	
	if ($this_one['postgame'] != NULL) {
		$output = $output . "[POSTGAME THREAD](/r/CFB/comments/" . $this_one['postgame'] . ") ";
		//TODO: Figure out how the official Reddit app works and change this URL to one it likes
	}
	$output = $output . "|\n";
}

$output =  $output . "\n\n";

//Create footer
$finish = microtime(true);
$generation_time = $finish - $timerstart;
$output = $output. "FAQ:\n\n" .
		"* Game threads are automatically posted one hour prior to the annouced kickoff time.\n" .
		"* Game threads must be 5 minutes old to be added. Postgame threads must be 5 minutes old. Script runs every 5 minutes, so it may take up to 10 minutes for a thread to appear.\n" .
		"* Table is sorted by game thread create time.\n" .
		"* I am unable to find a link format that works in all apps. I apologize if the links don't work in your app.\n" .
		"* If you see a problem, please contact us using modmail.\n\n";
$output = $output . "Generated in: " . $generation_time . " seconds\n\n";
$output = $output .  "Last updated: " . date('h:i:s T') . "\n\n";

//echo $output;	//DEBUG

$r->editText($thread_name, $output);
log_it("GIT run completed.");

/****************************
Parsing for thread titles
****************************/
class parsed_thread {
	public $is_gamethread;
	public $is_postgame;
	public $other;
	public $team1;
	public $team2;
	public $time;		//TODO: Add time to DB and output
	//public $score;	//TODO
}
function parse_thread ($thread_string){
	$obj_to_return = new parsed_thread();
	
	if (preg_match('/\[Game Thread\]/', $thread_string)) {	//If is game thread
		if (preg_match('/\[Game Thread\] \[Week [0-9]{1,2}\] Non-FBS Games/', $thread_string)) {	// Weekly Non-FBS Thread
			$obj_to_return->is_gamethread = false;
			$obj_to_return->is_postgame = false;
			$obj_to_return->other = "Non-FBS";
			return $obj_to_return;
		} else {
			$obj_to_return->is_gamethread = true;
			$obj_to_return->is_postgame = false;

			//Remove "[Game Thread] "
			$thread_string = substr($thread_string, strpos ($thread_string, "] ") + 2);

			//Pull team names, splitting at " @ " or " vs "
			if (preg_match('/@/', $thread_string)) {	//Non-neutral game
				$cut_at = strpos ($thread_string, " @ ");

				$obj_to_return->team1 = substr($thread_string, 0, $cut_at);
				$thread_string = substr($thread_string, $cut_at);
				$obj_to_return->team2 = substr($thread_string, 3, strpos($thread_string, "(") -4);
				$obj_to_return->time = substr($thread_string, strpos($thread_string, "(") +1, -1);
				return $obj_to_return;
			} else if (preg_match('/vs\./', $thread_string)) {
				$cut_at = strpos ($thread_string, " vs. ");
				$obj_to_return->team1 = substr($thread_string, 0, $cut_at);
				$thread_string = substr($thread_string, $cut_at);
				$obj_to_return->team2 = substr($thread_string, 5, strpos($thread_string, "(") -5);
				$obj_to_return->time = substr($thread_string, strpos($thread_string, "(") +1, -1);
				return $obj_to_return;
			}
		}	
	} else if (preg_match('/\[Postgame Thread\]/', $thread_string)) {	//If is post-game thread
		$obj_to_return->is_gamethread = false;
		$obj_to_return->is_postgame = true;

		//Remove "[Postgame Thread] "
		$thread_string = substr($thread_string, strpos ($thread_string, "] ") + 2);

		//Pull team names, splitting at " Defeats "
		$cut_at = strpos ($thread_string, " Defeats ");

		$obj_to_return->team1 = substr($thread_string, 0, $cut_at);
		$thread_string = substr($thread_string, $cut_at +9);
		$obj_to_return->team2 = preg_replace('/ [0-9]+-[0-9]+/', "", $thread_string);
		return $obj_to_return;
	} else {
		$obj_to_return->is_gamethread = false;
		$obj_to_return->is_postgame = false;
		return $obj_to_return;
	}
}

function log_it ($input){
	$now = date('Y-m-d G:i:s.v');
	echo $now . " " . $input . "\n";
}