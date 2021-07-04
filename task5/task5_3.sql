-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех


USE example;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `value` INT UNSIGNED
);

INSERT INTO storehouses_products (`value`) 
VALUES (0), (2500), (0), (300), (500), (1);

-- отсортировать записи в выводе 

SELECT * FROM storehouses_products 
ORDER BY (`value`=0), `value` ASC;
