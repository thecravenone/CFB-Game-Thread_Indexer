-- MySQL dump 10.13  Distrib 5.7.23, for Linux (x86_64)
--
-- Host: localhost    Database: game_thread_index
-- ------------------------------------------------------
-- Server version	5.7.23-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `setting` varchar(128) DEFAULT NULL,
  `value` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES ('week','5'),('thread',NULL);
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threads`
--

DROP TABLE IF EXISTS `threads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threads` (
  `game` varchar(6) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `visitor` varchar(64) DEFAULT NULL,
  `home` varchar(64) DEFAULT NULL,
  `postgame` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threads`
--

LOCK TABLES `threads` WRITE;
/*!40000 ALTER TABLE `threads` DISABLE KEYS */;
INSERT INTO `threads` VALUES ('9lgm8f',1538692210,'Georgia State','Troy','9lijxk'),('9lgurb',1538694017,'Tulsa','Houston','9lit31'),('9lhawd',1538697562,'Notre Dame (OH)','Fairmont State',NULL),('9lq75g',1538773211,'Dartmouth','Yale','9ls5dl'),('9lqq70',1538776810,'Georgia Tech','Louisville','9lshyq'),('9lqz8u',1538778611,'Middle Tennessee','Marshall','9lssaa'),('9lrm13',1538784010,'Utah State','BYU','9ltair'),('9lwkth',1538838159,'Holy Cross','New Hampshire','9lyitn'),('9lwkrp',1538838147,'Missouri','South Carolina','9lzms1'),('9lwkoi',1538838127,'Northwestern','Michigan State','9lyrj0'),('9lwkmw',1538838115,'Maryland','Michigan','9lz94l'),('9lwkki',1538838103,'Kansas','West Virginia','9lyn8l'),('9lwkif',1538838091,'ECU','Temple','9lykmc'),('9lwkgl',1538838079,'Tulane','Cincinnati','9lys36'),('9lwkeb',1538838067,'Illinois','Rutgers','9lyoxh'),('9lwkcd',1538838055,'Eastern Michigan','Western Michigan','9lysnv'),('9lwk94',1538838035,'Buffalo','Central Michigan','9lyo1p'),('9lwk6h',1538838023,'Alabama','Arkansas','9lyp05'),('9lwk44',1538838011,'Oklahoma','Texas ','9lyuw8'),('9lwplf',1538839209,'Syracuse','Pittsburgh',NULL),('9lws9f',1538839811,'Boston College','NC State','9lythn'),('9lwwei',1538840709,'San Diego','Morehead State','9lysdd'),('9lx0rk',1538841654,'CCSU','Robert Morris','9lzcdb'),('9lx0pg',1538841642,'Lehigh','Princeton','9lz4cv'),('9lx0lh',1538841622,'Brown','Rhode Island','9lyw2h'),('9lx0ir',1538841610,'Valparaiso','Dayton','9lyw65'),('9lx4w6',1538842510,'Marist','Columbia','9lz2gw'),('9lx96w',1538843422,'Harvard','Cornell','9lzcoh'),('9lx94i',1538843410,'Elon','James Madison','9lzhei'),('9lxhwp',1538845248,'North Dakota State','Northern Iowa','9lzoez'),('9lxhus',1538845236,'Butler','Drake','9lzec8'),('9lxhpj',1538845211,'Presbyterian','Kennesaw State','9lzhc3'),('9lxz94',1538848859,'Missouri State','South Dakota','9m06wc'),('9lxz74',1538848847,'Delaware','Richmond','9m03ed'),('9lxz4v',1538848835,'Pennsylvania','Sacred Heart','9m0341'),('9lxz32',1538848823,'Northern Illinois','Ball State','9m03yr'),('9lxz0w',1538848811,'Western Illinois','Illinois State','9m074o'),('9ly0ls',1538849109,'Southern Utah','Eastern Washington','9m0904'),('9lya5v',1538850786,'Clemson','Wake Forest','9m0e8n'),('9lya3q',1538850774,'South Alabama','Georgia Southern','9m0a46'),('9lya17',1538850762,'Iowa','Minnesota','9m0iqc'),('9ly9yv',1538850750,'Iowa State','Oklahoma State','9m0g7d'),('9ly9w5',1538850738,'Navy','Air Force','9m08r0'),('9ly9tw',1538850726,'Gardner-Webb','East Tennessee State','9m04pu'),('9ly9rt',1538850714,'San Diego State','Boise State','9m0e4p'),('9ly9pf',1538850702,'Kansas State','Baylor','9m0k1m'),('9ly9mw',1538850691,'Miami (OH)','Akron','9m0e6x'),('9ly9jv',1538850678,'USF','UMass','9m0jla'),('9ly9ha',1538850666,'Bowling Green','Toledo','9m0f48'),('9ly9cj',1538850646,'Villanova','Maine','9m08gk'),('9ly99m',1538850634,'Ohio','Kent State','9m0bn6'),('9ly976',1538850622,'LSU','Florida','9m0kan'),('9ly94n',1538850611,'Florida State','Miami','9m0q4l'),('9lyj2c',1538852459,'ULM','Ole Miss','9m0ih9'),('9lyizy',1538852447,'New Mexico','UNLV','9m0en5'),('9lyixe',1538852435,'Indiana','Ohio State','9m0rir'),('9lyiv4',1538852423,'Arizona State','Colorado','9m0jit'),('9lyiss',1538852411,'Stony Brook','Towson','9m0gyv'),('9lylsa',1538853010,'Western Carolina','Samford','9lzj5w'),('9lz073',1538856022,'Southeastern Louisiana','Incarnate Word','9m100v'),('9lz04p',1538856010,'Old Dominion','FAU','9m125a'),('9lz9ex',1538857810,'Weber State','Northern Arizona','9m18tt'),('9lzauo',1538858109,'Idaho','Idaho State','9m14t0'),('9lzhy6',1538859610,'Southern Illinois','Youngstown State','9m1erq'),('9lzzpd',1538863319,'Abilene Christian','McNeese','9m1mck'),('9lzzmy',1538863307,'Connecticut','Memphis','9m1pwe'),('9lzzk9',1538863295,'SMU','UCF','9m1sl3'),('9lzzhq',1538863283,'UAB','Louisiana Tech','9m227q'),('9lzzfq',1538863271,'West Florida','North Alabama','9m1jf7'),('9lzzdm',1538863259,'Oklahoma Panhandle','Grambling','9m1wub'),('9lzzb6',1538863247,'Louisiana','Texas State','9m1tpy'),('9lzz8w',1538863235,'UTSA','Rice','9m1o9t'),('9lzz6m',1538863222,'Kentucky','Texas A&amp;M',NULL),('9lzz4e',1538863210,'Nicholls','Northwestern State','9m1njk'),('9m07lm',1538865058,'Nebraska','Wisconsin','9m213i'),('9m07jy',1538865046,'North Texas','UTEP','9m1wlj'),('9m07ho',1538865034,'Washington','UCLA','9m1zgs'),('9m07g0',1538865022,'Vanderbilt','Georgia','9m23j4'),('9m07e7',1538865010,'Auburn','Mississippi State','9m1z27'),('9m0f73',1538866824,'Notre Dame','Virginia Tech','9m299u'),('9m0f4o',1538866811,'Liberty','New Mexico State','9m2b4w'),('9m0twd',1538870422,'Washington State','Oregon State','9m2l2p'),('9m0tui',1538870410,'Cal Poly','Sacramento State','9m2f0i'),('9m18ca',1538874010,'California','Arizona','9m2tq7'),('9m1fku',1538875835,'Colorado State','San JosÃ© State','9m344y'),('9m1fj9',1538875823,'Utah','Stanford','9m2u9n'),('9m1fhh',1538875810,'Fresno State','Nevada','9m2vlt'),('9m2057',1538881210,'Wyoming','Hawai\'i','9m39r0'),('9mu05p',1539126010,'Appalachian State','Arkansas State','9mvzuh'),('9nemxb',1539297022,'Texas Tech','TCU','9ngodt'),('9nemvk',1539297010,'Georgia Southern','Texas State','9ngkoh'),('9nol8i',1539381622,'Holy Cross','Harvard','9nqdl3'),('9nol6n',1539381610,'USF','Tulsa','9nqfaq'),('9npgjy',1539388810,'Air Force','San Diego State','9nrh80'),('9npuv3',1539392409,'Arizona','Utah','9nrd1h'),('9nudo9',1539442966,'Tennessee','Auburn',NULL),('9nudme',1539442954,'Akron','Buffalo',NULL),('9nudhf',1539442926,'Oklahoma State','Kansas State',NULL),('9nudfi',1539442914,'Nebraska','Northwestern',NULL),('9nudaa',1539442886,'Iowa','Indiana',NULL),('9nud7x',1539442874,'Cornell','Colgate',NULL),('9nud4k',1539442854,'Rutgers','Maryland',NULL),('9nud2i',1539442842,'Florida','Vanderbilt',NULL),('9nucyv',1539442822,'Toledo','Eastern Michigan',NULL),('9nucwn',1539442810,'Minnesota','Ohio State',NULL),('9nuicj',1539444017,'Duke','Georgia Tech',NULL);
/*!40000 ALTER TABLE `threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threads_test`
--

DROP TABLE IF EXISTS `threads_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threads_test` (
  `game` varchar(6) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `visitor` varchar(64) DEFAULT NULL,
  `home` varchar(64) DEFAULT NULL,
  `postgame` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threads_test`
--

LOCK TABLES `threads_test` WRITE;
/*!40000 ALTER TABLE `threads_test` DISABLE KEYS */;
/*!40000 ALTER TABLE `threads_test` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-13 15:40:00
