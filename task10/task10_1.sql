USE vk;

-- Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения 
-- и добавить необходимые индексы

-- 1. поиск по возрасту
-- ALTER TABLE profiles DROP INDEX ix_profiles_birthday;
CREATE INDEX ix_profiles_birthday ON profiles (birthday);
EXPLAIN SELECT first_name FROM profiles WHERE birthday < '2001-12-12';

-- 2. поиск по самым свежим записям
CREATE INDEX ix_posts_created_at ON posts (created_at);
EXPLAIN SELECT post_content FROM posts WHERE created_at > '2020-12-12';

-- 3. поиск по самым свежим медиафайлам
CREATE INDEX ix_media_created ON media (created_at);
EXPLAIN SELECT filename FROM media WHERE created_at > '2020-12-12';

-- 4. Новые подтвержденные друзья
-- ALTER TABLE friendship DROP INDEX ix_friendship_confirmed_at;
CREATE INDEX ix_friendship_confirmed_at ON friendship (confirmed_at);
EXPLAIN SELECT friend_id FROM friendship f WHERE (user_id = 1 AND  confirmed_at > '2001-01-01');


