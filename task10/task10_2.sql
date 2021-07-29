-- Задание на оконные функции. Построить запрос, который будет выводить следующие столбцы:
-- имя группы;
-- среднее количество пользователей в группах;
-- самый молодой пользователь в группе;
-- самый старший пользователь в группе;
-- общее количество пользователей в группе;
-- всего пользователей в системе;
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.


-- Результирующий запрос в конце файла

USE vk;

-- SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
-- INSERT INTO communities_users (community_id, user_id) VALUES (1, 2), (1, 4), (1, 6), (2, 3), (2, 5), (2, 7);

-- среднее количество пользователей в группах;
-- SELECT (2*4 + 1*98) / 100; 1.06
SELECT AVG(count1) 
FROM (
	SELECT COUNT(1) AS count1
	FROM communities_users cu
	GROUP BY cu.community_id
) sub_query;

SELECT AVG(COUNT(1)) OVER() 
FROM communities_users cu
GROUP BY cu.community_id;


-- test query
SELECT p.user_id , cu.community_id , p.birthday 
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC, p.birthday ASC ;

-- самый молодой пользователь в группе;
SELECT DISTINCT cu.community_id, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday DESC) AS youngest
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC;

-- самый старший пользователь в группе;
SELECT * FROM 
(SELECT cu.community_id, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday ASC) AS oldest  
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id )) AS T
GROUP BY community_id;

SELECT DISTINCT cu.community_id, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday ASC)
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC;

-- самый молодой и самый старший пользователь в группе;
SELECT * FROM 
(SELECT cu.community_id, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday ASC) AS oldest, 
FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday DESC) AS youngest  
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id )) AS T
GROUP BY community_id;

-- общее количество пользователей в группе;
SELECT COUNT(1)
FROM communities_users cu 
GROUP BY community_id ;

-- всего пользователей в системе;
SELECT SUM(COUNT(1)) OVER()
FROM profiles p 
GROUP BY p.user_id ;

-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
SELECT COUNT(1) / (SELECT SUM(COUNT(1)) OVER() FROM profiles p ) * 100
FROM communities_users cu 
GROUP BY community_id ;

-- запрос без самого молодого/старшего пользователя

SELECT  community_id,
AVG(COUNT(1)) OVER() AS avg_in_communities, -- среднее количество пользователей в группах;
COUNT(1) AS total_in_community,  -- общее количество пользователей в группе;
COUNT(1) / (SELECT SUM(COUNT(1)) OVER() FROM profiles p ) * 100 AS percentage, -- отношение в процентах 
(SELECT SUM(COUNT(1)) OVER() FROM profiles p ) AS total_users -- всего пользователей в системе;
FROM communities_users cu INNER JOIN profiles p ON (p.user_id = cu.user_id)
GROUP BY community_id;

-- запрос без имени группы

SELECT community_id, avg_in_communities, total_in_community, percentage, youngest, oldest
FROM (
(SELECT  community_id, 
AVG(COUNT(1)) OVER() AS avg_in_communities, -- среднее количество пользователей в группах;
COUNT(1) AS total_in_community,  -- общее количество пользователей в группе;
COUNT(1) / (SELECT SUM(COUNT(1)) OVER() FROM profiles p ) * 100 AS percentage, -- отношение в процентах 
(SELECT SUM(COUNT(1)) OVER() FROM profiles p ) AS total_users -- всего пользователей в системе;
FROM communities_users cu INNER JOIN profiles p ON (p.user_id = cu.user_id)
GROUP BY community_id) AS part1
INNER JOIN 
(SELECT DISTINCT cu.community_id AS si, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday DESC) AS youngest,
FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday ASC) AS oldest
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC) AS part2
ON (part1.community_id = part2.si));

-- имя группы

SELECT DISTINCT cu.community_id, c.name AS group_name FROM (profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
) INNER JOIN communities c ON (c.id = cu.community_id));

-- Результирующий запрос

SELECT community_id, community_name, avg_in_communities, total_in_community, percentage, youngest, oldest
FROM (
(SELECT  cu.community_id, co.name AS community_name,
AVG(COUNT(1)) OVER() AS avg_in_communities, -- среднее количество пользователей в группах;
COUNT(1) AS total_in_community,  -- общее количество пользователей в группе;
COUNT(1) / (SELECT SUM(COUNT(1)) OVER() FROM profiles p ) * 100 AS percentage, -- отношение в процентах 
(SELECT SUM(COUNT(1)) OVER() FROM profiles p ) AS total_users -- всего пользователей в системе;
FROM (profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
) INNER JOIN communities co ON (co.id = cu.community_id))
GROUP BY community_id) AS part1
INNER JOIN 
(SELECT DISTINCT cu.community_id AS si, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday DESC) AS youngest,
FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday ASC) AS oldest
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC) AS part2
ON (part1.community_id = part2.si));
