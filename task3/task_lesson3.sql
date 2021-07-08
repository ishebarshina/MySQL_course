DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY  COMMENT "Идентификатор строки",    
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

-- ALTER TABLE `users` ADD PRIMARY KEY (id);
ALTER TABLE `users` AUTO_INCREMENT=1;

DROP TABLE IF EXISTS `profiles`;
-- Таблица профилей с личными данными пользователя. Версионная 
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
ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES `users`(id);
-- ALTER TABLE `users` ADD CONSTRAINT fk_profile_id FOREIGN KEY (id) REFERENCES `profiles`(user_id);

-- Вставка для демонстрации работы внешнего ключа fk_user_id
-- INSERT INTO `profiles` (`id`, `user_id`, `first_name`, `last_name`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (1, 0, 'Natalia', 'Ruecker', '', '1984-12-17', 'Mylesfurt', '', '2016-01-04 17:29:12', '2010-10-05 18:30:17');
-- INSERT INTO `profiles` (`id`, `user_id`, `first_name`, `last_name`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (2, 1, 'Cristina', 'Davis', '', '1987-12-23', 'West Valentinechester', '92576', '1985-04-15 22:45:11', '2013-08-19 10:00:00');

-- Таблица для групп
CREATE TABLE `communities` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",     
  `name` VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
);

-- Таблица связи групп и пользователей 
CREATE TABLE `communities_users` (
  community_id INT UNSIGNED NOT NULL COMMENT "Идентификатор группы",  
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
);

-- В каждой группе пользователь может присутствовать только один раз, соотвественно делаем пару полей "community_id"
-- и "user_id" первичным ключом
ALTER TABLE `communities_users` ADD CONSTRAINT pk_communities_users PRIMARY KEY (community_id, user_id);

-- Создаем внешние ключи для связи таблицы "communities_users" с таблицами "communities" и "users"
ALTER TABLE `communities_users` ADD CONSTRAINT fk_community_id FOREIGN KEY (community_id) REFERENCES `communities`(id);
ALTER TABLE `communities_users` ADD CONSTRAINT fk_member_id FOREIGN KEY (user_id) REFERENCES `users`(id);

-- Таблица дружбы пользователей (друг/подписчик). Версионная.
CREATE TABLE `friendship` (
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

ALTER TABLE `friendship` ADD CONSTRAINT pk_friendship PRIMARY KEY (user_id, friend_id);
-- Создаем внешние ключи для связи таблицы "friendship" с "users". 
ALTER TABLE `friendship` ADD CONSTRAINT fk_current_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE `friendship` ADD CONSTRAINT fk_friend_id FOREIGN KEY (friend_id) REFERENCES `users`(id);

-- Таблица сообщений между пользователями. Версионная.

-- В данном случае мы можем создать естетвенный первичный ключ. Т.к. от одного пользователя к другому может быть отправлено
-- больше одного ключа, даже если мы сделаем ключом (sender_id, reciever_id, created_at) уникальность не гарантируется.
-- Поэтому создаем подолнительное поля id со свойством AUTO INCREMENT (увеличение на 1 при создании новой записи) и назначаем
-- это поле первичным ключом. Такой ключ называется синтетическим или сурогатным.
CREATE TABLE `messages` (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",     
  sender_id INT UNSIGNED NOT NULL COMMENT "Идентификатор отправителя",
  reciever_id INT UNSIGNED NOT NULL COMMENT "Идентификатор получателя",
  send_at DATETIME DEFAULT NOW() COMMENT "Время отправления сообщения",
  recieved_at DATETIME COMMENT "Время получения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

-- Создаем внешние ключи для связи таблицы "messages" с "users".
ALTER TABLE `messages` ADD CONSTRAINT fk_sender_id FOREIGN KEY (sender_id) REFERENCES `users`(id);
ALTER TABLE `messages` ADD CONSTRAINT fk_reciever_id FOREIGN KEY (reciever_id) REFERENCES `users`(id);

-- Добавить необходимую таблицу/таблицы для того, чтобы можно было использовать лайки для медиафайлов, постов и пользователей
-- 
-- not editable
DROP TABLE IF EXISTS `media_files`;
CREATE TABLE `media_files` (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор файла",
    user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя который опубликовал файл",
    file_name VARCHAR(100) NOT NULL COMMENT "Названия могут повторяться",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания", 
    -- file_link VARCHAR(250) NOT NULL UNIQUE COMMENT "Unique file link",
    file_description VARCHAR(100) NOT NULL COMMENT "Описание медиафайла"
);

-- not editable
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор поста, записи",
    post_content VARCHAR(280) NOT NULL COMMENT "Длина записи как твиттере",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время публикации поста", 
    user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя который опубликовал пост"
);

DROP TABLE IF EXISTS `entity_ident`;
CREATE TABLE `entity_ident` (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    `ref_table_name` VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO `entity_ident` VALUES 
	(1, 'profiles'),
    (2, 'media_files'),
    (3, 'posts');

DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    odject_type INT UNSIGNED NOT NULL COMMENT "id названия таблицы, можно получить из entity_ident",
    object_id INT UNSIGNED NOT NULL COMMENT "id медиафайла / поста / профиля в соответствующей таблице",
    who_liked_id INT UNSIGNED NOT NULL COMMENT "id пользователя, который поставил like"
);

ALTER TABLE `likes` ADD CONSTRAINT fk_object_type FOREIGN KEY (odject_type) REFERENCES `entity_ident`(id);


-- Инициализируем всё чем-нибудь
-- users
INSERT INTO `users` (email, phone) VALUES 
	('mail1', 'phone1'),
    ('mail2', 'phone2'),
    ('mail3', 'phone3');
-- profiles
INSERT INTO `profiles` (user_id, first_name, last_name, gender, city, birthday, country) VALUES
	(1, 'Ivan', 'Ivanov', 'm', 'Moscow', '1984-12-17', 'RF'),
    (2, 'Anna', 'Ivanova', 'f', 'Moscow', '1984-12-16', 'RF'),
    (3, 'Marina', 'Ivanova', 'f', 'Moscow', '1984-12-15', 'RF');
-- SELECT CONCAT(first_name,' ',last_name) full_name FROM `profiles` WHERE id = 2;
-- media_files
INSERT INTO `media_files` (user_id, file_name, file_description) VALUES
	(1, "cat", "cat photo"),
    (2, 'dog', 'dog photo'),
    (3, 'rabbit', 'rabbit photo');
-- posts
INSERT INTO `posts` (user_id, post_content) VALUES
	(1, 'my name is Ivan'),
    (2, 'my name is Anna'),
    (3, 'my name is Marina');

-- Ivan liked dog photo, rabbit photo and his own post
-- Anna liked rabbit photo and Marina's post and her profile
-- Marina liked cat photo and dog photo and Anna's profile
INSERT INTO `likes` (who_liked_id, odject_type, object_id) VALUES
	(1, 2, 2),
    (1, 2, 3),
    (1, 3, 1),
    (2, 2, 3),
    (2, 3, 3),
    (2, 1, 3),
    (3, 2, 1),
    (3, 2, 2),
    (3, 1, 2);
