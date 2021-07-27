-- Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, 
-- однако, мог бы извлекать записи из представления username.


USE example;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255),
	`password` VARCHAR(255)
);

INSERT INTO accounts (name, `password`) VALUES 
	('user1', 'pass1'), ('user2', 'pass2'), ('user3', 'pass3');

-- представление username таблицы accounts, предоставляющий доступ к столбца id и name 
CREATE OR REPLACE VIEW username AS SELECT id, name FROM accounts;

-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, 
CREATE USER 'user_read'@'localhost';

-- который бы не имел доступа к таблице accounts, но мог бы извлекать записи из представления username
GRANT SELECT (id, name) ON example.username TO 'user_read'@'localhost';