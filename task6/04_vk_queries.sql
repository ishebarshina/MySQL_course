USE vk;

-- Часть 2. Типовые запросы.

/*
1. Стена: посты пользователя и его друзей
2. Рекомендации: друзья друзей, у кого нет в друзьях пользователя
3. 5 друзей, которым мы отправили больше всего сообщения
4. Счетчик непрочитанных сообщений в разбивке по отправителю
5. Найти сообщения содержащие вложения определенного типа
*/

SELECT * FROM friendship;

-- "Подружим" других пользователей с пользователем id = 1
UPDATE friendship SET user_id = 1 WHERE user_id < 5;
SELECT * FROM friendship WHERE user_id = 1;
UPDATE friendship SET friend_id = 5 WHERE user_id = 1 AND friend_id = 1;

DESC friendship;

SELECT * FROM friendship WHERE friend_id = 1;

INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(6, 1, 1, CURRENT_TIMESTAMP);
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(18, 1, 1, CURRENT_TIMESTAMP);
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(19, 1, 1, CURRENT_TIMESTAMP);

-- Дружба у нас можем быть от A до В и от В до А.

-- Выберем принятые запросы на дружбу от пользователя 1 к другим пользователям
SELECT user_id, friend_id FROM friendship WHERE user_id = 1 AND status = 'Friend' AND confirmed_at IS NOT NULL;

-- Выберем принятые запросы на дружбу от других пользователей к пользователю 1 
SELECT friend_id, user_id  FROM friendship WHERE user_id = 1 AND status = 'Friend' AND confirmed_at IS NOT NULL

-- Горизонтально объединим результаты выборок, чтобы получить всех друзей
SELECT friend_id FROM friendship WHERE user_id = 1 AND status = 'Friend' AND confirmed_at IS NOT NULL
UNION
SELECT user_id AS friend_id FROM friendship WHERE friend_id = 1 AND status = 'Friend' AND confirmed_at IS NOT NULL;

/* Стена: посты пользователя и его друзей */

-- Посты пользователя
SELECT * FROM posts WHERE user_id = 1;

SELECT * FROM posts;

-- Посты друзей пользователя
SELECT * FROM posts WHERE user_id IN (  -- <- пример подзапроса
  -- Друзия пользвоателя
  SELECT    
    friend_id
  FROM
    friendship
  WHERE
    user_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
  UNION
  SELECT
    user_id AS friend_id
  FROM
    friendship
  WHERE
    friend_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
);

-- Сообщества, в которых состоит пользователь
SELECT * FROM communities_users WHERE user_id = 1;

-- Созданим текст постам
UPDATE posts SET post_content = MD5(RAND());

-- Посты сообществ, в кторых состоит пользователь
SELECT *
FROM
  posts
WHERE
  community_id IN (
  SELECT id
  FROM communities_users
  WHERE user_id = 1
)

-- Выведем информацию о посте: автора, дату и время создания и текст
SELECT 
  -- имя автора 
  (  
    SELECT
      concat_ws(' ', first_name, last_name)
    FROM
      profiles prof
    WHERE
      prof.user_id = posts.user_id  -- <- пример коррелированного подзапроса. Значение в подзапросе выбирается для каждой записи внешнего запроса.
  ) AS author,
  post_content ,
  created_at
FROM
  posts
WHERE
  user_id = 1;

SELECT 
  -- имя автора 
  ( 
    SELECT
      concat_ws(' ', first_name, last_name)
    FROM
      profiles prof
    WHERE
      prof.user_id = posts.user_id
  ) AS author,
  post_content ,
  created_at
FROM
  posts
WHERE 
  user_id IN (
    -- все друзья пользвоателя
    SELECT
      friend_id
    FROM
      friendship
    WHERE
      user_id = 1
      AND status = 'Friend'
      AND confirmed_at IS NOT NULL
    UNION
    SELECT
      user_id AS friend_id
    FROM
      friendship
    WHERE
      friend_id = 1
      AND status = 'Friend'
      AND confirmed_at IS NOT NULL
  );

SELECT 
  -- название соощества
  ( 
    SELECT
      name
    FROM
      communities u
    WHERE
      u.id = posts.community_id
  ) AS author,
  post_content ,
  created_at
FROM
  posts
