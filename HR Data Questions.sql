-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) as employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) as employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age and genre distribution of employees in the company?

SELECT 
    min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate IS NULL;

SELECT
  CASE 
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+' 
END as age_group, gender, 
COUNT(*) as employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) as employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT round(AVG(DATEDIFF(termdate, hire_date))/365,0) as avg_length_employment
FROM hr
WHERE termdate <= CURDATE() AND age >= 18 AND termdate IS NOT NULL;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) as employee_count
FROM hr
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) as employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, 
	total_count, 
    terminated_count,
	terminated_count/total_count as termination_rate
FROM (
	SELECT department,
    count(*) as total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) as terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
    ) as subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) as employee_count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY employee_count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires-terminations)/hires*100, 2) AS net_change_percent
FROM(
	SELECT
	year(hire_date) AS year,
	count(*) AS hires,
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
	FROM hr
	WHERE age >= 18
	GROUP BY YEAR(hire_date)
	) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, round(avg (datediff(termdate, hire_date)/365), 0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18
GROUP BY department;
