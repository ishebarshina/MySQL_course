USE shop;

-- �������� ������ ������� products � �������� catalogs, ������� ������������� ������

SELECT * FROM products;
SELECT * FROM catalogs c ;

SELECT 
	p.name, c.name
FROM
	products p 
LEFT JOIN	-- ������� ������ ������������� �����-�� �������. �� �����-�� ������ ����� ���� ������.
	catalogs c
ON 
	p.catalog_id = c.id ;
