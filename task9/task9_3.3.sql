-- Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.


-- SET GLOBAL log_bin_trust_function_creators = 1; 

USE example;

DROP FUNCTION IF EXISTS Fibonacci;
-- since recursion is not allowed...
DELIMITER $$
CREATE FUNCTION Fibonacci (num INT) 
RETURNS INT NOT DETERMINISTIC
BEGIN
	SET @x = num;
	CASE 
	WHEN (@x = 0)
		THEN RETURN 0 ;
	WHEN (@x = 1) 
		THEN RETURN 1 ;
	ELSE 
		BEGIN
			DECLARE ii INT DEFAULT 2;
			DECLARE f0 INT DEFAULT 0;
			DECLARE f1 INT DEFAULT 1;
			DECLARE fn INT DEFAULT 0;
			WHILE ii <= @x DO 
				SET fn = f0 + f1;
				SET f0 = f1;
				SET f1 = fn;
				SET ii = ii + 1;
			END WHILE;
		RETURN fn;
		END;
	END CASE ;
END $$
DELIMITER ;

SELECT Fibonacci(3)
UNION
SELECT Fibonacci(5)
UNION
SELECT Fibonacci(7)
UNION
SELECT Fibonacci(8)
UNION
SELECT Fibonacci(9)
UNION
SELECT Fibonacci(10);















