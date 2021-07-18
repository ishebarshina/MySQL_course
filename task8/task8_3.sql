USE vk;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- Посчитаем, сколько всего лайков поставили женщны
SELECT COUNT(1) 
FROM likes l
INNER JOIN profiles p ON (
	p.user_id = l.from_user_id 
	AND 
	p.gender = 'F'
	AND 
	l.like_type_id = 1
);

-- Посчитаем, сколько всего лайков поставили мужчины
SELECT COUNT(1) 
FROM likes l
INNER JOIN profiles p ON (
	p.user_id = l.from_user_id 
	AND 
	p.gender = 'M'
	AND 
	l.like_type_id = 1
);

-- Результирующий запрос
SELECT 'F', COUNT(1) AS num
FROM likes l
INNER JOIN profiles p ON (
	p.user_id = l.from_user_id 
	AND 
	p.gender = 'F'
	AND 
	l.like_type_id = 1
)
UNION
SELECT 'M', COUNT(1) AS num
FROM likes l
INNER JOIN profiles p ON (
	p.user_id = l.from_user_id 
	AND 
	p.gender = 'M'
	AND 
	l.like_type_id = 1
)
ORDER BY num DESC
LIMIT 1;