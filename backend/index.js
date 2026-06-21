require('dotenv').config();
const express = require('express');
const path = require('path');
const mysql = require('mysql2/promise');
const multer = require('multer');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const cookieParser = require('cookie-parser');

const app = express();
const PORT = process.env.PORT || 3000;
const SECRET_KEY = process.env.SECRET_KEY || 'storechicco-dev-secret-2024';

const SLUG_TO_CATEGORY = {
  smartphones: 'Смартфоны',
  laptops: 'Ноутбуки',
  tvs: 'Телевизоры',
  refrigerators: 'Холодильники',
  computers: 'Компьютеры',
  headphones: 'Наушники',
  accessories: 'Аксессуары'
};
const CATEGORY_TO_SLUG = Object.fromEntries(
  Object.entries(SLUG_TO_CATEGORY).map(([k, v]) => [v, k])
);

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// SVG-заглушка для отсутствующих изображений товаров
app.get('/images/placeholder.jpg', (req, res) => {
  res.set('Content-Type', 'image/svg+xml');
  res.send('<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="#f4f5f7" rx="8"/><text x="50%" y="55%" text-anchor="middle" font-size="60" fill="#d0d0d0">📦</text></svg>');
});

// ─── MySQL Pool ────────────────────────────────────────────────────────────────
const dbConfig = {
  host: process.env.MYSQLHOST,
  port: process.env.MYSQLPORT,
  user: process.env.MYSQLUSER,
  password: process.env.MYSQLPASSWORD,
  database: process.env.MYSQLDATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};
