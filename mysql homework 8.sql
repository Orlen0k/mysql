-- См. методичку
-- Задание:
-- Переписать запросы, заданые к ДЗ урока 6, с использованием JOIN.

-- Определить кто больше поставил лайков(всего) - мужчины или женщины?

select profiles.gender,
count(likes.id) as total_likes
from likes
join profiles On likes.user_id = profiles.user_id
group by profiles.gender
order by total_likes Desc
Limit 1;

-- подсчитать общее колличество лайковб которые получили 10 самых молодых пользователей.

select * from target_types;

select
	sum(total_likes_to_person)
from(    
	select
		count(*) AS total_likes_to_person,        -- пример выше перепроверить
		p.user_id,
		p.birthday
	from likes as l
	join profiles AS p ON l.target_id = p.user_id
	where l target_type_id = 2 -- users
	Group by p.user_id
	ORder by p.birthday DESC
	Limit 10;
) as total_likes;

-- найти 10 пользователей, 
-- которые проявляют наименьшую активность в использовании соц сети

select user.id,
	count(distinct messages.id) +
    count(distinct likes.id) +
    count(distinct media.id) AS activity
from users
left join messages on users.id = messages.from_user_id
left join  likes on users.id = likes.user_id
left join  media on user_id = media.user_id
group by users.id
order by activity
limit 10;

















