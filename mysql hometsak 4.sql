DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

-- Создаём таблицу пользователей
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  

-- Таблица профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  status VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили"; 

-- Таблица сообщений
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщения";

-- Таблица дружбы
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
  friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
  status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ"
) COMMENT "Таблица дружбы";

-- Таблица статусов дружеских отношений
CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Статусы дружбы";

-- Таблица групп
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

-- Таблица медиафайлов
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Медиафайлы";

-- Таблица типов медиафайлов
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";



-- Homework 4

show tables;

select * from users limit 10;

desc users;

UPDATE users SET updated_at = now() where updated_at < created_at;

desc profiles;

select * from profiles limit 10;

update profiles set photo_id = floor(1 + rand() * 100);

create table user_statuses (
	id int unsigned not null auto_increment primary key comment "Идентификатор строки",
    name varchar(100) not null comment "Название статуса (уникально)",
    created_at datetime not null default current_timestamp comment "Время создания строки",
    updated_at datetime default current_timestamp ON update current_timestamp comment "Время обновления строки"
) comment "Спавочник стран";

truncate table user_statuses;

UPDATE profiles SET	status = null;
select * from user_statuses;
insert into user_statuses (name) values
	('single'),
    ('married');
alter table profiles rename column status to user_status_id;
alter table profiles modify column user_status_id int unsigned;

desc profiles;

update profiles set user_status_id = floor(1 + rand() * 2);
select * from profiles limit 10;

drop temporary table if exists genders;
create temporary table genders (
	name char(1)
);

insert into genders values ('m'), ('f');

select * from genders;

update profiles
	set gender = (select name from genders order by rand() limit 1);

select * from profiles limit 10;

show tables;

desc messages;

select * from messages limit 10;

update messages set
	from_user_id = floor(1 + rand() * 100),
    to_user_id = floor(1 + rand() * 100);

desc media;

select * from media limit 10;

select * from media_types;

delete from media_types;

insert into media_types (name) Values
	('photo'),
    ('video'),
    ('audio')
;

truncate media_types;

select * from media LIMIT 10;

update media set media_type_id = floor(1 + rand() * 3);
update media set user_id = floor(1 + rand() * 100);

drop temporary table if exists extensions;
CREATE temporary table extensions (name VARCHAR(10));

insert into extensions values ('jpeg'), ('avi'), ('mpeg'), ('png');

select * from extensions;

update media set filename = concat(
	'http;//dropbox.net/vk/',
    filename,
    (select last_name from users order by rand() Limit 1),
    '.',
    (select name from extensions order by rand() limit 1)
);

select * from media;

update media set size = floor(10000 + (rand() * 1000000)) where size < 1000;

update media set metadata = concat('{"owner";"',
	(select concat(first_name, '' , last name) from users where id = user_id),
    '"}');   

desc media;

alter table media modify column metadata JSON;

-- структура таблицы дружбы
 
desc friendship;
rename table friendship to friendships;

select * from friendships limit 10;

desc friendships;

select * from friendships;

update friendships set
	user_id = floor(1 + rand() * 100),
    friend_id = floor(1 + rand() * 100);
    
alter table friendships add column id int unsigned;

--  исправляем случай user_id = friend_id
update friendships set friend_id = friend_id + 1 where user_id = friend_id;

select	* from friendship_statuses;

truncate friendship_statuses;

insert into friendship_statuses (name) values
	('Requested'),
    ('Confirmed'),
    ('Rejected');
    
update friendships set status_id = floor(1 + rand() * 3);

-- cруктура таблицы групп

desc communities;

select * from communities;

delete from communities where id > 20;

select * from communities_users;

-- обновляем значения community_id

update communities_users set community_id = floor(1 + rand() * 20);













