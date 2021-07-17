USE vk;

ALTER TABLE profiles DROP COLUMN gender;
ALTER TABLE profiles ADD COLUMN gender ENUM('M', 'F');

UPDATE profiles SET gender = 1 + ROUND(RAND());

UPDATE like_types SET like_type_name = 'like' WHERE id = 1;
UPDATE like_types SET like_type_name = 'dislike' WHERE id = 2;
DELETE FROM like_types WHERE id > 2;

UPDATE entity_types SET entity_name = 'profiles' WHERE id = 1;
UPDATE entity_types SET entity_name = 'posts' WHERE id = 2;
UPDATE entity_types SET entity_name = 'messages' WHERE id = 3;
DELETE FROM entity_types WHERE id > 3;

UPDATE likes SET entity_id = 1 + FLOOR(RAND() * 3);
UPDATE likes SET like_type_id = 1 + FLOOR(RAND() * 2);

UPDATE media_types SET name = 'video' WHERE id = 1;
UPDATE media_types SET name = 'audio' WHERE id = 2;
UPDATE media_types SET name = 'image' WHERE id = 3;
UPDATE media_types SET name = 'gif' WHERE id = 4;
DELETE FROM media_types WHERE id > 4;

ALTER TABLE media DROP COLUMN metadata;
ALTER TABLE media ADD COLUMN metadata JSON;

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


UPDATE media SET filename = CONCAT('https://some-server/dir/', metadata->>"$.name", '.', metadata->>"$.extention");

-- friendship
ALTER TABLE friendship DROP COLUMN status; 
ALTER TABLE friendship ADD COLUMN status ENUM('Friend', 'Following', 'Blocked'); 

UPDATE friendship SET status = 1 + FLOOR(RAND() * 3);

-- ALTER TABLE likes DROP COLUMN entity_type_id;
ALTER TABLE likes ADD COLUMN entity_type_id INT UNSIGNED NOT NULL DEFAULT 1;
ALTER TABLE likes DROP CONSTRAINT fk_likes_entity_id;
ALTER TABLE likes ADD CONSTRAINT fk_likes_entity_type_id FOREIGN KEY (entity_type_id) REFERENCES entity_types(id);

UPDATE likes SET entity_id = floor(1 + RAND()*100);
























