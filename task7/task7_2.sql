USE shop;

-- Выведите список товаров products и разделов catalogs, который соответствует товару

SELECT * FROM products;
SELECT * FROM catalogs c ;

SELECT 
	p.name, c.name
FROM
	products p 
INNER JOIN	-- каждому товару соответствует какой-то каталог. но какой-то катало может быть пустым.
	catalogs c
ON 
	p.catalog_id = c.id ;