const pool = mysql.createPool(dbConfig);
pool.getConnection()
  .then(async conn => {
    console.log('✅ Подключение к MySQL успешно');
    conn.release();
    // Миграции колонок пользователей
    for (const col of [
      "delivery_mode VARCHAR(10) DEFAULT 'pickup'",
      'delivery_street VARCHAR(255)',
      'delivery_house VARCHAR(10)',
      'delivery_apt VARCHAR(10)',
      'delivery_floor VARCHAR(10)',
      "role ENUM('user','admin','super_admin') DEFAULT 'user'"
    ]) {
      try { await pool.execute(`ALTER TABLE users ADD COLUMN ${col}`); } catch(e) {}
    }
    // Миграции таблицы products
    for (const col of [
      "specs TEXT",
      "old_price DECIMAL(10,2)",
      "is_deleted TINYINT(1) DEFAULT 0",
      "is_featured TINYINT(1) DEFAULT 0"
    ]) {
      try { await pool.execute(`ALTER TABLE products ADD COLUMN ${col}`); } catch(e) {}
    }
    // Миграция: добавляем image_url в promo_slides
    try { await pool.execute("ALTER TABLE promo_slides ADD COLUMN image_url VARCHAR(500) DEFAULT NULL"); } catch(e) {}
    // Обновляем иконки категорий с эмодзи на FontAwesome-классы
    const categoryIconMap = {
      smartphones:   'fas fa-mobile-alt',
      laptops:       'fas fa-laptop',
      tvs:           'fas fa-tv',
      refrigerators: 'fas fa-snowflake',
      computers:     'fas fa-desktop',
      headphones:    'fas fa-headphones',
      accessories:   'fas fa-plug'
    };
    for (const [slug, icon] of Object.entries(categoryIconMap)) {
      try { await pool.execute("UPDATE categories SET icon=? WHERE slug=? AND (icon NOT LIKE 'fas %' AND icon NOT LIKE 'far %')", [icon, slug]); } catch(e) {}
    }
    // Создаём таблицу product_specs если её нет
    await pool.execute(`
      CREATE TABLE IF NOT EXISTS product_specs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        product_id INT NOT NULL,
        spec_name VARCHAR(200) NOT NULL,
        spec_value VARCHAR(500) NOT NULL,
        sort_order INT DEFAULT 0,
        INDEX idx_product_id (product_id),
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    // Таблица промо-слайдов
    await pool.execute(`
      CREATE TABLE IF NOT EXISTS promo_slides (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        subtitle VARCHAR(255),
        badge VARCHAR(100),
        description TEXT,
        visual VARCHAR(20) DEFAULT '🛍️',
        gradient VARCHAR(200) DEFAULT 'linear-gradient(135deg,#0a9e94 0%,#2dbdb6 55%,#48D1CC 100%)',
        btn1_text VARCHAR(100),
        btn1_link VARCHAR(255) DEFAULT '/',
        btn2_text VARCHAR(100),
        btn2_link VARCHAR(255),
        is_active TINYINT(1) DEFAULT 1,
        sort_order INT DEFAULT 0
      )
    `);
    // Сидируем стандартные слайды если таблица пуста
    const [[{ cnt }]] = await pool.execute('SELECT COUNT(*) as cnt FROM promo_slides');
    if (cnt === 0) {
      const defaultSlides = [
        ['Лучшая электроника\nпо выгодным ценам', null, '⚡ Горячие предложения', 'Смартфоны, ноутбуки, телевизоры и многое другое — гарантия качества от ведущих брендов.', '🛍️', 'linear-gradient(135deg,#0a9e94 0%,#2dbdb6 55%,#48D1CC 100%)', 'Смотреть каталог', '/category/smartphones', 'Акции и скидки', '/category/smartphones', 1, 1],
        ['Смартфоны\nпо лучшим ценам', null, '🔥 Скидки до 30%', 'Apple, Samsung, Xiaomi — флагманские модели по выгодным ценам. Успейте купить!', '📱', 'linear-gradient(135deg,#0f7070 0%,#1da89e 55%,#3dd4c8 100%)', 'Все смартфоны', '/category/smartphones', 'Подробнее →', '/category/smartphones', 1, 2],
        ['Ноутбуки для\nлюбых задач', null, '💻 Для работы и учёбы', 'Производительные модели от ведущих производителей. Быстрая доставка и гарантия.', '💻', 'linear-gradient(135deg,#0d6060 0%,#1c9696 55%,#32c8be 100%)', 'Все ноутбуки', '/category/laptops', 'Подробнее →', '/category/laptops', 1, 3],
        ['Аксессуары\nи гаджеты', null, '⭐ Новинки сезона', 'Наушники, умные часы и аксессуары — всё для вашего цифрового образа жизни.', '🎧', 'linear-gradient(135deg,#1a5a7a 0%,#2694b0 55%,#40c8d0 100%)', 'Смотреть новинки', '/category/headphones', 'Аксессуары →', '/category/accessories', 1, 4],
      ];
      for (const s of defaultSlides) {
        await pool.execute(
          'INSERT INTO promo_slides (title,subtitle,badge,description,visual,gradient,btn1_text,btn1_link,btn2_text,btn2_link,is_active,sort_order) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
          s
        );
      }
      console.log('✅ Стандартные слайды карусели добавлены в БД');
    } else {
      // Нормализуем sort_order чтобы не было дублей
      const [allSlides] = await pool.execute('SELECT id FROM promo_slides ORDER BY sort_order, id');
      for (let i = 0; i < allSlides.length; i++) {
        await pool.execute('UPDATE promo_slides SET sort_order=? WHERE id=?', [i + 1, allSlides[i].id]);
      }
    }
  })
  .catch(err => { console.error('❌ Ошибка подключения к MySQL:', err.message); process.exit(1); });

// ─── Multer (загрузка изображений) ────────────────────────────────────────────
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const dir = path.join(__dirname, 'public', 'images');
    fs.mkdirSync(dir, { recursive: true });
    cb(null, dir);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + Math.round(Math.random() * 1e9) + path.extname(file.originalname));
  }
});
const upload = multer({
  storage,
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (/jpeg|jpg|png|gif|webp/.test(file.mimetype)) cb(null, true);
    else cb(new Error('Только изображения'));
  }
});

// ─── Middleware авторизации ────────────────────────────────────────────────────
app.use(async (req, res, next) => {
  const token = req.cookies.token;
  if (token) {
    try {
      const decoded = jwt.verify(token, SECRET_KEY);
      const [rows] = await pool.execute('SELECT id, username, role FROM users WHERE id = ?', [decoded.id]);
      if (rows.length) req.user = rows[0];
    } catch { res.clearCookie('token'); }
  }
  next();
});

const requireUser = async (req, res, next) => {
  const token = req.cookies.token;
  if (!token) return res.redirect('/login');
  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const [rows] = await pool.execute('SELECT id, username, role FROM users WHERE id = ?', [decoded.id]);
    if (!rows.length) { res.clearCookie('token'); return res.redirect('/login'); }
    req.user = rows[0];
    next();
  } catch { res.clearCookie('token'); return res.redirect('/login'); }
};

const requirePanelAdmin = async (req, res, next) => {
  const token = req.cookies.token;
  if (!token) return res.redirect('/login');
  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const [rows] = await pool.execute(
      "SELECT id, username, role FROM users WHERE id = ? AND role IN ('admin','super_admin')",
      [decoded.id]
    );
    if (!rows.length) return res.redirect('/');
    req.user = rows[0];
    next();
  } catch { res.clearCookie('token'); return res.redirect('/login'); }
};


async function getCategories() {
  try {
    const [rows] = await pool.execute('SELECT * FROM categories WHERE is_active = 1 ORDER BY sort_order');
    return rows;
  } catch { return []; }
}

// Временный диагностический роут
app.get('/debug-specs/:id', async (req, res) => {
  try {
    const [specs] = await pool.execute('SELECT * FROM product_specs WHERE product_id = ?', [req.params.id]);
    const [product] = await pool.execute('SELECT id, name, specs FROM products WHERE id = ?', [req.params.id]);
    res.json({ product: product[0] || null, product_specs: specs });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ═══════════════════════════════════════════════════════════════
//  СТРАНИЦЫ
// ═══════════════════════════════════════════════════════════════

app.get('/', async (req, res) => {
  try {
    const categories = await getCategories();
    const [promoSlides] = await pool.execute('SELECT * FROM promo_slides WHERE is_active=1 ORDER BY sort_order, id').catch(() => [[]]);
    const [featured] = await pool.execute(
      'SELECT * FROM products WHERE is_featured = 1 AND is_deleted = 0 ORDER BY id DESC LIMIT 8'
    );
    const [smartphones] = await pool.execute(
      "SELECT * FROM products WHERE category = 'Смартфоны' AND is_deleted = 0 ORDER BY id DESC LIMIT 4"
    );
    const [laptops] = await pool.execute(
      "SELECT * FROM products WHERE category = 'Ноутбуки' AND is_deleted = 0 ORDER BY id DESC LIMIT 4"
    );
    const [tvs] = await pool.execute(
      "SELECT * FROM products WHERE category = 'Телевизоры' AND is_deleted = 0 ORDER BY id DESC LIMIT 4"
    );
    res.render('shop/home', { user: req.user, categories, featured, smartphones, laptops, tvs, CATEGORY_TO_SLUG, promoSlides });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

app.get('/category/:slug', async (req, res) => {
  try {
    const { slug } = req.params;
    const categoryName = SLUG_TO_CATEGORY[slug];
    if (!categoryName) return res.status(404).render('404', { user: req.user, categories: await getCategories() });

    const categories = await getCategories();
    const { minPrice, maxPrice, brand, sort = 'default' } = req.query;

    let query = 'SELECT * FROM products WHERE category = ? AND is_deleted = 0';
    const params = [categoryName];

    if (minPrice) { query += ' AND price >= ?'; params.push(Number(minPrice)); }
    if (maxPrice) { query += ' AND price <= ?'; params.push(Number(maxPrice)); }
    if (brand) {
      const brands = Array.isArray(brand) ? brand : [brand];
      query += ` AND brand IN (${brands.map(() => '?').join(',')})`;
      params.push(...brands);
    }

    if (sort === 'price_asc') query += ' ORDER BY price ASC';
    else if (sort === 'price_desc') query += ' ORDER BY price DESC';
    else if (sort === 'name') query += ' ORDER BY name ASC';
    else query += ' ORDER BY id DESC';

    const [products] = await pool.execute(query, params);

    const [brandsRaw] = await pool.execute(
      'SELECT DISTINCT brand FROM products WHERE category = ? AND is_deleted = 0 AND brand IS NOT NULL ORDER BY brand',
      [categoryName]
    );
    const brands = brandsRaw.map(b => b.brand).filter(Boolean);

    const [priceRange] = await pool.execute(
      'SELECT MIN(price) as minP, MAX(price) as maxP FROM products WHERE category = ? AND is_deleted = 0',
      [categoryName]
    );

    res.render('shop/category', {
      user: req.user, categories, categoryName, slug, products, brands,
      priceRange: priceRange[0],
      filters: {
        minPrice: minPrice || '',
        maxPrice: maxPrice || '',
        brand: brand ? (Array.isArray(brand) ? brand : [brand]) : [],
        sort
      },
      CATEGORY_TO_SLUG
    });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

// Редирект старых ссылок /products?category=X → /category/:slug
app.get('/products', (req, res) => {
  const cat = req.query.category || 'Смартфоны';
  const slug = CATEGORY_TO_SLUG[cat] || 'smartphones';
  const rest = new URLSearchParams(req.query);
  rest.delete('category');
  const qs = rest.toString();
  res.redirect(`/category/${slug}${qs ? '?' + qs : ''}`);
});

app.get('/product/:id', async (req, res) => {
  try {
    const categories = await getCategories();
    const [productRows] = await pool.execute(
      'SELECT * FROM products WHERE id = ? AND is_deleted = 0', [req.params.id]
    );
    if (!productRows.length) return res.status(404).render('404', { user: req.user, categories });

    const product = productRows[0];
    const [images] = await pool.execute(
      'SELECT * FROM product_images WHERE product_id = ? ORDER BY sort_order', [product.id]
    );
    const [specsRows] = await pool.execute(
      'SELECT * FROM product_specs WHERE product_id = ? ORDER BY sort_order', [product.id]
    );
    let specs = specsRows;
    // Фолбэк: если в product_specs нет строк, парсим текстовую колонку products.specs
    if (specs.length === 0 && product.specs) {
      const parsed = [];
      let order = 0;
      for (const line of product.specs.split('\n')) {
        const colonIdx = line.indexOf(':');
        if (colonIdx < 1) continue;
        const spec_name = line.slice(0, colonIdx).trim();
        const spec_value = line.slice(colonIdx + 1).trim();
        if (spec_name && spec_value) parsed.push({ spec_name, spec_value, sort_order: order++ });
      }
      specs = parsed;
    }
    const [related] = await pool.execute(
      'SELECT * FROM products WHERE category = ? AND id != ? AND is_deleted = 0 ORDER BY RAND() LIMIT 4',
      [product.category, product.id]
    );

    res.render('shop/product', {
      user: req.user, categories, product, images, specs, related,
      slug: CATEGORY_TO_SLUG[product.category] || 'smartphones',
      CATEGORY_TO_SLUG
    });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

app.get('/cart', requireUser, async (req, res) => {
  try {
    const categories = await getCategories();
    const cartId = await getOrCreateCart(req.user.id);
    const [items] = await pool.execute(`
      SELECT ci.id, ci.quantity, p.id as productId, p.name, p.price, p.image_url, p.brand
      FROM cart_items ci JOIN products p ON ci.product_id = p.id
      WHERE ci.cart_id = ?`, [cartId]);
    res.render('shop/cart', { user: req.user, categories, items, CATEGORY_TO_SLUG });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

app.get('/checkout', requireUser, async (req, res) => {
  try {
    const categories = await getCategories();
    const cartId = await getOrCreateCart(req.user.id);
    const [items] = await pool.execute(`
      SELECT ci.quantity, p.id as productId, p.name, p.price, p.image_url
      FROM cart_items ci JOIN products p ON ci.product_id = p.id
      WHERE ci.cart_id = ?`, [cartId]);
    if (!items.length) return res.redirect('/cart');
    const [userRows] = await pool.execute(
      'SELECT username, phone, delivery_mode, delivery_street, delivery_house, delivery_apt, delivery_floor FROM users WHERE id = ?',
      [req.user.id]
    );
    const profile = userRows[0] || {};
    res.render('shop/checkout', { user: req.user, categories, items, CATEGORY_TO_SLUG, profile });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

app.get('/order/success', requireUser, async (req, res) => {
  const { orderId } = req.query;
  if (!orderId) return res.redirect('/');
  try {
    const categories = await getCategories();
    const [orders] = await pool.execute(
      'SELECT * FROM orders WHERE id = ? AND user_id = ?', [orderId, req.user.id]
    );
    if (!orders.length) return res.redirect('/');
    const [items] = await pool.execute(`
      SELECT oi.*, p.name, p.image_url FROM order_items oi
      JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?`, [orderId]);
    res.render('shop/order-success', { user: req.user, categories, order: orders[0], items, CATEGORY_TO_SLUG });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

app.get('/search', async (req, res) => {
  const q = (req.query.q || '').trim();
  if (!q) return res.redirect('/');
  try {
    const categories = await getCategories();
    const [products] = await pool.execute(
      `SELECT * FROM products WHERE is_deleted = 0 AND (name LIKE ? OR description LIKE ? OR brand LIKE ?)
       ORDER BY is_featured DESC LIMIT 40`,
      [`%${q}%`, `%${q}%`, `%${q}%`]
    );
    res.render('shop/search', { user: req.user, categories, products, q, CATEGORY_TO_SLUG });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

async function loadProfileData(userId) {
  const [userRows] = await pool.execute(
    'SELECT id, username, email, phone, role FROM users WHERE id = ?', [userId]
  );
  const [orders] = await pool.execute(
    'SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC', [userId]
  );
  for (const order of orders) {
    const [items] = await pool.execute(
      `SELECT oi.*, p.name, p.image_url FROM order_items oi
       JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?`,
      [order.id]
    );
    order.items = items;
  }
  return { fullUser: userRows[0], orders };
}

app.get('/profile', requireUser, async (req, res) => {
  try {
    const categories = await getCategories();
    const { fullUser, orders } = await loadProfileData(req.user.id);
    res.render('user/profile', { user: fullUser, categories, orders, CATEGORY_TO_SLUG, error: null, success: null });
  } catch (err) {
    console.error(err); res.status(500).send('Ошибка сервера');
  }
});

app.post('/profile/update', requireUser, async (req, res) => {
  const { new_username, current_password, new_password, confirm_password } = req.body;

  const renderWith = async (error, success) => {
    const categories = await getCategories();
    const { fullUser, orders } = await loadProfileData(req.user.id);
    res.render('user/profile', { user: fullUser, categories, orders, CATEGORY_TO_SLUG, error, success });
  };

  try {
    const [rows] = await pool.execute(
      'SELECT username, password_hash FROM users WHERE id = ?', [req.user.id]
    );
    const dbUser = rows[0];

    // Смена имени пользователя
    const newUname = (new_username || '').trim();
    if (newUname && newUname !== dbUser.username) {
      if (newUname.length < 6)  return renderWith('Имя должно содержать минимум 6 символов', null);
      if (newUname.length > 24) return renderWith('Имя не должно превышать 24 символа', null);
      const [ex] = await pool.execute('SELECT id FROM users WHERE username = ? AND id != ?', [newUname, req.user.id]);
      if (ex.length)            return renderWith('Это имя пользователя уже занято', null);
      await pool.execute('UPDATE users SET username = ? WHERE id = ?', [newUname, req.user.id]);
      // Обновляем JWT с новым именем
      const token = jwt.sign({ id: req.user.id, username: newUname }, SECRET_KEY, { expiresIn: '7d' });
      res.cookie('token', token, { httpOnly: true, maxAge: 7 * 24 * 3600 * 1000 });
      req.user.username = newUname;
    }

    // Смена пароля
    if (new_password) {
      if (!current_password)                           return renderWith('Введите текущий пароль', null);
      if (!(await bcrypt.compare(current_password, dbUser.password_hash)))
                                                       return renderWith('Неверный текущий пароль', null);
      if (new_password.length < 6)                     return renderWith('Новый пароль — минимум 6 символов', null);
      if (new_password.length > 24)                    return renderWith('Новый пароль — максимум 24 символа', null);
      if (new_password !== confirm_password)           return renderWith('Пароли не совпадают', null);
      const hash = await bcrypt.hash(new_password, 10);
      await pool.execute('UPDATE users SET password_hash = ? WHERE id = ?', [hash, req.user.id]);
    }

    renderWith(null, 'Изменения успешно сохранены');
  } catch (err) {
    console.error(err);
    renderWith('Произошла ошибка. Попробуйте ещё раз.', null);
  }
});

app.get('/favorites', requireUser, async (req, res) => {
  const categories = await getCategories();
  res.render('shop/favorites', { user: req.user, categories, CATEGORY_TO_SLUG });
});

app.get('/info', async (req, res) => {
  const categories = await getCategories();
  res.render('info', { user: req.user, categories, CATEGORY_TO_SLUG });
});

app.get('/login', (req, res) => {
  res.render('auth/login', { user: req.user, error: null });
});

app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const [rows] = await pool.execute('SELECT * FROM users WHERE username = ?', [username]);
    if (!rows.length || !(await bcrypt.compare(password, rows[0].password_hash))) {
      return res.render('auth/login', { user: null, error: 'Неверный логин или пароль' });
    }
    const token = jwt.sign({ id: rows[0].id, username }, SECRET_KEY, { expiresIn: '7d' });
    res.cookie('token', token, { httpOnly: true, maxAge: 7 * 24 * 3600 * 1000 });
    res.redirect('/');
  } catch (err) {
    console.error(err); res.render('auth/login', { user: null, error: 'Ошибка авторизации' });
  }
});

app.get('/register', (req, res) => {
  res.render('auth/register', { user: req.user, error: null, formData: {} });
});

app.post('/register', async (req, res) => {
  const { username, email, phone, password } = req.body;
  const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const phoneDigits = (phone || '').replace(/\D/g, '');

  // Сохраняем введённые данные, чтобы вернуть их в форму при ошибке
  const fd = {
    username: (username || '').trim(),
    email:    (email    || '').trim(),
    phone:    (phone    || '').trim()
  };
  const fail = (error) => res.render('auth/register', { user: null, error, formData: fd });

  if (!fd.username || fd.username.length < 6)   return fail('Имя должно содержать минимум 6 символов');
  if (fd.username.length > 24)                   return fail('Имя не должно превышать 24 символа');
  if (!email || !emailRe.test(fd.email))         return fail('Введите корректный email-адрес');
  if (fd.email.length > 24)                      return fail('Email не должен превышать 24 символа');
  if (phoneDigits.length !== 11)                 return fail('Введите номер телефона полностью');
  if (!password || password.length < 6)          return fail('Пароль должен содержать минимум 6 символов');
  if (password.length > 24)                      return fail('Пароль не должен превышать 24 символа');

  try {
    const [byName] = await pool.execute('SELECT id FROM users WHERE username = ?', [fd.username]);
    if (byName.length) return fail('Это имя пользователя уже занято');

    const [byEmail] = await pool.execute('SELECT id FROM users WHERE email = ?', [fd.email.toLowerCase()]);
    if (byEmail.length) return fail('Этот email уже зарегистрирован');

    const hash = await bcrypt.hash(password, 10);
    const [result] = await pool.execute(
      'INSERT INTO users (username, email, phone, password_hash) VALUES (?, ?, ?, ?)',
      [fd.username, fd.email.toLowerCase(), fd.phone, hash]
    );

    // Автологин: выдаём JWT и сразу перенаправляем на главную
    const token = jwt.sign({ id: result.insertId, username: fd.username }, SECRET_KEY, { expiresIn: '7d' });
    res.cookie('token', token, { httpOnly: true, maxAge: 7 * 24 * 3600 * 1000 });
    res.redirect('/?welcome=1');
  } catch (err) {
    console.error(err);
    fail('Ошибка регистрации. Попробуйте ещё раз.');
  }
});

app.post('/logout', (req, res) => {
  res.clearCookie('token');
  res.redirect('/');
});

// ═══════════════════════════════════════════════════════════════
//  API
// ═══════════════════════════════════════════════════════════════

app.get('/api/search', async (req, res) => {
  const q = (req.query.q || '').trim();
  if (!q || q.length < 2) return res.json({ success: true, data: [] });
  try {
    const [products] = await pool.execute(
      `SELECT id, name, price, image_url, category FROM products
       WHERE is_deleted = 0 AND (name LIKE ? OR brand LIKE ?) LIMIT 8`,
      [`%${q}%`, `%${q}%`]
    );
    res.json({ success: true, data: products });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
});

// Категории
app.get('/api/categories', async (req, res) => {
  try {
    const [cats] = await pool.execute('SELECT * FROM categories WHERE is_active = 1 ORDER BY sort_order');
    res.json({ success: true, data: cats });
  } catch (err) { res.status(500).json({ success: false }); }
});

// Товары
app.get('/api/products', async (req, res) => {
  try {
    const { category, brand, featured, ids, q } = req.query;
    let query = 'SELECT * FROM products WHERE is_deleted = 0';
    const params = [];

    if (ids) {
      const arr = ids.split(',').map(Number).filter(Boolean);
      if (arr.length) { query += ` AND id IN (${arr.map(() => '?').join(',')})`; params.push(...arr); }
    }
    if (category) { query += ' AND category = ?'; params.push(category); }
    if (brand) {
      const bs = Array.isArray(brand) ? brand : [brand];
      query += ` AND brand IN (${bs.map(() => '?').join(',')})`; params.push(...bs);
    }
    if (featured) query += ' AND is_featured = 1';
    if (q) { query += ' AND (name LIKE ? OR brand LIKE ?)'; params.push(`%${q}%`, `%${q}%`); }

    const [rows] = await pool.execute(query, params);
    res.json({ success: true, data: rows });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
});

app.get('/api/products/:id', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT * FROM products WHERE id = ? AND is_deleted = 0', [req.params.id]);
    if (!rows.length) return res.status(404).json({ success: false, message: 'Товар не найден' });
    const [images] = await pool.execute('SELECT * FROM product_images WHERE product_id = ? ORDER BY sort_order', [rows[0].id]);
    const [specs] = await pool.execute('SELECT * FROM product_specs WHERE product_id = ? ORDER BY sort_order', [rows[0].id]);
    res.json({ success: true, data: { ...rows[0], images, specs } });
  } catch (err) { res.status(500).json({ success: false }); }
});

app.post('/api/upload', upload.single('image'), (req, res) => {
  if (!req.file) return res.status(400).json({ success: false, message: 'Файл не загружен' });
  res.json({ success: true, imageUrl: `/images/${req.file.filename}` });
});

// Корзина
async function getOrCreateCart(userId) {
  const [rows] = await pool.execute('SELECT id FROM carts WHERE user_id = ? LIMIT 1', [userId]);
  if (rows.length) return rows[0].id;
  const [r] = await pool.execute('INSERT INTO carts (user_id) VALUES (?)', [userId]);
  return r.insertId;
}

app.get('/api/cart', async (req, res) => {
  if (!req.user) return res.json({ cartId: null, items: [] });
  try {
    const cartId = await getOrCreateCart(req.user.id);
    const [items] = await pool.execute(`
      SELECT ci.id, ci.quantity, p.id as productId, p.name, p.price, p.image_url, p.brand
      FROM cart_items ci JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = ?`, [cartId]);
    res.json({ cartId, items });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/cart/add', async (req, res) => {
  if (!req.user) return res.status(401).json({ message: 'Требуется авторизация' });
  const { productId, quantity = 1 } = req.body;
  try {
    const cartId = await getOrCreateCart(req.user.id);
    const [existing] = await pool.execute(
      'SELECT id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?', [cartId, productId]
    );
    if (existing.length) {
      const newQty = existing[0].quantity + quantity;
      if (newQty <= 0) {
        await pool.execute('DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?', [cartId, productId]);
      } else {
        await pool.execute('UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ?', [newQty, cartId, productId]);
      }
    } else if (quantity > 0) {
      await pool.execute('INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, ?)', [cartId, productId, quantity]);
    }
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/cart/remove', async (req, res) => {
  if (!req.user) return res.status(401).json({ message: 'Требуется авторизация' });
  const { productId } = req.body;
  try {
    const cartId = await getOrCreateCart(req.user.id);
    await pool.execute('DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?', [cartId, productId]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/cart', async (req, res) => {
  if (!req.user) return res.status(401).json({ message: 'Требуется авторизация' });
  try {
    const cartId = await getOrCreateCart(req.user.id);
    await pool.execute('DELETE FROM cart_items WHERE cart_id = ?', [cartId]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// Оформление заказа
app.post('/api/checkout', requireUser, async (req, res) => {
  const { customerName, phone, address, paymentMethod, deliveryMode, deliveryStreet, deliveryHouse, deliveryApt, deliveryFloor } = req.body;
  try {
    const cartId = await getOrCreateCart(req.user.id);
    const [items] = await pool.execute(`
      SELECT ci.product_id, ci.quantity, p.price FROM cart_items ci
      JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = ?`, [cartId]);
    if (!items.length) return res.status(400).json({ message: 'Корзина пуста' });

    const totalPrice = items.reduce((s, i) => s + i.quantity * Number(i.price), 0);
    const [r] = await pool.execute(
      `INSERT INTO orders (user_id, customer_name, phone, address, total_price, payment_method)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [req.user.id, customerName, phone, address, totalPrice, paymentMethod || 'cash']
    );
    const orderId = r.insertId;

    for (const item of items) {
      await pool.execute(
        'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)',
        [orderId, item.product_id, item.quantity, item.price]
      );
    }

    if (paymentMethod === 'online') {
      await pool.execute(
        'INSERT INTO payment_transactions (order_id, amount, payment_method, status) VALUES (?, ?, ?, ?)',
        [orderId, totalPrice, 'card', 'completed']
      );
      await pool.execute("UPDATE orders SET status='paid', payment_status='paid' WHERE id=?", [orderId]);
    }

    await pool.execute('DELETE FROM cart_items WHERE cart_id = ?', [cartId]);

    await pool.execute(
      'UPDATE users SET delivery_mode=?, delivery_street=?, delivery_house=?, delivery_apt=?, delivery_floor=? WHERE id=?',
      [deliveryMode || 'pickup', deliveryStreet || null, deliveryHouse || null, deliveryApt || null, deliveryFloor || null, req.user.id]
    );

    res.json({ success: true, orderId });
  } catch (err) {
    console.error(err); res.status(500).json({ message: err.message });
  }
});

