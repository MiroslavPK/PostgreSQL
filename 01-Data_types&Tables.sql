-- 0 - Create a DB
CREATE DATABASE minions_db;


-- 1 - Create a table
CREATE TABLE minions
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	age INT NOT NULL
);


-- 2 - Rename the table
ALTER TABLE minions RENAME TO minions_info;


-- 3 - Alter table Add new columns
ALTER TABLE minions_info
ADD COLUMN code CHAR(4),
ADD COLUMN task TEXT,
ADD COLUMN salary NUMERIC(8,3);


-- 4 - Rename column
ALTER TABLE minions_info
RENAME COLUMN salary TO banana;


-- 5 - Add new columns
ALTER TABLE minions_info
ADD COLUMN email VARCHAR(20),
ADD COLUMN equipped BOOL NOT NULL;


-- 6 - Create ENUM type
CREATE TYPE type_mood AS ENUM ('happy', 'relaxed', 'stressed', 'sad');
ALTER TABLE minions_info ADD COLUMN mood type_mood;


-- 7 - Set default values
ALTER TABLE minions_info
ALTER COLUMN age set default 0,
ALTER COLUMN name set default NOT NULL,
ALTER COLUMN code set default NOT NULL;


-- 8 - Add constraints
ALTER TABLE minions_info
ADD CONSTRAINT unique_constraint UNIQUE(id, email),
ADD CONSTRAINT banana_check check(banana > 0);


-- 9 Change column's data type
ALTER TABLE minions_info
ALTER COLUMN task TYPE VARCHAR(150);


-- 10 Drop constraint
ALTER TABLE minions_info
ALTER COLUMN equipped DROP NOT NULL;


-- 11 Drop column
ALTER TABLE minions_info
DROP COLUMN age;


-- 12 - Create new table
CREATE TABLE minions_birthdays
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	date_of_birth DATE NOT NULL,
	age INT,
	present VARCHAR(100),
	party timestamptz NOT NULL
);


-- 13 - Insert data
INSERT INTO minions_info
(name, code, task, banana, email, equipped, mood)
VALUES
('Mark','GKYA','Graphing Points',3265.265,'mark@minion.com',false,'happy'),
('Mel', 'HSK', 'Science Investigation', 54784.996, 'mel@minion.com', true, 'stressed'),
('Bob', 'HF', 'Painting', 35.652, 'bob@minion.com', true, 'happy'),
('Darwin', 'EHND', 'Create a Digital Greeting', 321.958, 'darwin@minion.com', false, 'relaxed'),
('Kevin', 'KMHD', 'Construct with Virtual Blocks', 35214.789, 'kevin@minion.com', false, 'happy'),
('Norbert', 'FEWB', 'Testing', 3265.500, 'norbert@minion.com', true, 'sad'),
('Donny', 'L', 'Make a Map', 8.452, 'donny@minion.com', true, 'happy');


-- 14 - Select info
SELECT name,task,email,banana FROM minions_info;


-- Truncate table i.e remove all data
TRUNCATE minions_info;


-- Drop table
DROP TABLE minions_birthdays;

-- 
DROP DATABASE minions_db;