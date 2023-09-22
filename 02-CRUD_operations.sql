-- Start by executing all commands from 02-DB-Exercise-softuni-management_db.sql

-- 01 - Select all cities ordered by id
SELECT * FROM cities ORDER BY id;

-- 02 - Now concatenate city name and state and rename area to Area (km2)
SELECT 
    CONCAT(name, ' ', state) AS "Cities Information", area AS "Area (km2)" 
FROM 
    cities 
ORDER BY id;


-- 03 - Remove duplicate rows, sort by name in descending order
SELECT 
DISTINCT 
    name, area AS "Area (km2)" 
FROM 
    cities 
ORDER BY 
    name DESC;


-- 04 - Limit records
SELECT 
    id AS "ID", CONCAT(first_name, ' ', last_name) AS "Full Name", job_title AS "Job Title" 
FROM 
    employees 
ORDER BY 
    first_name 
LIMIT 50;


-- 05 - Skip rows
SELECT 
    id, CONCAT_WS(' ', first_name, middle_name, last_name) AS "Full Name", hire_date AS "Hire Date" 
FROM 
    employees 
ORDER BY 
    hire_date OFFSET 9;


-- 06 - Find the Address
SELECT 
    id, CONCAT(number,' ', street) AS "Address", city_id 
FROM 
    addresses 
WHERE 
    id >= 20;


-- 07 Positive even number
SELECT 
    CONCAT(number,' ', street) AS "Address", city_id 
FROM 
    addresses
WHERE 
    city_id % 2 = 0 AND city_id > 1
ORDER BY 
    city_id;


-- 08 - Projects within a date range
SELECT 
    name, start_date, end_date
FROM 
    projects 
WHERE 
    start_date >= '2016-06-01 07:00:00' AND end_date < '2023-06-04 00:00:00'
ORDER BY 
    start_date;

-- 09 Multiple conditions
SELECT 
    number, street 
FROM 
    addresses 
WHERE 
    id BETWEEN 50 AND 100 OR number < 1000;


-- 10 - Set of values
SELECT 
    employee_id, project_id 
FROM 
    employees_projects
WHERE 
    employee_id IN (200, 250) AND project_id NOT IN (50, 100);


-- 11 - Compare character values
SELECT 
    name, start_date 
FROM 
    projects
WHERE 
    name IN ('Mountain', 'Road', 'Touring')
LIMIT 20;


-- 12 - Salary
SELECT 
    CONCAT(first_name, ' ', last_name) as "Full Name",
    job_title, salary 
FROM 
    employees
WHERE 
    salary IN (12500, 14000, 23600, 25000)
ORDER BY 
    salary DESC;


-- 13 - Missing value
SELECT 
	id, first_name, last_name
FROM
	employees
WHERE
	middle_name IS NULL
LIMIT 3;


-- 14 - INSERT DEPARTMENTS
INSERT INTO 
	departments 
	(department, manager_id)
VALUES
	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109);


-- 15 - New table
SELECT 
	CONCAT(first_name, ' ', last_name) AS "Full Name",
	job_title AS "Job Title",
	department_id AS "Department ID",
	manager_id AS "Manager ID"
INTO 
    company_chart
FROM 
    employees;


-- 16 - Update project end date
UPDATE 
	projects
SET 
	end_date = start_date + INTERVAL '5 months'
WHERE
	end_date IS NULL;


-- 17 - Award employees with experience
UPDATE 
	employees
SET 
	salary = salary + 1500,
	job_title = CONCAT('Senior ', job_title) 
WHERE
	hire_date BETWEEN '01-01-1998' AND '01-05-2000';


-- 18 - Delete addresses
DELETE FROM 
	addresses
WHERE
	city_id IN (5, 17, 20, 30);


-- 19 Create a view
CREATE OR REPLACE VIEW 
	view_company_chart AS
SELECT 
	"Full Name",
	"Job Title"
FROM
	company_chart
WHERE
	"Manager ID" = 184;


-- 20 - Create a View with multiple tables
CREATE OR REPLACE VIEW 
	view_addresses AS
SELECT 
	CONCAT(em.first_name, ' ', em.last_name) AS "Full Name",
	em.department_id,
	CONCAT(number, ' ', ad.street) AS "Address"
FROM
	employees AS em
INNER JOIN
	addresses AS ad
ON 
	em.address_id = ad.id
ORDER BY 
	"Address";


-- 21 - ALter view name
ALTER VIEW
	view_addresses
RENAME TO 
	view_employee_addresses_info;


-- 22 - DROP view
DROP VIEW view_company_chart;


-- 23 - Make data in name column UPPER case
UPDATE
	projects
SET 
	"name" = UPPER("name");


-- 24 - Substring initial 2 chars from a name
CREATE OR REPLACE VIEW
	view_initials
AS
SELECT
	substring(first_name, 1, 2) AS initial,
	last_name
FROM 
	employees
ORDER BY
	last_name;


-- 25 name starts "Like" 
SELECT
	name, start_date
FROM
	projects
WHERE
	name LIKE 'MOUNT%'
ORDER BY
	id;