-- Практическое задание по теме “Транзакции, переменные, представления”
-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
-- Используйте транзакции.

select * from shop.users;
select * from sample.users;

start transaction;
	insert into sample.users select * from shop.users where id = 1;
    delete from shop.users where id = 1;
commit;

-- Создайте представление, которое выводит название name товарной позиции из 
-- таблицы products и соответствующее название каталога name из таблицы catalogs.

create or replace view products_catalogs AS
select
	p.name as product,
    c.name as catalog
from
    products as p
left join
	catalogs as c
on
	p.catalog_id = c.id;
    
    
-- Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01',
-- '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный
-- список дат за август, выставляя в соседнем поле значение 1, если дата присутствует 
-- в исходном таблице и 0, если она отсутствует.   
    
    
create table if not exists posts (
		id serial primary key,
        name varchar(255),
        created_at date not null
 );
 
insert into posts values
(null, 'первая запись', '2018-08-01'),    
(null, 'вторая запись', '2016-08-04'),        
(null, 'третья запись', '2018-08-16'),        
(null, 'четвертая запись', '2018-08-17');

create temporary table last_days (     
	day int
);

insert into last_days values
(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), 
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20), 
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30);


select
	date(date('2018-08-31') - interval l.day DAY) as day,
    not isnull(p.name) as order_exist
from
	last_days as l
left join
	posts as p
on
	date(date('2018-08-31') - interval l.day DAY) = p.created_at
order by
	day;
    
 -- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу
--  "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

use vk;

drop function if exists hello;

DELIMITER //

create function hello()
returns tinytext no sql
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
  CASE
	when hour between 0 and 5 then
	  return "Доброй ночи";
	when hour between 6 and 11 then
	  return "Доброе утро";
	when hour between 12 and 17 then
	  return "Доброе день";
	when hour between 18 and 23 then
	  return "Доброе вечер";    
  END case;
END//

DELIMITER ;
select now(), hello();

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

create trigger validate_name_description_insert before insert on products
for each row begin
  if NEW.name is null and new.descriprion is null then
	signal sqlstate '45000'
    set message_text = 'Both name and description are null';
  end if;
end//

insert into products
	(name, description, price, catalog_id)
values
	(null, null, 9360.00, 2)//    

insert into products
	(name, description, price, catalog_id)
values
	('Asus prime z370-p', 'HDMI, SATA3, PCI Express 3.0,, USB 3.1,' 9360.00, 2)//  
    
create trigger validate_nme_description_update before update on products
for each row begin
	if new.name is null and new.description is null then
		signal solstaye '45000'
        set message_text = 'Both name and description are null';
    end if;    
 end//   
 
 
 
 












