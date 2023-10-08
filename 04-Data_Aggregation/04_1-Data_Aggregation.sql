-- Start by executing 04_1-DB-Exercises-gringotts_db

-- 01 - Count of records
SELECT 
    COUNT(*) 
FROM 
    wizard_deposits;

-- 02 - Total deposit amount
SELECT 
	SUM(deposit_amount)
FROM
	wizard_deposits;


-- 03 - AVG Magic Wand Size
SELECT
	ROUND(AVG(magic_wand_size),3)
FROM
	wizard_deposits;


-- 04 Minimum deposit charge
SELECT
	MIN(deposit_charge)
FROM
	wizard_deposits;


-- 05 MAX age
SELECT
	MAX(age)
FROM
	wizard_deposits;


-- 06 Group by deposit interest
SELECT
	deposit_group,
	SUM(deposit_interest)
FROM
	wizard_deposits
GROUP BY
	deposit_group
ORDER BY
	SUM(deposit_interest) DESC;


-- 07 - Limit Magic Wand Creator
SELECT
	magic_wand_creator,
	MIN(magic_wand_size)
FROM
	wizard_deposits
GROUP BY
	magic_wand_creator
ORDER BY
	MIN(magic_wand_size)
LIMIT 5;


-- 08 Bank Profitability
SELECT
	deposit_group,
	is_deposit_expired,
	FLOOR(AVG(deposit_interest))
FROM
	wizard_deposits
WHERE
	deposit_start_date > '1985-01-01'
GROUP BY 
	deposit_group,
	is_deposit_expired
ORDER BY
	deposit_group DESC,
	is_deposit_expired;


-- 09 - Notes containing Dumbledore
SELECT
	last_name,
	COUNT(notes)
FROM
	wizard_deposits
WHERE
	notes LIKE '%Dumbledore%'
GROUP BY
	last_name;


-- 10 - Wizard view
CREATE VIEW
	view_wizard_deposits_with_expiration_date_before_1983_08_17
AS SELECT
	CONCAT(first_name, ' ', last_name) AS "Wizard Name",
	deposit_start_date AS "Start Date",
	deposit_expiration_date AS "Expiration Date",
	deposit_amount AS "Amount"
FROM
	wizard_deposits
WHERE
	deposit_expiration_date <= '1983-08-17'
GROUP BY
	"Wizard Name",
	deposit_start_date,
	deposit_expiration_date,
	deposit_amount
ORDER BY
	deposit_expiration_date;


-- 11 Filter max deposit
SELECT
	magic_wand_creator,
	MAX(deposit_amount) AS "max_deposit_amount"
FROM
	wizard_deposits
GROUP BY 
	magic_wand_creator
HAVING 
	NOT MAX(deposit_amount) BETWEEN 20000 AND 40000
ORDER BY
	MAX(deposit_amount) DESC
LIMIT 3;


-- 12 Age group
SELECT
	CASE 
		WHEN age <= 10 THEN '[0-10]'
		WHEN age BETWEEN 11 and 20 THEN '[11-20]'
		WHEN age BETWEEN 21 and 30 THEN '[21-30]'
		WHEN age BETWEEN 31 and 40 THEN '[31-40]'
		WHEN age BETWEEN 41 and 50 THEN '[41-50]'
		WHEN age BETWEEN 51 and 60 THEN '[51-60]'
		WHEN age >= 61 THEN '[61+]'
	END age_group,
	COUNT(*)
FROM
	wizard_deposits
GROUP BY 
	age_group
ORDER BY
	age_group;
