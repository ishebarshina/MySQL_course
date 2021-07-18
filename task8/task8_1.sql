USE vk;
--  ### 1 ###
-- Пусть задан некоторый пользователь user_id = 1
-- Из всех друзей этого пользователя найдите человека, 
-- который больше всех общался с нашим пользователем. (LIMIT 1)


WITH friends AS ( 
  SELECT
    friend_id
  FROM
    friendship
  WHERE
    user_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
  UNION
  SELECT
    user_id AS friend_id
  FROM
    friendship
  WHERE
    friend_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
)
SELECT CONCAT_WS(' ', first_name, last_name) AS friend_name, COUNT(1)
FROM profiles p INNER JOIN (messages m
	INNER JOIN friends f ON (
		(m.sender_id = f.friend_id
		AND m.reciever_id = 1)
		OR 
		(m.reciever_id = f.friend_id
		AND m.sender_id = 1)
	)
) ON (p.user_id = f.friend_id)
GROUP BY friend_name
ORDER BY COUNT(1) DESC 
LIMIT 1;