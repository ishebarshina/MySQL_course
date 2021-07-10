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

-- Таблица для групп
DROP TABLE IF EXISTS communities;
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
  metadata VARCHAR(100) COMMENT 'Данные',
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
ALTER TABLE likes ADD CONSTRAINT fk_likes_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);


































