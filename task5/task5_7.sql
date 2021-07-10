-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20),
    birthday_at DATE NOT NULL
);

INSERT INTO users(user_name, birthday_at) VALUES 
	('Ivan', '2000-12-21'),   -- вт
    ('Polina', '2000-12-14'), -- вт
    ('Marina', '2001-12-23'), -- чт
    ('Nikita', '2001-11-18'), -- чт
    ('Igor', '2002-12-25'),   -- сб
    ('Masha', '2002-12-26');  -- вс


DROP TABLE IF EXISTS days_of_week;
CREATE TABLE days_of_week (
	id INT UNSIGNED PRIMARY KEY,
    day_name VARCHAR(20)
);

INSERT INTO days_of_week (id, day_name) VALUES 
	(1, 'Sunday'),
    (2, 'Monday'),
    (3, 'Tuesday'),
    (4, 'Wednesday'),
    (5, 'Thursday'),
    (6, 'Friday'),
    (7, 'Saturday');

-- кол-во пользователей на день недели
SELECT COUNT(*), 
DAYOFWEEK(STR_TO_DATE(CONCAT(EXTRACT(YEAR FROM NOW()), '-', EXTRACT(MONTH FROM birthday_at), '-', EXTRACT(DAY FROM birthday_at)), '%Y-%m-%d')) 
AS day_number,
(SELECT day_name FROM days_of_week WHERE days_of_week.id = day_number) AS `day`
FROM users 
GROUP BY day_number
ORDER BY day_number;

SELECT COUNT(*), 
(SELECT day_name 
	FROM days_of_week 
		WHERE days_of_week.id = 
		DAYOFWEEK(STR_TO_DATE(CONCAT(EXTRACT(YEAR FROM NOW()), '-', EXTRACT(MONTH FROM birthday_at), '-', EXTRACT(DAY FROM birthday_at)), '%Y-%m-%d')) )
		AS `day`
FROM users 
GROUP BY `day`
ORDER BY `day`;
