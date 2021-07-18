USE vk;

-- Результирующий запрос в конце файла
-- Подсчитать общее количество лайков, 
-- которые получили 10 самых молодых пользователей.
-- Нужно подсчитать 
-- количество лайков профилей пользователя +
-- количество лайков постов, который пользователь опубликовал +
-- количество лайков сообщений, который пользователь написал

-- все посты, которые опубликовали молодые пользователи
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT * FROM posts p 
INNER JOIN youngest_users yu ON (
	yu.user_id = p.user_id
);

-- все сообщения, которые написали молодые пользователи
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT * FROM messages m
INNER JOIN youngest_users yu ON (
	m.sender_id = yu.user_id	
);

-- смотрим лайки профилей
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT *  FROM likes l
INNER JOIN entity_types et ON (
	l.entity_type_id = et.id
	AND 
	et.entity_name = "profiles"
	AND 
	l.like_type_id = 1
) INNER JOIN youngest_users yu ON (
	l.entity_id = yu.id
);

-- смотрим лайки постов
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT *  FROM likes l 
INNER JOIN entity_types et ON (
	l.entity_type_id = et.id
	AND 
	l.like_type_id  = 1
	AND 
	et.entity_name = "posts"	
) INNER JOIN 
(
	posts po 
	INNER JOIN 
	youngest_users yu ON (
		po.user_id = yu.id
	)
) ON (
	po.id = l.entity_id
);

-- смотрим лайки сообщений
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT * FROM likes l
INNER JOIN entity_types et ON (
	l.entity_type_id = et.id 
	AND 
	et.entity_name = "messages"
	AND 
	l.like_type_id  = 1
) INNER JOIN 
(
	messages m 
	INNER JOIN
	youngest_users yu ON (
		m.sender_id = yu.id
	)
);


-- Выведем таблицу youngest_users | their profiles likes count
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
) 
SELECT CONCAT_WS(' ', yu.first_name, yu.last_name) AS youngs, COUNT(1)
FROM (youngest_users yu
INNER JOIN likes l ON (
	yu.id = l.entity_id
) 
INNER JOIN entity_types et ON (
	et.id = l.entity_type_id 
	AND 
	l.like_type_id = 1
	AND 
	et.entity_name = "profiles"
)) 
GROUP BY youngs
ORDER BY youngs;

-- Выведем таблицу youngest_users | their messages likes count
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT CONCAT_WS(' ', first_name, last_name) AS youngs, COUNT(1)
FROM (likes l 
INNER JOIN entity_types et ON (
	et.id = l.entity_type_id
	AND l.like_type_id  = 1
) INNER JOIN (
	messages m 
	INNER JOIN
	youngest_users yu ON (
		m.sender_id = yu.id
	)
) ON (
	m.id = l.entity_id 
	)
)
GROUP BY youngs
ORDER BY youngs;

-- original query
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT 
(
	SELECT CONCAT_WS(' ', first_name, last_name) 
	FROM youngest_users yu
	WHERE yu.id = l.entity_id
) AS youngs, COUNT(1)
FROM likes l 
WHERE (
	l.like_type_id  = 1 AND 
	(
	CASE 
		WHEN (l.entity_type_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "profiles"))
			THEN (l.entity_id IN (
				SELECT id FROM  youngest_users
			))
		WHEN (l.entity_type_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "posts"))
			THEN (l.entity_id IN (
				SELECT id FROM posts po
				WHERE po.user_id  IN (
					SELECT id FROM youngest_users
				)
			))
		WHEN (l.entity_type_id = (SELECT et.id FROM entity_types et WHERE et.entity_name = "messages"))
			THEN (l.entity_id IN (
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

-- РЕЗУЛЬТИРУЮЩИЙ ЗАПРОС
WITH youngest_users AS (
	SELECT * FROM profiles p 
	ORDER BY birthday DESC
	LIMIT 10
)
SELECT *, count(*) FROM (
SELECT CONCAT_WS(' ', first_name, last_name) AS youngs_names
FROM (youngest_users yu INNER JOIN 
(likes l INNER JOIN entity_types et ON (
	et.id = l.entity_type_id
	AND l.like_type_id  = 1
	AND et.entity_name = "profiles"
)) ON (
	l.entity_id = yu.id))
UNION ALL 
SELECT CONCAT_WS(' ', first_name, last_name) AS youngs_names
FROM (youngest_users yu1 INNER JOIN messages m ON (
	yu1.user_id = m.sender_id 
) INNER JOIN 
(likes l1 INNER JOIN entity_types et1 ON (
	et1.id = l1.entity_type_id
	AND l1.like_type_id  = 1
	AND et1.entity_name = "messages"
)) ON (
	m.id = l1.entity_id 
	)
)
UNION ALL 
SELECT CONCAT_WS(' ', first_name, last_name) AS youngs_names
FROM (youngest_users yu2 INNER JOIN posts po ON (
	yu2.user_id = po.user_id 
) INNER JOIN 
(likes l2 INNER JOIN entity_types et2 ON (
	et2.id = l2.entity_type_id
	AND l2.like_type_id  = 1
	AND et2.entity_name = "posts"
)) ON (
	po.id= l2.entity_id 
	)
)) AS youngs_names
GROUP BY youngs_names
ORDER BY youngs_names;


-- FROM profiles pr INNER JOIN youngest_users yu ON (
-- 	pr.id = yu.id)
-- 	
-- WITH youngest_users AS (
-- 	SELECT * FROM profiles p 
-- 	ORDER BY birthday DESC
-- 	LIMIT 10
-- )
-- SELECT * FROM (messages m CROSS JOIN posts po) CROSS JOIN youngest_users yu;
