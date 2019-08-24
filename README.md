# CFB-Game-Thread_Indexer

**Indexer for Game Threads and Postgame Threads on /r/CFB**

This code will be deprecated for the upcoming 2019 season for a variety of reasons. It's being posted now for posterity.

## How to use

### Setup

1. Add [Phapper](https://github.com/khicks/Phapper) to the directory at `./phapper`
2. Create a MySQL database as described in `dump.sql`
3. Update the DB to reflect the current week: `UPDATE config SET value = 'WEEK_NUMBER' WHERE setting = 'week';`
3. Configure your database access info in `database_connection.php` (there's a sample at `database_connection-SAMPLE.php`)
4. Configure the following crons. Don't forget to `>>` to a log file if you want logs!

```
# At 0400, increment what week of football it is
0 4 * * TUE python3 /path/to/handler.py --incrementweek

# At 1100 on Saturday, post the new thread and immediately run the scrape/update script
0 11 * * SAT python3 /path/to/handler.py --post && php /path/to/cron.php

# Every 5 minutes, scrape threads and update the index thread
*/5 * * * * php /path/to/cron.php
```

## How cron.php works

1. Load known game threads from the DB into an array
2. Load known post-game threads from the DB into an array
3. Scrape the last 100 threads from /r/CFB
4. If the thread is identified as a qualifying thread, parse it into home/visitor
5. Determine if the thread is one that is already known about. If it is not, add it to the database.
6. Load all threads from the database into one array
7. Output the header, array, and footer to a variable and post that variable to the Reddit API's `editText` function

## Things this script does not do

* Create the database (see `dump.sql` for a sample database)

## Other Caveats

* The API wrapper used for this script is [Phapper](https://github.com/khicks/Phapper), which is no longer maintained. Its creator's advice [is to use another language that has a working wrapper](https://www.reddit.com/r/redditdev/comments/9p7tb3/is_there_a_reddit_php_api_wrapper_that_actually/e7zx3ru/). This repo does not include the changes that must be made to the last version of Phapper for it to function properly.
* To be identified as a qualifying thread, the title must match the standard title format and the thread must be over five minutes old. This allows time for mods to remove threads that have been incorrectly posted and leaves a maximum lag time of 9:59.
* Home / Away is determined by team name order. For non-neutral site games, this always works as the format is `AWAY_TEAM @ HOME_TEAM`. For neutral site games, the Home / Away team is sometimes incorrect.
* This code was hurridly re-written from scratch in the week preceeding the 2018 season. If the code is terrible, that's why.
