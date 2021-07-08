USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20),
    birthday_at DATE NOT NULL
);

INSERT INTO users(user_name, birthday_at) VALUES 
	('Ivan', '2000-12-21'),   -- 20
    ('Polina', '2000-04-05'), -- 21
    ('Marina', '2001-12-21'), -- 19
    ('Nikita', '2001-04-05'), -- 20
    ('Igor', '2002-12-21'),   -- 18
    ('Masha', '2002-04-05');  -- 19

-- SELECT user_name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age FROM users;

-- (20 + 21 + 19 + 20 + 18 + 19) / 6 = 19.5
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS average_age FROM users;
