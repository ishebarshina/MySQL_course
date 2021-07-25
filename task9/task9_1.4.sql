USE example; 

-- Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, 
-- оставляя только 5 самых свежих записей

-- generate data 
DROP TABLE IF EXISTS august1;
CREATE TABLE august1 (
	created_at DATE
);

DROP PROCEDURE IF EXISTS proc_generate_date; 
DELIMITER $$
CREATE PROCEDURE proc_generate_date()
BEGIN
    DECLARE ii INT DEFAULT 0;
    WHILE ii <= 12 DO
		INSERT INTO august1(created_at) VALUES (DATE_ADD('2018-08-01', INTERVAL ROUND(RAND() * 30) DAY));
        SET ii = ii + 1;
    END WHILE;
END $$
DELIMITER ;

CALL proc_generate_date();

SELECT created_at AS ALL_TABLE FROM august1 
ORDER BY created_at DESC;

SELECT august1.created_at FROM (
	august1 INNER JOIN (
		SELECT created_at FROM august1
		ORDER BY created_at DESC LIMIT 5, 1) AS a5
	ON (
		august1.created_at <= a5.created_at 
	)
)
ORDER BY august1.created_at DESC ;

DELETE august1 
FROM ( august1 
	INNER JOIN (
		SELECT created_at FROM august1
		ORDER BY created_at DESC LIMIT 5, 1) AS a5
		ON (
			august1.created_at <= a5.created_at 
	)
);

SELECT created_at AS ALL_TABLE FROM august1 
ORDER BY created_at DESC;
