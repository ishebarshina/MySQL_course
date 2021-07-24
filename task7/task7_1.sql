USE shop; 

-- ��������� ������ ������������� users, 
-- ������� ����������� ���� �� ���� ����� orders 
-- � �������� ��������.

SELECT u.id , u.name 
FROM 
	orders o
INNER JOIN  
	users u
ON 
	u.id = o.user_id
GROUP BY u.id;
