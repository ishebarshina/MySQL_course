-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем

use example;
 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY  COMMENT "Идентификатор строки",    
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME,
  updated_at DATETIME
);

INSERT INTO `users` (email, phone) VALUES 
	('mail1', 'phone1'),
    ('mail2', 'phone2'),
    ('mail3', 'phone3');

SELECT * FROM users;

-- id  email phone created_at  updated_at
-- 1   mail1 phone1  NULL      NULL
-- 2   mail2 phone2  NULL      NULL
-- 3   mail3 phone3  NULL      NULL

-- Заполним поля текущими датой и временем:

UPDATE users SET created_at=NOW() WHERE id>0;
UPDATE users SET updated_at=CURRENT_TIMESTAMP WHERE id>0;

SELECT * FROM users;

-- id  email phone    created_at              updated_at
-- 1   mail1 phone1   '2021-07-04 11:14:18'   '2021-07-04 11:14:18'
-- 2   mail2 phone2   '2021-07-04 11:14:18'   '2021-07-04 11:14:18' 
-- 3   mail3 phone3   '2021-07-04 11:14:18'   '2021-07-04 11:14:18'

