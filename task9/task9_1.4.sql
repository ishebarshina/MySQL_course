USE example; 

-- Пусть имеется любая таблица с календарным полем created_at. Создайте
-- запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих
-- записей.

-- generate data 
DROP TABLE IF EXISTS august1;
CREATE TABLE august1 (
	created_at DATE
);

SELECT * FROM august1;

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

SELECT * FROM august1;





