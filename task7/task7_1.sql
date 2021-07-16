USE shop; 

-- ��������� ������ ������������� users, 
-- ������� ����������� ���� �� ���� ����� orders 
-- � �������� ��������.

SELECT u.id , u.name 
FROM 
	orders o
LEFT JOIN  
	users u
ON 
	u.id = o.user_id
GROUP BY u.id;