WHERE
  community_id IN (
    -- все сообщества пользователя
    SELECT id
    FROM communities_users
    WHERE user_id = 1
  );


-- Объединим три запроса выше в один

-- Внешняя "обертка" для корректной работы ORDER BY t1.created_at DESC, чтобы сортировка делалась для результатов итогового объединения
SELECT *
FROM (
  -- посты пользователя
  SELECT 
    -- имя пользовател
    ( 
      SELECT
        concat_ws(' ', first_name, last_name)
      FROM
        profiles prof
      WHERE
        prof.user_id = posts.user_id
    ) AS author,
    post_content ,
    created_at
  FROM
    posts
  WHERE
    user_id = 1
  UNION
  -- посты друзей пользователя
  SELECT 
    -- имя друга
    ( 
      SELECT
        concat_ws(' ', first_name, last_name)
      FROM
        profiles prof
      WHERE
        prof.user_id = posts.user_id
    ) AS author,
    post_content ,
    created_at
  FROM
    posts
  WHERE 
    user_id IN (
      -- все друзья пользователя
      SELECT
        friend_id
      FROM
        friendship
      WHERE
        user_id = 1
        AND status = 'Friend'
        AND confirmed_at IS NOT NULL
      UNION
      SELECT
        user_id AS friend_id
      FROM
        friendship
      WHERE
        friend_id = 1
        AND status = 'Friend'
        AND confirmed_at IS NOT NULL
    )
  UNION 
  -- посты сообществ, в которых состоит пользователь
  SELECT 
    -- название сообщества
    ( 
      SELECT
        name
      FROM
        communities u
      WHERE
        u.id = posts.community_id
    ) AS author,
    post_content,
    created_at
  FROM
    posts
  WHERE
    community_id IN (
      -- сообщества, в которых состоит пользователь
      SELECT id
      FROM communities_users
      WHERE user_id = 1
    )
) t1
-- сортируем по убыванию (максимальное вверху)
ORDER BY t1.created_at DESC;

/* Счетчик непрочитанных сообщений в разбивке по отправителю*/

-- Пометим произвольные сообщения, как непрочитанные
UPDATE messages SET recieved_at = NULL WHERE RAND() < 0.5; 

SELECT 
  -- имя получателя
  (
    SELECT concat_ws(' ', first_name, last_name)
    FROM profiles p 
    WHERE p.user_id = m.reciever_id 
  ) reciever,
  -- имя отправителя
  (
    SELECT concat_ws(' ', first_name, last_name)
    FROM profiles p 
    WHERE p.user_id = m.sender_id 
  ) sender,
  -- счетчик непрочитанных сообщений
  COUNT(1) AS unread_messages
FROM 
  messages m
WHERE 
  -- непрочитанные сообщения пользователю 1
  m.reciever_id = 1 AND m.recieved_at IS NULL
GROUP BY 
  -- группируем по отправителю (просто, чтобы вывести) и получателю (по нему считаем кол-во сообщений) 
  m.reciever_id, m.sender_id
ORDER BY unread_messages DESC;
  
/* 5 друзей, которым мы отправили больше всего сообщения */
DESC messages;

-- Генерируем произвольную дату из диапазона

-- UNIX_TIMESTAMP - количество секунд '1970-01-01 00:00:00' (принятое начало линуксовой эпохи)
-- Кол-во секунд по текущую дату
SELECT UNIX_TIMESTAMP(CURRENT_TIMESTAMP());

-- Кол-во секунд по выбранную дату
SELECT UNIX_TIMESTAMP('2020-01-01 00:00:00');

-- Разница в секундах между двумя датами
SELECT UNIX_TIMESTAMP(CURRENT_TIMESTAMP()) - UNIX_TIMESTAMP('2020-01-01 00:00:00');

-- Произвольная дата в интервале
SELECT
FROM_UNIXTIME(
  UNIX_TIMESTAMP('2020-01-01 00:00:00') + 
  FLOOR(
    RAND() * (
      UNIX_TIMESTAMP(CURRENT_TIMESTAMP()) - UNIX_TIMESTAMP('2020-01-01 00:00:00')
    )
  )
);

