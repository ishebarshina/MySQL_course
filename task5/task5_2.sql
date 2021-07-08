-- Таблица users была неудачно спроектирована.
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY  COMMENT "Идентификатор строки",    
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at VARCHAR(200),
  updated_at VARCHAR(200)
);

INSERT INTO `users` (email, phone, created_at, updated_at) VALUES 
	('mail1', 'phone1', '20.10.2017 8:10', '20.10.2017 8:10'),
    ('mail2', 'phone2', '20.10.2017 8:10', '20.10.2017 8:10'),
    ('mail3', 'phone3', '20.10.2017 8:10', '20.10.2017 8:10');

-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

UPDATE users
SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i')
WHERE id>0;

ALTER TABLE users MODIFY COLUMN created_at DATETIME;

UPDATE users
SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i')
WHERE id>0;

ALTER TABLE users MODIFY COLUMN updated_at DATETIME;
