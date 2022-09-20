
desc profiles;
-- добавляем внешние ключи

 alter table profiles
	add constraint profiles_user__id_fk
		foreign key (user_id) references users(id)
			on delete cascade,
    add constraint profiles_photo_id_fk
		foreign key (photo_id) references media(id)
			on delete set null;
 
--  изменяем тип столбца

alter table profiles drop foreign key profiles_user_id_fk;
alter table profiles modify column photo_id int(10) unsigned;

-- для таблицы сообщений

-- смотрим структуру таблицы

desc messages;

-- добавляем внешние ключи

alter table messages
	add constraint messages_from_user_id_fk
		foreign key (from_user_id) references users(id),
    add constraint messages_to_user_id_fk
		foreign key (to_user_id) references users(id);
        
 -- если нужно удалить  
 
 alter table table_name drop foreign key constraint_name;
 
--  примеры на основе бд vk

use vk;

-- получаем данные пользователей

select * from users where id = 7;

select first_name, last_name, 'city', 'main_photo' from users where id = 7;

select
	first_name,
    last_name,
    (select name from cities where id =
		(select city_id from profiles where user_id = 7)) as city,
     (select filename from media where id =
		(select photo_id from profiles where user_id = 7)
     ) as file_path
     from users
		where id = 7;    
        
--  дорабтываем условия  

select
	first_name,
    last_name,
    (select name from cities where id =
		(select city_id from profiles where user_id = users.id)) as city,
     (select filename from media where id =
		(select photo_id from profiles where user_id = users.id)
     ) as file_path
     from users
		where id = 7; 
        
--  получаем фотографии пользователя    

select filename from media
	where user_id = 7
		and media_type_id = (
			select id from media_types where name = 'photo'
		);
        
 select * from media_types;
 
--  выбираем историю по добавлению фотографий пользователя

select concat(
	'Пользователь',
	(select concat(first_name, ' ', last_name) from users where id = media.user_id),
	'добавил фото',
	filename, ' ',
	created_at) AS news
from media
where user_id = 7 and media_type_id = (
	select id from media_types where name = 'photo'
);

-- найдем кому принадлежат 10 самых больших файлов    

select user_id, filename, size
	from media
    order by size desc
    limit 10;
    
-- выбираем друзей пользователя с 2 сторон отношения дружбы

(select friend_id from friendships where user_id = 7)
union
(select user_id from friendships where friend_id = 7);

-- выбираем только друзей с активным статусом

select * from friendship_statuses;

(select friend_id
	from friendships
    where user_id = 7 and status_id = (
		select id from friendship_statuses where name = 'Confirmed'
       ) 
)
union
(select user_id
	from friendships
    where friend_id = 7 and status_id = (
		select id from friendship_statuses where name = 'Confirmed'
       ) 
);

-- выбираем медиафайлы друзей 

select filename from media where user_id In (
	(select friend_id
	from friendships
    where user_id = 7 and status_id = (
		select id from friendship_statuses where name = 'Confirmed'
       ) 
)
union
(select user_id
	from friendships
    where friend_id = 7 and status_id = (
		select id from friendship_statuses where name = 'Confirmed'
       )
	) 
);

-- определяем пользователей, общее занимаемое место медиафайлов которых превышает 100мб

select user_id, sum(size) as total
	from media
    group by user_id 
    having total > 100000000;
    
-- с итогами
    
select user_id, sum(size) as total
	from media
    group by user_id with rollup
    having total > 100000000;    
    
--  выбираем сообщения от пользователей  
select from_user_id, to_user_id, body, is_delivered, created_at
	from messages
		where from_user_id = 7 or to_user_id = 7
        order by created_at desc;
        
--         
-- сообщения со статусом   

select from_user_id,
	to_user_id,
    body,
    IF(is_delivered, 'delivered', 'not delivered') as status
		from messages
			where (from_user_id = 7 or to_user_id = 7)
        order by created_at desc;
        
-- поиск пользователя по шаблонам имени

select concat(first_name, ' ', last_name) as fullname
	from users
    where first_name like 'M%';
    
-- используем регулярные выражения   
    
  select concat(first_name, ' ', last_name) as fullname
	from users
    where first_name rlike '^K.*r$';  
  
 CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  user_id VARCHAR(100) NOT NULL,
  target_id VARCHAR(100) NOT NULL,
  target_type VARCHAR(100) NOT NULL UNIQUE,  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  
  );  

-- 2. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека,
--  который больше всех общался с нашим пользователем.

select
    COUNT(from_user_id) messages_count
    , from_user_id
    , to_user_id
from messages
where to_user_id = 10
group by from_user_id, to_user_id
order by messages_count desc
limit 1
;

 -- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
  
select
	(select gender from profiles where user_id = likes.user_id) as gender
from likes; 

-- Группируем и сортируем
select
	(select gender from profiles where user_id = likes.user_id) as gender,
	count()(*) as total
from likes
group by gender
order by total desc
limit 1;  

-- 4. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

 CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  
  ); 
  
-- Смотрим типы для лайков
select * from target_types;

-- Выбираем профили с сортировкой по дате рождения
select * from profiles order by birthday desc limit 10;


alter table target_types add column target_type_id int unsigned;

-- Выбираем количество лайков по условию
select
	(select count(*) from likes where target_id = profiles.user_id and target_type_id = 2) as likes_total  
	from profiles 
	order by birthday desc
	limit 10;

-- Подбиваем сумму внешним запросом
select SUM(likes_total) from  
  (select 
    (select COUNT(*) from likes where target_id = profiles.user_id and target_type_id = 2) as likes_total  
    from profiles 
    order by birthday 
    desc limit 10) as user_likes
; 

-- 5. Найти 10 пользователей, которые проявляют наименьшую
--  активность в использовании социальной сети.     

select
	name,
		(select COUNT(*) from likes where likes.user_id = users.id) + 
		(select COUNT(*) from media where media.user_id = users.id) + 
		(select COUNT(*) from messages where messages.from_user_id = users.id) as overall_activity 
from users
order by overall_activity
limit 10; 
   
    