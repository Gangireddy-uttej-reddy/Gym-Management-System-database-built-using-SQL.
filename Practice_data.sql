create database gym_data;

use gym_data;

CREATE TABLE gym_members (
member_id INT PRIMARY KEY,
member_name VARCHAR(50) NOT NULL,
gender VARCHAR(10),
age INT,
city VARCHAR(50),
plan_type VARCHAR(20),
join_date DATE,
last_visit DATE,
workout_time TIME,
fee DECIMAL(10,2),
attendance_days INT DEFAULT 0,
trainer_name VARCHAR(50),
payment_status VARCHAR(20)
);

select * from gym_members;

ALTER TABLE gym_members
ADD CONSTRAINT chk_age 
CHECK (age >= 16);

ALTER TABLE gym_members
ADD CONSTRAINT chk_fee 
CHECK (fee > 0);

ALTER TABLE gym_members
ADD CONSTRAINT chk_payment 
CHECK (payment_status IN ('Paid','Pending'));

select * from gym_members;
-- ---------------------------------------------------------------
-- CONSTRAINS -- 
-- ------------------------
-- check age > 16 
INSERT INTO gym_members VALUES
(1002,'Test','Male',10,'Delhi','Monthly','2025-01-01','2025-01-10','06:00:00',2000,10,'Ravi','Paid');
-- error Check constraint failed (chk_age)

-- error Check constraint failed (chk_payment) in valid pay ment method
INSERT INTO gym_members VALUES
(1004,'Test','Female',25,'Mumbai','Monthly','2025-01-01','2025-01-10','06:00:00',2000,10,'Ravi','Done');

-- Duplicate Primary Key
INSERT INTO gym_members VALUES
(1,'Duplicate','Male',25,'Delhi','Monthly','2025-01-01','2025-01-10','06:00:00',2000,10,'Ravi','Paid');
-- error Duplicate entry '1' for key 'PRIMARY'

-- Null not allowed
INSERT INTO gym_members VALUES
(1005,NULL,'Male',25,'Delhi','Monthly','2025-01-01','2025-01-10','06:00:00',2000,10,'Ravi','Paid');
-- errror Column 'member_name' cannot be null

INSERT INTO gym_members (
member_id, member_name, gender, age, city, plan_type, join_date, last_visit, workout_time, fee, trainer_name, payment_status
)
VALUES
(2001,'DefaultTest','Male',25,'Hyderabad','Monthly','2025-01-01','2025-01-10','06:00:00',2000,'Ravi','Paid');

select * from gym_members;
-- Null 
INSERT INTO gym_members VALUES
(2003,'NullTest','Male',25,'Delhi','Monthly','2025-01-01','2025-01-10','06:00:00',2000,NULL,'Ravi','Paid');
-- we have given default value as 0 but when we enter the null i will except null value 

select * from gym_members;

ALTER TABLE gym_members
ADD CONSTRAINT unique_member_name UNIQUE (member_name);

-- CLAUSES -- 
-- ----------------------------------------------------------------------------
-- 1. WHERE Clause (Filter BASED ON CONDITION)

SELECT * FROM gym_members WHERE city = 'Mumbai';

SELECT * FROM gym_members
WHERE city = 'Hyderabad';

SELECT * FROM gym_members
WHERE fee > 5000;

SELECT * FROM gym_members
WHERE city = 'Delhi' AND plan_type = 'Monthly';
-- ----------------------------------------------------------
-- 2. ORDER BY (Sorting)

SELECT * FROM gym_members ORDER BY fee DESC LIMIT 5;
 
SELECT * FROM gym_members
ORDER BY fee DESC;

SELECT * FROM gym_members
ORDER BY age ASC;

SELECT * FROM gym_members
ORDER BY city ASC, fee DESC;
-- --------------------------------------------------
-- 3. GROUP BY 
-- 3. Count members per trainer
SELECT trainer_name, COUNT(*) 
FROM gym_members 
GROUP BY trainer_name;

