-- ================================================
-- StoreChicco — Полная схема базы данных
-- Версия: 2.0
-- ================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------
-- Удаление существующих таблиц (порядок важен!)
-- ------------------------------------------------
DROP TABLE IF EXISTS `payment_transactions`;
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_items`;
DROP TABLE IF EXISTS `carts`;
DROP TABLE IF EXISTS `favorites`;
DROP TABLE IF EXISTS `product_specs`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `admins`;
DROP TABLE IF EXISTS `users`;

-- ------------------------------------------------
-- Таблица пользователей
-- ------------------------------------------------
CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `email` VARCHAR(255) DEFAULT NULL,
  `phone` VARCHAR(20) DEFAULT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Таблица администраторов
-- ------------------------------------------------
CREATE TABLE `admins` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Таблица категорий
-- ------------------------------------------------
CREATE TABLE `categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `slug` VARCHAR(100) NOT NULL UNIQUE,
  `description` TEXT DEFAULT NULL,
  `image_url` VARCHAR(500) DEFAULT NULL,
  `icon` VARCHAR(10) DEFAULT NULL,
  `sort_order` INT DEFAULT 0,
  `is_active` TINYINT(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `idx_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Таблица товаров
-- ------------------------------------------------
CREATE TABLE `products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(500) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `old_price` DECIMAL(10,2) DEFAULT NULL,
  `image_url` VARCHAR(500) DEFAULT NULL,
  `category` VARCHAR(100) DEFAULT NULL,
  `brand` VARCHAR(100) DEFAULT NULL,
  `is_featured` TINYINT(1) DEFAULT 0,
  `showOnMain` TINYINT(1) DEFAULT 0,
  `is_deleted` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_category` (`category`),
  INDEX `idx_brand` (`brand`),
  INDEX `idx_featured` (`is_featured`),
  INDEX `idx_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Дополнительные изображения товаров
-- ------------------------------------------------
CREATE TABLE `product_images` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `image_url` VARCHAR(500) NOT NULL,
  `sort_order` INT DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `idx_product_id` (`product_id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Технические характеристики товаров
-- ------------------------------------------------
CREATE TABLE `product_specs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `spec_name` VARCHAR(200) NOT NULL,
  `spec_value` VARCHAR(500) NOT NULL,
  `sort_order` INT DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `idx_product_id` (`product_id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Корзины
-- ------------------------------------------------
CREATE TABLE `carts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Позиции корзины
-- ------------------------------------------------
CREATE TABLE `cart_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cart_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cart_product` (`cart_id`, `product_id`),
  FOREIGN KEY (`cart_id`) REFERENCES `carts`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Избранное
-- ------------------------------------------------
CREATE TABLE `favorites` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Заказы
-- ------------------------------------------------
CREATE TABLE `orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT DEFAULT NULL,
  `customer_name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `address` TEXT NOT NULL,
  `total_price` DECIMAL(10,2) NOT NULL,
  `status` ENUM('new','paid','shipped','delivered','cancelled') DEFAULT 'new',
  `payment_method` ENUM('online','cash') DEFAULT 'cash',
  `payment_status` ENUM('pending','paid','failed') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_status` (`status`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Позиции заказа
-- ------------------------------------------------
CREATE TABLE `order_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_order_id` (`order_id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------
-- Платёжные транзакции
-- ------------------------------------------------
CREATE TABLE `payment_transactions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `status` ENUM('pending','completed','failed') DEFAULT 'pending',
  `payment_method` VARCHAR(50) DEFAULT NULL,
  `transaction_id` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ================================================
-- Начальные данные
-- ================================================

-- Категории электроники
INSERT INTO `categories` (`name`, `slug`, `icon`, `sort_order`, `description`) VALUES
('Смартфоны', 'smartphones', '📱', 1, 'Смартфоны и мобильные телефоны ведущих мировых брендов'),
('Ноутбуки', 'laptops', '💻', 2, 'Ноутбуки для работы, учебы и развлечений'),
('Телевизоры', 'tvs', '📺', 3, 'Smart TV, LED, OLED телевизоры'),
('Холодильники', 'refrigerators', '🧊', 4, 'Холодильники и морозильные камеры'),
('Компьютеры', 'computers', '🖥️', 5, 'Ноутбуки, ПК, моноблоки'),
('Наушники', 'headphones', '🎧', 6, 'Наушники, TWS гарнитуры, аудиотехника'),
('Аксессуары', 'accessories', '🔌', 7, 'Чехлы, кабели, зарядные устройства и аксессуары');

-- Администратор по умолчанию
-- Логин: admin | Пароль: admin123
INSERT INTO `admins` (`username`, `password_hash`) VALUES
('admin', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Пример пользователя (пароль: user123)
INSERT INTO `users` (`username`, `email`, `phone`, `password_hash`) VALUES
('testuser', 'test@example.com', '+7 (999) 123-45-67', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Примеры товаров (смартфоны)
INSERT INTO `products` (`name`, `description`, `price`, `image_url`, `category`, `brand`, `is_featured`) VALUES
('Apple iPhone 15 Pro 256GB Natural Titanium',
 'Смартфон Apple iPhone 15 Pro оснащён чипом A17 Pro, первым в мире с трёхнанометровым техпроцессом. Профессиональная камерная система с 48 МП главным сенсором, телеобъективом 3× и ультраширокоугольной камерой позволяет снимать на уровне профессиональной техники.',
 109990.00, '/images/placeholder.jpg', 'Смартфоны', 'Apple', 1),

('Samsung Galaxy S24 Ultra 256GB Titanium Black',
 'Samsung Galaxy S24 Ultra — флагманский смартфон с встроенным стилусом S Pen и революционным искусственным интеллектом Galaxy AI. Камера 200 МП с оптическим зумом 5× и 10× обеспечивает профессиональное качество снимков в любых условиях.',
 99990.00, '/images/placeholder.jpg', 'Смартфоны', 'Samsung', 1),

('Xiaomi 14 Pro 256GB Black',
 'Xiaomi 14 Pro — топовый флагман с объективом Leica, чипом Snapdragon 8 Gen 3 и быстрой зарядкой 120 Вт. Аккумулятор 4880 мАч полностью заряжается всего за 23 минуты.',
 79990.00, '/images/placeholder.jpg', 'Смартфоны', 'Xiaomi', 1),

('Apple iPhone 14 128GB Midnight',
 'iPhone 14 с улучшенной системой безопасности Emergency SOS via satellite, улучшенной камерой и чипом A15 Bionic обеспечивает надёжную производительность на весь день.',
 69990.00, '/images/placeholder.jpg', 'Смартфоны', 'Apple', 0);

-- Характеристики iPhone 15 Pro
INSERT INTO `product_specs` (`product_id`, `spec_name`, `spec_value`, `sort_order`) VALUES
(1, 'Операционная система', 'iOS 17', 1),
(1, 'Процессор', 'Apple A17 Pro (3 нм)', 2),
(1, 'Дисплей', '6.1" Super Retina XDR OLED, 2556×1179 px, 460 ppi', 3),
(1, 'Основная камера', '48 МП + 12 МП (ультраширокий) + 12 МП (телефото 3×)', 4),
(1, 'Фронтальная камера', '12 МП, f/1.9', 5),
(1, 'ОЗУ', '8 ГБ', 6),
(1, 'Встроенная память', '256 ГБ', 7),
(1, 'Аккумулятор', '3274 мАч, 18 Вт зарядка', 8),
(1, 'Материал корпуса', 'Титан Grade 5, стекло', 9),
(1, 'Диагональ экрана', '6.1 дюймов', 10),
(1, 'SIM-карта', 'nano-SIM + eSIM', 11),
(1, 'Стандарты связи', '5G, LTE, Wi-Fi 6E, Bluetooth 5.3', 12);

-- Характеристики Samsung Galaxy S24 Ultra
INSERT INTO `product_specs` (`product_id`, `spec_name`, `spec_value`, `sort_order`) VALUES
(2, 'Операционная система', 'Android 14, One UI 6.1', 1),
(2, 'Процессор', 'Snapdragon 8 Gen 3 (4 нм)', 2),
(2, 'Дисплей', '6.8" Dynamic AMOLED 2X, 3088×1440 px, 120 Гц', 3),
(2, 'Основная камера', '200 МП + 12 МП + 10 МП + 50 МП', 4),
(2, 'Фронтальная камера', '12 МП', 5),
(2, 'ОЗУ', '12 ГБ', 6),
(2, 'Встроенная память', '256 ГБ', 7),
(2, 'Аккумулятор', '5000 мАч, 45 Вт зарядка', 8),
(2, 'Стилус', 'S Pen встроенный', 9),
(2, 'Стандарты связи', '5G, LTE, Wi-Fi 7, Bluetooth 5.3', 10);

-- Примеры товаров (ноутбуки)
INSERT INTO `products` (`name`, `description`, `price`, `image_url`, `category`, `brand`, `is_featured`) VALUES
('Apple MacBook Pro 14" M3 Pro 512GB',
 'MacBook Pro с чипом M3 Pro устанавливает новые стандарты производительности для профессиональных пользователей. Великолепный дисплей Liquid Retina XDR, до 22 часов автономной работы и мощная нейронная система делают его идеальным инструментом для творчества.',
 199990.00, '/images/placeholder.jpg', 'Ноутбуки', 'Apple', 1),

('ASUS ROG Zephyrus G14 AMD Ryzen 9',
 'Игровой ноутбук ASUS ROG Zephyrus G14 сочетает мощь AMD Ryzen 9 и GeForce RTX 4060 в тонком и лёгком корпусе. Дисплей 2560×1600 с частотой 165 Гц обеспечивает плавный геймплей.',
 119990.00, '/images/placeholder.jpg', 'Ноутбуки', 'ASUS', 1),

('Lenovo ThinkPad X1 Carbon Gen 12',
 'Легендарный ThinkPad X1 Carbon в 12-м поколении предлагает невероятно лёгкий корпус (менее 1.12 кг), процессор Intel Core Ultra 7 и превосходную клавиатуру для максимальной продуктивности.',
 154990.00, '/images/placeholder.jpg', 'Ноутбуки', 'Lenovo', 0);

-- Характеристики MacBook Pro
INSERT INTO `product_specs` (`product_id`, `spec_name`, `spec_value`, `sort_order`) VALUES
(5, 'Операционная система', 'macOS Sonoma', 1),
(5, 'Процессор', 'Apple M3 Pro (12-ядерный CPU, 18-ядерный GPU)', 2),
(5, 'Дисплей', '14.2" Liquid Retina XDR, 3024×1964 px, 120 Гц', 3),
(5, 'ОЗУ', '18 ГБ унифицированной памяти', 4),
(5, 'Накопитель', '512 ГБ SSD', 5),
(5, 'Аккумулятор', '70 Вт·ч, до 17 часов работы', 6),
(5, 'Порты', '3× Thunderbolt 4, HDMI, SD-карт, MagSafe 3', 7),
(5, 'Вес', '1.61 кг', 8);

-- Примеры товаров (телевизоры)
INSERT INTO `products` (`name`, `description`, `price`, `image_url`, `category`, `brand`, `is_featured`) VALUES
('Samsung 65" QLED 4K Smart TV Q80C',
 'QLED-телевизор Samsung Q80C обеспечивает яркое изображение с квантовыми точками, объёмный звук и плавное воспроизведение контента благодаря частоте обновления 120 Гц и игровому режиму с низкой задержкой.',
 89990.00, '/images/placeholder.jpg', 'Телевизоры', 'Samsung', 1),

('LG 55" OLED 4K Smart TV C3',
 'OLED evo телевизор LG C3 с процессором α9 Gen6 AI обеспечивает идеальный чёрный цвет, бесконечный контраст и потрясающие цвета. Поддержка Dolby Vision, HDMI 2.1 и G-Sync для идеального гейминга.',
 84990.00, '/images/placeholder.jpg', 'Телевизоры', 'LG', 0);

-- Характеристики Samsung Q80C
INSERT INTO `product_specs` (`product_id`, `spec_name`, `spec_value`, `sort_order`) VALUES
(8, 'Диагональ', '65 дюймов', 1),
(8, 'Тип матрицы', 'QLED', 2),
(8, 'Разрешение', '3840×2160 (4K UHD)', 3),
(8, 'Частота обновления', '120 Гц', 4),
(8, 'HDR', 'Quantum HDR, HDR10+', 5),
(8, 'Smart TV', 'Tizen OS', 6),
(8, 'Порты', '4× HDMI 2.1, 2× USB, Wi-Fi, Bluetooth', 7),
(8, 'Звук', '60 Вт, Dolby Atmos', 8);

-- Примеры товаров (холодильники)
INSERT INTO `products` (`name`, `description`, `price`, `image_url`, `category`, `brand`, `is_featured`) VALUES
('Samsung RB38T776CS9 Side-by-Side',
 'Холодильник Samsung с технологией Twin Cooling Plus поддерживает оптимальную влажность в каждой камере независимо. SpaceMax позволяет разместить больше продуктов в стандартных габаритах.',
 69990.00, '/images/placeholder.jpg', 'Холодильники', 'Samsung', 1),

('LG GC-B247SEUV NatureFRESH',
 'Холодильник LG с системой DoorCooling+ и линейным инверторным компрессором гарантирует быстрое охлаждение и тихую работу. 8-летняя гарантия на компрессор.',
 54990.00, '/images/placeholder.jpg', 'Холодильники', 'LG', 0);

-- Примеры товаров (наушники)
INSERT INTO `products` (`name`, `description`, `price`, `image_url`, `category`, `brand`, `is_featured`) VALUES
('Sony WH-1000XM5 Wireless Headphones',
 'Флагманские наушники Sony с лучшим в классе шумоподавлением, 30 часами автономной работы и поддержкой LDAC для воспроизведения Hi-Res Audio. Идеальны для путешествий и работы.',
 27990.00, '/images/placeholder.jpg', 'Наушники', 'Sony', 1),

('Apple AirPods Pro 2nd Gen',
 'AirPods Pro второго поколения с активным шумоподавлением H2, адаптивным прозрачным режимом и персонализированным пространственным звуком обеспечивают непревзойдённое качество звука.',
 24990.00, '/images/placeholder.jpg', 'Наушники', 'Apple', 1);

-- Характеристики Sony WH-1000XM5
INSERT INTO `product_specs` (`product_id`, `spec_name`, `spec_value`, `sort_order`) VALUES
(12, 'Тип', 'Накладные, беспроводные', 1),
(12, 'Шумоподавление', 'Активное (ANC), до -30 дБ', 2),
(12, 'Время работы', '30 часов (с ANC)', 3),
(12, 'Зарядка', 'USB-C, 10 мин = 5 часов', 4),
(12, 'Кодеки', 'SBC, AAC, LDAC, aptX', 5),
(12, 'Частотный диапазон', '4 Гц – 40 кГц', 6),
(12, 'Вес', '250 г', 7),
(12, 'Подключение', 'Bluetooth 5.2, NFC', 8);

-- Примеры товаров (аксессуары)
INSERT INTO `products` (`name`, `description`, `price`, `image_url`, `category`, `brand`, `is_featured`) VALUES
('Apple MagSafe Charger 15W USB-C',
 'Оригинальное зарядное устройство MagSafe для iPhone с поддержкой быстрой зарядки до 15 Вт. Магнитное крепление обеспечивает идеальное выравнивание для максимальной эффективности.',
 3990.00, '/images/placeholder.jpg', 'Аксессуары', 'Apple', 0),

('Anker 65W GaN USB-C Charger',
 'Компактное зарядное устройство Anker на 65 Вт с GaN-технологией заряжает ноутбуки, планшеты и смартфоны. Три порта (2× USB-C + 1× USB-A) позволяют заряжать несколько устройств одновременно.',
 3490.00, '/images/placeholder.jpg', 'Аксессуары', 'Anker', 0);

-- ================================================
-- ИНСТРУКЦИЯ ПО ЗАПУСКУ
-- ================================================
-- 1. Создайте базу данных MySQL:
--    CREATE DATABASE storechicco CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--
-- 2. Импортируйте этот файл:
--    mysql -u root -p storechicco < database.sql
--
-- 3. Данные администратора по умолчанию:
--    Логин: admin
--    Пароль: admin123
--    (ОБЯЗАТЕЛЬНО смените пароль после первого входа!)
--
-- 4. Настройте .env файл:
--    DB_HOST=localhost
--    DB_PORT=3306
--    DB_USER=root
--    DB_PASSWORD=ваш_пароль
--    DB_NAME=storechicco
--    SECRET_KEY=ваш_секретный_ключ_минимум_32_символа
--    PORT=3000
-- ================================================
