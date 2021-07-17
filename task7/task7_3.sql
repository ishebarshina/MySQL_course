DROP DATABASE IF EXISTS example;
CREATE DATABASE example;
USE example;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`from` VARCHAR(20) NOT NULL,
	`to` VARCHAR(20) NOT NULL
);

-- Словарь
DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	label VARCHAR(20) NOT NULL UNIQUE, 
	name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO flights (`from`, `to`) VALUES 
	('moscow', 'omsk'),
	('novgorod', 'kazan'), 
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');
	
INSERT INTO cities (label, name) VALUES 
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'), 
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск'),
	('saratov', 'Саратов');
	

SELECT * FROM flights;
SELECT * FROM cities;

SELECT t1.id, t1.name, t2.name 
FROM 
(
	SELECT 
		f.id, f.`from`, f.`to`, c.name 
	FROM
		flights f 
	LEFT JOIN 
		cities c
	ON 
		f.`from` = c.label
) t1
LEFT JOIN 
(
	SELECT 
		f.id, c.name 
	FROM 
		flights f 
	LEFT JOIN 
		cities c
	ON 
		f.`to` = c.label
) t2
ON 
	t1.id = t2.id
ORDER BY 
		id;



