-- Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER 'shop_read'@'localhost';
GRANT SELECT, SHOW VIEW ON shop.* 
	TO 'shop_read'@'localhost';

CREATE USER 'shop'@'localhost';
GRANT ALL ON shop.* TO 'shop'@'localhost';

