-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_2390_books
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_id` int(11) NOT NULL AUTO_INCREMENT,
  `book_name` varchar(100) NOT NULL,
  `book_description` text NOT NULL,
  `year` year(4) NOT NULL,
  `publishing_house` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `volume_pages` int(11) NOT NULL,
  `cover_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`book_id`),
  KEY `books_ibfk_1` (`cover_id`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`cover_id`) REFERENCES `covers` (`cover_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'451 градус по Фаренгейту','Роман описывает американское общество близкого будущего, в котором книги находятся под запретом; «пожарные», к числу которых принадлежит и главный герой Гай Монтэг, сжигают любые найденные книги. В ходе романа Монтэг разочаровывается в идеалах общества, частью которого он является, становится изгоем и присоединяется к небольшой подпольной группе маргиналов, сторонники которой заучивают тексты книг, чтобы спасти их для потомков. Название книги объясняется в эпиграфе: «451 градус по Фаренгейту — температура, при которой воспламеняется и горит бумага». В книге содержится немало цитат из произведений англоязычных авторов прошлого (таких, как Уильям Шекспир, Джонатан Свифт и другие), а также несколько цитат из Библии.',1953,'Ballantine Books','Рэя Брэдбери',200,1),(3,'Капитанская дочка','Действие произведения происходит в период восстания Емельяна Пугачева и основано на реальных событиях. Повесть написана в форме мемуаров главного героя Петра Андреича Гринева – его дневниковых записей. Произведение названо в честь возлюбленной Гринева – Марьи Мироновой, капитанской дочери.',1936,'«Современник»','Александр Сергеевич Пушкин',256,1),(10,'123','# 2123',2123,'123','123',123,1),(13,'пойдет','            *norm*\r\n        ',2024,'политех','раиль',1000,1);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_genres`
--

DROP TABLE IF EXISTS `books_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_genres` (
  `book_genre_id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`book_genre_id`),
  KEY `genre_ibfk_1` (`genre_id`),
  KEY `book_genre_ibfk_2` (`book_id`),
  CONSTRAINT `book_genre_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `genre_ibfk_1` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_genres`
--

LOCK TABLES `books_genres` WRITE;
/*!40000 ALTER TABLE `books_genres` DISABLE KEYS */;
INSERT INTO `books_genres` VALUES (22,3,2),(23,3,6),(27,1,1),(28,1,3),(107,10,1),(108,10,2),(109,10,3),(112,13,5);
/*!40000 ALTER TABLE `books_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `covers`
--

DROP TABLE IF EXISTS `covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `covers` (
  `cover_id` int(11) NOT NULL AUTO_INCREMENT,
  `cover_name` varchar(100) NOT NULL,
  `MIME-type` varchar(100) NOT NULL,
  `MD5-hesh` varchar(100) NOT NULL,
  PRIMARY KEY (`cover_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `covers`
--

LOCK TABLES `covers` WRITE;
/*!40000 ALTER TABLE `covers` DISABLE KEYS */;
INSERT INTO `covers` VALUES (1,'first','type','hesh');
/*!40000 ALTER TABLE `covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `genre_id` int(11) NOT NULL AUTO_INCREMENT,
  `genre_name` varchar(100) NOT NULL,
  PRIMARY KEY (`genre_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (1,'научно-фантастический'),(2,'роман'),(3,'антиутопия'),(4,'драма'),(5,'комедия'),(6,'исторический');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `text` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (16,10,2,5,'<p><strong>wewwewewewew</strong></p>','2024-06-21 16:35:47'),(17,10,1,4,'<ol>\n<li>первое</li>\n<li>второе</li>\n</ol>','2024-06-21 18:04:17'),(18,1,3,5,'<h1>ПРОСТО ПУШКА</h1>','2024-06-21 18:09:22'),(20,13,1,5,'<p><strong>Лучшая книга</strong></p>','2024-06-21 18:18:19');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) NOT NULL,
  `role_description` text NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Админ','Cуперпользователь, имеет полный доступ к системе, в том числе к созданию и удалению книг'),(2,'Модератор','Может редактировать данные книг и производить модерацию рецензий'),(3,'Пользователь','Может оставлять рецензии');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(100) NOT NULL,
  `password` varchar(256) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `users_ibfk_1` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','0a8ab892fd7df1a92a41c2599108fc7857e1db1fc3602533538a1b177c2e182e','Шакиров','Раиль','Линарович',1),(2,'Moder','0a8ab892fd7df1a92a41c2599108fc7857e1db1fc3602533538a1b177c2e182e','Shakirov','Rail','Linarovich',2),(3,'User','0a8ab892fd7df1a92a41c2599108fc7857e1db1fc3602533538a1b177c2e182e','Силантьев','Даниил','Андреевич',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-21 21:47:15