// Избранное
app.get('/api/favorites', requireUser, async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT product_id FROM favorites WHERE user_id = ?', [req.user.id]);
    res.json({ success: true, data: rows.map(r => r.product_id) });
  } catch (err) { res.status(500).json({ success: false }); }
});

app.post('/favorites/add', async (req, res) => {
  if (!req.user) return res.status(401).json({ message: 'Требуется авторизация' });
  try {
    await pool.execute('INSERT IGNORE INTO favorites (user_id, product_id) VALUES (?, ?)', [req.user.id, req.body.productId]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false }); }
});

app.post('/favorites/remove', async (req, res) => {
  if (!req.user) return res.status(401).json({ message: 'Требуется авторизация' });
  try {
    await pool.execute('DELETE FROM favorites WHERE user_id = ? AND product_id = ?', [req.user.id, req.body.productId]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false }); }
});

// ═══════════════════════════════════════════════════════════════
//  ПАНЕЛЬ АДМИНИСТРАТОРА (на основе ролей пользователей)
// ═══════════════════════════════════════════════════════════════

app.get('/panel', requirePanelAdmin, (req, res) => res.redirect('/panel/orders'));

app.get('/panel/orders', requirePanelAdmin, async (req, res) => {
  try {
    const [orders] = await pool.execute(
      'SELECT o.*, u.username FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC'
    );
    res.render('panel/orders', { user: req.user, orders, page: 'orders' });
  } catch (err) { console.error(err); res.status(500).send('Ошибка'); }
});

