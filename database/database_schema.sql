-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: ebook
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `action_type` varchar(100) DEFAULT NULL,
  `entity` varchar(100) DEFAULT NULL,
  `entity_id` varchar(100) DEFAULT NULL,
  `description` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:12:58'),(2,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:18:47'),(3,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:19:04'),(4,1,'ANONYMOUS','LOGIN_FAILED','USER','1','Incorrect password attempt','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:22:30'),(5,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:22:37'),(6,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:28:48'),(7,1,'USER','PAYMENT_SUCCESS','ORDER','ORD1771875090767','Online payment verified and completed','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:32:01'),(8,NULL,'ANONYMOUS','LOGIN_FAILED','USER','1','Incorrect password attempt','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:36:10'),(9,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:36:19'),(10,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:39:54'),(11,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-23 19:43:58'),(12,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 01:35:35'),(13,1,'ANONYMOUS','LOGIN_FAILED','USER','1','Incorrect password attempt','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 01:57:06'),(14,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 01:57:12'),(15,1,'ANONYMOUS','LOGIN_FAILED','USER','1','Incorrect password attempt','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 02:16:02'),(16,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 02:16:09'),(17,1,'USER','PAYMENT_SUCCESS','ORDER','ORD1771899433108','Online payment verified and completed','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 02:17:50'),(18,1,'USER','LOGIN_SUCCESS','USER','1','User logged in successfully','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 07:33:36'),(19,1,'USER','ORDER_PLACED','ORDER','ORD1771918613861','Order placed successfully via COD','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-24 07:36:53');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocked_ips`
--

DROP TABLE IF EXISTS `blocked_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocked_ips` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) DEFAULT NULL,
  `blocked_until` timestamp NULL DEFAULT NULL,
  `reason` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_ips`
--

LOCK TABLES `blocked_ips` WRITE;
/*!40000 ALTER TABLE `blocked_ips` DISABLE KEYS */;
/*!40000 ALTER TABLE `blocked_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_dtls`
--

DROP TABLE IF EXISTS `book_dtls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_dtls` (
  `bookId` int NOT NULL AUTO_INCREMENT,
  `bookName` varchar(45) DEFAULT NULL,
  `author` varchar(45) DEFAULT NULL,
  `price` varchar(45) DEFAULT NULL,
  `bookCategory` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `photo` varchar(45) DEFAULT NULL,
  `userEmail` varchar(45) DEFAULT NULL,
  `description` text,
  `stock` int DEFAULT '0',
  `avgRating` double DEFAULT '0',
  `totalSales` int DEFAULT '0',
  PRIMARY KEY (`bookId`),
  FULLTEXT KEY `bookName` (`bookName`,`author`,`description`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_dtls`
--

