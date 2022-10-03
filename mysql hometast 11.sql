-- Практическое задание по теме “Оптимизация запросов”
-- Создайте таблицу logs типа Archive. Пусть при каждом
-- создании записи в таблицах users, catalogs и products в таблицу logs
-- помещается время и дата создания записи, название таблицы, 
-- идентификатор первичного ключа и содержимое поля name.

create table logs (
    id int unsigned not null auto_increment primary key,
    created_at datetime default current_timestamp,
    table_name varchar(50) not null,
    row_id int unsigned  not null,
    row_name varchar(255)
) engine = Archive;

DELIMITER //

create trigger products_insert after insert on products
for each row
begin
    insert into logs values (null, default, "products", new.id, new.name);
end//

create trigger users_insert after insert on users
for each row
begin
    insert into logs values (null, default, "users",  new.id, new.name);
end;//

create trigger catalogs_insert after insert on catalogs
for each row
begin
    insert into logs values (null, defaultT, "catalogs", new.id, new.name);
end //

DELIMITER ;


-- Практическое задание тема "NoSQL"
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
-- HINCRBY addresses '127.0.0.1' 1
-- HGETALL addresses

-- HINCRBY addresses '127.0.0.2' 1
-- HGETALL addresses

-- HGET addresses '127.0.0.1'

-- -- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному
-- -- адресу и наоборот, поиск электронного адреса пользователя по его имени.
-- HSET emails 'oleg' 'olegivanov@gmail.com'
-- HSET emails 'ivan' 'ivan@gmail.com'
-- HSET emails 'ira' 'ira@mail.ru'

-- HGET emails 'oleg'

-- HSET users 'olegivanov@gmail.com' 'oleg'
-- HSET users 'ivan@gmail.com' 'ivan'
-- HSET users 'ira@mail.ru' 'ira'

-- HGET users 'ira@mail.ru'

-- -- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
-- -- Предлагаемый вариант

-- show dbs

-- use shop

-- db.createCollection('catalogs')
-- db.createCollection('products')

-- db.catalogs.insert({name: 'Процессоры'})
-- db.catalogs.insert({name: 'Мат.платы'})
-- db.catalogs.insert({name: 'Видеокарты'})

-- db.products.insert(
--   {
--     name: 'Intel Core i3-8100',
--     description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
--     price: 7890.00,
--     catalog_id: new ObjectId("5b56c73f88f700498cbdc56b")
--   }
-- );

-- db.products.insert(
--   {
--     name: 'Intel Core i5-7400',
--     description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
--     price: 12700.00,
--     catalog_id: new ObjectId("5b56c73f88f700498cbdc56b")
--   }
-- );

-- db.products.insert(
--   {
--     name: 'ASUS ROG MAXIMUS X HERO',
--     description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
--     price: 19310.00,
--     catalog_id: new ObjectId("5b56c74788f700498cbdc56c")
--   }
-- );

-- db.products.find()

-- db.products.find({catalog_id: ObjectId("5b56c73f88f700498cbdc56bdb")})


