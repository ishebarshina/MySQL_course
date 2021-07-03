DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY  COMMENT "Идентификатор строки",    
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

ALTER TABLE users AUTO_INCREMENT=1;

-- Таблица профилей с личными данными пользователя. Версионная 
DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  user_id INT UNSIGNED NOT NULL UNIQUE COMMENT "Идентификатор пользователя", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE NOT NULL COMMENT "Дата рождения",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

-- Создаем внешний ключ для связи для "user_id" таблицы "profiles" и полем "id" таблицы users
ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);

-- Вставка для демонстрации работы внешнего ключа fk_user_id
-- INSERT INTO `profiles` (`id`, `user_id`, `first_name`, `last_name`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (1, 0, 'Natalia', 'Ruecker', '', '1984-12-17', 'Mylesfurt', '', '2016-01-04 17:29:12', '2010-10-05 18:30:17');
-- INSERT INTO `profiles` (`id`, `user_id`, `first_name`, `last_name`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (2, 1, 'Cristina', 'Davis', '', '1987-12-23', 'West Valentinechester', '92576', '1985-04-15 22:45:11', '2013-08-19 10:00:00');

-- Таблица для групп
-- DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",     
  `name` VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
);

-- Таблица связи групп и пользователей 
DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Идентификатор группы",  
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
);

-- В каждой группе пользователь может присутствовать только один раз, соотвественно делаем пару полей "community_id"
-- и "user_id" первичным ключом
ALTER TABLE communities_users ADD CONSTRAINT pk_communities_users PRIMARY KEY (community_id, user_id);

-- Создаем внешние ключи для связи таблицы "communities_users" с таблицами "communities" и "users"
ALTER TABLE communities_users ADD CONSTRAINT fk_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_member_id FOREIGN KEY (user_id) REFERENCES users(id);

-- Таблица дружбы пользователей (друг/подписчик). Версионная.
DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
  friend_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
  `status` VARCHAR(100) NOT NULL COMMENT "Тип отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

-- У каждого пользователя может существовать только одна связь типа "друг" или "подписчик с другим пользователем.
-- Т.е. если у нас есть два друга A и B (т.е. два пользователя подписанных друг на дурга), то выглядит это так:
-- | user_id | friend_id |
-- |    A    |     B     |
-- |    B    |     A     |
-- Сделаем эту пару полей первичным ключом

ALTER TABLE friendship ADD CONSTRAINT pk_friendship PRIMARY KEY (user_id, friend_id);
-- Создаем внешние ключи для связи таблицы "friendship" с "users". 
ALTER TABLE friendship ADD CONSTRAINT fk_current_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

-- Таблица сообщений между пользователями. Версионная.

-- В данном случае мы можем создать естетвенный первичный ключ. Т.к. от одного пользователя к другому может быть отправлено
-- больше одного ключа, даже если мы сделаем ключом (sender_id, reciever_id, created_at) уникальность не гарантируется.
-- Поэтому создаем подолнительное поля id со свойством AUTO INCREMENT (увеличение на 1 при создании новой записи) и назначаем
-- это поле первичным ключом. Такой ключ называется синтетическим или сурогатным.
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",     
  sender_id INT UNSIGNED NOT NULL COMMENT "Идентификатор отправителя",
  reciever_id INT UNSIGNED NOT NULL COMMENT "Идентификатор получателя",
  send_at DATETIME DEFAULT NOW() COMMENT "Время отправления сообщения",
  recieved_at DATETIME COMMENT "Время получения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

-- Создаем внешние ключи для связи таблицы "messages" с "users".
ALTER TABLE messages ADD CONSTRAINT fk_sender_id FOREIGN KEY (sender_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_reciever_id FOREIGN KEY (reciever_id) REFERENCES users(id);

 -- Создаем и связываем таблицы для постов, медиа и лайков 
 
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  name VARCHAR(100) NOT NULL UNIQUE COMMENT 'Тип медиайла',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Тип медиа контента';

DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  media_type_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на тип контента',
  filename varchar(1000) NOT NULL COMMENT 'Путь в файлу',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Медиа';

ALTER TABLE media ADD CONSTRAINT fk_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);

DROP TABLE IF EXISTS messages_media;
CREATE TABLE messages_media (
  message_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор сообшения',
  media_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор медиа',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Связь сообщений и медиа';

ALTER TABLE messages_media ADD CONSTRAINT fk_mm_media_id FOREIGN KEY (media_id) REFERENCES media (id);
ALTER TABLE messages_media ADD CONSTRAINT fk_mm_message_id FOREIGN KEY (message_id) REFERENCES messages (id);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  user_id int UNSIGNED DEFAULT NULL COMMENT 'Ссылка на идентификатор пользователя который опубликовал пост',
  community_id int UNSIGNED DEFAULT NULL COMMENT 'Ссылка на дентификатор пользователя который опубликовал пост',
  post_content text COMMENT 'Текст произвольной длины',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время публикации поста',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Посты пользователей и групп';

ALTER TABLE posts ADD CONSTRAINT fk_post_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_post_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

DROP TABLE IF EXISTS posts_media;
CREATE TABLE posts_media (
  post_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор поста',
  media_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор медиа',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (post_id, media_id)
) COMMENT 'Связь постов и медиа';

ALTER TABLE posts_media ADD CONSTRAINT fk_pm_media_id FOREIGN KEY (media_id) REFERENCES media(id);
ALTER TABLE posts_media ADD CONSTRAINT fk_pm_post_id FOREIGN KEY (post_id) REFERENCES posts(id);

DROP TABLE IF EXISTS like_types;
CREATE TABLE like_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  like_type_name varchar(100) NOT NULL UNIQUE COMMENT 'Название варианта лайка'
) COMMENT 'Справочная таблица с типами лайков';

