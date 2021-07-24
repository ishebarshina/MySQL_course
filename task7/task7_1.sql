USE shop; 

-- —оставьте список пользователей users, 
-- которые осуществили хот€ бы один заказ orders 
-- в интернет магазине.

SELECT u.id , u.name 
FROM 
	orders o
INNER JOIN  
	users u
ON 
	u.id = o.user_id
GROUP BY u.id;
