USE chhavi;
CREATE TABLE placements (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    
    gender VARCHAR(10),
    ssc_percentage DECIMAL(5,2),
    ssc_board VARCHAR(20),
    
    hsc_percentage DECIMAL(5,2),
    hsc_board VARCHAR(20),
    hsc_stream VARCHAR(20),
    
    degree_percentage DECIMAL(5,2),
    degree_type VARCHAR(20),
    
    work_experience VARCHAR(5),   -- Yes / No
    
    employability_test DECIMAL(5,2),
    
    specialisation VARCHAR(20),   -- Mkt&Fin / Mkt&HR
    
    mba_percentage DECIMAL(5,2),
    
    status VARCHAR(10),            -- Placed / Not Placed
    salary INT                     -- NULL for not placed
);

LOAD DATA INFILE 'Placement_Data_Full_Class.csv'
INTO TABLE placements
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Total students
SELECT COUNT(*) AS total_students
FROM placements;

-- placed students
SELECT COUNT(*) AS placed_students
FROM placements
WHERE status = 'Placed';

-- placement rate
SELECT 
    ROUND(
        COUNT(CASE WHEN status = 'Placed' THEN 1 END) * 1.0 
        / COUNT(*),
        2
    ) AS placement_rate
FROM placements;


-- average salary (placed only)
SELECT 
    ROUND(AVG(salary), 0) AS avg_salary
FROM placements
WHERE status = 'Placed'
  AND salary > 0;


-- work experience (%)
SELECT 
    ROUND(
        COUNT(CASE WHEN work_experience = 'Yes' THEN 1 END) * 1.0
        / COUNT(*),
        2
    ) AS work_experience_pct
FROM placements;

-- placement distribution
SELECT 
    status,
    COUNT(*) AS student_count
FROM placements
GROUP BY status;

-- placed students by specialisation
SELECT 
    specialisation,
    COUNT(*) AS placed_students
FROM placements
WHERE status = 'Placed'
GROUP BY specialisation;

-- placement rate by specialisation
SELECT 
    specialisation,
    ROUND(
        COUNT(CASE WHEN status = 'Placed' THEN 1 END) * 1.0
        / COUNT(*),
        2
    ) AS placement_rate
FROM placements
GROUP BY specialisation;


-- avg salary by specialization
SELECT 
    specialisation,
    ROUND(AVG(salary), 0) AS avg_salary
FROM placements
WHERE status = 'Placed'
  AND salary > 0
GROUP BY specialisation;

-- impact of work exp on salary
SELECT 
    work_experience,
    ROUND(AVG(salary), 0) AS avg_salary
FROM placements
WHERE status = 'Placed'
  AND salary > 0
GROUP BY work_experience;


-- mba score vs salary
SELECT 
    student_id,
    mba_percentage,
    degree_percentage,
    salary
FROM placements
WHERE status = 'Placed'
  AND salary > 0;

-- placement rate vs degree
SELECT 
    FLOOR(degree_percentage / 10) * 10 AS degree_bin,
    ROUND(
        COUNT(CASE WHEN status = 'Placed' THEN 1 END) * 1.0
        / COUNT(*),
        2
    ) AS placement_rate
FROM placements
GROUP BY FLOOR(degree_percentage / 10) * 10
ORDER BY degree_bin;

-- placement rate by degree type
SELECT 
    degree_t,
    ROUND(
        COUNT(CASE WHEN status = 'Placed' THEN 1 END) * 1.0
        / COUNT(*),
        2
    ) AS placement_rate
FROM placements
GROUP BY degree_type;

-- placement rate by degree stream
SELECT 
    degree_type,
    ROUND(
        COUNT(CASE WHEN status = 'Placed' THEN 1 END) * 1.0
        / COUNT(*),
        2
    ) AS placement_rate
FROM placements
GROUP BY degree_type;

-- exceptions
Select student_id, degree_percentage, mba_percentage, work_experience, status
from placements
where degree_percentage < 60 and  mba_percentage < 60 and work_experience = 'No' and status = 'Placed'




