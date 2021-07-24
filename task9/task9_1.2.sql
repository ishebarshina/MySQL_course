USE shop;

-- Создайте представление, которое выводит название name товарной позиции из таблицы
-- products и соответствующее название каталога name из таблицы catalogs.

CREATE VIEW query AS 
	SELECT p.name AS 'product name', c.name 'catalog name' FROM 
		products p INNER JOIN catalogs c ON (
			p.catalog_id = c.id 
		)
	ORDER BY c.id;
	
SELECT * FROM query;