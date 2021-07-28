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
OVER(PARTITION BY cu.community_id ORDER BY p.birthday DESC)
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC;

-- самый старший пользователь в группе;
SELECT DISTINCT cu.community_id, FIRST_VALUE(p.user_id) 
OVER(PARTITION BY cu.community_id ORDER BY p.birthday ASC)
FROM profiles p INNER JOIN communities_users cu ON (
	cu.user_id = p.user_id 
)
ORDER BY cu.community_id ASC;

-- общее количество пользователей в группе;
SELECT COUNT(1) 
FROM communities_users cu 
GROUP BY community_id ;

-- всего пользователей в системе;
SELECT SUM(COUNT(1)) OVER()
FROM users u
GROUP BY u.id;

-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
SELECT COUNT(1) / (SELECT SUM(COUNT(1)) OVER() FROM users u) * 100
FROM communities_users cu 
GROUP BY community_id ;





