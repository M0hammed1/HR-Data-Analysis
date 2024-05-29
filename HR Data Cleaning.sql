-- Create a new database named projects
CREATE DATABASE projects;

-- Select the newly created projects database for use
USE projects;

-- Retrieve all records from the hr table
SELECT * FROM hr;

-- Change the column name from ï»¿id to emp_id with data type VARCHAR(20) and allow null values
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Display the structure of the hr table including data types and other properties
DESCRIBE hr;

-- Select the birthdate column from the hr table
SELECT birthdate FROM hr;

-- Disable safe updates mode to allow updates without specifying a key in the WHERE clause
SET sql_safe_updates = 0;

-- Update the birthdate in the hr table to a standard format (YYYY-MM-DD) based on its current format
UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT birthdate FROM hr;

-- Modify the birthdate column to DATE data type
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
DESCRIBE hr;

-- Update the hire_date in the hr table to a standard format (YYYY-MM-DD) based on its current format
UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
SELECT hire_date FROM hr;
-- Modify the hire_date column to DATE data type
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
DESCRIBE hr;

SELECT termdate FROM hr;

-- This query attempts to find and count all termdate values that do not match the regular expression (REG. EXP.) designed for the 'YYYY-MM-DD HH:MM:SS UTC' format.
SELECT termdate, COUNT(*)
FROM hr
WHERE termdate NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} UTC$'
AND termdate IS NOT NULL AND termdate != ''
GROUP BY termdate
ORDER BY COUNT(*) DESC;

-- Update the termdate in the hr table to a standard DATE format (YYYY-MM-DD), removing time and timezone information
UPDATE hr
SET termdate = CASE
    WHEN termdate IS NOT NULL AND termdate != '' AND termdate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} UTC$' THEN
        date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE termdate
END
WHERE termdate IS NOT NULL AND termdate != '';
SELECT termdate FROM hr;

SELECT termdate, HEX(termdate)
FROM hr
WHERE termdate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' = 0
AND termdate IS NOT NULL;

ALTER TABLE hr ALTER COLUMN termdate DROP DEFAULT;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

UPDATE hr SET termdate = NULL WHERE termdate = '0000-00-00';

-- we can use this SET sql_mode = 'ALLOW_INVALID_DATES'; ou bien use this : UPDATE hr SET termdate = NULL WHERE termdate = '0000-00-00';

-- Modify the termdate column to DATE data type
ALTER TABLE hr
MODIFY COLUMN termdate DATE;
DESCRIBE hr;

-- Add a new column named age of type INT to the hr table
ALTER TABLE hr ADD COLUMN age INT;

-- Update the age column with the difference in years between the current date and birthdate
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

-- Select the youngest and oldest ages from the hr table
SELECT 
    min(age) AS youngest,
    max(age) AS oldest
FROM hr;

-- Count the number of records where age is less than 18
SELECT count(*) FROM hr WHERE age < 18;

-- Count the number of records where the termdate is in the future
SELECT COUNT(*) FROM hr WHERE termdate > CURDATE();

-- Count the number of records where the termdate is NULL but we can use is set to '0000-00-00' but use ( UPDATE hr SET termdate = NULL WHERE termdate = '0000-00-00';) line
SELECT COUNT(*)
FROM hr
WHERE termdate IS NULL;
SELECT termdate FROM hr;

-- Select the location column from the hr table
SELECT location FROM hr;
