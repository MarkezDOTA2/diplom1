-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: storechicco
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'admin','$2b$10$kFBYEijxbi/jn138TGZHFOJmVx0in09Ckf.bPxeROKTKKJR6ogvw6');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `cart_id` (`cart_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (55,2,26,1),(74,4,1,1),(75,4,32,1),(76,4,60,1);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
INSERT INTO `carts` VALUES (1,12,'2025-04-15 09:55:58'),(2,6,'2025-04-15 10:34:34'),(3,1,'2025-04-15 11:33:10'),(4,14,'2025-04-15 16:14:21'),(5,15,'2025-11-13 02:57:13');
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_favorite` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (27,1,26),(28,14,10),(29,14,29);
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,3,1,1),(2,4,1,2),(3,5,1,1),(4,5,2,1),(5,6,1,1),(6,6,10,1),(7,7,20,3),(8,7,10,1),(9,8,62,1),(10,9,26,1),(11,10,20,1),(12,11,28,1),(13,11,27,1),(14,12,26,2),(15,12,27,1),(16,12,20,4),(19,15,20,1),(20,15,10,1),(21,15,2,1),(22,16,20,1),(23,16,2,1),(24,17,10,1),(25,18,10,1),(26,18,26,1),(27,19,20,1),(28,20,20,1),(29,21,26,1),(30,21,2,1),(31,22,26,1),(32,23,20,1),(33,23,10,1),(34,24,27,1),(35,24,20,2),(36,25,26,1),(37,26,31,1),(38,26,30,1);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `totalPrice` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_price` int NOT NULL DEFAULT '0',
  `status` enum('Новый','В пути','Доставлен') DEFAULT 'Новый',
  `user_id` int DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (3,'321321','9500539672','31231212',NULL,'2025-04-12 07:45:01',1000,'Новый',NULL,NULL),(4,'213124r4','9500539672','31231212',NULL,'2025-04-12 07:47:26',2000,'Новый',NULL,NULL),(5,'WQEQWEWQ WQEWQWEQ','9500539672','31231212',NULL,'2025-04-12 07:51:42',3500,'Новый',NULL,NULL),(6,'WQEQWEWQ WQEWQWEQ','9500539672','31231212',NULL,'2025-04-12 08:06:49',124123,'Новый',NULL,NULL),(7,'21312321312','9500539672','3312312',NULL,'2025-04-12 10:54:59',9492492,'Новый',NULL,NULL),(8,'маркез','321312312','ангарск',NULL,'2025-04-13 10:31:56',18999,'Новый',NULL,NULL),(9,'213123','312312','21321',NULL,'2025-04-13 10:56:47',7999,'Новый',8,NULL),(10,'312312','213123','312312',NULL,'2025-04-13 10:58:53',21999,'Новый',6,NULL),(11,'213123','21312','321312',NULL,'2025-04-13 11:05:39',27998,'Новый',6,NULL),(12,NULL,'312312','312312',NULL,'2025-04-15 10:09:21',122993,'Новый',12,'312312'),(13,NULL,'32121','21312',NULL,'2025-04-15 10:14:48',57997,'Новый',12,'23213'),(14,NULL,'312312','21312',NULL,'2025-04-15 10:15:36',57997,'Новый',12,'321312'),(15,'321312','321312123','3123123',NULL,'2025-04-15 10:17:54',57997,'Новый',12,NULL),(16,'1231212312','12312','123123',NULL,'2025-04-15 10:18:23',44998,'Новый',12,NULL),(17,'23123','21312','312312',NULL,'2025-04-15 10:42:58',12999,'Новый',6,NULL),(18,'312312213','32121','321321',NULL,'2025-04-15 11:13:56',20998,'Новый',6,NULL),(19,'3213','21312','312312',NULL,'2025-04-15 11:17:20',21999,'Новый',6,NULL),(20,'321312','21312','21321',NULL,'2025-04-15 11:29:16',21999,'Новый',6,NULL),(21,'21312','21312','312312',NULL,'2025-04-15 11:32:50',30998,'Новый',6,NULL),(22,'fff','ff','fff',NULL,'2025-04-15 11:33:16',7999,'Доставлен',1,NULL),(23,'маркез','21312','москоу',NULL,'2025-04-15 15:06:55',34998,'Новый',6,NULL),(24,'21312','3213','3213',NULL,'2025-04-15 15:40:49',62997,'Новый',1,NULL),(25,'213213','312321','21312',NULL,'2025-04-23 06:41:58',7999,'Новый',14,NULL),(26,'markez222','31312312312','москва',NULL,'2025-11-13 02:57:44',197998,'Доставлен',15,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (161,32,'/images/1762998168089-860810822.jpg'),(162,32,'/images/1762998168090-586167236.jpg'),(163,60,'/images/1762998263434-880898082.jpg'),(164,60,'/images/1762998263435-649147214.jpg'),(165,61,'/images/1762998335715-50565559.jpg'),(166,61,'/images/1762998335715-882119522.jpg'),(167,31,'/images/1762998422218-147295289.jpg'),(168,31,'/images/1762998422218-405569549.jpg'),(169,55,'/images/1762998502192-512764461.jpg'),(170,55,'/images/1762998502192-787966565.jpg'),(171,59,'/images/1762998571911-350314069.jpg'),(172,59,'/images/1762998571912-54120974.jpg'),(173,62,'/images/1762998636100-935765349.jpg'),(174,62,'/images/1762998636101-628414526.jpg'),(175,56,'/images/1762998741315-580936562.jpg'),(176,56,'/images/1762998741316-909413382.jpg'),(177,58,'/images/1762998820461-194008064.jpg'),(178,58,'/images/1762998820461-920844985.jpg'),(179,57,'/images/1762998904186-781684032.jpg'),(180,57,'/images/1762998904186-766496392.jpg'),(181,64,'/images/1762998961445-618136757.jpg'),(182,64,'/images/1762998961445-518103802.jpg'),(183,108,'/images/1762999019699-933052482.jpg'),(184,108,'/images/1762999019699-734669654.jpg'),(185,2,'/images/1762999159227-324337538.jpg'),(186,2,'/images/1762999159227-764017706.jpg'),(187,20,'/images/1762999219507-929746848.jpg'),(188,20,'/images/1762999219508-446424771.jpg'),(189,27,'/images/1762999398908-992711860.jpg'),(190,27,'/images/1762999398908-471231779.jpg'),(191,28,'/images/1762999460349-857359695.jpg'),(192,28,'/images/1762999460349-614005387.jpg'),(193,48,'/images/1762999608634-846559663.jpg'),(194,48,'/images/1762999608634-668979421.jpg'),(195,10,'/images/1762999732546-176773476.jpg'),(196,10,'/images/1762999732546-250513143.jpg'),(197,49,'/images/1762999814386-216692139.jpg'),(198,49,'/images/1762999814387-803615557.jpg'),(199,53,'/images/1762999882382-562825056.jpg'),(200,53,'/images/1762999882382-176647084.jpg'),(201,91,'/images/1762999933394-888570551.jpg'),(202,91,'/images/1762999933395-462805076.jpg'),(203,92,'/images/1762999985430-143857483.jpg'),(204,92,'/images/1762999985431-303969800.jpg'),(205,26,'/images/1763000062387-999664828.png'),(206,26,'/images/1763000062387-625727362.png'),(207,50,'/images/1763000119032-401688754.png'),(208,50,'/images/1763000119032-936376237.png'),(209,51,'/images/1763000163906-540944689.jpg'),(210,51,'/images/1763000163906-901967166.jpg'),(211,52,'/images/1763000207530-541283633.png'),(212,52,'/images/1763000207530-376506053.png'),(213,54,'/images/1763000295931-135455543.jpg'),(214,54,'/images/1763000295932-898222562.jpg'),(215,85,'/images/1763000351133-86575219.jpg'),(216,85,'/images/1763000351133-297172574.jpg'),(217,86,'/images/1763000398047-793349922.jpg'),(218,86,'/images/1763000398047-428393527.jpg'),(223,81,'/images/1763000694507-25087795.jpg'),(224,81,'/images/1763000694507-672947317.jpg'),(225,82,'/images/1763000727301-627371613.jpg'),(226,82,'/images/1763000727301-523133353.jpg'),(227,35,'/images/1763001074374-383513205.png'),(228,35,'/images/1763001074375-451068407.png'),(229,72,'/images/1763001148592-19494550.png'),(230,72,'/images/1763001148592-761923620.png'),(231,74,'/images/1763001191345-24168490.png'),(232,74,'/images/1763001191345-623046830.png'),(233,76,'/images/1763001236681-628357630.png'),(234,76,'/images/1763001236681-956457226.png'),(235,36,'/images/1763001425376-901336196.jpg'),(236,36,'/images/1763001425376-487099399.jpg'),(237,83,'/images/1763001485598-274925085.jpg'),(238,83,'/images/1763001485599-663126953.png'),(239,84,'/images/1763001549985-266129297.jpg'),(240,84,'/images/1763001549985-829428571.jpg'),(243,77,'/images/1763001751749-935445696.jpg'),(244,77,'/images/1763001751749-412516877.jpg'),(245,78,'/images/1763001792116-90769225.jpg'),(246,78,'/images/1763001792116-539650151.png'),(247,79,'/images/1763001844000-71720837.jpg'),(248,79,'/images/1763001844001-146676460.jpg'),(249,65,'/images/1763001989179-310231501.png'),(250,69,'/images/1763002032634-379970773.png'),(251,71,'/images/1763002087304-993592432.png'),(252,66,'/images/1763002196864-527487577.jpg'),(253,73,'/images/1763002232242-386452104.png'),(254,75,'/images/1763002303695-368183567.png'),(255,67,'/images/1763002373977-247524447.png'),(256,68,'/images/1763002403510-611947501.png'),(257,70,'/images/1763002434176-470266427.png');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `category` varchar(100) NOT NULL DEFAULT 'Общее',
  `is_featured` tinyint(1) DEFAULT '0',
  `brand` varchar(100) DEFAULT NULL,
  `showOnMain` tinyint(1) DEFAULT '0',
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Apple iPhone 16 Pro Max 256 ГБ',NULL,89999.00,'/images/1762996833231-378265215.jpg','Смартфоны',0,'Apple',0,1),(2,'Samsung Galaxy Book 4 NP754','',69999.00,'/images/1762999159196-601353621.png','Ноутбуки',0,'Samsung',0,0),(10,'Xiaomi RedmiBook 15 XMA2101-BN',NULL,37999.00,'/images/1762999732522-888223954.jpg','Ноутбуки',0,'Xiaomi',0,1),(20,'Samsung Galaxy Book5 Pro NP940XHA',NULL,89999.00,'/images/1762999219486-955342101.jpg','Ноутбуки',1,'Samsung',0,1),(26,'Apple MacBook Air M4',NULL,95999.00,'/images/1763000062364-821991769.png','Ноутбуки',1,'Apple',0,1),(27,'Samsung Galaxy Book5 Pro 360 NP960QHA',NULL,95999.00,'/images/1762999398885-167680468.jpg','Ноутбуки',1,'Samsung',0,1),(28,' Samsung Galaxy Book3',NULL,87999.00,'/images/1762999460326-775088937.jpg','Ноутбуки',1,'Samsung',0,1),(29,' Apple iPhone 17 Pro 256 ГБ',NULL,99999.00,'/images/1762996907359-640862645.jpg','Смартфоны',1,'Apple',0,1),(30,'Apple iPhone 17 Pro 256 ГБ',NULL,99999.00,'/images/1762996962615-242015122.jpg','Смартфоны',1,'Apple',0,1),(31,'Samsung Galaxy S25 Ultra 256 ГБ',NULL,97999.00,'/images/1762998422196-704637927.jpg','Смартфоны',1,'Samsung',0,1),(32,'Apple iPhone 16 128 ГБ',NULL,75999.00,'/images/1762998168063-378139079.jpg','Смартфоны',1,'Apple',0,1),(34,'Телевизор Haier 50 Smart TV S4',NULL,38999.00,'/images/1763000556360-589966559.jpg','Телевизоры',1,'Haier',0,1),(35,'Телевизор Hisense 55U7Q черный',NULL,69999.00,'/images/1763001074344-113547999.png','Телевизоры',1,'Hisense',0,1),(36,' Телевизор iFFALCON 65U75',NULL,52999.00,'/images/1763001425349-441644656.jpg','Телевизоры',1,'iFFALCON',0,1),(37,'Телевизор TCL 55C6K',NULL,69999.00,'/images/1763001657091-154394064.jpg','Телевизоры',1,'TCL',0,1),(48,'Samsung Galaxy Book 4 NP750XG',NULL,66999.00,'/images/1762999608611-427049895.jpg','Ноутбуки',0,'Samsung',NULL,0),(49,'Xiaomi Book 14',NULL,39999.00,'/images/1762999814364-120111877.jpg','Ноутбуки',0,'Xiaomi',NULL,0),(50,'Apple MacBook Pro M4 PRO',NULL,98999.00,'/images/1763000119007-721427548.png','Ноутбуки',0,'Apple',NULL,0),(51,'Apple MacBook Air',NULL,63999.00,'/images/1763000163881-593747153.jpg','Ноутбуки',0,'Apple',NULL,0),(52,'Apple MacBook Air M4',NULL,96999.00,'/images/1763000207497-358214642.png','Ноутбуки',0,'Apple',NULL,0),(53,' Xiaomi RedmiBook 15',NULL,28999.00,'/images/1762999882357-620904969.jpg','Ноутбуки',0,'Xiaomi',NULL,0),(54,' LG Gram 17',NULL,44999.00,'/images/1763000295904-188412649.jpg','Ноутбуки',0,'LG',NULL,0),(55,'Samsung Galaxy S24 FE 256 ГБ',NULL,48999.00,'/images/1762998502169-919839342.jpg','Смартфоны',0,'Samsung',NULL,0),(56,'Sony Xperia 1 VII 256 ГБ',NULL,89999.00,'/images/1762998741293-132939747.jpg','Смартфоны',0,'Sony',NULL,0),(57,'HUAWEI Pura 80 Pro 512 ГБ',NULL,79999.00,'/images/1762998904161-782418260.jpg','Смартфоны',0,'Huawei',NULL,0),(58,' Sony Xperia 1 VII 256 ГБ',NULL,89999.00,'/images/1762998820436-256522088.jpg','Смартфоны',0,'Sony',NULL,0),(59,'Samsung Galaxy M55 256 ГБ',NULL,24999.00,'/images/1762998571890-964320747.jpg','Смартфоны',0,'Samsung',NULL,0),(60,'Apple iPhone 13 128 ГБ',NULL,47999.00,'/images/1762998263411-772740312.jpg','Смартфоны',0,'Apple',NULL,0),(61,' Apple iPhone 13 128 ГБ',NULL,46999.00,'/images/1762998335681-48983132.jpg','Смартфоны',0,'Apple',NULL,0),(62,'Samsung Galaxy A56 256 ГБ',NULL,34999.00,'/images/1762998636078-313935639.jpg','Смартфоны',0,'Samsung',NULL,0),(64,'HUAWEI nova 13 Pro 512 ГБ',NULL,40999.00,'/images/1762998961422-669843990.jpg','Смартфоны',0,'Huawei',NULL,0),(65,'Телевизор Harper 85U755TS',NULL,98999.00,'/images/1763001989132-99603794.png','Телевизоры',0,'Harper',NULL,0),(66,'Телевизор Hyundai H-LED85BU7007',NULL,88999.00,'/images/1763002196844-970783706.jpg','Телевизоры',0,'Hyundai',NULL,0),(67,'Телевизор Samsung UE85DU8000UXRU',NULL,89999.00,'/images/1763002373954-931098469.jpg','Телевизоры',0,'Samsung',NULL,0),(68,'Телевизор Samsung QE43Q7FAAUXRU',NULL,42999.00,'/images/1763002403487-92291686.jpg','Телевизоры',0,'Samsung',NULL,0),(69,'Телевизор Harper 75Q851TS',NULL,75999.00,'/images/1763002032612-947655039.jpg','Телевизоры',0,'Harper',NULL,0),(70,'Телевизор Samsung QE50Q60DAUXRU',NULL,72999.00,'/images/1763002434155-320422154.jpg','Телевизоры',0,'Samsung',NULL,0),(71,'Телевизор Harper 32R720T',NULL,22999.00,'/images/1763002087281-949983761.jpg','Телевизоры',0,'Harper',NULL,0),(72,'Телевизор Hisense 65E7Q PRO',NULL,65999.00,'/images/1763001148561-328699979.png','Телевизоры',0,'Hisense',NULL,0),(73,'Телевизор Hyundai H-LED65BU7009',NULL,42999.00,'/images/1763002232211-826617321.png','Телевизоры',0,'Hyundai',NULL,0),(74,' Телевизор Hisense 55U7NQ',NULL,59999.00,'/images/1763001191313-222858428.png','Телевизоры',0,'Hisense',NULL,0),(75,'Телевизор Hyundai H-LED40BS5002',NULL,12999.00,'/images/1763002303676-629193194.jpg','Телевизоры',0,'Hyundai',NULL,0),(76,'Телевизор Hisense 65E7NQ',NULL,49999.00,'/images/1763001236640-906331473.png','Телевизоры',0,'Hisense',NULL,0),(77,'Телевизор TCL 50P7K',NULL,34999.00,'/images/1763001751725-847790892.jpg','Телевизоры',0,'TCL',NULL,0),(78,' Телевизор TCL 55P6K',NULL,31999.00,'/images/1763001792092-58907335.jpg','Телевизоры',0,'TCL',NULL,0),(79,'Телевизор TCL 65C8K',NULL,87999.00,'/images/1763001843973-393843290.jpg','Телевизоры',0,'TCL',NULL,0),(80,'Телевизор Haier 75 Mini LED',NULL,89999.00,'/images/1763000636074-63545113.jpg','Телевизоры',0,'Haier',NULL,0),(81,'Телевизор Haier 43 Smart TV S4 ',NULL,33999.00,'/images/1763000694480-585267741.jpg','Телевизоры',0,'Haier',NULL,0),(82,'Haier 50 Smart TV S5 PRO',NULL,55999.00,'/images/1763000727273-517899535.jpg','Телевизоры',0,'Haier',NULL,0),(83,'Телевизор iFFALCON 85U75',NULL,97999.00,'/images/1763001485575-995013761.jpg','Телевизоры',0,'iFFALCON',NULL,0),(84,'Телевизор iFFALCON IFF75U64',NULL,59999.00,'/images/1763001549962-708570403.jpg','Телевизоры',0,'iFFALCON',NULL,0),(85,'LG Gram 14',NULL,22999.00,'/images/1763000351103-377778847.jpg','Ноутбуки',0,'LG',NULL,0),(86,'LG Gram 16',NULL,33999.00,'/images/1763000398024-971703605.jpg','Ноутбуки',0,'LG',NULL,0),(91,' Xiaomi RedmiBook 15',NULL,31999.00,'/images/1762999933369-785312826.jpg','Ноутбуки',0,'Xiaomi',NULL,0),(92,' Xiaomi Book 14',NULL,49999.00,'/images/1762999985403-458828554.jpg','Ноутбуки',0,'Xiaomi',NULL,0),(108,'HUAWEI Mate70 Pro 512 ГБ',NULL,79999.00,'/images/1762999019674-930274720.jpg','Смартфоны',0,'Huawei',0,0);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'маркез','$2b$10$F9lsfcPO0QTC8bfafKJnI.bt09.nrmKx8k1OHDMYVB/UJszZbR4du','2025-04-15 15:39:48'),(14,'3213123@gmail.com','$2b$10$fkbasIhWsm1g3bjqw5zREe/xxknNaWNCLSCxS7U3bjm5oK.dqxIBS','2025-04-15 16:14:15'),(15,'markez222','$2b$10$9m7JlScIC3NFPKkJwiAvi.Tcu4vK02A8vocw2e8p5g3HuwT8Uc/XC','2025-11-13 02:57:08');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'storechicco'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-18 20:24:16
