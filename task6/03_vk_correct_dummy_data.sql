USE vk;

-- Пол пользователя в профиле
ALTER TABLE profiles DROP COLUMN gender;
ALTER TABLE profiles ADD COLUMN gender ENUM('M', 'F');


-- Вариант 1. Произвольно генерируем 'M' или 'F'
-- UPDATE profiles SET gender = (
--  SELECT 
--    CASE
--      WHEN RAND() > 0.5 THEN 'M'
--      ELSE 'F'
--    END
-- );

-- Вариант 2. Пользуемся свойством типа ENUM и обращается к значению по индексу:
-- 1 - 'M'
-- 2 - 'F'
-- UPDATE profiles SET gender = (
--   SELECT 
--     CASE
--       WHEN RAND() > 0.5 THEN 1
--       ELSE 2
--     END
-- );

-- Вариант 3. Генерируем рандомное число и округляем
UPDATE profiles SET gender = 1 + ROUND(RAND());

-- Типы лайков

UPDATE like_types SET like_type_name = 'like' WHERE id = 1;
UPDATE like_types SET like_type_name = 'dislike' WHERE id = 2;
DELETE FROM like_types WHERE id > 2;

-- Справочник сущностей, которым можно поставить лайк

UPDATE entity_types SET entity_name = 'profiles' WHERE id = 1;
UPDATE entity_types SET entity_name = 'posts' WHERE id = 2;
UPDATE entity_types SET entity_name = 'messages' WHERE id = 3;
DELETE FROM entity_types WHERE id > 3;

-- Обновляем значения согласно содержимому справочников

UPDATE likes SET entity_id = 1 + FLOOR(RAND() * 3);
UPDATE likes SET like_type_id = 1 + FLOOR(RAND() * 2);

-- Справочник типов медиа-файлов

UPDATE media_types SET name = 'video' WHERE id = 1;
UPDATE media_types SET name = 'audio' WHERE id = 2;
UPDATE media_types SET name = 'image' WHERE id = 3;
UPDATE media_types SET name = 'gif' WHERE id = 4;
DELETE FROM media_types WHERE id > 4;

-- Создаем поле под метаданные(описание) медиа-файлов

ALTER TABLE media DROP COLUMN metadata;
ALTER TABLE media ADD COLUMN metadata JSON;

-- Наполним метаданные медиа-файлов
-- Пример JSON (JavaScript Object Notation):
-- { "name": "", "size": "", "extention":"" }

UPDATE media SET metadata = CONCAT(
  '{ "name": "',
  SUBSTRING(MD5(RAND()) FROM 1 FOR 10),
  '", "size": "',
  FLOOR(RAND() * 10000000),
  ' KB", "extention":"',
  CASE
    WHEN media_type_id = 1 THEN 'avi'
    WHEN media_type_id = 2 THEN 'wav'
    WHEN media_type_id = 3 THEN 'jpeg'
    ELSE 'gif'
  END,
  '" }');

-- Пример обращения к полям JSON
-- SELECT 
--   metadata->>"$.name",
--   metadata->>"$.size",
--   metadata->>"$.extention"
-- FROM media;

-- Соберем путь к файлу из метаданных
UPDATE media SET filename = CONCAT('https://some-server/dir/', metadata->>"$.name", '.', metadata->>"$.extention");

-- friendship
ALTER TABLE friendship DROP COLUMN status; 
ALTER TABLE friendship ADD COLUMN status ENUM('Friend', 'Following', 'Blocked'); 

-- Генерируем статус из перечисления
UPDATE friendship SET status = 1 + FLOOR(RAND() * 3);
























