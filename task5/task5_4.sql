-- Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)


USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20),
    birthday_month VARCHAR(20)
);

INSERT INTO users(user_name, birthday_month) VALUES 
	('Ivan', 'January'), 
    ('Polina', 'May'), 
    ('Marina', 'August'), 
    ('Nikita', 'July'), 
    ('Igor', 'may'), 
    ('Masha', 'December');

SELECT user_name AS `user_name` FROM users WHERE birthday_month RLIKE('[Aa]ugust') OR birthday_month RLIKE('[mM]ay'); 
