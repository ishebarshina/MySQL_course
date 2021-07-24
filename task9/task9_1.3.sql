USE example;

-- Пусть имеется таблица с календарным полем created_at. В ней размещены
-- разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и
-- 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в
-- соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она
-- отсутствует.

-- generate data 
DROP TABLE IF EXISTS august;
CREATE TABLE august (
	created_at DATE
);

INSERT INTO august(created_at) VALUES ('2018-08-01'),
										('2018-08-04'),
										('2018-08-16'),
										('2018-08-17');

SELECT * FROM august;

DROP TABLE IF EXISTS day_august;
CREATE TABLE day_august (
	i INT
);

DROP PROCEDURE IF EXISTS proc_date; 
DELIMITER $$
CREATE PROCEDURE proc_date()
BEGIN
    DECLARE ii INT DEFAULT 1;
    WHILE ii <= 31 DO
		INSERT INTO day_august(i) VALUES (ii);
        SET ii = ii + 1;
    END WHILE;
END $$
DELIMITER ;

CALL proc_date();

SELECT * FROM day_august;

-- результирующий запрос

SELECT DATE_ADD('2018-08-01', INTERVAL (da.i - 1) DAY) AS 'day_August', 
		(au.created_at) IS NOT NULL AS 'true'
FROM day_august da LEFT JOIN august au ON (
	DAYOFMONTH(au.created_at) = da.i
);

