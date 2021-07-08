USE example;

DROP TABLE IF EXISTS val;
CREATE TABLE val (
	v INT
);

INSERT INTO val VALUES (7), (2), (3), (4), (5);

SELECT EXP(SUM(LOG(V))) FROM val;
-- 7 * 2 * 3 * 4 * 5 = 840

