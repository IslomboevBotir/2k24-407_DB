CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE IF NOT EXISTS students(
    student_id serial primary key,
    first_name varchar,
	last_name varchar,
	birthdate date,
	envanment_year int);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
	grade INTEGER,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id)
    
);

INSERT INTO courses (course_name, credit_hours) VALUES
('Mathematics', 3),
('Physics', 4),
('Chemistry', 3),
('Biology', 3),
('Computer Science', 4),
('English Literature', 3),
('History', 3),
('Psychology', 3),
('Sociology', 3),
('Philosophy', 3);


INSERT INTO students (first_name, last_name, birthdate, envanment_year) VALUES
('John', 'Doe', '2001-03-15', 2019),
('Jane', 'Smith', '2000-07-22', 2018),
('Michael', 'Johnson', '2001-02-10', 2019),
('Emily', 'Williams', '2002-04-01', 2020),
('Daniel', 'Brown', '2000-12-12', 2018),
('Olivia', 'Davis', '2001-05-14', 2019),
('James', 'Miller', '2001-08-23', 2019),
('Sophia', 'Wilson', '2002-01-11', 2020),
('Jackson', 'Moore', '2000-09-05', 2018),
('Ava', 'Taylor', '2001-06-19', 2019),
('Benjamin', 'Anderson', '2000-11-30', 2018),
('Isabella', 'Thomas', '2001-03-17', 2019),
('Lucas', 'Jackson', '2002-10-25', 2020),
('Mason', 'White', '2001-04-28', 2019),
('Liam', 'Harris', '2002-02-14', 2020),
('Mia', 'Martin', '2001-07-07', 2019),
('Ethan', 'Thompson', '2000-06-12', 2018),
('Charlotte', 'Garcia', '2002-09-21', 2020),
('Amelia', 'Martinez', '2001-11-03', 2019),
('Alexander', 'Rodriguez', '2002-05-16', 2020);

INSERT INTO enrollments (grade, student_id, course_id) VALUES
(85, 1, 1),
(90, 1, 2),
(80, 2, 3),
(75, 2, 4),
(88, 3, 5),
(92, 3, 6),
(70, 4, 7),
(95, 4, 8),
(78, 5, 9),
(82, 5, 10),
(85, 6, 1),
(76, 6, 2),
(90, 7, 3),
(84, 7, 4),
(92, 8, 5),
(88, 8, 6),
(73, 9, 7),
(79, 9, 8),
(81, 10, 9),
(83, 10, 10),
(87, 11, 1),
(93, 11, 2),
(80, 12, 3),
(86, 12, 4),
(89, 13, 5),
(94, 13, 6),
(77, 14, 7),
(78, 14, 8),
(90, 15, 9),
(85, 15, 10),
(84, 16, 1),
(82, 16, 2),
(91, 17, 3),
(79, 17, 4),
(92, 18, 5),
(88, 18, 6),
(80, 19, 7),
(86, 19, 8),
(93, 20, 9),
(81, 20, 10);

-- 3.1
	-- 3.1.1
SELECT first_name, last_name, birthdate
FROM students;
	-- 3.1.2
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';
	-- 3.1.3
SELECT s.first_name, s.last_name, e.grade
FROM students s
JOIN enrollments e on s.student_id = e.student_id
where grade < 80;
-- 3.2
	--3.2.1
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN students s ON s.student_id = e.student_id;
	-- 3.2.2
SELECT s.student_id, s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;
-- 3.3
	-- 3.3.1
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;
	--3.3.2
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count
LIMIT 1;
-- 3.4
	--3.4.1
SELECT last_name, first_name
FROM students
ORDER BY last_name ASC;
	-- 3.4.2
SELECT s.first_name, s.last_name, s.birthdate, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'History' 
AND s.birthdate > '2000-01-01';
-- 3.5
	--3.5.1
SELECT s.first_name, s.last_name 
FROM students s
WHERE (SELECT COUNT(e.course_id) 
       FROM enrollments e 
       WHERE e.student_id = s.student_id) > 
      (SELECT AVG(course_count) 
       FROM (SELECT COUNT(e.course_id) AS course_count 
             FROM enrollments e 
             GROUP BY e.student_id) subquery);
	--3.5.2
SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
WHERE s.student_id IN (
    SELECT e.student_id
    FROM enrollments e
    JOIN students s ON e.student_id = s.student_id
    GROUP BY e.student_id
    HAVING AVG(e.grade) = (
        SELECT MIN(average_grade)
        FROM (
            SELECT e.student_id, AVG(e.grade) AS average_grade
            FROM enrollments e
            GROUP BY e.student_id
        ) AS subquery
    )
);
-- 3.6
	--3.6.1
UPDATE enrollments
SET grade = 70
WHERE grade > 70
	--3.6.2
DELETE FROM enrollments
WHERE course_id is null
	--3.6.3
INSERT INTO enrollments (student_id, course_id, grade)
VALUES
	((SELECT MAX(student_id) from enrollments), 7 , 70),
	((SELECT MAX(student_id) from enrollments), 3 , 90)










