SELECT city, COUNT(*) AS total_members
FROM gym_members
GROUP BY city;

SELECT city, SUM(fee)
FROM gym_members
GROUP BY city;
-- --------------------------------------
-- 4. HAVING (Filter groups)

-- 4. Cities with more than 50 members
SELECT city, COUNT(*) 
FROM gym_members 
GROUP BY city 
HAVING COUNT(*) > 50;

SELECT city, COUNT(*) AS total
FROM gym_members
GROUP BY city
HAVING total > 100;

SELECT trainer_name, COUNT(*) AS total
FROM gym_members
GROUP BY trainer_name
HAVING total > 50 AND total < 200;

-- 5. LIMIT (Top rows)
SELECT * FROM gym_members
LIMIT 10;

-- 6. DISTINCT (Remove duplicates)

SELECT DISTINCT city FROM gym_members;

SELECT DISTINCT plan_type FROM gym_members;
-- ------------------------------------------------
-- Like -- 

-- Starts With-- 
SELECT * FROM gym_members
WHERE member_name LIKE 'A%';
-- Ends With --
SELECT * FROM gym_members
WHERE city LIKE '%i';
-- Contains--
SELECT * FROM gym_members
WHERE member_name LIKE '%ra%';
-- Exact Length -- 
SELECT * FROM gym_members
WHERE member_name LIKE 'R____';
-- Single Character Match -- 
SELECT * FROM gym_members
WHERE member_name LIKE '_a%';
-- NOT LIKE -- 
SELECT * FROM gym_members
WHERE city NOT LIKE 'H%';
-- Combine with WHERE -- 
SELECT  * FROM gym_members
WHERE member_name LIKE 'A%' 
AND city = 'Hyderabad';
-- LIKE with ORDER BY -- 
SELECT * FROM gym_members
WHERE member_name LIKE '%a%'
ORDER BY fee DESC;

-- OPERATORS -- 

SELECT * FROM gym_members
where city ='Hyderbad';

SELECT * FROM gym_members
where city !='Delhi';

SELECT * FROM gym_members
WHERE fee > 5000;

SELECT * FROM gym_members
WHERE age >= 25 AND age <= 35;
-- ---------------------------------------
-- Logical Operators -- 
-- AND
SELECT * FROM gym_members
WHERE city = 'Hyderabad' AND fee > 3000;
-- OR
SELECT * FROM gym_members
WHERE city = 'Delhi' OR city = 'Mumbai';
-- NOT
SELECT * FROM gym_members
WHERE NOT payment_status = 'Paid';

-- BETWEEN

SELECT * FROM gym_members
WHERE fee BETWEEN 2000 AND 6000;

-- IN --
-- 2. Members from Hyderabad or Bangalore
SELECT * FROM gym_members
WHERE city IN ('Hyderabad','Bangalore');
-- ----------------------------------------------------
-- Window Functions--
-- 1. ROW_NUMBER() -- 
SELECT member_name, city,
ROW_NUMBER() OVER (PARTITION BY city ORDER BY fee DESC) AS rank_no
FROM gym_members;

-- RANK() -- 
SELECT member_name, fee,
RANK() OVER (ORDER BY fee DESC) AS rnk
FROM gym_members;
-- DENSE_RANK() -- 
SELECT member_name, fee,
DENSE_RANK() OVER (ORDER BY fee DESC) AS rnk
FROM gym_members;
-- SUM() -- 
SELECT member_name, fee,
SUM(fee) OVER (ORDER BY member_id) AS running_total
FROM gym_members;
-- AVG()--
SELECT member_name, city, fee,
AVG(fee) OVER (PARTITION BY city) AS avg_city_fee
FROM gym_members;
-- LAG() -- 
SELECT member_name, fee,
LAG(fee) OVER (ORDER BY member_id) AS prev_fee
FROM gym_members;
-- LEAD() -- 
SELECT member_name, fee,
LEAD(fee) OVER (ORDER BY member_id) AS next_fee
FROM gym_members;