-- Генерируем сообщения от пользователя 1 к его друзьям
INSERT INTO messages (sender_id, reciever_id, send_at)
SELECT 
  1, 
  friend_id,
  FROM_UNIXTIME(
    UNIX_TIMESTAMP('2020-01-01 00:00:00') + 
    FLOOR(
      RAND() * (
        UNIX_TIMESTAMP(CURRENT_TIMESTAMP()) - UNIX_TIMESTAMP('2020-01-01 00:00:00')
      )
    )
  )
FROM (
  -- друзья
  SELECT
    friend_id
  FROM
    friendship
  WHERE
    user_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
  UNION
  SELECT
    user_id AS friend_id
  FROM
    friendship
  WHERE
    friend_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
) t1
ORDER BY RAND()
LIMIT 1;

WITH friends AS ( -- <- пример именованного подзапроса
 -- все друзья пользователя
  SELECT
    friend_id
  FROM
    friendship
  WHERE
    user_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
  UNION
  SELECT
    user_id AS friend_id
  FROM
    friendship
  WHERE
    friend_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
)
SELECT 
  -- имя друга
  (
    SELECT concat_ws(' ', first_name, last_name)
    FROM profiles p 
    WHERE p.user_id = m.reciever_id 
  ) friend  
FROM messages m
WHERE sender_id = 1 AND reciever_id IN (
  -- выбираем сообщения отправленные друзьям
  SELECT friend_id
  FROM friends  -- <- обращение к именованному подзапросу
)
GROUP BY friend
-- сортируем по убыванию (максимальное вверху)
ORDER BY COUNT(1) DESC 
-- выбираем первые пять
LIMIT 5;

/* Найти сообщения содержащие вложения определенного типа */
SELECT * FROM messages_media;

SELECT  
  -- имя получателя
  (
    SELECT concat_ws(' ', first_name, last_name)
    FROM profiles p 
    WHERE p.user_id = m.reciever_id 
  ) reciever,
  -- имя отправителя
  (
    SELECT concat_ws(' ', first_name, last_name)
    FROM profiles p 
    WHERE p.user_id = m.sender_id 
  ) sender,
  -- дата отправки
  m.send_at 
FROM 
  messages m
WHERE
  m.reciever_id = 1
  AND (
    -- Коррелированный подзапрос для поиска медиафайлов сообщения
    SELECT mm.media_id
    FROM messages_media mm
    WHERE mm.message_id = m.id
    AND (
      -- Коррелированный подзапрос для проверки типа медиафайла
      SELECT media_id
      FROM media m2 
      WHERE 
        mm.media_id = m2.id 
        AND m2.media_type_id = 1
    )
  )
ORDER BY m.send_at;

-- Дружим друзей пользователя с другими пользователями
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(6, 2, 1, CURRENT_TIMESTAMP);
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(19, 2, 1, CURRENT_TIMESTAMP);
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(4, 2, 1, CURRENT_TIMESTAMP);
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(6, 19, 1, CURRENT_TIMESTAMP);
INSERT INTO friendship (user_id, friend_id, status, confirmed_at) VALUES(5, 4, 1, CURRENT_TIMESTAMP);


/* Рекомендации: друзья друзей, у кого нет в друзьях пользователя */

WITH f AS (
  -- все друзья пользователя 1
  SELECT
    friend_id
  FROM
    friendship
  WHERE
    user_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
  UNION
  SELECT
    user_id AS friend_id
  FROM
    friendship
  WHERE
    friend_id = 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
), ff AS (
  -- все друзья друзей пользователя 1
  SELECT
    friend_id
  FROM
    friendship
  WHERE
    user_id IN (
      -- обращение к подзапросу f
      SELECT friend_id FROM f
    )
    -- икслючаем дружбу с пользователем 1
    AND friend_id != 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
  UNION
  SELECT
    user_id AS friend_id
  FROM
    friendship
  WHERE
    friend_id IN (
      -- обращение к подзапросу f
      SELECT friend_id FROM f
    )
    -- икслючаем дружбу с пользователем 1
    AND user_id != 1
    AND status = 'Friend'
    AND confirmed_at IS NOT NULL
)
SELECT  
  -- имя рекомендованного пользователя
  (
    SELECT concat_ws(' ', first_name, last_name)
    FROM profiles p 
    WHERE p.user_id = ff.friend_id 
  ) recommeded_user_name
FROM ff;