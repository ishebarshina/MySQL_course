USE vk;

-- Результирующий запрос в конце файла
-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- будем считать, что нужно подсчитать 
-- количество лайков профилей пользователя +
-- количество лайков постов, который пользователь опубликовал +
-- количество лайков сообщений, который пользователь написал

-- генерим лайки
-- ALTER TABLE likes DROP COLUMN entity_object_id; -- 
-- ALTER TABLE likes ADD COLUMN entity_object_id int unsigned NOT NULL DEFAULT 1 COMMENT 'Ссылка на id объекста сущности';
-- SELECT * FROM likes l ;
-- UPDATE likes SET entity_object_id = ROUND(1 + RAND() * 99);


-- профили 10 самых молодых мользователей
-- SELECT * FROM profiles p 
-- ORDER BY birthday DESC
-- LIMIT 10;

-- все посты, которые опубликовали молодые пользователи
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT * FROM posts p
WHERE p.user_id  IN (
	SELECT user_id FROM youngest_users
);

-- все сообщения, которые написали молодые пользователи
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT * FROM messages m
WHERE m.sender_id  IN (
	SELECT user_id FROM youngest_users
);

-- смотрим лайки профилей
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT *  FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "profiles") AND 
	l.entity_object_id IN (
		SELECT id FROM  youngest_users
	)
) ;

-- смотрим лайки постов
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT *  FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "posts") AND 
	l.entity_object_id IN (
		SELECT id FROM posts po
		WHERE po.user_id  IN (
			SELECT id FROM youngest_users
		)
)) ;

-- смотрим лайки сообщений
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT * FROM likes l
WHERE (
	l.like_type_id  = 1 AND 
	l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "messages") AND 
	l.entity_object_id IN (
		SELECT id FROM messages m
		WHERE m.sender_id  IN (
			SELECT id FROM youngest_users
		)
));


-- Выведем таблицу youngest_users | their profiles likes count
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT 
(
	SELECT CONCAT_WS(' ', first_name, last_name) 
	FROM youngest_users yu
	WHERE yu.id = l.entity_object_id
) AS youngs, COUNT(1)
FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "profiles") AND 
	l.entity_object_id IN (
		SELECT id FROM  youngest_users
	)
)
GROUP BY youngs
ORDER BY youngs; -- COUNT(1);

-- Выведем таблицу youngest_users | their posts likes count
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT 
(
	SELECT CONCAT_WS(' ', first_name, last_name) 
	FROM youngest_users yu
	WHERE yu.id = l.entity_object_id
) AS youngs, COUNT(1)
FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "posts") AND 
	l.entity_object_id IN (
		SELECT id FROM posts po
		WHERE po.user_id  IN (
			SELECT id FROM youngest_users
			)
	)
)
GROUP BY youngs
ORDER BY youngs; -- COUNT(1);


-- Выведем таблицу youngest_users | their messages likes count
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT 
(
	SELECT CONCAT_WS(' ', first_name, last_name) 
	FROM youngest_users yu
	WHERE yu.id = l.entity_object_id
) AS youngs, COUNT(1)
FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "messages") AND 
	l.entity_object_id IN (
		SELECT id FROM messages m
		WHERE m.sender_id  IN (
			SELECT id FROM youngest_users
			)
	)
)
GROUP BY youngs
ORDER BY youngs; -- COUNT(1);

-- Собираем всё вместе -- РЕЗУЛЬТИРУЮЩИЙ ЗАПРОС
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT 
(
	SELECT CONCAT_WS(' ', first_name, last_name) 
	FROM youngest_users yu
	WHERE yu.id = l.entity_object_id
) AS youngs, COUNT(1)
FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	(
	CASE 
		WHEN (l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "profiles"))
			THEN (l.entity_object_id IN (
				SELECT id FROM  youngest_users
			))
		WHEN (l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "posts"))
			THEN (l.entity_object_id IN (
				SELECT id FROM posts po
				WHERE po.user_id  IN (
					SELECT id FROM youngest_users
				)
			))
		WHEN (l.entity_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "messages"))
			THEN (l.entity_object_id IN (
				SELECT id FROM messages m
				WHERE m.sender_id  IN (
					SELECT id FROM youngest_users
				)
			))
	END
	)
)
GROUP BY youngs
ORDER BY youngs; -- COUNT(1);


