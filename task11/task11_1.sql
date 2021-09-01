USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	created_at DATETIME,
	table_name VARCHAR(20),
	id_pk INT UNSIGNED,
	name VARCHAR(200)
) ENGINE = ARCHIVE ;

DROP TRIGGER IF EXISTS trig_insert_users ;
DELIMITER $$
CREATE TRIGGER trig_insert_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO logs(created_at, table_name, id_pk, name) VALUES (NOW(), 'users', NEW.id, NEW.name);
END $$

DROP TRIGGER IF EXISTS trig_insert_catalogs;
DELIMITER $$
CREATE TRIGGER trig_insert_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	INSERT INTO logs(created_at, table_name, id_pk, name) VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END $$

DROP TRIGGER IF EXISTS trig_insert_products;
DELIMITER $$
CREATE TRIGGER trig_insert_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	INSERT INTO logs(created_at, table_name, id_pk, name) VALUES (NOW(), 'products', NEW.id, NEW.name);
END $$


INSERT INTO users(id, name) VALUES (2, 'Masha');
INSERT INTO catalogs (id, name) VALUES (1, 'catalog1');
INSERT INTO products (id, name) VALUES (1, 'product1');

SELECT * FROM logs;

DESCRIBE logs;


