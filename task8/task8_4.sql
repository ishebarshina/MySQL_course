USE vk;

-- ������ 10 �������������, ��� ������� ����� 
-- (������������ ����� + ������������ ���������) 
-- ����������

-- �������������� ������

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




