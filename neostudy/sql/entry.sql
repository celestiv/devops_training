-- Написать запрос по шаблону, к демонстрационной базе данных, использовать любую таблицу на ваше усмотрение,
-- главный критерий код запроса должен быть рабочим и возвращать строки, код запроса приложить в качестве результата выполненого ДЗ, самостоятельно код запроса выполнить и проанализировать результат.

-- 1
SELECT flight_no, departure_airport, arrival_airport
FROM flights
LIMIT 5; -- чтобы не было слишком много строк в выводе

--2
SELECT DISTINCT departure_airport
FROM flights
LIMIT 25;

--3 
SELECT flight_no, arrival_airport
FROM flights
WHERE departure_airport = 'ESL'; -- аэропорты, куда можно улететь из Элисты

--4 использовать как AND так и OR в одном условии.
SELECT flight_no, arrival_airport
FROM flights
WHERE departure_airport = 'ESL' AND (arrival_airport = 'VKO' OR arrival_airport = 'DME'); -- из Элисты во Внуково или Домодедово

--5
SELECT flight_no, arrival_airport
FROM flights
WHERE departure_airport = 'ESL' AND (arrival_airport IN ('VKO', 'DME'));

--6
SELECT departure_airport_name, arrival_airport_name, duration
FROM routes
WHERE duration BETWEEN '2:20:00' AND '2:30:00'; -- полеты которые длятся от 2ч 20 минут до 2ч 30 минут

--7
SELECT departure_airport_name, arrival_airport_name, duration
FROM routes
WHERE departure_airport LIKE 'VK%'; -- Код аэропорта начинается на "VK"

--8 Использовать одновременно ASC и DESC для разных столбцов
SELECT departure_airport_name, arrival_airport_name, duration
FROM routes
WHERE duration BETWEEN '2:20:00' AND '2:30:00' -- полеты которые длятся от 2ч 20 минут до 2ч 30 минут
ORDER BY departure_airport_name ASC, duration DESC,

--9
SELECT days_of_week, SUM(duration) -- сумарная длительность перелетов из Внуково
FROM routes
WHERE departure_airport = 'VKO'
GROUP BY days_of_week;

--10
SELECT days_of_week, COUNT(duration) -- количество перелетов из Внуково, сгрупированное по расписанию в течение недели
FROM routes
WHERE departure_airport = 'VKO'
GROUP BY days_of_week;

--11
SELECT days_of_week, COUNT(duration)
FROM routes
WHERE departure_airport = 'VKO'
GROUP BY days_of_week
HAVING SUM(duration) > '3:00:00';
-----


Аналогично предыдущему заданию, по шаблонам написать рабочие запросы к демонстрационной базе данных.

-- создание таблицы, не менее 4х колонок разного типа,
 1 колонка первичный ключ, одна необнуляймая
CREATE TABLE test (
  col1 SERIAL,
  col2 INT,
  col3 VARCHAR(10)
  col4 TEXT,
  PRIMARY KEY (col1)
);

-- удаление таблицы
DROP TABLE test;

-- создание индекса
CREATE UNIQUE INDEX test_idx
ON test (col1);

-- удаление индекса
ALTER TABLE test
DROP INDEX test_idx;

-- получение описания структуры таблицы
DESC test;

-- очистка таблицы
TRUNCATE TABLE test;

-- выбрать одно из вариантов: добавление/удаление/модификация колонок
ALTER TABLE test ADD col5 DATE;

-- переименование таблицы
ALTER TABLE test RENAME TO new_table;

-- вставка значений
INSERT INTO test (col2, col3, col4, col5)
VALUES (42, 'hello', 'this is a test table', '2024-06-19 10:10:11');

-- обновление записей
UPDATE test
SET col2 = 1111, col3 = 'aloha!', col4 = 'simple text', col5 = '2024-06-19 01:23:45'
WHERE col2 = 42;

-- удаление записей
DELETE FROM test
WHERE col2 = 1111;