LOCK TABLES `book_dtls` WRITE;
/*!40000 ALTER TABLE `book_dtls` DISABLE KEYS */;
INSERT INTO `book_dtls` VALUES (1,'Dopamine Detox',' Thibaut Meurisse','245.0','New','Active','71Q2fXtMhaL._AC_UY218_.jpg',NULL,' Do you keep procrastinating or restless and unable to focus on your work?  If so, you might need a dopamine detox.',0,0,0),(2,'Human Edge in the AI Age','Nitin Seth','799.0','New','Active','81fqWc6aiGL._AC_UY218_.jpg',NULL,'A seismic shift is underway―one that will redefine work, value, and even what it means to be human.',3,0,0),(3,'The Psychology of Money',' Morgan Housel','399.0','New','Active','71XEsXS5RlL._AC_UY218_.jpg',NULL,'Timeless lessons on wealth, greed, and happiness doing well with money isn?t necessarily about what you know. It?s about how you behave. And behavior is hard to teach, even to really smart people.',4,0,0),(4,'The Palace of Illusions',' Chitra Banerjee Divakaruni ','499.0','New','Active','A1dtQ-soQEL._AC_UY218_.jpg',NULL,'\"Be taken back to a time that is half history, half myth, and wholly magical ?',5,0,0),(5,'The Lost Bookshop','Evie Woods ','599.0','New','Active','91Sy3S-198L._AC_UY218_.jpg',NULL,'‘The thing about books,’ she said ‘is that they help you to imagine a life bigger and better than you could ever dream of.’',5,0,0),(6,'The Best of Sherlock Holmes (Set of 2 Books) ',' Sir Arthur Conan Doyle','599.0','New','Active','81AFx0AuG-L._AC_UL320_.jpg',NULL,'Uncover the brilliance of Sherlock Holmes with The Best of Sherlock Holmes set. This captivating two-book collection features carefully selected tales showcasing the detective\'s greatest cases, capturing the essence of Sir Arthur Conan Doyle\'s iconic character and his unparalleled powers of deduction.\r\n',5,0,0),(7,'Ghosts of The Silent Hills',' Anita Krishan','249.0','New','Active','81zKpTU9gRL._AC_UY218_.jpg',NULL,'The hills are surrounded by dense, menacing forests, enveloped in a deadly silence, where you never know what lurks in the cold, dark nights. You may come across a beautiful woman in white, who haunts the lonely pathways or you may hear screams of people who died in accidents. Ghosts of the Silent Hills is a collection of horror stories that will make your nights a little scarier, encompassing the very best spine-chilling stories based on true hauntings.',5,0,0),(8,'Shrimad Bhagwat Geeta Yatharoop',' A.C. Bhaktivendanta Swami Prabhupada ','208.0','New','Active','91msEbTletL._AC_UY218_.jpg',NULL,'The largest-selling edition of the Gita all over the world, Bhagavad-Gita as It Is, is more than a book. For many it has changed their lives altogether. Universally Bhagavad-Gita is renowned and truly claimed as the crown jewel of India?s spiritual wisdom. Spoken by Lord Krishna the Supreme Personality of Godhead to His intimate disciple Arjuna, the Gita’s seven hundred concise verses provides a definitive guide to the science of self realization. Complete wisdom with original sanskrit texts, word to word meaning, translation and purpot by His divine gracre A.C Bhakti Vedanta Swami Srila Prabhupada, Founder acharya of ISKCON',0,0,0),(9,'RAHASYA',' Rhonda Byrne ','499.0','New','Active','81IK3yH-rIL._AC_UY218_.jpg',NULL,'एक महान रहस्य के अंश पुराने काव्य, साहित्य, धर्मों, दर्शनों में सदियों से मौजूद हैं। रहस्य के ये सभी अंश पहली बार इकट्ठे होकर अविश्वसनीय रूप में सामने आ रहे हैं, इस रहस्य का ज्ञान और अनुभव सभी लोगों के जीवन का कायाकल्प कर सकता है। ',5,0,0),(10,'My Journey','Abdul Kalam','250.0','New','Active','61HGmcAr-lL._AC_UY218_.jpg',NULL,'The book, ‘My Journey: Transforming Dreams into Actions’ is the life story of Dr. APJ Abdul Kalam, India\'s famous scientist and former President. Written with a powerful narrative style laden with significant experiences, Dr. Kalam has filled this book with the details that matter. ',5,0,0),(11,'Ratan Tata : A Life',' Thomas Mathew','1499.0','New','Active','719oHU9kiFL._AC_UY218_.jpg',NULL,'To create an Indian environment with fresh air to breathe, clean water to drink, nutritious food with no one left hungry, and a way to care for everyone’s health should be the priority for you and me.—Ratan Tata',5,0,0),(12,'Knife Drop',' Nick DiGiovanni','2625.0','New','Active','81QmOCsmelL._AC_UY218_.jpg',NULL,'\"Nick breathes fresh energy into cooking and makes it accessible to chefs of all ages. I promise if you cook something from this cookbook, it will receive nothing but praise from me!\"\r\n—Gordon Ramsay, from the foreword\r\n\r\nForget the rules and get cooking with flavor-forward recipes from celebrity chef and social media superstar Nick DiGiovanni!',4,0,0),(13,'GORDON RAMSAY\'S ULTIMATE COOKERY COURSE',' Gordon Ramsay','2450.0','New','Active','81WeYtjHf+L._AC_UY218_.jpg',NULL,'\"I want to teach you how to cook good food at home. By stripping away all the hard graft and complexity, anyone can produce mouth-watering recipes. Put simply, I\'m going to show you how to cook yourself into a better cook. \"GORDON RAMSAYGordon Ramsay\'s Ultimate Cookery Course is about giving home cooks the desire, confidence and inspiration to hit the stoves and get cooking, with over 120 modern, simple and accessible recipes. The ultimate reference bible, it\'s a lifetime\'s worth of expertise from one of the world\'s finest chefs distilled into a beautiful book.',5,0,0),(14,'The Kid Who Came From Space',' Ross Welford','399.0','New','Active','81uvCkcYSFL._AC_UY218_.jpg',NULL,'The stunning new 10+ story from the bestselling and award-winning author of time travelling with a hamster, for anyone who loved the humour of wall-e, the action of star Wars and the deeply touching emotion of et. A small village in the wilds of northumberland is rocked by the disappearance of twelve-year-old Tammy. Only her twin brother, Ethan, knows she is safe  and the extraordinary truth of where she is. It is a secret he must keep, or risk never seeing her again. But that doesn\'t mean hes going to give up. Together with his friend Iggy and the mysterious (and very hairy) hellyann, Ethan teams up with a spaceship called Philip, and Suzy the trained chicken, for a nail-biting chase to get his sister backthat will take him further than anyone has ever been before.',5,0,0),(15,'The Lost World',' Arthur Conan Doyle ','199.0','New','Active','81X76RHWvFL._AC_UY218_.jpg',NULL,'“So tomorrow we disappear into the unknown. . . It may be our last word to those who are interested in our fate. ” dinosaurs, pterodactyls, ape-men, and other prehistoric creatures still roam among us. This ground-breaking discovery has been made by the notorious Professor George Edward Challenger, who is a brilliant scientist. But this revelation has been subjected to ridicule. In order to believe, people need proof. So, that’s what he will give them. Braving danger and risking his life, Challenger will set foot into the depths of the amazonian plateau of South America. Accompanying him in this extraordinary adventure are his professional rival Professor summerlee, journalist Edward Malone, and Lord John roxton. In the dense foliage of the dark, lost world, will Challenger find the proof he is looking for? And, if he does, will he survive? Arthur Conan Doyle the lost world became an instant success on publication. It is one of the best sci-fi stories ever written and is considered a classic that has set the standard for all fantasy-adventure stories.',5,0,0),(16,'It Ends With Us',' Colleen Hoover','499.0','New','Active','91CqNElQaKL._AC_UY218_.jpg',NULL,'The newest, highly anticipated novel from beloved #1 New York Times bestselling author, Colleen Hoover. Sometimes it is the one who loves you who hurts you the most. Lily hasn?t always had it easy, but that\'s never stopped her from working hard for the life she wants. She?s come a long way from the small town in Maine where she grew up?she graduated from college, moved to Boston and started her own business. ',5,0,0),(17,'Too Good to Be True',' Prajakta Koli','399.0','New','Active','818vo2TWp+L._AC_UY218_.jpg',NULL,'Winner of the Amazon India Popular Choice Debut Book 2025 Award.\r\n\r\nFrom one of India\'s most-loved creators comes something new to fall in love with.',5,0,0),(18,'One Piece 01',' Eiichiro Oda','799.0','New','Active','91NxYvUNf6L._AC_UY218_.jpg',NULL,'Join Monkey D. Luffy and his swashbuckling crew in their search for the ultimate treasure, One Piece!',5,0,0),(19,'Haikyu, Vol. 43',' Haruichi Furudate','1199.0','New','Active','816-B+Jfe5L._AC_UY218_.jpg',NULL,'Shoyo Hinata is out to prove that in volleyball you don\'t need to be tall to fly!Ever since he saw the legendary player known as “the Little Giant” compete at the national volleyball finals, Shoyo Hinata has been aiming to be the best volleyball player ever! Who says you need to be tall to play volleyball when you can jump higher than anyone else?After graduating high school, Hinata books it all the way to Brazil to learn how to play beach volleyball and improve his control and strength. While there, his efforts earn him the moniker “Ninja Shoyo,” and one day he’s approached by another player named Heitor, who is desperate to win his next match and keep his sponsors. Will Hinata’s skills be enough to help his new partner?',4,0,0),(20,'Spider-Man: Kraven\'s Last Hunt',' J.M. DeMatteis','1199.0','New','Active','813NhXAicML._AC_UY218_.jpg',NULL,'The ultimate tale of revenge! Kraven the Hunter has stalked and killed every beast known to man. But there is one prey that has eluded him. One quarry that has mocked him at every turn: the Spider. Now, in one last hunt, Kraven will finally prove he is Spider-Man’s master — by burying him alive and taking his place! To destroy the spider, he must become the spider! Prepare for one of the greatest Spidey stories ever told — a tale that has cast its shadow over Peter Parker’s life for years! Collecting WEB OF SPIDER-MAN (1985) #31-32; AMAZING SPIDER-MAN (1963) #293-294; and PETER PARKER, THE SPECTACULAR SPIDER-MAN (1976) #131-132.',5,0,0),(21,'Diary of a wimpy kid: Partypooper','Jeff Kinney','699.0','New','Active','91NDZEkcE7L._AC_UY218_.jpg',NULL,'You’re Invited – RSVP for Fun!\r\n\r\nOver the years, Greg Heffley has chronicled his mishaps and misadventures in a series of diaries – make that journals – but book 20 of the Diary of a Wimpy Kid series, Partypooper, really takes the cake! Expect gobs of fun and over-the-top antics as Greg throws an epic birthday party for none other than himself. So come celebrate and laugh alongside Greg, his family, and the entire world of Wimpy Kid fans.\r\n',5,0,0),(22,'Harry Potter : The Complete Collection','J.K. Rowling','12999.0','New','Active','81uRUnI9Y3L._AC_UY218_.jpg',NULL,'Loved by millions of readers worldwide, let the greatest children\'s book series of all time take you on an unforgettable journey. The hope and wonder of Harry Potter\'s world will make you want to escape to Hogwarts again and again. This magical paperback box set is perfect for gifting!',3,0,0),(23,'Ikigai',' Francesc García, Héctor,Miralles ','599.0','New','Active','81l3rZK4lnL._AC_UY218_.jpg',NULL,'It\'s the Japanese word for \'a reason to live\' or \'a reason to jump out of bed in the morning\'.\r\n\r\nIt\'s the place where your needs, desires, ambitions, and satisfaction meet. A place of balance. Small wonder that finding your ikigai is closely linked to living longer.',6,0,0),(24,'The Power of Your Subconscious Mind',' Joseph Murphy ','275.0','New','Active','71sBtM3Yi5L._AC_UY218_.jpg',NULL,'The Power of Your Subconscious Mind is one of the most promising self improvement books that you can gift to yourself or your loved ones. This book is designed to help you improve your relationships, health, and also to give you an internal strength that makes every hurdle look small. The book brings together best of both the worlds – scientific research as well as spiritual wisdom. It used the combined ideas to explain how our subconscious mind has the power to change our lives.',3,0,0),(25,'The Kite Runner',' Khaled Hosseini','599.0','New','Active','81YXfTztoZL._AC_UY218_.jpg',NULL,'Afghanistan, 1975: Twelve-year-old Amir is desperate to win the local kite-fighting tournament, and his loyal friend Hassan promises to help him. But neither of the boys can foresee what will happen to Hassan that afternoon—an event that will shatter their lives.\r\n\r\nAfter the Russian invasion forces Amir\'s family to flee to America, he grows up in a new world but realises that one day he must return to Afghanistan, now under Taliban rule, to find the one thing his new life cannot grant him: redemption.',3,0,0);
/*!40000 ALTER TABLE `book_dtls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre`
--

DROP TABLE IF EXISTS `book_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genre` (
  `book_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `idx_book_genre_genre` (`genre_id`),
  KEY `idx_book_genre_book` (`book_id`),
  CONSTRAINT `book_genre_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book_dtls` (`bookId`) ON DELETE CASCADE,
  CONSTRAINT `book_genre_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genre`
--

LOCK TABLES `book_genre` WRITE;
/*!40000 ALTER TABLE `book_genre` DISABLE KEYS */;
INSERT INTO `book_genre` VALUES (4,1),(5,1),(6,1),(7,1),(25,1),(14,2),(15,2),(22,2),(18,3),(20,3),(21,3),(22,3),(6,4),(7,4),(20,4),(22,4),(16,5),(17,5),(1,6),(23,6),(24,6),(10,7),(11,7),(8,8),(10,8),(11,8),(12,8),(13,8),(24,8),(7,9),(22,9),(12,10),(13,10),(18,11),(19,11),(20,11),(21,11),(8,12),(9,12),(1,13),(2,13),(3,13);
/*!40000 ALTER TABLE `book_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_order`
--

DROP TABLE IF EXISTS `book_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int DEFAULT NULL,
  `order_id` varchar(45) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `user_name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `book_name` varchar(45) DEFAULT NULL,
  `author` varchar(45) DEFAULT NULL,
  `price` varchar(45) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `payment` varchar(45) DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(30) DEFAULT 'PLACED',
  `total_amount` double DEFAULT NULL,
  `return_status` varchar(20) DEFAULT 'NONE',
  `refund_amount` double DEFAULT '0',
  `payment_method` varchar(20) DEFAULT 'COD',
  `payment_status` varchar(20) DEFAULT 'PENDING',
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  `razorpay_payment_id` varchar(100) DEFAULT NULL,
  `razorpay_signature` varchar(255) DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_order`
--

LOCK TABLES `book_order` WRITE;
/*!40000 ALTER TABLE `book_order` DISABLE KEYS */;
INSERT INTO `book_order` VALUES (1,0,'ORD1771875090767',1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','1144janta Quarter Nanda Nagar, Indore,MP, near new water tank, Indore, Madhya Pradesh, 452011','8602505047','Multiple Items','-','3864.0',2,NULL,'2026-02-23 19:31:30','PLACED',3864,'NONE',0,'ONLINE','PAID','order_SJhfpriS6usf0A','pay_SJhg4x5jQtkoKp','823ac127b4906cd5cb955f35ff4efb39903d22b0f7f79ff0eb54d187dc125f23',NULL),(2,0,'ORD1771899433108',1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','1144janta Quarter Nanda Nagar, Indore,MP, near new water tank, Indore, Madhya Pradesh, 452011','8602505047','Multiple Items','-','1338.7',3,NULL,'2026-02-24 02:17:13','PLACED',1338.7,'NONE',0,'ONLINE','PAID','order_SJoaP3GHu5b2xE','pay_SJoalAYXcmPBv0','3d6d273d6e062bbce97d613afe78aad1a89a6e6454faa112588b212cef0d86eb',NULL),(3,0,'ORD1771918533785',1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','1144janta Quarter Nanda Nagar, Indore,MP, 4rd, Indore, Madhya Pradesh, 452011','8602505047','Multiple Items','-','1080.0',5,NULL,'2026-02-24 07:35:33','PAYMENT_PENDING',1080,'NONE',0,'ONLINE','INITIATED',NULL,NULL,NULL,NULL),(4,0,'ORD1771918560454',1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','1144janta Quarter Nanda Nagar, Indore,MP, ex, Indore, Madhya Pradesh, 452011','8602505047','Multiple Items','-','1020.0',4,NULL,'2026-02-24 07:36:00','PAYMENT_PENDING',1020,'NONE',0,'ONLINE','INITIATED',NULL,NULL,NULL,NULL),(5,0,'ORD1771918613861',1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','1144janta Quarter Nanda Nagar, Indore,MP,  d, Indore, Madhya Pradesh, 452011','8602505047','Multiple Items','-','639.0',1,NULL,'2026-02-24 07:36:53','PLACED',639,'NONE',0,'COD','PENDING',NULL,NULL,NULL,NULL),(6,0,'ORD1771918690612',1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','1144janta Quarter Nanda Nagar, Indore,MP, jhvu, Indore, Madhya Pradesh, 452011','8602505047','Multiple Items','-','839.0',1,NULL,'2026-02-24 07:38:10','PAYMENT_PENDING',839,'NONE',0,'ONLINE','INITIATED','order_SJu3Qs4Kla7zSc',NULL,NULL,NULL);
/*!40000 ALTER TABLE `book_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_popularity`
--

DROP TABLE IF EXISTS `book_popularity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_popularity` (
  `book_id` int NOT NULL,
  `views` int DEFAULT '0',
  `purchases` int DEFAULT '0',
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_popularity`
--

LOCK TABLES `book_popularity` WRITE;
/*!40000 ALTER TABLE `book_popularity` DISABLE KEYS */;
INSERT INTO `book_popularity` VALUES (1,0,6),(2,0,3),(3,0,2),(8,0,5),(12,1,2),(19,1,2),(23,0,1),(24,1,0),(25,1,0);
/*!40000 ALTER TABLE `book_popularity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_review`
--

DROP TABLE IF EXISTS `book_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `review_text` varchar(500) DEFAULT NULL,
  `review_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `helpful` int DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_review`
--

LOCK TABLES `book_review` WRITE;
/*!40000 ALTER TABLE `book_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cid` int NOT NULL AUTO_INCREMENT,
  `bid` int DEFAULT NULL,
  `uid` int DEFAULT NULL,
  `bookName` varchar(45) DEFAULT NULL,
  `author` varchar(45) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `totalPrice` double DEFAULT NULL,
  `quantity` int DEFAULT '1',
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `is_featured` tinyint(1) DEFAULT '0',
  `display_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_genre_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Fiction','fiction','Stories created from imagination — from emotional dramas to epic adventures. Fiction transports readers into compelling worlds and unforgettable characters.',1,0,0,'2026-02-23 18:28:55'),(2,'Science Fiction','science-fiction','Futuristic technology, space exploration, AI, time travel, and alternate realities. Perfect for readers who love innovation and imagination.',1,0,0,'2026-02-23 18:29:11'),(3,'Fantasy','fantasy','Magic, mythical creatures, powerful kingdoms, and epic quests. Escape into worlds where the impossible becomes reality.',1,0,0,'2026-02-23 18:29:21'),(4,'Mystery & Thriller','mystery-&-thriller','Suspenseful plots, shocking twists, crime investigations, and psychological tension that keeps readers hooked till the last page.',1,0,0,'2026-02-23 18:29:31'),(5,'Romance','romance','Love stories that explore relationships, passion, heartbreak, and emotional journeys across different settings and eras.',1,0,0,'2026-02-23 18:29:47'),(6,'Self-Help & Personal Development','self-help-&-personal-development','Books focused on mindset, productivity, confidence, habits, leadership, and achieving success in life and career.',1,0,0,'2026-02-23 18:30:01'),(7,'Biography & Autobiography','biography-&-autobiography','Real-life stories of influential personalities, entrepreneurs, leaders, and inspiring individuals.',1,0,0,'2026-02-23 18:30:16'),(8,'Educational ','educational-','Textbooks, exam preparation guides, competitive exams, reference materials, and study resources.',1,0,0,'2026-02-23 18:30:59'),(9,'Horror','horror','Dark, supernatural, and psychological stories designed to thrill and terrify readers.',1,0,0,'2026-02-23 18:31:09'),(10,'Cookbooks & Food','cookbooks-&-food','Recipe collections, culinary techniques, baking guides, regional cuisines, and food culture explorations for cooking enthusiasts.',1,0,0,'2026-02-23 18:31:27'),(11,'Anime & Manga','anime-&-manga','This genre includes action-packed adventures, fantasy epics, romantic dramas, slice-of-life stories, and more — loved by fans of Japanese pop culture worldwide.',1,0,0,'2026-02-23 18:31:46'),(12,'Spirituality & Religion','spirituality-&-religion','Philosophy, meditation, spiritual growth, religious teachings, and mindfulness practices.',1,0,0,'2026-02-23 18:32:01'),(13,'Non-Fiction','non-fiction','Books based on real events, real people, and factual information. This genre covers topics such as history, science, politics, memoirs, business, culture, and real-world knowledge — perfect for readers who want to learn, grow, and explore reality.',1,0,0,'2026-02-23 18:35:27');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_attempts` (
  `user_id` int NOT NULL,
  `attempt_count` int DEFAULT '0',
  `lock_until` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `login_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES (1,0,NULL);
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(45) NOT NULL,
  `book_id` int NOT NULL,
  `book_name` varchar(100) DEFAULT NULL,
  `author` varchar(100) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `total` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `book_order` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,'ORD1771875090767',19,'Haikyu, Vol. 43',' Haruichi Furudate',1199,1,1199),(2,'ORD1771875090767',12,'Knife Drop',' Nick DiGiovanni',2625,1,2625),(3,'ORD1771899433108',1,'Dopamine Detox',' Thibaut Meurisse',245,1,245),(4,'ORD1771899433108',3,'The Psychology of Money',' Morgan Housel',399,1,399),(5,'ORD1771899433108',2,'Human Edge in the AI Age','Nitin Seth',799,1,799),(6,'ORD1771918533785',8,'Shrimad Bhagwat Geeta Yatharoop',' A.C. Bhaktivendanta Swami Prabhupada ',208,5,1040),(7,'ORD1771918560454',1,'Dopamine Detox',' Thibaut Meurisse',245,4,980),(8,'ORD1771918613861',23,'Ikigai',' Francesc García, Héctor,Miralles ',599,1,599),(9,'ORD1771918690612',2,'Human Edge in the AI Age','Nitin Seth',799,1,799);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_helpful`
--

DROP TABLE IF EXISTS `review_helpful`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_helpful` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_review_user` (`review_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_helpful`
--

LOCK TABLES `review_helpful` WRITE;
/*!40000 ALTER TABLE `review_helpful` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_helpful` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `search_analytics`
--

DROP TABLE IF EXISTS `search_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `search_analytics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `keyword` varchar(255) NOT NULL,
  `user_id` int DEFAULT NULL,
  `result_count` int DEFAULT '0',
  `search_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `search_analytics`
--

LOCK TABLES `search_analytics` WRITE;
/*!40000 ALTER TABLE `search_analytics` DISABLE KEYS */;
/*!40000 ALTER TABLE `search_analytics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seller_payout_requests`
--

DROP TABLE IF EXISTS `seller_payout_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seller_payout_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seller_id` int DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seller_payout_requests`
--

LOCK TABLES `seller_payout_requests` WRITE;
/*!40000 ALTER TABLE `seller_payout_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `seller_payout_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seller_wallet_transactions`
--

DROP TABLE IF EXISTS `seller_wallet_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seller_wallet_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seller_id` int NOT NULL,
  `amount` double NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seller_wallet_transactions`
--

LOCK TABLES `seller_wallet_transactions` WRITE;
/*!40000 ALTER TABLE `seller_wallet_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `seller_wallet_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phno` varchar(10) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `landmark` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `wallet` double DEFAULT '0',
  `fraud_flag` varchar(20) DEFAULT 'NORMAL',
  `account_status` varchar(20) DEFAULT 'ACTIVE',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `role` varchar(20) DEFAULT 'USER',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Bhavesh Pahuja','bhaveshpahuja9@gmail.com','$2a$10$o2wLlLg/EdPBHIM2NwsHkuD6ICbwUxZvODLqCHsRTIVESDXR/oN12','8602505047',NULL,NULL,NULL,NULL,NULL,0,'NORMAL','ACTIVE','2026-02-24 00:42:50',NULL,'USER');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activity`
--

DROP TABLE IF EXISTS `user_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `action` varchar(30) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity`
--

LOCK TABLES `user_activity` WRITE;
/*!40000 ALTER TABLE `user_activity` DISABLE KEYS */;
INSERT INTO `user_activity` VALUES (1,1,25,'VIEW','2026-02-23 19:22:47'),(2,1,19,'VIEW','2026-02-23 19:23:07'),(3,1,12,'VIEW','2026-02-23 19:23:16'),(4,1,24,'VIEW','2026-02-23 19:41:38');
/*!40000 ALTER TABLE `user_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallet_transactions`
--

DROP TABLE IF EXISTS `wallet_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallet_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet_transactions`
--

LOCK TABLES `wallet_transactions` WRITE;
/*!40000 ALTER TABLE `wallet_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `wallet_transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-23 17:45:31
