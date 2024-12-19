CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE students(
    student_id serial primary key,
    first_name varchar,
	last_name varchar,
	birthdate date,
	envanment_year int);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
	grade INTEGER,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id)
    
);

INSERT INTO courses (course_name, credit_hours) VALUES
('Mathematics', 4),
('Physics', 3),
('Chemistry', 3),
('Biology', 4),
('Computer Science', 3),
('History', 2),
('Literature', 3),
('Art', 2),
('Economics', 3),
('Philosophy', 2);

INSERT INTO students (first_name, last_name, birthdate) 
VALUES 
    ('Ali', 'Karimov', '2000-01-15'),
    ('Madina', 'Tursunova', '2001-05-22'),
    ('Jasur', 'Rahimov', '1999-03-11'),
    ('Dilnoza', 'Nazarova', '2002-07-19'),
    ('Aziz', 'Usmonov', '1998-12-05'),
    ('Shahnoza', 'Aliyeva', '2000-09-30'),
    ('Sardor', 'Bekmurodov', '2003-02-14'),
    ('Mohira', 'Shukurova', '2001-11-28'),
    ('Elshodbek', 'Turayev', '2005-11-21'),
    ('Gulnoza', 'Hamidova', '2000-08-08');


INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 85), (2, 1, 78), (3, 1, 92),
(1, 2, 90), (2, 2, 88), (4, 2, 95),
(3, 3, 75), (4, 3, 80), (5, 3, 85),
(1, 4, 89), (2, 4, 82), (3, 4, 78),
(5, 5, 90), (6, 5, 88), (7, 5, 85),
(8, 6, 92), (9, 6, 94), (10, 6, 89),
(3, 7, 76), (5, 7, 85), (7, 7, 80),
(2, 8, 90), (4, 8, 78), (6, 8, 85),
(1, 9, 88), (3, 9, 83), (5, 9, 91),
(6, 10, 84), (7, 10, 89), (8, 10, 92);

SELECT first_name, last_name, birthdate FROM students;

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';

SELECT s.first_name, s.last_name, AVG(e.grade) AS gpa
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING AVG(e.grade) > 4;

SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN courses c ON s.student_id = c.course_id;

SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

SELECT c.course_name, count(e.student_id)
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

SELECT first_name, last_name
FROM students
ORDER BY last_name ;

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.enrollment_year > 2015 AND c.course_name = 'History';

select s.first_name, s.last_name
from students s
where (SELECT COUNT(e.course_id) 
FROM enrollments e 
WHERE e.student_id = s.student_id)
      > (SELECT AVG(course_count) 
	  FROM 
         (SELECT COUNT(e.course_id) AS course_count 
		 FROM enrollments e 
		 GROUP BY e.student_id) subquery);

SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.student_id = (SELECT s.student_id 
                      FROM students s 
                      JOIN enrollments e ON s.student_id = e.student_id
                      GROUP BY s.student_id
                      ORDER BY AVG(e.grade) ASC
                      LIMIT 1);


update enrollments 
set grade = 3
where grade = 4

DELETE FROM students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);


INSERT INTO students (first_name, last_name, birthdate, enrollment_year) 
VALUES ('Alex', 'Taylor', '2004-05-16', 2022);

INSERT INTO enrollments (student_id, course_id, grade) 
VALUES ((SELECT student_id FROM students WHERE first_name = 'Alex' AND last_name = 'Taylor'), 1, 90),
       ((SELECT student_id FROM students WHERE first_name = 'Alex' AND last_name = 'Taylor'), 2, 85);

SELECT c.course_name, AVG(e.grade) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY average_score DESC;



