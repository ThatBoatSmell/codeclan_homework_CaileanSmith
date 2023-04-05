-- Final SQL Lab/Homework

-- MVP
-- Q1: How many employee records are lacking both a grade and salary?

SELECT 
	count(*)
FROM employees
WHERE (grade IS NULL AND salary IS null)

/* Q2: Produce a table with the two following fields (columns):
		the department
		the employees full name (first and last name)
		Order your resulting table alphabetically by department, and then by last name */

SELECT 
	first_name,
	last_name,
	department
FROM employees
ORDER BY 
	department ASC NULLS LAST,
	last_name ASC;

-- Q3: Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.

SELECT *
FROM employees
WHERE last_name ~ '^[A]'
ORDER BY salary DESC NULLS LAST
LIMIT 10;

-- Q4: Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT 
	department,
	count(*) AS num_2003_starts	
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;

-- Q5: Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. 
--	   Order the table alphabetically by department, and then in ascending order of fte_hours.
SELECT
	department,
	fte_hours,
	count(*) AS num_employees_per_dep_fte
FROM employees
GROUP BY department,
		fte_hours
ORDER BY department ASC NULLS LAST;

-- Q6: Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status in the corporation pension scheme.

SELECT 
	pension_enrol,
	count(*) AS num_per_status
FROM employees
GROUP BY pension_enrol
ORDER BY pension_enrol NULLS LAST;

-- Q7: Obtain the details for the employee with the highest salary in the ‘Accounting’ department who is not enrolled in the pension scheme?

SELECT *
FROM employees
WHERE (pension_enrol IS NOT TRUE 
AND department = 'Accounting')
ORDER BY salary DESC NULLS LAST
LIMIT 1;

-- Q8: Get a table of country, number of employees in that country, and the average salary of employees in that country for any countries in which more than 30 employees are based. 
-- 	   Order the table by average salary descending.

SELECT
	country,
	count(*) AS num_employees_per_country,
	round(avg(salary)) AS avg_salary
FROM employees
GROUP BY country
HAVING count(*) > 30
ORDER BY avg_salary;

-- Q9: Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), 
-- 	   salary, and a new column effective_yearly_salary which should contain fte_hours multiplied by salary. 
--	   Return only rows where effective_yearly_salary is more than 30000.

SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours*salary) AS effective_yearly_salary
FROM employees
WHERE (fte_hours*salary) >= 30000
AND (fte_hours*salary) IS NOT NULL;

-- Q10: Find the details of all employees in either Data Team 1 or Data Team 2
SELECT *
FROM employees INNER JOIN teams 
ON employees.team_id = teams.id
WHERE teams.name = 'Data Team 1' 
OR teams.name = 'Data Team 2'
ORDER BY teams.name;

-- Q11: Find the first name and last name of all employees who lack a local_tax_code

SELECT 
	first_name,
	last_name,
	local_tax_code
FROM employees INNER JOIN pay_details
ON employees.id = pay_details.id
WHERE local_tax_code IS NULL; 

-- Q12: The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
--	    where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee.
SELECT
	first_name,
	last_name,
	(48 * 35 * CAST(charge_cost AS int) - salary) AS expected_profit
FROM employees INNER JOIN teams
ON employees.team_id = teams.id
ORDER BY expected_profit DESC NULLS LAST;

-- Q13: Find the first_name, last_name and salary of the lowest paid employee in Japan who works the least common full-time equivalent hours across the corporation.

SELECT
	first_name,
	last_name,
	salary, 
	country,
	fte_hours
FROM employees
WHERE country = 'Japan' 
AND 
(fte_hours = (SELECT
				mode() WITHIN GROUP 
				(ORDER BY fte_hours)
			  FROM employees))
LIMIT 1;

-- Q14: Obtain a table showing any departments in which there are two or more employees lacking a stored first name.
--      Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department.

SELECT
	department,
	count(*) AS num_first_name_null
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING count(*) >= 2

-- Q15: Return a table of those employee first_names shared by more than one employee, together with a count of the number of times each first_name occurs.
-- Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.

SELECT 
	first_name,
	count(*)
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
ORDER BY 
	count(*) DESC,
	first_name;

-- Q16: Find the proportion of employees in each department who are grade 1 - sum(grade/count(id)) cast to convert 

SELECT
	department,
	count(department),
	CAST(count(grade = 1)AS boolean) AS grade_1,
	CAST(count(grade = 0) AS boolean) AS not_grade_1
FROM employees
GROUP BY department

--

-- EXT
-- Q17 
