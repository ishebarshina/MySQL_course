DROP DATABASE IF EXISTS vv;
CREATE DATABASE vv;

USE vv;

DROP TABLE IF EXISTS acts;
CREATE TABLE acts(
	N INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	id INT UNSIGNED,
	`action` ENUM('start', 'r_tap', 'l_tap')
);

-- truncate acts;

SELECT * FROM acts;

-- fill with data
-- результатом должно быть 4 слайда
INSERT INTO acts(id, `action`) VALUES (625, 'start'), -- 1
									(625, 'r_tap'), -- 2
									(625, 'r_tap'), -- 3
									(625, 'l_tap'), -- 2
									(625, 'l_tap'), -- 1
									(625, 'r_tap'), -- 2
									(625, 'r_tap'), -- 3
									(625, 'r_tap'), -- 4
									(625, 'start'), -- 1 
									(625, 'r_tap'), -- 2
									(625, 'r_tap'); -- 3


SET @x = (SELECT max(N) FROM acts);
SELECT @x;
SELECT ((SELECT `action` FROM acts WHERE N = 1) <=> 'start');

SELECT IF ((SELECT `action` FROM acts WHERE N = 2) <=> 'start', 'yes', 'no');


DROP PROCEDURE IF EXISTS find_max_story; 
DELIMITER $$
CREATE PROCEDURE find_max_story()
BEGIN
	DECLARE current_story_number INT DEFAULT 1;
	DECLARE max_story_number INT DEFAULT 1;
	DECLARE ii INT DEFAULT 1;
	SET @N_acts = (SELECT max(N) FROM acts);
	WHILE ii <= @N_acts DO
		IF ((SELECT `action` FROM acts WHERE N = ii) <=> 'start')
			THEN SET current_story_number = 1;
		ELSEIF ((SELECT `action` FROM acts WHERE N = ii) <=> 'r_tap')
			THEN SET current_story_number = current_story_number + 1;
		ELSEIF ((SELECT `action` FROM acts WHERE N = ii) <=> 'l_tap')
			THEN SET current_story_number = current_story_number - 1;
		END IF;
		IF (max_story_number < current_story_number)
			THEN SET max_story_number = current_story_number;
		END IF;
    	SET ii = ii + 1;
    END WHILE;
   	SELECT max_story_number;
END $$
DELIMITER ;

CALL find_max_story();

