-- Start by executing all commands from/importing 03-DB-Exercises-geography_db

-- 00 - CREATE DATABASE geography_db;

-- 01 - River info
CREATE OR REPLACE VIEW 
	view_river_info
AS
SELECT
	CONCAT_WS
	(
		' ', 
		'The river', 
		river_name, 
		'flows into the', 
		outflow, 
		'and is', 
		"length", 
		'kilometers long.'
	) 
AS
    "River Information"
FROM 
	rivers
ORDER BY
	river_name;


-- 02 - Concatenate geography data
CREATE OR REPLACE VIEW
	view_continents_countries_currencies_details
AS
SELECT
	CONCAT(TRIM(ctts.continent_name), ': ', ctts.continent_code) AS "Continent Details",
	CONCAT_WS(' - ', ctrs.country_name, ctrs.capital, ctrs.area_in_sq_km, 'km2') AS "Country Information",
	CONCAT(cur.description, ' (', cur.currency_code, ')') AS "Currencies"
FROM 
	continents AS ctts
JOIN 
	countries AS ctrs
ON
	ctts.continent_code = ctrs.continent_code
JOIN
	currencies AS cur
ON
	ctrs.currency_code = cur.currency_code
ORDER BY
	"Country Information",
	"Currencies";


-- 03 - Add column and set it to capital code (1st 2 letters)
ALTER TABLE
	countries
ADD COLUMN
	capital_code CHAR(2);
UPDATE
	countries
SET 
	capital_code = SUBSTRING(capital,1,2);


-- 04 - Remove first 5 characters from a string and extract substring
SELECT 
	SUBSTRING(description,5)
FROM 
	currencies;


-- 05 Substring river length with regex
SELECT 
	SUBSTRING("River Information" FROM '([0-9]{1,4})') AS "river_length"
FROM 
	view_river_info;


-- 06 - Replace 'a'/'A'
SELECT 
	REPLACE(mountain_range, 'a', '@') AS "replace_a",
	REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM
	mountains;


-- 07 - Translate
SELECT 
	capital, 
    TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM
	countries;


-- 08 - query without Leading spaces
SELECT 
    continent_name, 
    TRIM(LEADING continent_name) AS "trim" 
FROM 
    continents;


-- 09 - query without Trailing spaces
SELECT 
    continent_name, 
    TRIM(TRAILING continent_name) AS "trim" 
FROM 
    continents;


-- 10 - LTRIM & RTRIM
SELECT
	LTRIM(peak_name, 'M') AS "Left Trim",
	RTRIM(peak_name, 'm') AS "Right Trim"
FROM
	peaks;


-- 11 - Character length and bits
SELECT
	CONCAT(m.mountain_range, ' ', p.peak_name) AS "Mountain Information",
	LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "Characters Length",
	BIT_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS "Bits of a String"
FROM 
	mountains as m
JOIN
	peaks as p
ON
	m.id = p.mountain_id


-- 12 - Length of a number
SELECT
	population,
	LENGTH(population::text)
FROM
	countries;


-- 13 - Positive and Negative left
SELECT
	peak_name,
	LEFT(peak_name,4) AS "Positive Left",
	LEFT(peak_name,-4) AS "Negative Left"
FROM
	peaks;


-- 14 Positive and Negative right
SELECT
	peak_name,
	RIGHT(peak_name,4) AS "Positive Right",
	RIGHT(peak_name,-4) AS "Negative Right"
FROM
	peaks;


-- 15 - Update ISO code (where null)
UPDATE
	countries
SET
	iso_code = UPPER(LEFT(country_name,3))
WHERE 
	iso_code is NULL;


-- 16 - REVERSE country code
UPDATE
	countries
SET
	country_code = REVERSE(LOWER(country_code));


-- 17 - Elevation --->> Peak Name
SELECT
	CONCAT
	(
		elevation, 
		' ', 
		REPEAT('-',3), 
		'>> ', 
		peak_name
	) AS "Elevation --->> Peak Name"
FROM
	peaks
WHERE
	elevation >= 4884;