DROP TABLE IF EXISTS entity_types;
CREATE TABLE entity_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  entity_name varchar(100) NOT NULL UNIQUE COMMENT 'Имя сущности'
) COMMENT 'Справочная таблица с перечнем сущностей, которым можно поставить лайк';

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  entity_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор сущности',
  from_user_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор пользователя',
  like_type_id int unsigned NOT NULL COMMENT 'Ссылка на тип лайка',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Таблица лайков';

ALTER TABLE likes ADD CONSTRAINT fk_likes_entity_id FOREIGN KEY (entity_id) REFERENCES entity_types(id);
ALTER TABLE likes ADD CONSTRAINT fk_likes_type_id FOREIGN KEY (like_type_id) REFERENCES like_types(id);

-- Ограничесние целостности CHECK

-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (1, 'wo\'connell@example.org', '565.124.7072x8747', '2020-08-06 01:46:12', '1999-12-03 09:21:39');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (2, 'zachary84@example.com', '460-685-8030x92171', '1990-08-21 13:14:02', '2017-05-03 15:22:03');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (3, 'ilabadie@example.net', '05918920677', '1981-12-02 05:06:22', '1989-08-08 10:26:11');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (4, 'kozey.pearline@example.net', '615-859-8996x47247', '2020-09-23 22:27:44', '2015-05-31 15:35:31');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (5, 'bertha.kshlerin@example.org', '135-612-0360x8411', '1972-11-21 02:42:13', '1986-01-05 09:54:28');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (6, 'klocko.river@example.org', '+49(3)7806598096', '2005-10-17 02:20:46', '2005-12-02 18:08:52');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (7, 'gblanda@example.org', '1-620-816-9773x160', '2019-11-10 16:18:10', '2015-09-26 08:05:03');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (8, 'edgardo81@example.org', '1-621-106-4469x882', '1979-05-10 03:28:25', '2002-07-17 02:51:52');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (9, 'bogan.flavio@example.org', '02810064527', '2007-08-30 19:32:14', '2013-07-23 09:32:14');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (10, 'loren88@example.org', '+69(9)5824583456', '1987-12-09 23:35:20', '1988-03-12 00:29:06');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (11, 'gutmann.tremayne@example.com', '+04(3)3890785379', '1997-01-31 03:23:34', '2005-10-30 09:01:36');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (12, 'cindy17@example.net', '744.801.8677', '1993-06-17 15:09:08', '1987-02-01 09:28:31');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (13, 'gking@example.net', '+68(5)3074537722', '1987-01-17 23:39:23', '2015-10-24 12:35:30');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (14, 'jude.hudson@example.com', '553.164.0110', '1979-12-31 16:33:37', '1983-04-18 12:26:38');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (15, 'schaden.ana@example.net', '1-579-527-2123', '1993-02-21 19:29:53', '2013-11-07 09:36:59');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (16, 'melyna.bechtelar@example.net', '711-717-9216x032', '1992-12-14 15:33:11', '1993-08-19 13:46:43');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (17, 'clarabelle30@example.org', '(320)378-7438', '1998-06-06 04:11:23', '1997-10-25 20:31:09');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (18, 'streich.consuelo@example.org', '1-076-303-4431x36878', '2015-04-16 02:57:32', '2018-01-07 15:54:45');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (19, 'delmer.hyatt@example.org', '017-955-6302x64356', '1984-12-19 13:57:32', '2015-04-02 06:13:46');
-- INSERT INTO `users` (`id`, `email`, `phone`, `created_at`, `updated_at`) VALUES (20, 'greta.waelchi@example.net', '490-641-8842x04470', '1988-10-25 10:32:29', '2008-05-19 01:36:49');

-- INSERT INTO users and messages -- import from csv exaple 

SET GLOBAL local_infile = 'ON';
LOAD DATA LOCAL INFILE '/home/irina/shared/MySQL/fillbd_example/users.csv' 
INTO TABLE users 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/irina/shared/MySQL/fillbd_example/messages.csv' 
INTO TABLE messages 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Проверяем данные 
SELECT phone from users LIMIT 10;

--  Допустимы только номера телефонов вида +7<10 цифровых знаков>
ALTER TABLE users ADD CONSTRAINT phone_check CHECK (REGEXP_LIKE(PHONE, '^\\+7[0-9]{10}$'));

-- Генерируем подходящие данные для номера телефонов
-- в семинаре лишняя 9-ка в 9999... их должно быть 9, а не 10, тк одна уже есть в 90000...
UPDATE users SET phone = CONCAT('+7', 9000000000 + FLOOR(RAND()*999999999)); 

-- Работа с метаданными
-- USE INFORMATION_SCHEMA;

-- SHOW TABLES;

-- DESC `TABLES`;

-- SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'INFORMATION_SCHEMA';
-- SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'vk';
-- SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE  WHERE TABLE_SCHEMA = 'vk';

-- SELECT 
-- 	TABLE_NAME,
-- 	COLUMN_NAME,
-- 	CONSTRAINT_NAME,
-- 	REFERENCED_TABLE_NAME,
-- 	REFERENCED_COLUMN_NAME
-- FROM 
-- 	INFORMATION_SCHEMA.KEY_COLUMN_USAGE
-- WHERE 
-- 	TABLE_SCHEMA = 'vk'
--     AND TABLE_NAME = 'profiles' 
--     AND REFERENCED_COLUMN_NAME IS NOT NULL;