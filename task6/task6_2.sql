USE vk;

-- Пусть задан некоторый пользователь user_id = 1
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем. (LIMIT 1)


WITH friends AS ( 
 -- все друзья пользователя
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
SELECT 
(
	SELECT CONCAT_WS(' ', first_name, last_name)
	FROM profiles p
-- Чтобы в запросе участвовали и люди, которым писал user_id=1,
-- и люди, которые ему писали
-- изменим условие WHERE по сравнению с семинарским
	WHERE p.user_id = m.reciever_id OR p.user_id = m.reciever_id 
) AS friend, COUNT(1) -- выведем также кол-во сообщений
FROM messages m
-- Чтобы в запросе участвовали и люди, которым писал user_id=1,
-- и люди, которые ему писали
-- изменим условие WHERE по сравнению с семинарским
WHERE ((reciever_id = 1 AND sender_id IN (
  -- выбираем сообщения отправленные друзьям
  SELECT friend_id
  FROM friends 
)) OR (sender_id = 1 AND reciever_id IN (
  SELECT friend_id
  FROM friends 
)))
GROUP BY friend
-- сортируем по убыванию (максимальное вверху)
ORDER BY COUNT(1) DESC 
LIMIT 1;


