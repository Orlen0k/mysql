-- ========Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”========

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users
	SET created_at = NOW() AND updated_at = NOW()
;
SELECT * FROM users;


-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
--    типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
--    Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

-- неудачно проектируем таблицу
ALTER TABLE users MODIFY COLUMN created_at VARCHAR(26) NULL;
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(26) NULL;

UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';

-- преобразование полей к формату DATETIME с сохранением значений
UPDATE users 
	SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

-- преобразование в тип DATETIME
ALTER TABLE users MODIFY COLUMN created_at DATETIME NULL;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME NULL;


-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться
-- самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.


ALTER TABLE storehouses_products ADD COLUMN storehouse_id VARCHAR(255) NOT NULL;
ALTER TABLE storehouses_products ADD COLUMN product_id VARCHAR(255) NOT NULL;
ALTER TABLE storehouses_products ADD COLUMN value VARCHAR(255) NOT NULL;
ALTER TABLE storehouses_products ADD COLUMN created_at datetime not null; 
ALTER TABLE storehouses_products ADD COLUMN updated_at datetime not null;


SELECT * FROM storehouses_products;

INSERT INTO storehouses_products
	(storehouse_id, product_id, value, created_at, updated_at) VALUES
	(1, 1, 2, now(), now()),
	(2, 2, 1, now(), now()),
	(3, 3, 5, now(), now()),
	(4, 4, 0, now(), now()),
	(5, 5, 4, now(), now()),
	(6, 6, 3, now(), now())
;

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 9999999999999999999999 ELSE value END;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
-- Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT * FROM users WHERE birthday_at RLIKE '^[0-9]{4}-(05|08)-[0-9]{2}';

-- ========Практическое задание теме “Агрегация данных”========

-- 5. (по желанию) Подсчитайте произведение чисел в столбце таблицы

SELECT round(exp(sum(log(id))), 10) from users;