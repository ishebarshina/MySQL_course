DROP TABLE IF EXISTS sample.users;
CREATE TABLE sample.users (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255)
);

-- changing FK in shop data base so I can delete users without errors
ALTER TABLE shop.discounts DROP CONSTRAINT fk_d_user_id;
ALTER TABLE shop.discounts ADD CONSTRAINT fk_d_user_id FOREIGN KEY (user_id) REFERENCES shop.users(id) ON DELETE CASCADE;

ALTER TABLE shop.orders DROP CONSTRAINT fk_order_user_id;
ALTER TABLE shop.orders ADD CONSTRAINT fk_order_user_id FOREIGN KEY (user_id) REFERENCES shop.users(id) ON DELETE CASCADE;

ALTER TABLE shop.orders_products DROP CONSTRAINT fk_product_id;
ALTER TABLE shop.orders_products ADD CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES shop.products(id) ON DELETE CASCADE;

ALTER TABLE shop.orders_products DROP CONSTRAINT fk_order_id;
ALTER TABLE shop.orders_products ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES shop.orders(id) ON DELETE CASCADE;

-- В базе данных shop и sample присутствуют одни и те же таблицы, 
-- учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users 
-- в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
	INSERT INTO sample.users 
		SELECT * FROM shop.users 
		WHERE id = 1
	;
	DELETE FROM shop.users WHERE id = 1;
COMMIT;

SELECT * FROM sample.users;
SELECT * FROM shop.users;