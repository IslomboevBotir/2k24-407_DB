-- 1. Creating additional tables

-- Table: courses
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credit_hours INTEGER NOT NULL
);
-- Create students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    enrollment_date DATE NOT NULL,
    gpa NUMERIC(3, 2) CHECK (gpa BETWEEN 0 AND 4)
);

-- Insert sample data into students table
INSERT INTO students (first_name, last_name, date_of_birth, enrollment_date, gpa) VALUES
('Alice', 'Smith', '2001-05-14', '2018-09-01', 3.8),
('Bob', 'Johnson', '2000-07-22', '2017-09-01', 3.5),
('Charlie', 'Brown', '2002-03-18', '2019-09-01', 3.2),
('Diana', 'Miller', '2001-11-12', '2018-09-01', 3.9),
('Ethan', 'Williams', '2000-01-05', '2016-09-01', 3.0),
('Fiona', 'Davis', '2001-09-23', '2018-09-01', 3.6),
('George', 'Wilson', '2000-10-14', '2017-09-01', 2.9),
('Hannah', 'Taylor', '2002-12-01', '2019-09-01', 3.4),
('Ivan', 'Anderson', '2001-04-20', '2018-09-01', 3.1),
('Julia', 'Moore', '2000-06-17', '2017-09-01', 3.7);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER CHECK (grade BETWEEN 1 AND 5)
);

-- 2. Filling with data

-- Insert data into courses
INSERT INTO courses (course_name, credit_hours) VALUES
('Mathematics', 4),
('History', 3),
('Physics', 4),
('Chemistry', 4),
('Biology', 3),
('Computer Science', 5),
('Economics', 3),
('Philosophy', 3),
('Literature', 2),
('Art', 2);

-- Insert data into enrollments
-- Assuming students table already exists and contains at least 10 students
INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 5),
(2, 1, 4),
(3, 2, 3),
(4, 3, 5),
(5, 4, 2),
(6, 5, 4),
(7, 6, 3),
(8, 7, 5),
(9, 8, 4),
(10, 9, 3),
(1, 2, 4),
(2, 3, 3),
(3, 4, 2),
(4, 5, 5),
(5, 6, 3),
(6, 7, 4),
(7, 8, 2),
(8, 9, 5),
(9, 10, 4),
(10, 1, 3),
(1, 3, 5),
(2, 4, 2),
(3, 5, 4),
(4, 6, 3),
(5, 7, 5),
(6, 8, 2),
(7, 9, 4),
(8, 10, 5),
(9, 1, 3),
(10, 2, 2);

-- 3. Practical tasks

-- 3.1 Queries
-- Display all students with their first name, last name, and date of birth
SELECT first_name, last_name, date_of_birth FROM students;

-- Find all students enrolled in the Mathematics course
-- Find all students enrolled in the Mathematics course
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';


-- Display all students with a GPA lower than 4
SELECT first_name, last_name, gpa 
FROM students
WHERE gpa < 4;

-- 3.2 Joining data (JOIN)
-- List students along with the names of the courses they are enrolled in
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Find students who are not enrolled in any courses
SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- 3.3 Grouping and Aggregates
-- Count the number of students enrolled in each course
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Find the course with the most students
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC
LIMIT 1;

-- 3.4 Filtering and Sorting
-- List students sorted by last name
SELECT first_name, last_name
FROM students
ORDER BY last_name;

-- Find all students enrolled after 2015 and enrolled in the History course
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'History' AND s.enrollment_date > '2015-01-01';

-- 3.5 Working with Subqueries
-- Find students enrolled in more courses than the average number of courses per student
SELECT s.first_name, s.last_name
FROM students s
WHERE (SELECT COUNT(e.course_id) FROM enrollments e WHERE e.student_id = s.student_id) >
      (SELECT AVG(course_count) FROM (SELECT COUNT(e.course_id) AS course_count FROM enrollments e GROUP BY e.student_id) subquery);

-- List the names of courses enrolled by students with the lowest average grade
SELECT DISTINCT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.grade = (SELECT MIN(avg_grade) 
                 FROM (SELECT AVG(e.grade) AS avg_grade FROM enrollments e GROUP BY e.student_id) subquery);

-- 3.6 Modifying Data
-- Update the grade of all students with a current grade of 4 to 3
UPDATE enrollments
SET grade = 3
WHERE grade = 4;

-- Remove all students who are not enrolled in any courses
DELETE FROM students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);

-- Add a new student and enroll him in two courses
INSERT INTO students (first_name, last_name, date_of_birth, enrollment_date, gpa) VALUES
('New', 'Student', '2000-01-01', '2025-01-01', 3.5);

INSERT INTO enrollments (student_id, course_id, grade) VALUES
((SELECT student_id FROM students WHERE first_name = 'New' AND last_name = 'Student'), 1, 4),
((SELECT student_id FROM students WHERE first_name = 'New' AND last_name = 'Student'), 2, 5);

-- 4. Additional task (optional)
-- Calculate the average score of all students for each course
SELECT c.course_name, AVG(e.grade) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;



