-- 1. Составьте список пользователей users, которые осуществили хотя бы один
-- заказ orders в интернет магазине.
use example;
DROP TABLE IF EXISTS orders_products;
create table orders_products (
	id serial primary key,
    order_id bigint unsigned not null,
    product_id bigint unsigned not null,
    total int not null,
    foreign key (order_id) references orders (id),
    foreign key (product_id) references products (id)
);

create table if not exists orders (
	id serial primary key,
    order_id bigint unsigned not null,
    product_id bigint unsigned not null,
    total int not null    
);

create table if not exists products (
	id serial primary key,
    order_id bigint unsigned not null,
    product_id bigint unsigned not null,
    total int not null    
);
ALTER TABLE products ADD COLUMN name VARCHAR(255) NOT NULL;
ALTER TABLE orders ADD COLUMN user_id VARCHAR(255) NOT NULL;

insert into orders (user_id)
select id from users where name = 'Геннадий';


insert into orders_products (order_id, product_id, total)
select LAST_INSERT_ID(), id, 2 from products
where name = 'Intel Core i5-7400';

insert into orders (user_id)
select id from users where name = 'Наталья';

insert intoorders_products (order_id, product_id, total)
select LAST_INSERT_ID(), id, 1 from products
where name IN ('Intel Core i5-7400', 'Gigabyte H310M S2H');

insert into orders (user_id)
select id from users where name = 'Иван';

insert into orders_products (order_id, product_id, total)
select LAST_INSERT_ID(), id, 1 from products
where name IN ('AMD FX-8320', 'ASUS ROG MAXIMUS X HERO');

select id, name, birthday_at from users;

select u.id, u.name, u.birthday_at
	from users as u
	JOIN orders as o on u.id = o.user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует
-- товару.

select * from catalogs;

select
  p.id,
  p.name,
  p.price,
  c.name as catalog
from products as p
left JOIN catalogs as c on p.catalog_id = c.id;


-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица 
-- городов cities (label, name). Поля from, to и label содержат английские 
-- названия городов, поле name — русское. Выведите список рейсов flights с
-- русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'Город отравления',
  `to` VARCHAR(255) COMMENT 'Город прибытия'
) COMMENT = 'Рейсы';

INSERT INTO flights (`from`, `to`) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'Код города',
  name VARCHAR(255) COMMENT 'Название города'
) COMMENT = 'Словарь городов';

INSERT INTO cities (label, name) VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

select
  f.id,
  cities_from.name as `from`,
  cities_to.name as `to`
from flights as f
  JOIN cities as cities_from
    on f.from = cities_from.label
  JOIN cities as cities_to
    on f.to = cities_to.label;
