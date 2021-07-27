-- В таблице products есть два текстовых поля: 
-- name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

USE example;

DROP TABLE IF EXISTS products1;
CREATE TABLE products1 (
	name VARCHAR(255),
	description VARCHAR(255)
);


DROP TRIGGER IF EXISTS trig_insert ;

DELIMITER $$
CREATE TRIGGER trig_insert BEFORE INSERT ON products1
FOR EACH ROW 
BEGIN 
	IF (NEW.name IS NULL AND NEW.description IS NULL) 
		THEN 
		SIGNAL SQLSTATE '45000' -- unhandled user-defined exception
		SET MESSAGE_TEXT = 'bot fields IS NULL -- insert trigger';
	END IF ;
END $$

-- INSERT INTO products1 (name, description) VALUES (NULL, NULL ) ; $$
DELIMITER ;
-- 
DROP TRIGGER IF EXISTS trig_update;
DELIMITER $$
CREATE TRIGGER trig_update BEFORE UPDATE ON products1
FOR EACH ROW 
BEGIN 
	IF (NEW.name IS NULL AND NEW.description IS NULL) 
		THEN 
		SIGNAL SQLSTATE '45000' -- unhandled user-defined exception
		SET MESSAGE_TEXT = 'bot fields IS NULL -- update trigger';
	END IF ;
END $$
DELIMITER ;

INSERT INTO products1 (name, description) VALUES ('1', '2');
UPDATE products1 SET name = '1', description = '1NULL' ;
UPDATE products1 SET name = NULL, description = NULL ;

SELECT * FROM products1; 

