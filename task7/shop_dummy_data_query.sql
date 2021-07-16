
CREATE TABLE catalogs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя'
) COMMENT = 'Покупатели';

CREATE TABLE products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED
) COMMENT = 'Товарные позиции';

ALTER TABLE products ADD CONSTRAINT fk_catalog_id FOREIGN KEY (catalog_id) REFERENCES catalogs(id);

CREATE TABLE orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED
) COMMENT = 'Заказы';

ALTER TABLE orders ADD CONSTRAINT fk_order_user_id FOREIGN KEY (user_id) REFERENCES users(id);

CREATE TABLE orders_products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций'
) COMMENT = 'Состав заказа';

ALTER TABLE orders_products ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE orders_products ADD CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(id);

CREATE TABLE discounts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0'
) COMMENT = 'Скидки';

ALTER TABLE discounts ADD CONSTRAINT fk_d_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE discounts ADD CONSTRAINT fk_d_product_id FOREIGN KEY (product_id) REFERENCES products(id);

CREATE TABLE storehouses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название'
) COMMENT = 'Склады';

CREATE TABLE storehouses_products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе'
) COMMENT = 'Запасы на складе';

ALTER TABLE storehouses_products ADD CONSTRAINT fk_sth_id FOREIGN KEY (storehouse_id) REFERENCES storehouses(id);
ALTER TABLE storehouses_products ADD CONSTRAINT fk_sth_product_id FOREIGN KEY (product_id) REFERENCES products(id);


