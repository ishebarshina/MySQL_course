USE vk;

-- Результирующий запрос в конце файла
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- DESC likes ;

-- генерим лайки
-- ALTER TABLE likes DROP COLUMN entity_object_id; -- 
-- ALTER TABLE likes ADD COLUMN entity_object_id int unsigned NOT NULL DEFAULT 1 COMMENT 'Ссылка на id объекста сущности';
-- SELECT * FROM likes l ;
-- UPDATE likes SET entity_object_id = ROUND(1 + RAND() * 99);


-- Для этого задания сгенерируем новые данные поля from_user_id
-- ALTER TABLE likes DROP COLUMN from_user_id;
-- ALTER TABLE likes ADD COLUMN from_user_id int unsigned NOT NULL;
-- UPDATE likes SET from_user_id = ROUND(1 + RAND() * 99);




-- Найдем 10 пользователей, для которых сумма 
-- (поставленные лайки + отправленные сообщения) 
-- наименьшая


-- SELECT 
-- (
-- 	SELECT CONCAT_WS(' ', first_name, last_name) 
-- 	FROM profiles p 
-- ) AS last_users, 
-- COUNT(1) 
-- 	FROM likes l
-- 	
-- 
-- GROUP BY last_users ;



SELECT from_user_id , COUNT(1) 
FROM likes l
GROUP BY from_user_id 
ORDER BY COUNT(1), from_user_id ASC;


SELECT sender_id , COUNT(1) 
FROM messages m 
GROUP BY sender_id 
ORDER BY COUNT(1), sender_id ASC;

-- Результирующий запрос

WITH likes_and_messages AS (
	SELECT 
		from_user_id 
	AS 
		U_ID 
	FROM 
		likes l 
	UNION ALL
	SELECT 
		sender_id 
	AS 
		U_ID
	FROM 
		messages m 
)
SELECT 
	U_ID, 
	(
	SELECT 
		CONCAT_WS(' ', first_name, last_name)
	FROM 
		profiles p 
	WHERE 
		p.user_id = U_ID
	) AS user_full_name,
	COUNT(1)
FROM 
	likes_and_messages
GROUP BY 
	U_ID
ORDER BY 
	COUNT(1), U_ID ASC
LIMIT 10;  -- 




