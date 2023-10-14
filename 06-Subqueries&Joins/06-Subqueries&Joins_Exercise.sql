-- 01 Booked for nights
CREATE DATABASE subqueries_joins_booking_db;

-- Execute queries from 06-DB-Exercise-booking_db.sql
SELECT
	CONCAT(apartments.address, ' ', apartments.address_2) AS "apartment_address",
	bookings.booked_for AS "nights"
FROM 
	apartments
JOIN 
	bookings 
ON 
	bookings.booking_id = apartments.booking_id
ORDER BY 
	apartments.apartment_id;


-- 02 - First 10 Apartments Booked At
SELECT
	apartments.name,
	apartments.country,
	bookings.booked_at:: date
FROM
	apartments
LEFT JOIN 
	bookings 
ON 
	bookings.booking_id = apartments.booking_id
LIMIT 10;

-- 03 First 10 customers with Bookings
SELECT
	bookings.booking_id,
	bookings.starts_at:: date,
	bookings.apartment_id,
	CONCAT(customers.first_name, ' ', customers.last_name) AS "customer_name"
FROM
	bookings
RIGHT JOIN 
	customers
ON 
	bookings.customer_id = customers.customer_id
ORDER BY 
	"customer_name"
LIMIT 10;


-- 04 - Booking information
SELECT
	bookings.booking_id,
	apartments.name AS "apartment_owner",
	apartments.apartment_id,
	CONCAT(customers.first_name, ' ', customers.last_name) AS "customer_name"
FROM 
	bookings
FULL JOIN
	apartments ON apartments.booking_id = bookings.booking_id 
FULL JOIN
	customers ON customers.customer_id = bookings.customer_id
ORDER BY
	bookings.booking_id, "apartment_owner", "customer_name";


-- 05 - Multiplication of information
SELECT 
	bookings.booking_id,
	customers.first_name
FROM
	bookings
CROSS JOIN 
	customers
ORDER BY 
	customers.first_name;


-- 06 - Unassigned apartments
SELECT
	bookings.booking_id,
	bookings.apartment_id,
	customers.companion_full_name
FROM 
	bookings
JOIN 
	customers
ON
	customers.customer_id = bookings.customer_id
WHERE 
	bookings.apartment_id IS NULL;


-- 07 - Bookings made by lead
SELECT
	bookings.apartment_id,
	bookings.booked_for,
	customers.first_name,
	country
FROM
	bookings
JOIN
	customers
ON
	bookings.customer_id = customers.customer_id
WHERE
	customers.job_type = 'Lead';


-- 08 - Hahn's Bookings
SELECT
	COUNT(*)
FROM
	bookings
JOIN
	customers
ON
	customers.customer_id = bookings.customer_id
WHERE
	customers.last_name='Hahn';


-- 09 - Total Sum of Nights
SELECT
	apartments.name,
	SUM(bookings.booked_for)
FROM 
	apartments
JOIN
	bookings
ON
	bookings.apartment_id = apartments.apartment_id
GROUP BY
	apartments.name
ORDER BY
	apartments.name;


-- 10 - Popular Vacation Destinations
SELECT
	apartments.country,
	COUNT(bookings.booking_id)
FROM 
	apartments
JOIN
	bookings
ON
	bookings.apartment_id = apartments.apartment_id
WHERE
	bookings.booked_at > '2021-05-18 07:52:09.904+03' AND bookings.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY
	apartments.country
ORDER BY
	COUNT(bookings.booking_id) DESC;


-- 11 - Bulgaria's Peaks higher than 2835m.
SELECT 
	mountains_countries.country_code,
	mountains.mountain_range,
	peaks.peak_name,
	peaks.elevation
FROM
	mountains
JOIN
	peaks ON peaks.mountain_id = mountains.id
JOIN
	mountains_countries ON mountains_countries.mountain_id = mountains.id
WHERE
	mountains_countries.country_code = 'BG' AND peaks.elevation > 2835
ORDER BY
	peaks.elevation DESC;


-- 12 Count mountains ranges
SELECT 
	mountains_countries.country_code,
	COUNT(mountains.mountain_range)
FROM
	mountains
JOIN
	mountains_countries ON mountains_countries.mountain_id = mountains.id
WHERE
	mountains_countries.country_code IN ('BG','RU','US')
GROUP BY
	mountains_countries.country_code
ORDER BY
	COUNT(mountains.mountain_range) DESC;


-- 13 Rivers in AFrica
SELECT 
	countries.country_name,
	rivers.river_name
FROM
	countries
FULL JOIN
	countries_rivers ON countries.country_code = countries_rivers.country_code
FULL JOIN
	rivers ON rivers.id = countries_rivers.river_id
WHERE
	countries.continent_code = 'AF'
ORDER BY
	countries.country_name
LIMIT 5;


-- 14 Minimum Average Area Across Continents
SELECT
	MIN("average_area")
FROM
	(
		SELECT
			AVG(countries.area_in_sq_km) AS "average_area"
		FROM
			countries
		GROUP BY 
			countries.continent_code
	) 
AS 
	"average_area_per_continent";


-- 15 - Countries Without Any Mountains
	-- Option 1:
SELECT
	COUNT(*)
FROM
	countries AS c
LEFT JOIN
	mountains_countries AS mc
USING
	(country_code)
WHERE
	mc.mountain_id is NULL;

	-- Option 2
SELECT
	"countries_cnt" - "mount_cnt"
FROM(
	SELECT
		COUNT(countries.country_code) AS "countries_cnt",
		COUNT(mountains_countries.country_code) AS "mount_cnt"
	FROM
		countries
	LEFT JOIN
		mountains_countries
	USING
		(country_code)
	) AS "countries";


-- 16 - Monasteries by Country 

--  create table monasteries
CREATE TABLE monasteries(
	id SERIAL PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);

--  insert data
INSERT INTO monasteries
	(monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
	('Bachkovo Monastery "Virgin Mary"', 'BG'),
	('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR');


--  add new column "three_rivers" as bool in countries
ALTER TABLE 
	countries
ADD COLUMN
	three_rivers BOOL DEFAULT FALSE;

-- update three_rivers based on river count per country
UPDATE
	countries
SET
	three_rivers = (
		SELECT
			COUNT(*) > 3
		FROM
			countries_rivers
		WHERE 
			countries_rivers.country_code = countries.country_code
	);

-- select monasteries from countries with more than 3 rivers
SELECT
	m.monastery_name,
	c.country_name
FROM 
	monasteries AS m
JOIN
	countries AS c
USING
	(country_code)
WHERE
	NOT c.three_rivers
ORDER BY
	m.monastery_name;


-- 17 - Monasteries by Continents and Countries
UPDATE 
	countries
SET
	country_name = 'Burma'
WHERE
	country_name = 'Myanmar';


INSERT INTO monasteries
	(monastery_name, country_code)
VALUES
	('Hanga Abbey', 'TZ'),
	('Myin-Tin-Daik', 'MM');


SELECT
	cnt.continent_name,
	ctr.country_name,
	COUNT(m.monastery_name) AS "monasteries_count"
FROM
	continents AS cnt
JOIN
	countries AS ctr
USING 
	(continent_code)
LEFT JOIN
	monasteries AS m
USING
	(country_code)
WHERE
	NOT ctr.three_rivers
GROUP BY
	ctr.country_name,
	cnt.continent_name
ORDER BY
	"monasteries_count" DESC,
	ctr.country_name;

-- 18 - Retrieving Information about Indexes
SELECT 
	tablename, indexname, indexdef 
FROM 
	pg_indexes
WHERE
	schemaname = 'public'
ORDER BY
	tablename,
	indexname;