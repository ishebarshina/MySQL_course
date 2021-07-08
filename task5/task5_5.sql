-- Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN

DROP DATABASE IF EXISTS catalogs;
CREATE DATABASE catalogs;

USE catalogs;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
);

INSERT INTO products
  (`name`, `description`, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор Intel', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор Intel', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор AMD', 4780.00, 1),
  ('AMD FX-8320', 'Процессор AMD', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'B250, Socket 1151, DDR4, mATX', 5060.00, 2);

-- Отсортируйте записи в порядке, заданном в списке IN
SELECT * FROM products WHERE id IN (5, 1, 2) 
ORDER BY FIELD(id, 5, 1, 2);
