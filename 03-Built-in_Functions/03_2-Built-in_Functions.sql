-- Start by executing all commands from/importing 03-DB-Exercises-booking_db

-- 00 - CREATE DATABASE booking_db;

-- 18 - Arithmetical operators
CREATE TABLE
	bookings_calculation
AS
SELECT
	booked_for
FROM
	bookings
WHERE
	apartment_id=93;


ALTER TABLE
	bookings_calculation
ADD COLUMN
	multiplication NUMERIC,
ADD COLUMN
	modulo NUMERIC;


UPDATE
	bookings_calculation
SET
	multiplication = booked_for * 50,
	modulo = booked_for % 50;


-- 19 - Round vs Trunc
SELECT
	latitude,
	ROUND(latitude, 2),
	TRUNC(latitude, 2)
FROM
	apartments;


-- 20 - Absolute value
SELECT
	longitude,
	ABS(longitude)
FROM
	apartments;


-- 21 - Billing day
ALTER TABLE
	bookings
ADD COLUMN
	billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

SELECT 
	TO_CHAR(
			billing_day, 
			'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS'
	) AS "Billing Day" 
FROM 
	bookings;


-- 22 - EXTRACT Booked at
SELECT
	EXTRACT(YEAR FROM booked_at) AS "Year",
	EXTRACT(MONTH FROM booked_at) AS "Month",
	EXTRACT(DAY FROM booked_at) AS "Day",
	EXTRACT(HOUR FROM booked_at AT TIME ZONE 'UTC') AS "Hour",
	EXTRACT(MINUTE FROM booked_at) AS "Minute",
	CEIL(EXTRACT(SECOND FROM booked_at)) AS "Second"
FROM 
	bookings;


-- 23 - Early birds
SELECT
	user_id,
	AGE(starts_at, booked_at) AS "Early Birds"
FROM
	bookings
WHERE
	AGE(starts_at, booked_at) >= INTERVAL '10 months';


-- 24 - Match or not
SELECT
	companion_full_name,
	email
FROM 
	users
WHERE
	companion_full_name ILIKE '%aNd%'
AND
	NOT email LIKE '%@gmail';


-- 25 COUNT by initial
SELECT
	LEFT(first_name,2) AS "Initials",
	COUNT(LEFT(first_name,2)) AS "user_count" 
FROM
	users
GROUP BY 
	LEFT(first_name,2)
ORDER BY
	"user_count" DESC,
	"Initials";


-- 26 SUM
SELECT
	SUM(booked_for)
FROM
	bookings
WHERE
	apartment_id=90;


-- 27 Average
SELECT
	AVG(multiplication)
FROM
	bookings_calculation;
