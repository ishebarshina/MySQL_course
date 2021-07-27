-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

SET GLOBAL log_bin_trust_function_creators = 1;

USE example;

DROP FUNCTION IF EXISTS hello;

DELIMITER $$
CREATE FUNCTION hello (in_var TIME) 
RETURNS VARCHAR(255) NOT DETERMINISTIC
BEGIN
	SET @t = in_var;
	CASE 
	WHEN (CAST(@t AS TIME) >= CAST('06:00:00' AS time)
		AND CAST(@t AS TIME) < CAST('12:00:00' AS time))
		THEN RETURN 'good morning' ;
	WHEN (CAST(@t AS TIME) >= CAST('12:00:00' AS time)
		AND CAST(@t AS TIME) < CAST('18:00:00' AS time)) 
		THEN RETURN 'good afternoon' ;
	WHEN (CAST(@t AS TIME) >= CAST('18:00:00' AS time)
		AND CAST(@t AS TIME) <= CAST('24:00:00' AS time))
		THEN RETURN 'good evening' ;
	ELSE 
		RETURN 'time to go to bed already' ;
-- 	RETURN '';
	END CASE ;
END $$
DELIMITER ;

SELECT hello(CURRENT_TIME()) ;
SELECT hello('09:00:00')
UNION 
SELECT hello('15:00:00')
UNION 
SELECT hello('20:00:00')
UNION
SELECT hello('02:00:00');


