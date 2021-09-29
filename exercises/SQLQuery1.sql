-- drop database if exists vv;
-- CREATE DATABASE vv;

USE vv;


DROP TABLE IF EXISTS acts; 
CREATE TABLE acts(
	N INT not null constraint pk_N primary key,
	id INT not null,
	[action] VARCHAR(10) NOT NULL CHECK ([action] IN('start', 'r_tap', 'l_tap'))
);

-- truncate acts;

-- fill with data
-- результатом должно быть 4 слайда
INSERT INTO acts(N, id, [action]) VALUES (1, 625, 'start'), -- 1
									(2, 625, 'r_tap'), -- 2
									(3, 625, 'r_tap'), -- 3
									(4, 625, 'l_tap'), -- 2
									(5, 625, 'l_tap'), -- 1
									(6, 625, 'r_tap'), -- 2
									(7, 625, 'r_tap'), -- 3
									(8, 625, 'r_tap'), -- 4
									(9, 625, 'start'), -- 1 
									(10, 625, 'r_tap'), -- 2
									(11, 625, 'r_tap'); -- 3

SELECT * FROM acts;

DROP PROCEDURE IF EXISTS find_max_story; 
GO
CREATE PROCEDURE find_max_story
AS
BEGIN
	DECLARE @current_story_number INT;
	SET @current_story_number = 1;
	DECLARE @max_story_number INT;
	SET @max_story_number = 1;
	DECLARE @ii INT;
	SET @ii = 1;
	DECLARE @N_acts INT;
	SET @N_acts = (SELECT max(N) FROM acts);
	WHILE @ii <= @N_acts 
	BEGIN
		IF ((SELECT [action] FROM acts WHERE N = @ii) = 'start')
		BEGIN
			SET @current_story_number = 1;
		END
		IF ((SELECT [action] FROM acts WHERE N = @ii) = 'r_tap')
		BEGIN
			SET @current_story_number = @current_story_number + 1;
		END
		IF ((SELECT [action] FROM acts WHERE N = @ii) = 'l_tap')
		BEGIN
			SET @current_story_number = @current_story_number - 1;
		END
		IF (@max_story_number < @current_story_number)
		BEGIN
			SET @max_story_number = @current_story_number;
		END
    	SET @ii = @ii + 1;
    END
   	select @max_story_number;
END
GO


EXEC find_max_story;
