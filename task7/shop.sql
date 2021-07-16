DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id INT UNSIGNED PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя'
) COMMENT = 'Покупатели';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id INT UNSIGNED PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED
) COMMENT = 'Товарные позиции';

ALTER TABLE products ADD CONSTRAINT fk_catalog_id FOREIGN KEY (catalog_id) REFERENCES catalogs(id);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id INT UNSIGNED PRIMARY KEY,
  user_id INT UNSIGNED
) COMMENT = 'Заказы';

ALTER TABLE orders ADD CONSTRAINT fk_order_user_id FOREIGN KEY (user_id) REFERENCES users(id);

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id INT UNSIGNED PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций'
) COMMENT = 'Состав заказа';

ALTER TABLE orders_products ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE orders_products ADD CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(id);

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id INT UNSIGNED PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0'
) COMMENT = 'Скидки';

ALTER TABLE discounts ADD CONSTRAINT fk_d_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE discounts ADD CONSTRAINT fk_d_product_id FOREIGN KEY (product_id) REFERENCES products(id);

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id INT UNSIGNED PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название'
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id INT UNSIGNED PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе'
) COMMENT = 'Запасы на складе';

ALTER TABLE storehouses_products ADD CONSTRAINT fk_sth_id FOREIGN KEY (storehouse_id) REFERENCES storehouses(id);
ALTER TABLE storehouses_products ADD CONSTRAINT fk_sth_product_id FOREIGN KEY (product_id) REFERENCES products(id);