app.get('/panel/products', requirePanelAdmin, async (req, res) => {
  try {
    const [products] = await pool.execute('SELECT * FROM products WHERE is_deleted = 0 ORDER BY id DESC');
    const [allImages] = await pool.execute('SELECT * FROM product_images ORDER BY sort_order');
    const [allSpecs] = await pool.execute('SELECT * FROM product_specs ORDER BY sort_order');
    products.forEach(function(p) {
      p.extra_images = allImages.filter(function(img) { return img.product_id === p.id; }).map(function(img) { return img.image_url; });
      const pSpecs = allSpecs.filter(function(s) { return s.product_id === p.id; });
      if (pSpecs.length) {
        p.specs = pSpecs.map(function(s) { return s.spec_name + ': ' + s.spec_value; }).join('\n');
      }
    });
    const categories = await getCategories();
    res.render('panel/products', { user: req.user, products, categories, page: 'products' });
  } catch (err) { console.error(err); res.status(500).send('Ошибка'); }
});

app.get('/panel/promotions', requirePanelAdmin, async (req, res) => {
  try {
    const [slides] = await pool.execute('SELECT * FROM promo_slides ORDER BY sort_order, id');
    res.render('panel/promotions', { user: req.user, slides, page: 'promotions' });
  } catch (err) { console.error(err); res.status(500).send('Ошибка'); }
});

