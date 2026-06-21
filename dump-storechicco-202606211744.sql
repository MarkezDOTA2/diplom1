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
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'admin','$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','2026-06-20 23:14:08');
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
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cart_product` (`cart_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
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
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
INSERT INTO `carts` VALUES (1,2,'2026-06-20 23:16:36');
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Смартфоны','smartphones','Смартфоны и мобильные телефоны ведущих мировых брендов',NULL,'📱',1,1),(2,'Ноутбуки','laptops','Ноутбуки для работы, учебы и развлечений',NULL,'💻',2,1),(3,'Телевизоры','tvs','Smart TV, LED, OLED телевизоры',NULL,'fas fa-tv',3,1),(4,'Холодильники','refrigerators','Холодильники и морозильные камеры',NULL,'🧊',4,1),(5,'Компьютеры','computers','Ноутбуки, ПК, моноблоки',NULL,'🖥️',5,1),(6,'Наушники','headphones','Наушники, TWS гарнитуры, аудиотехника',NULL,'🎧',6,1),(7,'Аксессуары','accessories','Чехлы, кабели, зарядные устройства и аксессуары',NULL,'🔌',7,1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
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
  UNIQUE KEY `uk_user_product` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (8,2,14),(7,2,15),(6,2,25),(5,2,26);
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
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,23,2,120990.00),(2,2,12,1,27990.00),(3,3,3,1,79990.00);
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
  `user_id` int DEFAULT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('new','paid','shipped','delivered','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'new',
  `payment_method` enum('online','cash') COLLATE utf8mb4_unicode_ci DEFAULT 'cash',
  `payment_status` enum('pending','paid','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,2,'admin1','+7 (950) 053-96-72','Самовывоз: г. Ангарск, ул. Примерная, 123',241980.00,'delivered','online','paid','2026-06-21 00:51:18'),(2,2,'TRET','+74234234243','Самовывоз: г. Ангарск, ул. Примерная, 123',27990.00,'new','cash','pending','2026-06-21 01:23:33'),(3,2,'Сергей Иванович Иванов','+7 (950) 053-96-72','Самовывоз: г. Ангарск, ул. Примерная, 123',79990.00,'paid','cash','pending','2026-06-21 01:24:06');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_transactions`
--

DROP TABLE IF EXISTS `payment_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','completed','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payment_transactions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_transactions`
--

LOCK TABLES `payment_transactions` WRITE;
/*!40000 ALTER TABLE `payment_transactions` DISABLE KEYS */;
INSERT INTO `payment_transactions` VALUES (1,1,241980.00,'completed','card',NULL,'2026-06-21 00:51:18');
/*!40000 ALTER TABLE `payment_transactions` ENABLE KEYS */;
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
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (2,3,'/images/1781998232430-555401472.jpg',0),(3,4,'/images/1781998494083-610526703.jpeg',0),(4,2,'/images/1781998617772-185158916.jpg',0),(6,1,'/images/1781998755870-824082953.jpg',0),(7,7,'/images/1781998945536-820786950.jpg',0),(8,6,'/images/1781999078581-130627369.jpg',0),(9,5,'/images/1781999222783-661314727.jpg',0),(10,16,'/images/1781999423425-260487225.jpg',0),(12,8,'/images/1781999721969-30352987.jpg',0),(15,17,'/images/1781999986223-798793514.jpg',0),(16,18,'/images/1782000102847-244643410.jpg',0),(17,9,'/images/1781999574843-374793937.jpg',0),(18,11,'/images/1782000512548-585007691.jpg',0),(19,10,'/images/1782000666718-859083850.jpg',0),(20,19,'/images/1782000861711-932933814.jpg',0),(21,20,'/images/1782001005009-133995881.jpg',0),(23,21,'/images/1782001183543-16259227.jpg',0),(24,22,'/images/1782001409551-710092065.jpg',0),(25,23,'/images/1782001519741-623772250.jpg',0),(26,24,'/images/1782001645868-332677637.jpg',0),(27,14,'/images/1782001782128-276675219.jpg',0),(28,15,'/images/1782001924557-297425771.jpeg',0),(29,25,'/images/1782002210225-882287153.jpg',0),(30,26,'/images/1782002441632-595048586.jpg',0),(31,13,'/images/1782002639051-745037796.jpg',0),(32,27,'/images/1782002874744-189565781.jpg',0),(33,28,'/images/1782003006791-469714785.jpg',0),(35,29,'/images/1782032000803-512079580.jpg',0),(37,30,'/images/1782032608908-364933055.jpg',0),(38,31,'/images/1782032904954-797396472.jpg',0),(39,32,'/images/1782033055395-940667309.jpg',0),(40,33,'/images/1782033180501-688601492.jpg',0),(41,34,'/images/1782033301104-63329673.jpg',0),(42,35,'/images/1782033421667-627035163.jpg',0),(44,36,'/images/1782033558122-845241723.jpg',0),(45,38,'/images/1782034054852-819294821.jpg',0),(46,39,'/images/1782034140841-693924212.jpg',0),(47,40,'/images/1782034246593-61012511.jpg',0),(48,41,'/images/1782034321571-457757084.jpg',0),(49,42,'/images/1782034540186-435867656.jpg',0),(50,43,'/images/1782034629288-89006561.jpg',0),(51,44,'/images/1782034711791-322042192.jpg',0);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_specs`
--

DROP TABLE IF EXISTS `product_specs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_specs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `spec_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `spec_value` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `product_specs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=583 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_specs`
--

LOCK TABLES `product_specs` WRITE;
/*!40000 ALTER TABLE `product_specs` DISABLE KEYS */;
INSERT INTO `product_specs` VALUES (66,3,'Память','8/256 ГБ',0),(67,3,'Производитель','Xiaomi',1),(68,3,'Год выхода','2025',2),(69,3,'Модель','Xiaomi Redmi Note 14 Pro',3),(70,3,'Оперативная память','8 ГБ',4),(71,3,'Операционная система','Android',5),(72,3,'Емкость батареи (mAh)','5500',6),(73,3,'Цвет','черный',7),(74,3,'Диагональ экрана (дюйм)','6.67',8),(75,3,'Количество ядер','8',9),(76,4,'Страна','Китай',0),(77,4,'Год релиза','2022',1),(78,4,'Серия','iPhone 14',2),(79,4,'Разрешение экрана','2532x1170 Пикс',3),(80,4,'Экран','6.1\"2532x1170 Пикс',4),(81,4,'Технология экрана','OLED',5),(82,4,'Тип экрана','Super Retina XDR',6),(83,4,'Частота обновления','60 Гц',7),(84,4,'Тип процессора','A15 Bionic',8),(85,2,'Операционная система','Android 14, One UI 6.1',0),(86,2,'Процессор','Snapdragon 8 Gen 3 (4 нм)',1),(87,2,'Дисплей','6.8\" Dynamic AMOLED 2X, 3088×1440 px, 120 Гц',2),(88,2,'Основная камера','200 МП + 12 МП + 10 МП + 50 МП',3),(89,2,'Фронтальная камера','12 МП',4),(90,2,'ОЗУ','12 ГБ',5),(91,2,'Встроенная память','256 ГБ',6),(92,2,'Аккумулятор','5000 мАч, 45 Вт зарядка',7),(93,2,'Стилус','S Pen встроенный',8),(94,2,'Стандарты связи','5G, LTE, Wi-Fi 7, Bluetooth 5.3',9),(107,1,'Операционная система','iOS 17',0),(108,1,'Процессор','Apple A17 Pro (3 нм)',1),(109,1,'Дисплей','6.1\" Super Retina XDR OLED, 2556×1179 px, 460 ppi',2),(110,1,'Основная камера','48 МП + 12 МП (ультраширокий) + 12 МП (телефото 3×)',3),(111,1,'Фронтальная камера','12 МП, f/1.9',4),(112,1,'ОЗУ','8 ГБ',5),(113,1,'Встроенная память','256 ГБ',6),(114,1,'Аккумулятор','3274 мАч, 18 Вт зарядка',7),(115,1,'Материал корпуса','Титан Grade 5, стекло',8),(116,1,'Диагональ экрана','6.1 дюймов',9),(117,1,'SIM-карта','nano-SIM + eSIM',10),(118,1,'Стандарты связи','5G, LTE, Wi-Fi 6E, Bluetooth 5.3',11),(119,7,'Процессор','Intel Core Ultra 7 155U',0),(120,7,'Количество ядер процессора','12',1),(121,7,'Частота процессора','1.2 - 4.8 ГГц',2),(122,7,'Графический процессор','встроенный Intel',3),(123,7,'Объём оперативной памяти','32 ГБ',4),(124,7,'Тип оперативной памяти','LPDDR5x 6400 МГц',5),(125,7,'Общий объём накопителей','512 ГБ',6),(126,7,'Тип накопителей','SSD M.2 2280 PCIe 4.0x4',7),(127,7,'Диагональ дисплея','14\"',8),(128,7,'Экран','1920x1200, IPS, 400 нит, 100% sRGB, 60 Гц, антибликовое покрытие',9),(129,6,'Тип ноутбука','Игровой',0),(130,6,'Бренд процессора','AMD',1),(131,6,'Модель процессора','AMD Ryzen 9 7940HS',2),(132,6,'Количество ядер процессора','8',3),(133,6,'Частота процессора','4 ГГц (Base), 5.2 ГГц (Boost)',4),(134,6,'Объем оперативной памяти','16 ГБ',5),(135,6,'Тип оперативной памяти','DDR5',6),(136,6,'Общий объем накопителей','512 ГБ',7),(137,6,'Тип накопителя','SSD',8),(138,6,'Серия графического процессора','NVIDIA GeForce RTX 4060, 8 ГБ',9),(139,6,'Диагональ экрана','14 дюймов',10),(140,6,'Экран','2560 x 1600, IPS, 165 Гц, 500 нит',11),(141,5,'Операционная система','macOS Sonoma',0),(142,5,'Процессор','Apple M3 Pro (12-ядерный CPU, 18-ядерный GPU)',1),(143,5,'Дисплей','14.2\" Liquid Retina XDR, 3024×1964 px, 120 Гц',2),(144,5,'ОЗУ','18 ГБ унифицированной памяти',3),(145,5,'Накопитель','512 ГБ SSD',4),(146,5,'Аккумулятор','70 Вт·ч, до 17 часов работы',5),(147,5,'Порты','3× Thunderbolt 4, HDMI, SD-карт, MagSafe 3',6),(148,5,'Вес','1.61 кг',7),(149,16,'Бренд процессора','Intel',0),(150,16,'Модель процессора','Core Ultra 7 258V',1),(151,16,'Количество ядер процессора','8',2),(152,16,'Частота процессора','2.2 - 4.8 ГГц',3),(153,16,'Объем оперативной памяти','32 ГБ',4),(154,16,'Тип оперативной памяти','LPDDR5x',5),(155,16,'Общий объем накопителей','1 ТБ',6),(156,16,'Тип накопителя','M.2 PCIe Gen4x4 SSD',7),(157,16,'Серия графического процессора','встроенный, Arc 140V',8),(158,16,'Диагональ экрана','15.3\"',9),(159,16,'Экран','2880х1800, 120 Гц, OLED, 100% DCI-P3',10),(171,8,'Диагональ','65 дюймов',0),(172,8,'Тип матрицы','QLED',1),(173,8,'Разрешение','3840×2160 (4K UHD)',2),(174,8,'Частота обновления','120 Гц',3),(175,8,'HDR','Quantum HDR, HDR10+',4),(176,8,'Smart TV','Tizen OS',5),(177,8,'Порты','4× HDMI 2.1, 2× USB, Wi-Fi, Bluetooth',6),(178,8,'Звук','60 Вт, Dolby Atmos',7),(205,17,'Тип телевизора','LED',0),(206,17,'Диагональ','65\"',1),(207,17,'Разрешение','3840 × 2160 пикселей',2),(208,17,'Поддержка HDR','Да',3),(209,17,'Частота обновления экрана','120 Гц',4),(210,17,'Подсветка экрана','QD Mini LED',5),(211,17,'Оперативная память','3 ГБ',6),(212,17,'Размер встроенной памяти','64 ГБ',7),(213,17,'Яркость','1500 нит',8),(214,17,'Звуковая мощность','40 Вт',9),(215,17,'Звук','Dolby Atmos, OTS',10),(216,17,'Подключения','Bluetooth 5.2, Wi-Fi 5',11),(217,17,'Smart TV','Да',12),(218,18,'Тип подсветки экрана','Mini LED',0),(219,18,'Диагональ','75\"',1),(220,18,'Разрешение HD','4K',2),(221,18,'Разрешение','3840 x 2160',3),(222,18,'Поддержка HDR','да',4),(223,18,'Частота обновления экрана','144 Гц в 4K',5),(224,18,'Процессор','ARM Cortex-A73, 4 ядра',6),(225,18,'Графический процессор','Mali-G52 (2EE) MC1',7),(226,18,'Технологии','Dolby Vision Gaming, AMD FreeSync Premium',8),(227,18,'Номинальная мощность звука','2 x 15 Вт',9),(228,18,'Беспроводное подключение','Wi-Fi 6, Bluetooth 5.2',10),(229,18,'Платформа','HyperOS 3',11),(230,18,'Размер оперативной памяти','4 ГБ',12),(231,18,'Размер встроенной памяти','64 ГБ',13),(232,9,'Тип подсветки экрана','OLED',0),(233,9,'Диагональ','55\"',1),(234,9,'Разрешение HD','Ultra HD 4K',2),(235,9,'Разрешение','3840 х 2160',3),(236,9,'Угол обзора','178 градусов',4),(237,9,'Частота обновления экрана','120 Гц, 144 Гц (VRR)',5),(238,9,'Время отклика','0.1 мс',6),(239,9,'Функции звука','Dolby Atmos',7),(240,9,'Суммарная мощность звука','40 Вт',8),(241,9,'Интерфейсы','4х HDMI 2.1, 3х USB 2.0, 1х SPDIF, 1х RF вход, 1х Ethernet',9),(242,9,'Smart TV','да',10),(243,11,'Тип','холодильник с морозильником',0),(244,11,'Расположение морозильной камеры','снизу',1),(245,11,'Управление','электронное',2),(246,11,'Цвет','белый',3),(247,11,'Полезный объём','325 л',4),(248,11,'Объём холодильной камеры','247 л',5),(249,11,'Объём морозильной камеры','78 л',6),(250,11,'Кол-во компрессоров','1',7),(251,11,'Инверторный компрессор','нет',8),(252,11,'Кол-во камер','2',9),(253,11,'Кол-во дверей','2',10),(254,11,'Сигнализация','есть',11),(255,10,'Тип','холодильник с морозильником',0),(256,10,'Расположение морозильной камеры','снизу',1),(257,10,'Управление','электронное',2),(258,10,'Цвет','нержавеющая сталь',3),(259,10,'Полезный объём','371 л',4),(260,10,'Объём холодильной камеры','271 л',5),(261,10,'Объём морозильной камеры','100 л',6),(262,10,'Кол-во компрессоров','1',7),(263,10,'Инверторный компрессор','да',8),(264,10,'Кол-во камер','2',9),(265,10,'Кол-во дверей','2',10),(266,19,'Тип','холодильник с морозильником',0),(267,19,'Расположение морозильной камеры','снизу',1),(268,19,'Управление','электромеханическое',2),(269,19,'Цвет','серебристый',3),(270,19,'Полезный объём','256 л',4),(271,19,'Объём холодильной камеры','181 л',5),(272,19,'Объём морозильной камеры','75 л',6),(273,19,'Кол-во компрессоров','1',7),(274,19,'Инверторный компрессор','нет',8),(275,19,'Кол-во камер','2',9),(276,19,'Кол-во дверей','2',10),(277,20,'Тип','холодильник с морозильником',0),(278,20,'Расположение морозильной камеры','снизу',1),(279,20,'Управление','электронное',2),(280,20,'Цвет','серебристый',3),(281,20,'Полезный объём','348 л',4),(282,20,'Объём холодильной камеры','254 л',5),(283,20,'Объём морозильной камеры','94 л',6),(284,20,'Кол-во компрессоров','1',7),(285,20,'Инверторный компрессор','нет',8),(286,20,'Кол-во камер','2',9),(287,20,'Кол-во дверей','2',10),(288,20,'Сигнализация','есть',11),(297,21,'Операционная система','Windows 11 Pro',0),(298,21,'Процессор','AMD Ryzen 9 9900X3D (120 Вт TDP)',1),(299,21,'Видеокарта','NVIDIA GeForce RTX 5070 Ti с 16 ГБ видеопамяти GDDR7',2),(300,21,'Установленная оперативная память','32 ГБ',3),(301,21,'Общий объем установленного хранилища','2 ТБ',4),(302,21,'Внешние отсеки','не указаны производителем',5),(303,21,'Входы/выходы','1x USB-C 3.1/3.2 Gen 2',6),(304,21,'Входы/выходы дисплея','3x DisplayPort 1.4a',7),(305,22,'Чипсет','Intel Z890',0),(306,22,'Процессор','Intel Core Ultra 9 285',1),(307,22,'Разъем ЦП','LGA 1851',2),(308,22,'ЦП','24-ядерный:',3),(309,22,'Выделенные ядра ИИ','Да',4),(310,22,'Кэш L3','36 МБ',5),(311,22,'Тип графики','Выделенный',6),(312,22,'Графический процессор','AMD Radeon RX 9070 с 16 ГБ видеопамяти GDDR6',7),(313,22,'Установленная оперативная память','32 ГБ',8),(314,22,'Тип ОЗУ','6400 МТ/с DDR5',9),(315,23,'Процессор','Intel Core i7-14700F (14-го поколения)',0),(316,23,'Разъем ЦП','LGA 1700',1),(317,23,'ЦП','20-ядерный: от 2,1 до 5,3 ГГц Производительность (8 ядер)',2),(318,23,'Выделенные ядра ИИ','Да: 614 TOPS',3),(319,23,'Кэш L3','33 МБ',4),(320,23,'Тип графики','Выделенный',5),(321,23,'графический процессор','NVIDIA GeForce RTX 5060',6),(322,23,'Установленная оперативная память','16 ГБ',7),(323,23,'Тип ОЗУ','DDR5',8),(324,23,'Конфигурация/емкость ОЗУ','/ 4 слота',9),(325,23,'Поддержка vPro','Нет',10),(326,24,'Чипсет','AMD B650',0),(327,24,'Процессор','AMD Ryzen 7-8700F',1),(328,24,'Разъем процессора','AM5',2),(329,24,'Процессор','8-ядерный: от 4,1 до 5 ГГц (8 ядер)',3),(330,24,'Выделенные ядра для ИИ','нет',4),(331,24,'Кэш L3','16 МБ',5),(332,24,'Тип графики','выделенный',6),(333,24,'Графический процессор','NVIDIA GeForce RTX 5060 с 8 ГБ видеопамяти GDDR7',7),(334,24,'Установленная оперативная память','16 ГБ',8),(335,24,'Тип ОЗУ','6000 МТ/с DDR5',9),(336,14,'Назначение','для смартфона',0),(337,14,'Тип','чехол',1),(338,14,'Совместимость','iPhone 17 Pro Max',2),(339,14,'Материалы','техническая ткань (полиэстер)',3),(340,15,'Угол поворота','360°',0),(341,15,'Крышка','телескопическая, регулируемая',1),(342,15,'Материал','ABS, силикон',2),(343,15,'Цвет','черный',3),(344,15,'Размеры','12 × 7 × 6 см',4),(345,15,'Вес','115 г',5),(346,25,'Страна производства','Китай',0),(347,25,'Срок службы товара','5 лет',1),(348,25,'Гарантийный срок','1 год',2),(349,25,'Размер циферблата','45 мм, 44 мм, 46 мм, 49 мм',3),(350,25,'Застежка','пряжка',4),(351,25,'Регулировка ремешка','да',5),(352,25,'Материал застежки','металл',6),(353,26,'Цвет','Черный',0),(354,26,'Количество портов USB-C','1',1),(355,26,'Кредит возможен','Да',2),(356,26,'Материал','пластик',3),(357,26,'Ширина','16.5 см',4),(358,26,'Толщина','10 см',5),(359,26,'Высота','17.5 см',6),(360,26,'Вес','333 г',7),(361,26,'Тип','Беспроводные ЗУ',8),(362,26,'Мощность, Вт','15',9),(363,26,'Напряжение питания','9 В, 12 В',10),(364,26,'Сила тока','3 А',11),(365,26,'Тип подключения','USB-C',12),(366,13,'Длина кабеля, см','120',0),(367,13,'Модуль связи Bluetooth','5.0',1),(368,13,'Кабель и штекер','L-образный штекер',2),(369,13,'Разъем','3.5 мм',3),(370,13,'Конструкция наушников','накладные',4),(371,13,'Мин. частота, Гц','20',5),(372,13,'Макс. частота, Гц','20000',6),(373,13,'Сопротивление, Ом','32',7),(374,13,'Способ передачи звука','динамики',8),(375,13,'Тип подключения','беспроводное, проводное',9),(376,13,'Вес товара, г','165',10),(385,12,'Тип','беспроводные',0),(386,12,'Шумоподавление','Активное (ANC), до -30 дБ',1),(387,12,'Время работы','30 часов (с ANC)',2),(388,12,'Зарядка','USB-C, 10 мин = 5 часов',3),(389,12,'Кодеки','SBC, AAC, LDAC, aptX',4),(390,12,'Частотный диапазон','4 Гц – 40 кГц',5),(391,12,'Вес','250 г',6),(392,12,'Подключение','Bluetooth 5.2, NFC',7),(393,27,'Тип подключения','Беспроводной',0),(394,27,'Тип наушников','Полноразмерные',1),(395,27,'Технология','Динамические',2),(396,27,'Микрофон','Есть',3),(397,27,'Количество микрофонов','11',4),(398,27,'Система активного шумоподавления (ANC)','Есть',5),(399,27,'Время воспроизведения','До 20 часов на одном заряде (с ANC)',6),(400,27,'Время разговора','До 20 часов на одном заряде',7),(401,27,'Быстрая зарядка','5 минут зарядки = 1.5 часа',8),(402,27,'Интерфейс','Type-C',9),(403,27,'Подключение','Bluetooth 5.3',10),(404,27,'Размер','168.6 x 187.3 x 83.4 мм',11),(405,27,'Вес','386.2 г',12),(406,28,'Тип подключения','беспроводное',0),(407,28,'Тип наушников','вкладыши',1),(408,28,'Активное шумоподавление','да, при звонках',2),(409,28,'Тип крепления','зажим для уха',3),(410,28,'Размер динамика','11 мм, 9 мм',4),(411,28,'Глубина шумоподавления','до 55 дБ',5),(412,28,'Частотный диапазон','20 - 40000 Гц',6),(413,28,'Чувствительность','до 115 дБ',7),(414,28,'Микрофон','да, 2 кремниевых + 1 VPU',8),(415,28,'Чувствительность микрофона','-38 дБ',9),(416,28,'Тип беспроводного подключения','Bluetooth 6.1',10),(417,28,'Радиус действия','10 м',11),(418,29,'Основной дисплей','6,9\", 2608x1200, LTPO AMOLED, 120 Гц',0),(419,29,'Дополнительный дисплей','2,9\", 976x596, LTPO AMOLED, 120 Гц',1),(420,29,'Основная камера','50 МП + 50 МП + 50 МП',2),(421,29,'Фронтальная камера','50 МП',3),(422,29,'Объем оперативной памяти','12 Гб',4),(423,29,'Объем встроенной памяти','512 Гб',5),(424,29,'Процессор','Snapdragon 8 Elite Gen 5',6),(425,29,'Графический процессор','Adreno 840',7),(426,29,'Емкость аккумулятора','7500 мАч',8),(427,29,'Быстрая зарядка','есть, 100 Вт',9),(428,29,'Беспроводная зарядка','есть, 50 Вт',10),(429,29,'Сканер отпечатка пальца','есть',11),(431,30,'Платформа','HiOS 15',0),(432,30,'Операционная система','Android 15',1),(433,30,'Кол-во физических SIM-карт','2 шт.',2),(434,30,'Тип SIM-карты','nano-SIM',3),(435,30,'Поддержка eSIM','нет',4),(436,30,'Тип дисплея','AMOLED',5),(437,30,'Диагональ дисплея','6.78 \"',6),(438,30,'Разрешение дисплея','2720x1224 пикс.',7),(439,30,'Частота обновления экрана','144 Гц',8),(440,30,'Процессор','MediaTek Dimensity 7300',9),(441,30,'Ultimate Частота процессора','2500 МГц',10),(442,30,'Кол-во ядер процессора','8',11),(443,30,'Видеопроцессор','Mali-G615 MC2',12),(444,30,'Камера (основная)','64+8 Мпикс.',13),(445,30,'Камера (фронтальная)','13 Мпикс.',14),(446,30,'Вспышка','светодиодная',15),(447,30,'Оперативная память','12 Гб',16),(448,30,'Встроенная память','256 Гб',17),(449,31,'Основной дисплей','6,82\'\', LTPO OLED, 2868 x 232, 5000 нит, 120 Гц',0),(450,31,'Дополнительный дисплей','4,0\'\', LTPO OLED, 1200 x 1092, 5000 нит, 120 Гц',1),(451,31,'Процессор','Qualcomm Snapdragon 8 Gen 3',2),(452,31,'Графический чип','Adreno 750',3),(453,31,'Оперативная память','12 Гб',4),(454,31,'Встроенная память','512 Гб',5),(455,31,'Основная камера','тройной модуль, 200 МП + 50 МП + 50 МП',6),(456,31,'Фронтальная камера','50 МП',7),(457,32,'Дисплей','6,9\", AMOLED, 2608 х 1200, 120 Гц, 3500 нит',0),(458,32,'Основная камера','50 МП + 200 МП + 50 МП',1),(459,32,'Фронтальная камера','50 МП',2),(460,32,'Объем оперативной памяти','12 Гб',3),(461,32,'Объем встроенной памяти','512 Гб',4),(462,32,'Процессор','Snapdragon 8 Elite Gen 5',5),(463,32,'Емкость аккумулятора','6800 мАч',6),(464,32,'Быстрая зарядка','есть, 90 Вт',7),(465,32,'Беспроводная зарядка','есть, 50 Вт',8),(466,32,'Сканер отпечатка пальца','есть',9),(467,33,'Бренд процессора','Intel',0),(468,33,'Модель процессора','Core i5-12450H',1),(469,33,'Количество ядер процессора','8',2),(470,33,'Частота процессора','1.5 - 4.4 ГГц',3),(471,33,'Объем оперативной памяти','8 ГБ',4),(472,33,'Тип оперативной памяти','DDR4',5),(473,33,'Общий объем накопителей','512 ГБ',6),(474,33,'Тип накопителя','SSD',7),(475,33,'Серия графического процессора','Nvidia GeForce RTX 2050 4 ГБ',8),(476,33,'Диагональ экрана','15.6 дюймов',9),(477,33,'Разрешение экрана','1920 x 1080',10),(478,34,'Тип ноутбука','игровой',0),(479,34,'Бренд процессора','Intel',1),(480,34,'Модель процессора','Core Ultra 9 275HX',2),(481,34,'Количество ядер процессора','24',3),(482,34,'Частота процессора','2.7 - 5.4 ГГц',4),(483,34,'Объем оперативной памяти','32 ГБ',5),(484,34,'Тип оперативной памяти','DDR5',6),(485,34,'Общий объем накопителей','1 ТБ',7),(486,34,'Тип накопителя','M.2 NVMe SSD',8),(487,34,'Серия графического процессора','NVIDIA GeForce RTX 5070',9),(488,34,'Диагональ экрана, дюймы','16',10),(489,34,'Разрешение экрана','2560 x 1600',11),(490,34,'Частота обновления экрана','165 Гц',12),(491,35,'Диагональ дисплея','13\'\'',0),(492,35,'Тип/технология матрицы','IPS',1),(493,35,'Разрешение дисплея','2408 х 1506',2),(494,35,'Яркость','500 нит',3),(495,35,'Цветовое пространство','sRGB',4),(496,35,'Объем оперативной памяти','8 ГБ',5),(497,35,'Объем встроенной памяти','256 ГБ SSD',6),(498,35,'Процессор','Apple A18 Pro',7),(499,35,'Количество ядер процессора','6',8),(500,35,'Количество ядер видеокарты','5',9),(510,36,'Бренд процессора','AMD',0),(511,36,'Модель процессора','Ryzen 5 PRO 230',1),(512,36,'Количество ядер процессора','6/12',2),(513,36,'Частота процессора','3.5 - 4.9 ГГц',3),(514,36,'Объем оперативной памяти','16 ГБ',4),(515,36,'Тип оперативной памяти','DDR5 7500 МГц',5),(516,36,'Общий объем накопителей','512 ГБ',6),(517,36,'Тип накопителя','SSD',7),(518,36,'Серия графического процессора','AMD Radeon 760M (8 ядер)',8),(519,37,'Тип подсветки экрана','Direct LED',0),(520,37,'Диагональ','65\"',1),(521,37,'Разрешение HD','Ultra HD 4K',2),(522,37,'Разрешение','3840 x 2160',3),(523,37,'Поддержка HDR','есть',4),(524,37,'Формат телевизора','16',5),(525,37,'Угол обзора','178 градусов',6),(526,37,'Частота обновления экрана','120 Гц',7),(527,38,'Тип подсветки экрана','Mini-LED',0),(528,38,'Диагональ','55\"',1),(529,38,'Разрешение','3840 x 2160',2),(530,38,'Поддержка HDR','есть',3),(531,38,'Форматы HDR','Dolby Vision/HDR Vivid/HDR10/HLG',4),(532,38,'Углы обзора','178°',5),(533,38,'Частота обновления экрана','120 Гц',6),(534,38,'Функции звука','Acoustic Multi-Audio, Voice Zoom 3, Dolby Atmos, DTS',7),(535,38,'Мощность звука','32 Вт',8),(536,39,'Тип подсветки экрана','Mini LED',0),(537,39,'Диагональ','55\"',1),(538,39,'Разрешение HD','4K Ultra HD',2),(539,39,'Разрешение','3840 x 2160',3),(540,39,'Поддержка HDR','да',4),(541,39,'Формат телевизора','16',5),(542,39,'Частота обновления экрана','240 Гц',6),(543,39,'Контрастность','125000',7),(544,40,'Тип подсветки экрана','Triluminos',0),(545,40,'Диагональ','55\"',1),(546,40,'Разрешение','3840 x 2160',2),(547,40,'Поддержка HDR','есть',3),(548,40,'Форматы HDR','Dolby Vision/HDR10/HLG',4),(549,40,'Углы обзора','178°',5),(550,40,'Частота обновления экрана','60 Гц',6),(551,41,'Тип','side-by-side',0),(552,41,'Метод охлаждения','воздушное',1),(553,41,'Общий объем','436 л',2),(554,41,'Объем холодильной камеры','257 л',3),(555,41,'Объем морозильной камеры','154 л',4),(556,41,'Объем камеры с переменной температурой','25 л',5),(557,42,'Способ охлаждения','статический',0),(558,42,'Класс энергоэффективности','1',1),(559,42,'Климатический класс','N',2),(560,42,'Компрессор','с фиксированной частотой',3),(561,42,'Количество дверей','1',4),(562,42,'Количество камер','2',5),(563,42,'Общий объём','136 л',6),(564,42,'Объём холодильной камеры','124 л',7),(565,42,'Объём морозильной камеры','12 л',8),(566,43,'Способ охлаждения','статический',0),(567,43,'Класс энергоэффективности','1',1),(568,43,'Климатический класс','N',2),(569,43,'Компрессор','с фиксированной частотой',3),(570,43,'Способ контроля температуры','электронный',4),(571,43,'Количество дверей','1',5),(572,43,'Количество камер','1',6),(573,43,'Общий объем','92 л',7),(574,44,'Способ охлаждения','воздушный',0),(575,44,'Класс энергоэффективности','1',1),(576,44,'Климатический класс','N',2),(577,44,'Компрессор','с фиксированной частотой',3),(578,44,'Количество дверей','1',4),(579,44,'Количество камер','2',5),(580,44,'Общий объём','135 л',6),(581,44,'Объём холодильной камеры','115 л',7),(582,44,'Объём морозильной камеры','20 л',8);
/*!40000 ALTER TABLE `product_specs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL,
  `old_price` decimal(10,2) DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT '0',
  `showOnMain` tinyint(1) DEFAULT '0',
  `is_deleted` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `specs` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_brand` (`brand`),
  KEY `idx_featured` (`is_featured`),
  KEY `idx_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Apple iPhone 15 Pro 256GB Natural Titanium','Смартфон Apple iPhone 15 Pro оснащён чипом A17 Pro, первым в мире с трёхнанометровым техпроцессом. Профессиональная камерная система с 48 МП главным сенсором, телеобъективом 3× и ультраширокоугольной камерой позволяет снимать на уровне профессиональной техники.',69990.00,89990.00,'/images/1781998758115-980355746.jpg','Смартфоны','Apple',1,0,0,'2026-06-20 23:14:08','Операционная система: iOS 17\nПроцессор: Apple A17 Pro (3 нм)\nДисплей: 6.1\" Super Retina XDR OLED, 2556×1179 px, 460 ppi\nОсновная камера: 48 МП + 12 МП (ультраширокий) + 12 МП (телефото 3×)\nФронтальная камера: 12 МП, f/1.9\nОЗУ: 8 ГБ\nВстроенная память: 256 ГБ\nАккумулятор: 3274 мАч, 18 Вт зарядка\nМатериал корпуса: Титан Grade 5, стекло\nДиагональ экрана: 6.1 дюймов\nSIM-карта: nano-SIM + eSIM\nСтандарты связи: 5G, LTE, Wi-Fi 6E, Bluetooth 5.3'),(2,'Samsung Galaxy S24 Ultra 256GB Titanium Black','Samsung Galaxy S24 Ultra — флагманский смартфон с встроенным стилусом S Pen и революционным искусственным интеллектом Galaxy AI. Камера 200 МП с оптическим зумом 5× и 10× обеспечивает профессиональное качество снимков в любых условиях.',79990.00,89990.00,'/images/1781998629128-151325534.png','Смартфоны','Samsung',1,0,0,'2026-06-20 23:14:08','Операционная система: Android 14, One UI 6.1\nПроцессор: Snapdragon 8 Gen 3 (4 нм)\nДисплей: 6.8\" Dynamic AMOLED 2X, 3088×1440 px, 120 Гц\nОсновная камера: 200 МП + 12 МП + 10 МП + 50 МП\nФронтальная камера: 12 МП\nОЗУ: 12 ГБ\nВстроенная память: 256 ГБ\nАккумулятор: 5000 мАч, 45 Вт зарядка\nСтилус: S Pen встроенный\nСтандарты связи: 5G, LTE, Wi-Fi 7, Bluetooth 5.3'),(3,'Xiaomi 14 Pro 256GB Black','Xiaomi 14 Pro — топовый флагман с объективом Leica, чипом Snapdragon 8 Gen 3 и быстрой зарядкой 120 Вт. Аккумулятор 4880 мАч полностью заряжается всего за 23 минуты.',79990.00,NULL,'/images/1781998233752-236467077.jpg','Смартфоны','Xiaomi',1,0,0,'2026-06-20 23:14:08','Память: 8/256 ГБ\nПроизводитель: Xiaomi\nГод выхода: 2025\nМодель: Xiaomi Redmi Note 14 Pro\nОперативная память: 8 ГБ\nОперационная система: Android\nЕмкость батареи (mAh): 5500\nЦвет: черный\nДиагональ экрана (дюйм): 6.67\nКоличество ядер: 8'),(4,'Apple iPhone 14 128GB Midnight','iPhone 14 с улучшенной системой безопасности Emergency SOS via satellite, улучшенной камерой и чипом A15 Bionic обеспечивает надёжную производительность на весь день.',39990.00,NULL,'/images/1781998045044-183257514.jpeg','Смартфоны','Apple',0,0,0,'2026-06-20 23:14:08','Страна: Китай\nГод релиза: 2022\nСерия: iPhone 14\nРазрешение экрана: 2532x1170 Пикс\nЭкран: 6.1\"2532x1170 Пикс\nТехнология экрана: OLED\nТип экрана: Super Retina XDR\nЧастота обновления: 60 Гц\nТип процессора: A15 Bionic'),(5,'Apple MacBook Pro 14\" M3 Pro 512GB','MacBook Pro с чипом M3 Pro устанавливает новые стандарты производительности для профессиональных пользователей. Великолепный дисплей Liquid Retina XDR, до 22 часов автономной работы и мощная нейронная система делают его идеальным инструментом для творчества.',149990.00,199990.00,'/images/1781999234890-861025333.jpg','Ноутбуки','Apple',1,0,0,'2026-06-20 23:14:08','Операционная система: macOS Sonoma\nПроцессор: Apple M3 Pro (12-ядерный CPU, 18-ядерный GPU)\nДисплей: 14.2\" Liquid Retina XDR, 3024×1964 px, 120 Гц\nОЗУ: 18 ГБ унифицированной памяти\nНакопитель: 512 ГБ SSD\nАккумулятор: 70 Вт·ч, до 17 часов работы\nПорты: 3× Thunderbolt 4, HDMI, SD-карт, MagSafe 3\nВес: 1.61 кг'),(6,'ASUS ROG Zephyrus G14 AMD Ryzen 9','Игровой ноутбук ASUS ROG Zephyrus G14 сочетает мощь AMD Ryzen 9 и GeForce RTX 4060 в тонком и лёгком корпусе. Дисплей 2560×1600 с частотой 165 Гц обеспечивает плавный геймплей.',119990.00,NULL,'/images/1781999079878-539620587.jpg','Ноутбуки','ASUS',1,0,0,'2026-06-20 23:14:08','Тип ноутбука: Игровой\nБренд процессора: AMD\nМодель процессора: AMD Ryzen 9 7940HS\nКоличество ядер процессора: 8\nЧастота процессора: 4 ГГц (Base), 5.2 ГГц (Boost)\nОбъем оперативной памяти: 16 ГБ\nТип оперативной памяти: DDR5\nОбщий объем накопителей: 512 ГБ\nТип накопителя: SSD\nСерия графического процессора: NVIDIA GeForce RTX 4060, 8 ГБ\nДиагональ экрана: 14 дюймов\nЭкран: 2560 x 1600, IPS, 165 Гц, 500 нит'),(7,'Lenovo ThinkPad X1 Carbon Gen 12','Легендарный ThinkPad X1 Carbon в 12-м поколении предлагает невероятно лёгкий корпус (менее 1.12 кг), процессор Intel Core Ultra 7 и превосходную клавиатуру для максимальной продуктивности.',154990.00,NULL,'/images/1781998946465-228556522.jpg','Ноутбуки','Lenovo',0,0,0,'2026-06-20 23:14:08','Процессор: Intel Core Ultra 7 155U\nКоличество ядер процессора: 12\nЧастота процессора: 1.2 - 4.8 ГГц\nГрафический процессор: встроенный Intel\nОбъём оперативной памяти: 32 ГБ\nТип оперативной памяти: LPDDR5x 6400 МГц\nОбщий объём накопителей: 512 ГБ\nТип накопителей: SSD M.2 2280 PCIe 4.0x4\nДиагональ дисплея: 14\"\nЭкран: 1920x1200, IPS, 400 нит, 100% sRGB, 60 Гц, антибликовое покрытие'),(8,'Samsung Neo QLED 4K TV QN87D, 65\", 4K, Mini LED, 120 Гц','QLED-телевизор Samsung Q80C обеспечивает яркое изображение с квантовыми точками, объёмный звук и плавное воспроизведение контента благодаря частоте обновления 120 Гц и игровому режиму с низкой задержкой.',119990.00,149990.00,'/images/1781999723968-768421510.jpg','Телевизоры','Samsung',1,0,0,'2026-06-20 23:14:08','Диагональ: 65 дюймов\nТип матрицы: QLED\nРазрешение: 3840×2160 (4K UHD)\nЧастота обновления: 120 Гц\nHDR: Quantum HDR, HDR10+\nSmart TV: Tizen OS\nПорты: 4× HDMI 2.1, 2× USB, Wi-Fi, Bluetooth\nЗвук: 60 Вт, Dolby Atmos'),(9,'LG OLED Evo C5, 55\", 4K, OLED, 144 Гц,','В LG OLED Evo серии AI C5 используется OLED-панель с разрешением 3840 × 2160 и переменной частотой обновления до 144 Гц, время отклика составляет 0,1 мс. \nМодель поддерживает такие функции, как NVIDIA G-Sync, FreeSync Premium, GeForce NOW, Game Portal, VRR, ALLM, eARC и HGiG.',224990.00,189990.00,'/images/1781999618435-90102702.jpg','Телевизоры','LG',1,0,0,'2026-06-20 23:14:08','Тип подсветки экрана: OLED\nДиагональ: 55\"\nРазрешение HD: Ultra HD 4K\nРазрешение: 3840 х 2160\nУгол обзора: 178 градусов\nЧастота обновления экрана: 120 Гц, 144 Гц (VRR)\nВремя отклика: 0.1 мс\nФункции звука: Dolby Atmos\nСуммарная мощность звука: 40 Вт\nИнтерфейсы: 4х HDMI 2.1, 3х USB 2.0, 1х SPDIF, 1х RF вход, 1х Ethernet\nSmart TV: да'),(10,'Холодильник  MDRB509FGF46ID','Холодильник Midea с технологией Twin Cooling Plus поддерживает оптимальную влажность в каждой камере независимо. SpaceMax позволяет разместить больше продуктов в стандартных габаритах.',39990.00,NULL,'/images/1782000672801-226840619.jpg','Холодильники','Midea',1,0,0,'2026-06-20 23:14:08','Тип: холодильник с морозильником \nРасположение морозильной камеры:снизу \nУправление:электронное\nЦвет:нержавеющая сталь \nПолезный объём:371 л \nОбъём холодильной камеры:271 л \nОбъём морозильной камеры:100 л \nКол-во компрессоров:1 \nИнверторный компрессор:да \nКол-во камер:2 \nКол-во дверей:2'),(11,'Холодильник Indesit ITR 5200 W','Холодильник Indesit ITR 5200 W с системой охлаждения No Frost – хорошее подспорье на вашей кухне. Общий полезный объем в 325 литров позволит закупать впрок продукты для ваших любимых блюд.',34990.00,NULL,'/images/1782000515772-913728702.jpg','Холодильники','Indesit',0,0,0,'2026-06-20 23:14:08','Тип: холодильник с морозильником \nРасположение морозильной камеры: снизу \nУправление: электронное \nЦвет: белый \nПолезный объём: 325 л \nОбъём холодильной камеры: 247 л \nОбъём морозильной камеры: 78 л \nКол-во компрессоров: 1 \nИнверторный компрессор: нет \nКол-во камер: 2 \nКол-во дверей: 2 \nСигнализация: есть'),(12,'Apple AirPods 4, с активным шумоподавлением, беспроводная зарядка','Apple представила обновленное поколение базовых наушников-вкладышей AirPods 4 с активным шумоподавлением. Наушники получили уменьшенный кейс, порт USB-C и поддержку жестового управления.',27990.00,NULL,'/images/1782002737968-64212267.jpg','Наушники','Apple',1,0,0,'2026-06-20 23:14:08','Тип: беспроводные\nШумоподавление: Активное (ANC), до -30 дБ\nВремя работы: 30 часов (с ANC)\nЗарядка: USB-C, 10 мин = 5 часов\nКодеки: SBC, AAC, LDAC, aptX\nЧастотный диапазон: 4 Гц – 40 кГц\nВес: 250 г\nПодключение: Bluetooth 5.2, NFC'),(13,'Беспроводные наушники Marshall Major IV, черный','Встречайте Major IV, культовые наушники от Marshall с более чем 80 часами беспроводного воспроизведения, беспроводной зарядкой и новым улучшенным эргономичным дизайном.',14990.00,NULL,'/images/1782002642338-154248802.jpg','Наушники','Marshall',1,0,0,'2026-06-20 23:14:08','Длина кабеля, см:120\nМодуль связи Bluetooth:5.0\nКабель и штекер:L-образный штекер\nРазъем:3.5 мм\nКонструкция наушников:накладные\nМин. частота, Гц: 20\nМакс. частота, Гц:20000\nСопротивление, Ом:32\nСпособ передачи звука:динамики\nТип подключения:беспроводное, проводное\nВес товара, г: 165'),(14,'Чехол Apple TechWoven Case для iPhone 17 Pro Max, оранжевый','Чехол TechWoven с технологией MagSafe, разработанный компанией Apple, позволяет персонализировать ваш iPhone 17 Pro Max и обеспечивает его защиту.',5990.00,NULL,'/images/1782001782949-225527596.jpg','Аксессуары','Apple',0,0,0,'2026-06-20 23:14:08','Назначение: для смартфона\nТип: чехол\nСовместимость: iPhone 17 Pro Max\nМатериалы: техническая ткань (полиэстер)'),(15,'Автомобильный держатель для телефона, универсальный, TechProtect, черный','Автомобильный держатель для телефона Tech-Protect V5 - это универсальное, устойчивое и гибкое решение для безопасного использования смартфона в автомобиле.',3490.00,NULL,'/images/1782001925605-736284946.jpg','Аксессуары','TechProtect',0,0,0,'2026-06-20 23:14:08','Угол поворота: 360°\nКрышка: телескопическая, регулируемая\nМатериал: ABS, силикон\nЦвет: черный\nРазмеры: 12 × 7 × 6 см\nВес: 115 г'),(16,'ThinkPad X9 15 Aura, 15.3\", 32 ГБ/1 ТБ, Ultra 7 258V','Бизнес-ноутбуки Lenovo серии ThinkPad X9 15 Aura оснащены процессором линейки Intel Ultra 200V \"Lunar Lake\" и имеют тонкий (6,8 мм) и лёгкий (1.4 кг) металлический корпус с большой сенсорной панелью.',125990.00,155990.00,'/images/1781999425842-466079821.jpg','Ноутбуки','Lenovo',1,0,0,'2026-06-20 23:50:25','Бренд процессора: Intel\nМодель процессора: Core Ultra 7 258V\nКоличество ядер процессора: 8\nЧастота процессора: 2.2 - 4.8 ГГц\nОбъем оперативной памяти: 32 ГБ\nТип оперативной памяти: LPDDR5x\nОбщий объем накопителей: 1 ТБ\nТип накопителя: M.2 PCIe Gen4x4 SSD\nСерия графического процессора: встроенный, Arc 140V\nДиагональ экрана: 15.3\"\nЭкран: 2880х1800, 120 Гц, OLED, 100% DCI-P3'),(17,'Samsung Neo QLED TV QNX9D, 65\", 4K, Mini LED, 120 Гц','Мощный процессор искусственного интеллекта обеспечивает реалистичное изображение 4K. Технология улучшения изображения 4K AI от Samsung поддерживается 20 нейронными сетями AI и может обеспечить качество изображения, близкое к 4K.',135990.00,150990.00,'/images/1781999987459-356065417.jpg','Телевизоры','Samsung',0,0,0,'2026-06-20 23:56:27','Тип телевизора: LED\nДиагональ: 65\"\nРазрешение: 3840 × 2160 пикселей\nПоддержка HDR: Да\nЧастота обновления экрана: 120 Гц\nПодсветка экрана: QD Mini LED\nОперативная память: 3 ГБ\nРазмер встроенной памяти: 64 ГБ\nЯркость: 1500 нит\nЗвуковая мощность: 40 Вт\nЗвук: Dolby Atmos, OTS\nПодключения: Bluetooth 5.2, Wi-Fi 5\nSmart TV: Да'),(18,'Xiaomi TV REDMI X 75 (2026), 75\", 4К, Mini LED, 288 Гц','Телевизор REDMI TV X 2026 с подсветкой Mini LED открывает новую эру в мире домашних кинотеатров. Благодаря технологии Mini LED с 512  индивидуально управляемыми зонами, он обеспечивает невероятное качество изображения с высокой детализацией и глубиной. Подсветка минимизирует засветы и усиливает динамический диапазон, делая просмотр фильмов и игр реалистичным.',47990.00,55990.00,'/images/1782000162796-598071454.jpg','Телевизоры','Xiaomi',0,0,0,'2026-06-21 00:02:42','Тип подсветки экрана: Mini LED\nДиагональ: 75\"\nРазрешение HD: 4K\nРазрешение: 3840 x 2160\nПоддержка HDR: да\nЧастота обновления экрана: 144 Гц в 4K\nПроцессор: ARM Cortex-A73, 4 ядра\nГрафический процессор: Mali-G52 (2EE) MC1\nТехнологии: Dolby Vision Gaming, AMD FreeSync Premium\nНоминальная мощность звука: 2 x 15 Вт\nБеспроводное подключение: Wi-Fi 6, Bluetooth 5.2\nПлатформа: HyperOS 3\nРазмер оперативной памяти: 4 ГБ\nРазмер встроенной памяти: 64 ГБ'),(19,'Холодильник Stinol STN 167 G','Холодильник двухкамерный Stinol STS 200 серого цвета обеспечивает качественное хранение продуктов благодаря продуманной конструкции и высоте 200 см.',25990.00,NULL,'/images/1782000863786-149805778.jpg','Холодильники','Stinol',0,0,0,'2026-06-21 00:14:23','Тип:холодильник с морозильником \nРасположение морозильной камеры:снизу \nУправление:электромеханическое \nЦвет:серебристый \nПолезный объём:256 л \nОбъём холодильной камеры:181 л \nОбъём морозильной камеры:75 л \nКол-во компрессоров:1 \nИнверторный компрессор:нет \nКол-во камер:2\nКол-во дверей:2'),(20,'Холодильник Atlant ХМ 4626-181 NL','Холодильник серии 46-NL (COMFORT) снабжен интеллектуальными решениями для легкого повседневного использования, а инновационный дизайн и элегантный стиль позволит вписать технику в любой интерьер.',56990.00,NULL,'/images/1782001006043-432375004.jpg','Холодильники','Atlant',0,0,0,'2026-06-21 00:16:46','Тип:холодильник с морозильником \nРасположение морозильной камеры:снизу \nУправление:электронное \nЦвет:серебристый \nПолезный объём:348 л \nОбъём холодильной камеры:254 л\nОбъём морозильной камеры:94 л \nКол-во компрессоров:1 \nИнверторный компрессор:нет \nКол-во камер:2 \nКол-во дверей:2 \nСигнализация:есть'),(21,'MSI Infinite ZS Gaming Desktop Computer INFINITE ZS 9NVR-1482US','Получите непревзойденные игровые возможности с игровым настольным компьютером MSI Infinite ZS. Оснащенный мощным 12-ядерным процессором AMD Ryzen 9 9900X3D с жидкостным охлаждением и дискретной видеокартой NVIDIA GeForce RTX 5070 Ti, ноутбук Infinite ZS легко запускает требовательные игры и приложения. Видеокарта RTX 5070 Ti обеспечивает высокую частоту кадров и поддерживает расширенные функции, такие как трассировка лучей в реальном времени, искусственный интеллект, DLSS и многое другое.',259990.00,299990.00,'/images/1782001184706-295714036.jpg','Компьютеры','MSI',0,0,0,'2026-06-21 00:19:44','Операционная система: Windows 11 Pro\nПроцессор: AMD Ryzen 9 9900X3D (120 Вт TDP)\nВидеокарта: NVIDIA GeForce RTX 5070 Ti с 16 ГБ видеопамяти GDDR7\nУстановленная оперативная память: 32 ГБ\nОбщий объем установленного хранилища: 2 ТБ\nВнешние отсеки: не указаны производителем\nВходы/выходы: 1x USB-C 3.1/3.2 Gen 2\nВходы/выходы дисплея: 3x DisplayPort 1.4a'),(22,'CyberPowerPC Gamer Supreme Liquid Cool','Исследуйте захватывающие миры и создавайте контент с помощью настольного компьютера CyberPowerPC Gamer Supreme Liquid Cool. Gamer Supreme, оснащенный передовыми игровыми компонентами, позволяет вам с легкостью играть в игры, проектировать, редактировать и делать многое другое.',199990.00,205990.00,'/images/1782001415968-794988419.jpg','Компьютеры','CyberPowerPC',0,0,0,'2026-06-21 00:23:35','Чипсет: Intel Z890\nПроцессор: Intel Core Ultra 9 285\nРазъем ЦП: LGA 1851\nЦП: 24-ядерный:\nПроизводительность от 2,5 до 5,4 ГГц (8 ядер)\nЭффективность от 1,9 до 4,6 ГГц (16 Ядра)\nВыделенные ядра ИИ: Да\nКэш L3: 36 МБ\nТип графики: Выделенный\nГрафический процессор: AMD Radeon RX 9070 с 16 ГБ видеопамяти GDDR6\nУстановленная оперативная память: 32 ГБ\nТип ОЗУ: 6400 МТ/с DDR5'),(23,'Acer Nitro 60 Desktop Computer N60-640-UR22','Наслаждайтесь оптимальными игровыми сессиями с настольным компьютером Acer Nitro 60. Благодаря 12-ядерному процессору Intel Core i7 14-го поколения и видеокарте NVIDIA RTX 5060, Nitro 60 с легкостью справится с вашими любимыми компьютерными играми. Благодаря элегантному дизайну и подсветке aRGB вы можете настроить Nitro 60 под любой игровой компьютер. Nitro 60 также оснащен слотами расширения, такими как PCIe, M.2 и другими, для модернизации в будущем.',120990.00,135990.00,'/images/1782001521443-509545068.jpg','Компьютеры','Acer',0,0,0,'2026-06-21 00:25:21','Процессор: Intel Core i7-14700F (14-го поколения)\nРазъем ЦП: LGA 1700\nЦП: 20-ядерный: от 2,1 до 5,3 ГГц Производительность (8 ядер)\nОт 1,5 до 4,2 ГГц Эффективность (12 ядер)\nВыделенные ядра ИИ: Да: 614 TOPS\nКэш L3: 33 МБ\nТип графики: Выделенный\nграфический процессор: NVIDIA GeForce RTX 5060\nУстановленная оперативная память: 16 ГБ\nТип ОЗУ: DDR5\nКонфигурация/емкость ОЗУ: / 4 слота\nПоддержка vPro: Нет'),(24,'MSI Codex Z2 Gaming Desktop Computer CODEX Z2 A8NVL-484US','Игровой настольный компьютер Codex Z2 от MSI, оснащенный высококачественным оборудованием, обеспечивает геймерам повышенную производительность для работы с широким спектром графически требовательных игр. Этот настольный компьютер, оснащенный 8-ядерным процессором AMD Ryzen 7 8700F с вентилятором охлаждения и графикой NVIDIA GeForce RTX 5060, обеспечивает насыщенные игровые возможности и ускоряет создание контента.',110990.00,125990.00,'/images/1782001646891-900374555.jpg','Компьютеры','MSI',0,0,0,'2026-06-21 00:27:26','Чипсет: AMD B650\nПроцессор: AMD Ryzen 7-8700F\nРазъем процессора: AM5\nПроцессор: 8-ядерный: от 4,1 до 5 ГГц (8 ядер)\nВыделенные ядра для ИИ: нет\nКэш L3: 16 МБ\nТип графики: выделенный\nГрафический процессор: NVIDIA GeForce RTX 5060 с 8 ГБ видеопамяти GDDR7\nУстановленная оперативная память: 16 ГБ\nТип ОЗУ: 6000 МТ/с DDR5'),(25,'Ремешок Akkerds на Apple Watch S9/s8/s7/se/ultra2, оранжевый','Удобный ремешок из фторэластомера, созданный специально для любителей дайвинга. Он идеально держится даже на мокром гидрокостюме и не вызывает раздражения во время тренировок. Ремешок оснащён устойчивой к коррозии титановой пряжкой и таким же кольцом для фиксации края. Кольцо может быть установлено в любые из отверстий Ocean Band.',1699.00,2099.00,'/images/1782002211731-167015966.jpg','Аксессуары','Akkerds',0,0,0,'2026-06-21 00:36:51','Страна производства: Китай\nСрок службы товара: 5 лет\nГарантийный срок:1 год\nРазмер циферблата:45 мм, 44 мм, 46 мм, 49 мм\nЗастежка:пряжка\nРегулировка ремешка:да\nМатериал застежки:металл'),(26,'Беспроводная зарядная станция ALOGIC MagSpeed 3-в-1','Беспроводная зарядная станция MagSpeed 3 in 1 от Alogic позволяет с удобством заряжать три ваших устройства одновременно – просто разместите Ваш iPhone на круглой шайбе с поддержкой технологии MagSafe, на нижней подставке – AirPods любой модели (поколения с поддержкой беспроводной зарядки Qi), а на «шайбе» справа – ваши Apple Watch.',11999.00,12990.00,'/images/1782002444691-134706326.jpg','Аксессуары','ALOGIC',0,0,0,'2026-06-21 00:40:44','Цвет: Черный\nКоличество портов USB-C: 1\nКредит возможен: Да\nМатериал: пластик\nШирина: 16.5 см\nТолщина: 10 см\nВысота: 17.5 см\nВес: 333 г\nТип: Беспроводные ЗУ\nМощность, Вт: 15\nНапряжение питания: 9 В, 12 В\nСила тока: 3 А\nТип подключения: USB-C'),(27,'Apple AirPods Max 2, Purple','Лучший в мире опыт прослушивания в полноразмерных наушниках — теперь в пяти ярких цветах и с активным шумоподавлением, которое в 1.5 раза мощнее, чем у предыдущего поколения. AirPods Max 2 обеспечивают потрясающе детальное и высокоточное звучание в формате high-fidelity.',45990.00,NULL,'/images/1782002875478-491135283.jpg','Наушники','Apple',0,0,0,'2026-06-21 00:47:55','Тип подключения:Беспроводной\nТип наушников:Полноразмерные\nТип крепления;Оголовье\nТехнология:Динамические\nМикрофон:Есть\nКоличество микрофонов:11\nСистема активного шумоподавления (ANC):Есть\nВремя воспроизведения:До 20 часов на одном заряде (с ANC)\nВремя разговора:До 20 часов на одном заряде\nБыстрая зарядка:5 минут зарядки = 1.5 часа\nИнтерфейс:Type-C\nПодключение:Bluetooth 5.3\nРазмер:168.6 x 187.3 x 83.4 мм\nВес:386.2 г'),(28,'Наушники беспроводные Oppo Enco Clip 2, золотой','OPPO выпустила беспроводные наушники Enco Clip2, сочетающие открытую конструкцию с высоким качеством звука. Для достижения последнего показателя компании пришлось интегрировать в модель целый ряд различных технологий.',12990.00,NULL,'/images/1782003008696-951777334.jpg','Наушники','Oppo',0,0,0,'2026-06-21 00:50:08','Тип подключения:беспроводное\nТип наушников:вкладыши\nАктивное шумоподавление:да, при звонках\nТип крепления:зажим для уха\nРазмер динамика:11 мм, 9 мм\nГлубина шумоподавления:до 55 дБ\nЧастотный диапазон:20 - 40000 Гц\nЧувствительность:до 115 дБ\nМикрофон:да, 2 кремниевых + 1 VPU\nЧувствительность микрофона:-38 дБ\nТип беспроводного подключения:Bluetooth 6.1\nРадиус действия:10 м'),(29,'Xiaomi 17 Pro Max (CN), 12Гб/512Гб, 2 Nano-SIM','Xiaomi 17 Pro Max - это смартфон, который заполучил экран, расположенный в блоке камер.\nОн обладает корпусом толщиной в 8 мм и весом в 219 граммов. Он получил экран RGB OLED с диагональю 6,9 дюйма и разрешением 2608×1200 пикселей.',67990.00,NULL,'/images/1782032001899-538542079.jpg','Смартфоны','Xiaomi',0,0,0,'2026-06-21 08:53:21','Основной дисплей:6,9\", 2608x1200, LTPO AMOLED, 120 Гц\nДополнительный дисплей: 2,9\", 976x596, LTPO AMOLED, 120 Гц\nОсновная камера:50 МП + 50 МП + 50 МП\nФронтальная камера:50 МП\nОбъем оперативной памяти:12 Гб\nОбъем встроенной памяти:512 Гб\nПроцессор:Snapdragon 8 Elite Gen 5\nГрафический процессор:Adreno 840\nЕмкость аккумулятора:7500 мАч\nБыстрая зарядка:есть, 100 Вт\nБеспроводная зарядка:есть, 50 Вт\nСканер отпечатка пальца:есть'),(30,'TECNO Pova 7 Pro 5G 12/256GB','Умный ассистент Ella выполняет голосовые команды — от редактирования фото до вызова такси. А ещё TECNO Pova 7 Ultra 5G умеет генерировать тексты и изображения, искать информацию, решать математические задачи, переводить речь в реальном времени и расшифровывать аудиозаписи. И это лишь часть возможностей встроенного искусственного интеллекта.',23990.00,NULL,'/images/1782032609659-990369101.jpg','Смартфоны','TECNO',0,0,0,'2026-06-21 09:03:29','Платформа: HiOS 15 \nОперационная система:Android 15 \nКол-во физических SIM-карт:2 шт.\nТип SIM-карты:nano-SIM \nПоддержка eSIM:нет \nТип дисплея:AMOLED \nДиагональ дисплея:6.78 \" \nРазрешение дисплея:2720x1224 пикс. \nЧастота обновления экрана:144 Гц \nПроцессор:MediaTek Dimensity 7300 \nUltimate Частота процессора:2500 МГц \nКол-во ядер процессора:8 \nВидеопроцессор:Mali-G615 MC2 \nКамера (основная):64+8 Мпикс. \nКамера (фронтальная):13 Мпикс. \nВспышка:светодиодная \nОперативная память:12 Гб \nВстроенная память:256 Гб'),(31,'Honor Magic V Flip2 (CN), 12Гб/512Гб, Dual Nano-SIM','Honor Magic V Flip 2 — второе поколение складного смартфона-раскладушки, которое компания позиционирует как стильный аксессуар и технологичный флагман в одном лице.',75990.00,NULL,'/images/1782032906296-450691970.jpg','Смартфоны','Honor',0,0,0,'2026-06-21 09:08:26','Основной дисплей:6,82\'\', LTPO OLED, 2868 x 232, 5000 нит, 120 Гц\nДополнительный дисплей:4,0\'\', LTPO OLED, 1200 x 1092, 5000 нит, 120 Гц\nПроцессор:Qualcomm Snapdragon 8 Gen 3\nГрафический чип:Adreno 750\nОперативная память:12 Гб\nВстроенная память:512 Гб\nОсновная камера:тройной модуль, 200 МП + 50 МП + 50 МП\nФронтальная камера:50 МП'),(32,'Xiaomi 17 Ultra (CN), 12Гб/512Гб, Dual NanoSIM','Флагманский смартфон нового поколения, оснащённый мощным процессором Snapdragon 8 Elite Gen 5, обеспечивающим максимальную производительность для игр, бизнеса и мультимедиа.',84990.00,NULL,'/images/1782033056226-733639743.jpg','Смартфоны','Xiaomi',0,0,0,'2026-06-21 09:10:56','Дисплей:6,9\", AMOLED, 2608 х 1200, 120 Гц, 3500 нит\nОсновная камера:50 МП + 200 МП + 50 МП\nФронтальная камера:50 МП\nОбъем оперативной памяти:12 Гб\nОбъем встроенной памяти:512 Гб\nПроцессор:Snapdragon 8 Elite Gen 5\nЕмкость аккумулятора:6800 мАч\nБыстрая зарядка:есть, 90 Вт\nБеспроводная зарядка:есть, 50 Вт\nСканер отпечатка пальца:есть'),(33,'MSI Thin GF63 12UCX, 15.6\", 8 ГБ/512 ГБ, i5-12450H, RTX 2050','Новый взгляд на многоядерную архитектуру\nПроцессор Core i5 12-го поколения наделяет ноутбук Thin GF63 великолепной производительностью при запуске ресурсоемких игр и работе в многозадачном режиме.',63990.00,NULL,'/images/1782033181327-424982238.jpg','Ноутбуки','MSI',0,0,0,'2026-06-21 09:13:01','Бренд процессора:Intel\nМодель процессора:Core i5-12450H\nКоличество ядер процессора:8\nЧастота процессора:1.5 - 4.4 ГГц\nОбъем оперативной памяти:8 ГБ\nТип оперативной памяти:DDR4\nОбщий объем накопителей:512 ГБ\nТип накопителя:SSD\nСерия графического процессора:Nvidia GeForce RTX 2050 4 ГБ\nДиагональ экрана:15.6 дюймов\nРазрешение экрана:1920 x 1080'),(34,'Asus TUF Gaming F16, 16\", 32ГБ/1ТБ, Core Ultra 9 275HX, RTX 5070','С 16-дюймовым ноутбуком ASUS TUF Gaming F16 вы сможете играть в свои любимые компьютерные игры, не выходя из дома.',134990.00,155990.00,'/images/1782033301993-618631826.jpg','Ноутбуки','ASUS',0,0,0,'2026-06-21 09:15:02','Тип ноутбука:игровой\nБренд процессора:Intel\nМодель процессора:Core Ultra 9 275HX\nКоличество ядер процессора:24\nЧастота процессора:2.7 - 5.4 ГГц\nОбъем оперативной памяти:32 ГБ\nТип оперативной памяти:DDR5\nОбщий объем накопителей:1 ТБ\nТип накопителя:M.2 NVMe SSD\nСерия графического процессора:NVIDIA GeForce RTX 5070\nДиагональ экрана, дюймы:16\nРазрешение экрана:2560 x 1600\nЧастота обновления экрана:165 Гц'),(35,'Apple MacBook Neo 13\" (2026), A18 Pro, 8 ГБ/256 ГБ','Apple MacBook Neo — это потрясающий Mac, который имеет прочный корпус, красивые цвета и мощные функции — это волшебный способ каждый день влюбляться в Mac.',55990.00,NULL,'/images/1782033422706-10100870.jpg','Ноутбуки','Apple',0,0,0,'2026-06-21 09:17:02','Диагональ дисплея:13\'\'\nТип/технология матрицы:IPS\nРазрешение дисплея:2408 х 1506\nЯркость:500 нит\nЦветовое пространство:sRGB\nОбъем оперативной памяти:8 ГБ\nОбъем встроенной памяти:256 ГБ SSD\nПроцессор:Apple A18 Pro\nКоличество ядер процессора:6\nКоличество ядер видеокарты:5'),(36,'Dell Pro 14 Plus (92XY7), 14\", 16 ГБ/512 ГБ, Ryzen 5 PRO 230, Radeon 760M','Тонкий и лёгкий ноутбук Dell Pro 14 Plus оснащён алюминиевой верхней крышкой и подставкой для рук, что придаёт ему элегантный внешний вид и ощущение.',84990.00,NULL,'/images/1782033558999-634528455.jpg','Ноутбуки','Dell',0,0,0,'2026-06-21 09:19:19','Бренд процессора: AMD\nМодель процессора: Ryzen 5 PRO 230\nКоличество ядер процессора: 6/12\nЧастота процессора: 3.5 - 4.9 ГГц\nОбъем оперативной памяти: 16 ГБ\nТип оперативной памяти: DDR5 7500 МГц\nОбщий объем накопителей: 512 ГБ\nТип накопителя: SSD\nСерия графического процессора: AMD Radeon 760M (8 ядер)'),(37,'Sony KD-65X85L, 65\", 4К, Direct LED, 120 Гц','Высокая плавность движений и переходов обеспечивается за счёт частоты обновления экрана 120 Гц. Благодаря Motion Clarity даже самые динамичные сцены воспроизводятся плавно и без потери деталей. Инновационная технология, сравнивая ключевые составляющие изображения в последовательных кадрах, создает и добавляет дополнительные кадры между исходными.',105990.00,NULL,'/images/1782033978667-397276178.jpg','Телевизоры','Sony',0,0,0,'2026-06-21 09:26:18','Тип подсветки экрана:Direct LED\nДиагональ:65\"\nРазрешение HD:Ultra HD 4K\nРазрешение:3840 x 2160\nПоддержка HDR:есть\nФормат телевизора:16\nУгол обзора:178 градусов\nЧастота обновления экрана:120 Гц'),(38,'Sony Bravia 5 K-55XR50, 55\", 4K, Mini-LED, 120 Гц','Модель Sony Bravia XR50 5 серии оснащена 55-дюймовой панелью с Mini-LED подсветкой, обеспечивающая до 4 миллионов точно настроенных сегментов подсветки и 22-битный контроль оттенков серого.',137990.00,NULL,'/images/1782034055520-324756849.jpg','Телевизоры','Sony',0,0,0,'2026-06-21 09:27:35','Тип подсветки экрана:Mini-LED\nДиагональ:55\"\nРазрешение:3840 x 2160\nПоддержка HDR:есть\nФорматы HDR:Dolby Vision/HDR Vivid/HDR10/HLG\nУглы обзора:178°\nЧастота обновления экрана:120 Гц\nФункции звука:Acoustic Multi-Audio, Voice Zoom 3, Dolby Atmos, DTS\nМощность звука:32 Вт'),(39,'Huawei Vision Smart 5 SE, 55\", 4K Ultra HD, Mini LED, 240 Гц','HUAWEI Vision Smart Screen 5 SE получил Mini LED-панель с разрешением 3840 × 2160 пикселей и частотой обновления изображения 120 Гц. Однако устройство имеет возможность повысить скорость развертки вдвое — до 240 Гц. Пиковая яркость в режиме HDR достигает 800 нит. Коэффициент контрастности находится на уровне 125 0',55990.00,NULL,'/images/1782034141556-704374115.jpg','Телевизоры','Huawei',0,0,0,'2026-06-21 09:29:01','Тип подсветки экрана:Mini LED\nДиагональ:55\"\nРазрешение HD:4K Ultra HD\nРазрешение:3840 x 2160\nПоддержка HDR:да\nФормат телевизора:16\nЧастота обновления экрана:240 Гц\nКонтрастность:125000'),(40,'Sony Bravia 3 K-55S30, 55\", 4K, Triluminos, 60 Гц','Умный телевизор Sony Bravia 3 серии S30 - обновлённая ультратонкая модель с массой режимов для комфортного просмотра любимых кинофильмов, шоу, фото, а также для игр на любимых консолях.',89990.00,NULL,'/images/1782034247683-775451122.jpg','Телевизоры','Sony',0,0,0,'2026-06-21 09:30:47','Тип подсветки экрана:Triluminos\nДиагональ:55\"\nРазрешение:3840 x 2160\nПоддержка HDR:есть\nФорматы HDR:Dolby Vision/HDR10/HLG\nУглы обзора:178°\nЧастота обновления экрана:60 Гц'),(41,'Xiaomi Mijia BCD-436WMBI','Холодильник Xiaomi Mijia BCD-436WMBI для хранения свежих продуктов. Ультратонкий, занимающий мало места, более совершенная система хранения продуктов. Общий объем составляет 436 л, 18 отделений для хранения продуктов.',83990.00,NULL,'/images/1782034322361-948141724.jpg','Холодильники','Xiaomi',0,0,0,'2026-06-21 09:32:02','Тип:side-by-side\nМетод охлаждения:воздушное\nОбщий объем:436 л\nОбъем холодильной камеры:257 л\nОбъем морозильной камеры:154 л\nОбъем камеры с переменной температурой:25 л'),(42,'Холодильник барный Haier 136L, LC-136LHESD1','Haier 136L LC-136LHESD1- компактный холодильник, занимающий площадь всего 0,22 кв.м, станет эстетичным дополнением небольших кухонь и комнат. Дугообразный рисунок стекла дверцы придаёт мягкий привлекательный вид, а низкий уровень шума в 35 дБ гарантирует комфорт и спокойствие.',69990.00,NULL,'/images/1782034541215-374326678.jpg','Холодильники','Haier',0,0,0,'2026-06-21 09:35:41','Способ охлаждения:статический\nКласс энергоэффективности:1\nКлиматический класс:N\nКомпрессор:с фиксированной частотой\nКоличество дверей:1\nКоличество камер:2\nОбщий объём:136 л\nОбъём холодильной камеры:124 л\nОбъём морозильной камеры:12 л'),(43,'Холодильник барный Haier 92L, LC-92LH9EY1','Haier 92L LC-92LH9EY1 - компактный холодильник, занимающий площадь всего 0,22 кв.м, станет прекрасным дополнением небольших кухонь и комнат. Выполненный в привлекательном минималистичном дизайне, холодильник имеет мягкий цвет и скругленные углы, что позволит с лёгкостью интегрировать его в различные стили интерьера. Конструкция дверных петель скрыта в корпусе и позволяет приподнимать дверь.',44990.00,NULL,'/images/1782034630035-941962447.jpg','Холодильники','Haier',0,0,0,'2026-06-21 09:37:10','Способ охлаждения:статический\nКласс энергоэффективности:1\nКлиматический класс:N\nКомпрессор:с фиксированной частотой\nСпособ контроля температуры:электронный\nКоличество дверей:1\nКоличество камер:1\nОбщий объем:92 л'),(44,'Холодильник барный Haier 135L, LC-135LH69D1','Холодильник Haier 133L DS0133LH69D1 станет эстетичным дополнением небольших кухонь и комнат.\nВ 135 л общего объёма организовано пять зон для хранения. Возможность точной регулировки температурного режима для разного вида продуктов: от 2 до 15 ℃ для холодильной камеры, и от -20 до -6  ℃ для морозильной, обеспечит эффективное хранение на протяжении длительного времени.',69990.00,NULL,'/images/1782034712812-740492358.jpg','Холодильники','Haier',0,0,0,'2026-06-21 09:38:32','Способ охлаждения:воздушный\nКласс энергоэффективности:1\nКлиматический класс:N\nКомпрессор:с фиксированной частотой\nКоличество дверей:1\nКоличество камер:2\nОбщий объём:135 л\nОбъём холодильной камеры:115 л\nОбъём морозильной камеры:20 л');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promo_slides`
--

DROP TABLE IF EXISTS `promo_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promo_slides` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `badge` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `visual` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 0xF09F9B8DEFB88F,
  `gradient` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'linear-gradient(135deg,#0a9e94 0%,#2dbdb6 55%,#48D1CC 100%)',
  `btn1_text` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `btn1_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '/',
  `btn2_text` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `btn2_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promo_slides`
--

LOCK TABLES `promo_slides` WRITE;
/*!40000 ALTER TABLE `promo_slides` DISABLE KEYS */;
INSERT INTO `promo_slides` VALUES (1,'Лучшая электроника по выгодным ценам',NULL,'⚡ Горячие предложения','Смартфоны, ноутбуки, телевизоры и многое другое — гарантия качества от ведущих брендов.','🛍️','linear-gradient(135deg,#0a9e94 0%,#48d1cc 100%)','Смотреть каталог','/category/smartphones','Акции и скидки','/category/smartphones',1,1,'/images/1782031462855-883534725.jpg'),(2,'Смартфоны по лучшим ценам',NULL,'🔥 Скидки до 30%','Apple, Samsung, Xiaomi — флагманские модели по выгодным ценам. Успейте купить!','📱','linear-gradient(135deg,#0f7070 0%,#3dd4c8 100%)','Все смартфоны','/category/smartphones','Подробнее →','/category/smartphones',1,2,'/images/1782018256159-964816065.png'),(3,'Ноутбуки для любых задач',NULL,'💻 Для работы и учёбы','Производительные модели от ведущих производителей. Быстрая доставка и гарантия.','💻','linear-gradient(135deg,#0d6060 0%,#32c8be 100%)','Все ноутбуки','/category/laptops','Подробнее →','/category/laptops',1,3,'/images/1782031610779-212006110.png'),(4,'Аксессуарыи гаджеты',NULL,'⭐ Новинки сезона','Наушники, умные часы и аксессуары — всё для вашего цифрового образа жизни.','🎧','linear-gradient(135deg,#1a5a7a 0%,#40c8d0 100%)','Смотреть новинки','/category/headphones','Аксессуары →','/category/accessories',1,4,'/images/1782031710760-430311886.png');
/*!40000 ALTER TABLE `promo_slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delivery_mode` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'pickup',
  `delivery_street` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_house` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_apt` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_floor` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('user','admin','super_admin') COLLATE utf8mb4_unicode_ci DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'testuser','test@example.com','+7 (999) 123-45-67','$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','2026-06-20 23:14:08','pickup',NULL,NULL,NULL,NULL,'user'),(2,'admin1','klayfi32@yandex.ru','+7 (950) 053-96-72','$2b$10$Z0FXQKlzs16wM79yVEbOc.8l8wbUMFXtLSVkPeSbnoMSUKAKVkFd2','2026-06-20 23:16:35','pickup',NULL,NULL,NULL,NULL,'super_admin');
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

-- Dump completed on 2026-06-21 17:44:07
