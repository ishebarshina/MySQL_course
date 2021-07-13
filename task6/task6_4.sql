USE vk;

-- Результирующий запрос в конце файла
-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- DESC likes ;

-- генерим лайки
-- ALTER TABLE likes DROP COLUMN entity_object_id; -- 
-- ALTER TABLE likes ADD COLUMN entity_object_id int unsigned NOT NULL DEFAULT 1 COMMENT 'Ссылка на id объекста сущности';
-- SELECT * FROM likes l ;
-- UPDATE likes SET entity_object_id = ROUND(1 + RAND() * 99);

-- Посчитаем, сколько всего лайков поставили женщны
SELECT COUNT(1) 
FROM likes l
WHERE (
	l.like_type_id = 1 AND 
	(SELECT p.gender FROM profiles p
	 WHERE p.user_id = l.from_user_id) = 'F' 
);

-- Посчитаем, сколько всего лайков поставили мужчины
SELECT COUNT(1) 
FROM likes l
WHERE (
	l.like_type_id = 1 AND 
	(SELECT p.gender FROM profiles p
	 WHERE p.user_id = l.from_user_id) = 'M' 
);

-- Результирующий запрос
SELECT 'F', COUNT(1) AS num
FROM likes l
WHERE (
	l.like_type_id = 1 AND 
	(SELECT p.gender FROM profiles p
	 WHERE p.user_id = l.from_user_id) = 'F' 
)
UNION
SELECT 'M', COUNT(1) AS num
FROM likes l
WHERE (
	l.like_type_id = 1 AND 
	(SELECT p.gender FROM profiles p
	 WHERE p.user_id = l.from_user_id) = 'M' 
) 
ORDER BY num DESC
LIMIT 1;
