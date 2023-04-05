-- SQL Day 2 Lab and Homework
--MVP
-- Q1(a). Find the first name, last name and team name of employees who are members of teams.
SELECT 
	teams.name,
	employees.first_name,
	employees.last_name
FROM teams INNER JOIN employees
ON teams.id = employees.team_id;

-- (b). Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.
SELECT 
	teams.name,
	employees.first_name,
	employees.last_name
FROM teams INNER JOIN employees
ON teams.id = employees.team_id
WHERE pension_enrol = TRUE;

-- (c). Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80.
SELECT 
	teams.name,
	employees.first_name,
	employees.last_name
FROM teams INNER JOIN employees
ON teams.id = employees.team_id
WHERE (SELECT(CAST(charge_cost AS INT))) > 80;

-- Q2 (a). Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.
SELECT
	employees.*,
	pay_details.local_account_no,
	pay_details.local_sort_code
FROM employees FULL JOIN pay_details
ON employees.id = pay_details.id;

-- (b). Amend your query above to also return the name of the team that each employee belongs to.
SELECT
	employees.*,
	pay_details.local_account_no,
	pay_details.local_sort_code,
	teams.name
FROM 
	(employees FULL JOIN pay_details
	ON employees.id = pay_details.id)
INNER JOIN teams ON employees.team_id = teams.id;

-- Q3 (a). Make a table, which has each employee id along with the team that employee belongs to.
SELECT
	employees.id,
	teams.name
FROM employees LEFT JOIN teams
ON employees.team_id = teams.id;

-- (b). Breakdown the number of employees in each of the teams.
SELECT
	teams.name,
	count(employees.id)
FROM employees LEFT JOIN teams
ON employees.team_id = teams.id
GROUP BY teams.name;

-- (c). Order the table above by so that the teams with the least employees come first.
SELECT
	teams.name,
	count(employees.id)
FROM employees LEFT JOIN teams
ON employees.team_id = teams.id
GROUP BY teams.name
ORDER BY count(employees.id);

-- Q4. (a). Create a table with the team id, team name and the count of the number of employees in each team.
SELECT
	teams.id,
	teams.name,
	count(employees.id)
FROM teams LEFT JOIN employees
ON teams.id = employees.team_id
GROUP BY teams.id
ORDER BY teams.id;

-- (b). The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. (SELECT(CAST(charge_cost AS INT)))
--    	Calculate the total_day_charge for each team.
SELECT
	teams.id,
	teams.name,
	count(employees.id),
	CAST(teams.charge_cost AS int)*count(employees.id) AS total_day_charge
FROM teams LEFT JOIN employees
ON teams.id = employees.team_id
GROUP BY teams.id
ORDER BY teams.id;

-- (c). How would you amend your query from above to show only those teams with a total_day_charge greater than 5000? 
SELECT
	teams.id,
	teams.name,
	count(employees.id),
	CAST(teams.charge_cost AS int)*count(employees.id) AS total_day_charge
FROM teams LEFT JOIN employees
ON teams.id = employees.team_id
GROUP BY teams.id
--HAVING total_day_charge > 5000

-- EXT
-- Q6 How many of the employees serve on one or more committees?
/*SELECT 
	count(employees.id),
	committees.name
FROM (employees_committees LEFT JOIN employees
ON employees_committees.employee_id = employees.id)
FULL JOIN committees ON committees.id = employees_committees.committee_id
GROUP BY committees.name;
HAVING DISTINCT(employees.id); */

SELECT 
	
	