app.get('/panel/users', requirePanelAdmin, async (req, res) => {
  if (req.user.role !== 'super_admin') return res.redirect('/panel/orders');
  try {
    const [users] = await pool.execute(
      'SELECT id, username, email, phone, role, created_at FROM users ORDER BY id DESC'
    );
    res.render('panel/users', { user: req.user, users, page: 'users' });
  } catch (err) { console.error(err); res.status(500).send('Ошибка'); }
});

// Panel API — промо-слайды
app.get('/api/panel/promotions', requirePanelAdmin, async (req, res) => {
  const [rows] = await pool.execute('SELECT * FROM promo_slides ORDER BY sort_order, id');
  res.json({ success: true, data: rows });
});

app.post('/api/panel/promotions', requirePanelAdmin, async (req, res) => {
  const { title, subtitle, badge, description, visual, image_url, gradient, btn1_text, btn1_link, btn2_text, btn2_link, sort_order } = req.body;
  try {
    const [r] = await pool.execute(
      'INSERT INTO promo_slides (title,subtitle,badge,description,visual,image_url,gradient,btn1_text,btn1_link,btn2_text,btn2_link,sort_order) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
      [title, subtitle||null, badge||null, description||null, visual||'🛍️', image_url||null, gradient||'linear-gradient(135deg,#0a9e94 0%,#2dbdb6 55%,#48D1CC 100%)', btn1_text||null, btn1_link||'/', btn2_text||null, btn2_link||null, sort_order||0]
    );
    res.json({ success: true, id: r.insertId });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.put('/api/panel/promotions/:id', requirePanelAdmin, async (req, res) => {
  const { title, subtitle, badge, description, visual, image_url, gradient, btn1_text, btn1_link, btn2_text, btn2_link, is_active, sort_order } = req.body;
  try {
    if (title === undefined) {
      // Частичное обновление (только is_active / sort_order)
      await pool.execute(
        'UPDATE promo_slides SET is_active=? WHERE id=?',
        [is_active ? 1 : 0, req.params.id]
      );
    } else {
      await pool.execute(
        'UPDATE promo_slides SET title=?,subtitle=?,badge=?,description=?,visual=?,image_url=?,gradient=?,btn1_text=?,btn1_link=?,btn2_text=?,btn2_link=?,is_active=?,sort_order=? WHERE id=?',
        [title, subtitle||null, badge||null, description||null, visual||'🛍️', image_url||null, gradient, btn1_text||null, btn1_link||'/', btn2_text||null, btn2_link||null, is_active?1:0, sort_order||0, req.params.id]
      );
    }
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.post('/api/panel/promotions/:id/move', requirePanelAdmin, async (req, res) => {
  const { dir } = req.body;
  try {
    const [slides] = await pool.execute('SELECT id, sort_order FROM promo_slides ORDER BY sort_order, id');
    const idx = slides.findIndex(s => s.id == req.params.id);
    if (idx === -1) return res.status(404).json({ message: 'Не найдено' });
    const swapIdx = dir === 'up' ? idx - 1 : idx + 1;
    if (swapIdx < 0 || swapIdx >= slides.length) return res.json({ success: true });
    const a = slides[idx], b = slides[swapIdx];
    await pool.execute('UPDATE promo_slides SET sort_order=? WHERE id=?', [b.sort_order, a.id]);
    await pool.execute('UPDATE promo_slides SET sort_order=? WHERE id=?', [a.sort_order, b.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/panel/promotions/:id', requirePanelAdmin, async (req, res) => {
  try {
    await pool.execute('DELETE FROM promo_slides WHERE id=?', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// Panel API — управление ролями (только super_admin)
app.put('/api/panel/users/:id/role', requirePanelAdmin, async (req, res) => {
  if (req.user.role !== 'super_admin') return res.status(403).json({ message: 'Недостаточно прав' });
  const { role } = req.body;
  if (!['user', 'admin', 'super_admin'].includes(role)) return res.status(400).json({ message: 'Неверная роль' });
  if (Number(req.params.id) === req.user.id) return res.status(400).json({ message: 'Нельзя изменить свою роль' });
  try {
    await pool.execute('UPDATE users SET role=? WHERE id=?', [role, req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// Panel API — заказы
app.get('/api/panel/orders/:id/items', requirePanelAdmin, async (req, res) => {
  try {
    const [items] = await pool.execute(
      'SELECT oi.*, p.name, p.image_url FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?',
      [req.params.id]
    );
    res.json({ success: true, data: items });
  } catch (err) { res.status(500).json({ success: false }); }
});

app.put('/api/panel/orders/:id/status', requirePanelAdmin, async (req, res) => {
  const { status } = req.body;
  if (!['new','paid','shipped','delivered','cancelled'].includes(status))
    return res.status(400).json({ message: 'Некорректный статус' });
  try {
    await pool.execute('UPDATE orders SET status=? WHERE id=?', [status, req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false }); }
});

// Panel API — товары
app.post('/api/panel/products', requirePanelAdmin, async (req, res) => {
  const { name, brand, category, price, old_price, image_url, description, specs, is_featured, images } = req.body;
  if (!name || !category || !price) return res.status(400).json({ message: 'Заполните обязательные поля' });
  try {
    const [r] = await pool.execute(
      'INSERT INTO products (name,brand,category,price,old_price,image_url,description,specs,is_featured) VALUES (?,?,?,?,?,?,?,?,?)',
      [name, brand||null, category, price, old_price||null, image_url||null, description||null, specs||null, is_featured?1:0]
    );
    const productId = r.insertId;
    if (images && images.length) {
      for (let i = 0; i < images.length; i++) {
        await pool.execute('INSERT INTO product_images (product_id,image_url,sort_order) VALUES (?,?,?)', [productId, images[i], i]);
      }
    }
    console.log('[POST products] specs received:', JSON.stringify(specs));
    if (specs) {
      const lines = specs.split('\n');
      console.log('[POST products] lines:', lines);
      let order = 0;
      for (const line of lines) {
        const colonIdx = line.indexOf(':');
        if (colonIdx < 1) continue;
        const specName = line.slice(0, colonIdx).trim();
        const specValue = line.slice(colonIdx + 1).trim();
        if (specName && specValue) {
          console.log('[POST products] inserting spec:', specName, '=', specValue);
          await pool.execute(
            'INSERT INTO product_specs (product_id, spec_name, spec_value, sort_order) VALUES (?,?,?,?)',
            [productId, specName, specValue, order++]
          );
        }
      }
    }
    res.json({ success: true, id: productId });
  } catch (err) { console.error('[POST products] ERROR:', err); res.status(500).json({ message: err.message }); }
});

app.put('/api/panel/products/:id', requirePanelAdmin, async (req, res) => {
  const { name, brand, category, price, old_price, image_url, description, specs, is_featured, images } = req.body;
  try {
    await pool.execute(
      'UPDATE products SET name=?,brand=?,category=?,price=?,old_price=?,image_url=?,description=?,specs=?,is_featured=? WHERE id=?',
      [name, brand||null, category, price, old_price||null, image_url||null, description||null, specs||null, is_featured?1:0, req.params.id]
    );
    await pool.execute('DELETE FROM product_images WHERE product_id=?', [req.params.id]);
    if (images && images.length) {
      for (let i = 0; i < images.length; i++) {
        await pool.execute('INSERT INTO product_images (product_id,image_url,sort_order) VALUES (?,?,?)', [req.params.id, images[i], i]);
      }
    }
    await pool.execute('DELETE FROM product_specs WHERE product_id=?', [req.params.id]);
    if (specs) {
      const lines = specs.split('\n');
      let order = 0;
      for (const line of lines) {
        const colonIdx = line.indexOf(':');
        if (colonIdx < 1) continue;
        const specName = line.slice(0, colonIdx).trim();
        const specValue = line.slice(colonIdx + 1).trim();
        if (specName && specValue) {
          await pool.execute(
            'INSERT INTO product_specs (product_id, spec_name, spec_value, sort_order) VALUES (?,?,?,?)',
            [req.params.id, specName, specValue, order++]
          );
        }
      }
    }
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

app.delete('/api/panel/products/:id', requirePanelAdmin, async (req, res) => {
  try {
    await pool.execute('UPDATE products SET is_deleted=1 WHERE id=?', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
});

// 404
app.use(async (req, res) => {
  const categories = await getCategories();
  res.status(404).render('404', { user: req.user, categories });
});

app.listen(PORT, () => console.log(`🚀 Сервер запущен: http://localhost:${PORT}`));
