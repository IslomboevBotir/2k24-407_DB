DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS enrollment;

CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birthdate DATE,
    enrollment_year INTEGER
);

CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE IF NOT EXISTS enrollment (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE,
    grade INTEGER
);

INSERT INTO students (first_name, last_name, birthdate, enrollment_year)
VALUES 
    ('Alice', 'Johnson', '2003-05-14', 2021),
    ('Bob', 'Smith', '2002-09-23', 2020),
    ('Charlie', 'Brown', '2001-12-02', 2019),
    ('Diana', 'Prince', '2003-03-08', 2021),
    ('Ethan', 'Hunt', '2004-07-16', 2022),
    ('Fiona', 'Gallagher', '2002-11-25', 2020),
    ('George', 'Miller', '2001-02-17', 2019),
    ('Hannah', 'Wells', '2003-08-05', 2021),
    ('Ian', 'Wright', '2004-04-12', 2022),
    ('Jenny', 'Lewis', '2002-10-30', 2020);

INSERT INTO courses (course_name, credit_hours)
VALUES 
    ('Mathematics', 3),
    ('History', 3),
    ('Physics', 4),
    ('Biology', 4),
    ('Chemistry', 4),
    ('Computer Science', 3),
    ('English Literature', 3),
    ('Economics', 3),
    ('Philosophy', 2),
    ('Art History', 3);

INSERT INTO enrollment (student_id, course_id, grade)
VALUES 
    (1, 1, 5),
    (1, 2, 4),
    (1, 3, 5),
    (2, 4, 3),
    (2, 5, 4),
    (2, 6, 5),
    (3, 7, 4),
    (3, 8, 5),
    (3, 9, 3),
    (4, 10, 5),
    (4, 1, 3),
    (4, 2, 4),
    (5, 3, 4),
    (5, 4, 3),
    (5, 5, 4),
    (6, 6, 3),
    (6, 7, 4),
    (6, 8, 5),
    (7, 9, 5),
    (7, 10, 3),
    (7, 1, 4),
    (8, 2, 5),
    (8, 3, 3),
    (8, 4, 3),
    (9, 5, 4),
    (9, 6, 4),
    (9, 7, 5),
    (10, 8, 4),
    (10, 9, 3),
    (10, 10, 4);

SELECT first_name, last_name, birthdate
FROM students;

SELECT s.first_name, s.last_name, s.birthdate, c.course_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';

SELECT s.first_name, s.last_name, AVG(e.grade) AS gpa
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING AVG(e.grade) < 4;

SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollment e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC;

SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC
LIMIT 1;

SELECT first_name, last_name
FROM students
ORDER BY last_name;

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.enrollment_year > 2015
  AND c.course_name = 'History';

WITH course_counts AS (
    SELECT student_id, COUNT(*) AS course_count
    FROM enrollment
    GROUP BY student_id
),
average_course_count AS (
    SELECT AVG(course_count) AS avg_courses_per_student
    FROM course_counts
)
SELECT s.first_name, s.last_name, cc.course_count
FROM students s
JOIN course_counts cc ON s.student_id = cc.student_id,
     average_course_count avg_cc
WHERE cc.course_count > avg_cc.avg_courses_per_student;

WITH average_grades AS (
    SELECT student_id, AVG(grade) AS avg_grade
    FROM enrollment
    GROUP BY student_id
),
lowest_avg_grade AS (
    SELECT MIN(avg_grade) AS min_avg_grade
    FROM average_grades
),
students_with_lowest_avg AS (
    SELECT student_id
    FROM average_grades
    WHERE avg_grade = (SELECT min_avg_grade FROM lowest_avg_grade)
)
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id IN (SELECT student_id FROM students_with_lowest_avg);

UPDATE enrollment
SET grade = 3
WHERE grade = 4;

DELETE FROM students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollment);

SELECT c.course_name AS "Course Name", ROUND(AVG(e.grade), 2) AS "Average Score"
FROM courses c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY c.course_name;

SELECT c.course_name AS "Course Name", ROUND(AVG(e.grade), 2) AS "Average Score"
FROM courses c
JOIN enrollment e ON c.course_id = e.course_id
WHERE e.grade IS NOT NULL
GROUP BY c.course_name
ORDER BY c.course_name;
