CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    birth_date DATE,
    age INT,
    enrollment_year INT);

CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER);


INSERT INTO students (name, age, birth_date)
VALUES
    ('Sardorbek', 22, '2002-01-01'),
    ('Alice', 20, '2003-05-10'),
    ('Bob', 22, '2001-12-12'),
    ('Charlie', 19, '2004-03-21'),
    ('Diana', 21, '2002-09-15'),
    ('Sobirjon', 19, '2003-07-23');


INSERT INTO courses (course_name, credit_hours)
VALUES
    ('Mathematics', 3),
    ('History', 3),
    ('Physics', 4),
    ('Art', 2),
    ('Science', 4),
    ('English', 3),
    ('Biology', 4),
    ('Chemistry', 4),
    ('Geography', 3),
    ('Computer Science', 3);


INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    (1, 1, 5),
	(1, 2, 4),
	(2, 3, 3),
	(2, 4, 5),
	(3, 5, 4),
    (4, 1, 3),
	(5, 2, 2),
	(3, 4, 5),
	(4, 5, 3),
	(1, 3, 4),
    (2, 5, 5),
	(5, 6, 3),
	(1, 7, 4),
	(2, 8, 5), 
	(3, 9, 2),
    (4, 10, 4),
	(5, 3, 5),
	(1, 4, 4),
	(2, 6, 5),
	(3, 7, 3),
    (4, 8, 2), 
	(5, 9, 4),
	(1, 10, 5),
	(2, 1, 4),
	(3, 2, 5),
    (4, 3, 3),
	(5, 4, 4),
	(1, 5, 3), 
	(2, 7, 2),
	(3, 8, 4);


SELECT 
    name, 
    age, 
    birth_date 
FROM students;


SELECT 
    s.name AS student_name, 
    c.course_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';


SELECT 
    s.name AS student_name, 
    AVG(e.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING AVG(e.grade) < 4;


SELECT 
    s.name AS student_name, 
    c.course_name 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.name;


SELECT 
    s.name AS student_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


SELECT 
    c.course_name, 
    COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;


SELECT 
    c.course_name, 
    COUNT(e.student_id) AS student_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC
LIMIT 1;


SELECT 
    name 
FROM students
ORDER BY name;


SELECT 
    s.name AS student_name, 
    s.enrollment_year
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.enrollment_year > 2015 AND c.course_name = 'History';


SELECT 
    s.name AS student_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > (
    SELECT AVG(course_count)
    FROM (
        SELECT COUNT(e.course_id) AS course_count
        FROM enrollments e
        GROUP BY e.student_id
    ) AS subquery
);


SELECT 
    c.course_name, 
    s.name AS student_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON s.student_id = e.student_id
WHERE e.student_id = (
    SELECT student_id
    FROM enrollments
    GROUP BY student_id
    ORDER BY AVG(grade) ASC
    LIMIT 1
);


UPDATE enrollments
SET grade = 3
WHERE grade = 4;


DELETE FROM students
WHERE student_id NOT IN (
    SELECT DISTINCT student_id 
    FROM enrollments
);


INSERT INTO students (name, age, birth_date, enrollment_year)
VALUES ('John Doe', 20, '2004-01-01', 2023);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES 
    ((SELECT student_id FROM students WHERE name = 'John Doe'), 1, 5),
    ((SELECT student_id FROM students WHERE name = 'John Doe'), 2, 4);
