USE vk;

-- Найдем 10 пользователей, для которых сумма 
-- (поставленные лайки + отправленные сообщения) 
-- наименьшая

-- Результирующий запрос

SELECT *, COUNT(1) 
FROM (
	SELECT CONCAT_WS(' ', first_name, last_name) AS U_ID
	FROM (
		profiles p INNER JOIN likes l ON (
			p.user_id = l.from_user_id 
		))
	UNION ALL 
	SELECT CONCAT_WS(' ', first_name, last_name) AS U_ID
	FROM (
		profiles p INNER JOIN messages m ON (
			p.user_id = m.sender_id 
		))
) AS U_ID 
GROUP BY U_ID 
ORDER BY COUNT(1) ASC 
LIMIT 10;




