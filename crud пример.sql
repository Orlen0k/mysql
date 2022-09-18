-- -----------------
-- CREATE ----------
-- -----------------
INSERT INTO 
	users (email,pass,name,surname,phone,gender,birthday,hometown,photo_id,created_at) 
VALUES 
	('azari_19921@rambler.ru','9cb6d063fb98b570f203f42d939a4ac6','Орест','Белоусов','+7 (221) 837-80-93','м','1972-07-05','Ряжск',2,'2020-07-11 01:33:07'),
	('pavel941@rambler.ru','e25b95bfaea95978dc5321d8582eae7b','Доброслав','Матвеев','+7 (161) 654-82-24','м','1988-12-14','Семлячики',4,'2020-07-13 15:49:02'),
	('blohinveniamin1@yahoo.com','5820d8df0f966b37e0716509821b9a77','Савелия','Ковалева','+7 (772) 747-36-96','ж','1990-10-21','Магадан',6,'2020-08-01 03:11:00'),
	('regina_20011@gmail.com','01217a39221665c6e8f006c2ccb18191','Виктория','Маслова','+7 (923) 310-11-56','ж','1999-06-17','Усть-Ордынский',8,'2020-01-13 17:37:29'),
	('parfen19717@rambler.ru','c365700914278365dddc437db98b907a','Феврония','Захарова','+7 (497) 236-28-26','ж','1995-08-31','Калевала',10,'2020-01-31 19:37:04'),
	('vadim761@hotmail.com','3ad95df172783de57a235ea90f525474','Софрон','Самсонов','+7 (417) 269-35-52','м','1974-05-06','Агата',12,'2020-02-17 03:12:14'),
	('nazarmakaro1v@rambler.ru','a5af1a1435f33d03a4ab8aff383ef4da','Роман','Шарапов','+7 (616) 293-81-54','м','1984-06-15','Липецк',14,'2020-03-15 04:03:25'),
	('bogdan_314@hotmail.com','4d8dd8a65409fb89bbfeb1e801ff60c3','Прокофий','Алексеев','+7 (156) 601-19-41','м','1990-01-27','Усть-Кулом',16,'2020-02-15 11:04:30'),
	('ikolobo1v@yahoo.com','bdc5f2f3f6fdacf4b4ce483ac63d5d3d','Гордей','Воробьев','+7 (433) 525-75-65','м','1992-02-27','Павловская',18,'2020-07-30 00:22:15'),
	('nestor118@yandex.ru','ec51054d5a81eb31beefd72550e9c4da','Сильвестр','Степанов','+7 (153) 800-74-57','м','1995-12-14','Каспийск',20,'2020-01-13 06:29:48');


INSERT INTO 
	users 
SET 
	email = 'seliverst_633@mail.ru',
	pass = '80384ced22d592b2bafaa489dc840d5c',
	name = 'Аверкий',
	surname = 'Жуков',
	phone = '+7 (218) 412-28-72',
	gender = 'м',
	birthday = '1972-07-05',
	hometown = 'Ряжск',
	photo_id = 2,
	created_at = '2020-07-11 01:33:07';


INSERT INTO 
	users (email,pass,name,surname,phone,gender,birthday,hometown,photo_id,created_at) 
SELECT 
	'newsel33@mail.ru',pass,name,surname,phone,gender,birthday,hometown,photo_id,created_at 
FROM 
	users 
WHERE 
	id = 2;


-- -----------------
-- READ ------------
-- -----------------
SELECT 
	CONCAT(name,' "', DAYNAME(created_at), '" ', surname) nickname, gender
FROM 
	users 
WHERE 
	id BETWEEN 11 AND 85
	AND surname LIKE '%ов_'
	AND gender = 'м'
LIMIT 3, 5;
/*
nickname                       |gender|
-------------------------------|------|
Януарий "Tuesday" Некрасова    |м     |
Геннадий "Monday" Мясникова    |м     |
Мстислав "Sunday" Константинова|м     |
Дмитрий "Sunday" Кудряшова     |м     |
Аникей "Friday" Фролова        |м     |
*/


SELECT 
	ROUND( DATEDIFF(NOW(), birthday) / 365 ) age, COUNT(*) quantity
FROM 
	users
GROUP BY 
	age 
HAVING quantity > 5;

/*
age|quantity|
---|--------|
 19|       9|
 21|      11|
 25|       6|
 27|       6|
 29|       8|
 30|       6|
 36|       6|
 40|       6|
 41|       8|
 44|       6|
 46|       8|
 47|       7|
 */


-- -----------------
-- UPDATE ----------
-- -----------------
UPDATE 
	users
SET
	created_at = NOW()
WHERE 
	id > 100;


-- -----------------
-- DELETE ----------
-- -----------------
DELETE FROM
	users
WHERE 
	id > 100;

TRUNCATE TABLE new_table; 