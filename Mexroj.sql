-- 1-
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credit_hours INTEGER NOT NULL
);


CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER CHECK (grade >= 0 AND grade <= 100)
);

-- 2-
INSERT INTO courses (course_name, credit_hours)
VALUES
    ('Mathematics', 3),
    ('History', 4),
    ('Physics', 3),
    ('Chemistry', 3),
    ('Biology', 3),
    ('Philosophy', 2),
    ('Computer Science', 3),
    ('Statistics', 3),
    ('Art', 2),
    ('Economics', 3);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    (1, 1, 85), (2, 1, 90), (3, 1, 75),
    (1, 2, 88), (4, 2, 95), (5, 2, 70),
    (6, 3, 60), (7, 3, 80), (8, 3, 85),
    (2, 4, 70), (9, 4, 75), (10, 4, 65),
    (1, 5, 95), (3, 5, 80), (5, 5, 85),
    (2, 6, 55), (6, 6, 60), (7, 6, 62),
    (8, 7, 88), (9, 7, 85), (10, 7, 89),
    (1, 8, 92), (3, 8, 87), (4, 8, 90),
    (5, 9, 76), (6, 9, 65), (7, 9, 85),
    (8, 10, 70), (9, 10, 88), (10, 10, 92);

-- 3.1-
SELECT first_name, last_name, date_of_birth FROM students;

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';


SELECT first_name, last_name
FROM students
WHERE gpa < 4;

-- 3.2-

SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;


SELECT first_name, last_name
FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

-- 3.3-

SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

-- 3.4-

SELECT first_name, last_name
FROM students
ORDER BY last_name;

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.enrollment_date > '2015-01-01' AND c.course_name = 'History';

-- 3.5-

SELECT s.first_name, s.last_name
FROM students s WHERE 
(SELECT COUNT(e.course_id)
FROM enrollments e
WHERE e.student_id = s.student_id) > (SELECT AVG(course_count)
FROM (SELECT COUNT(e.course_id) AS course_count 
FROM enrollments e GROUP BY e.student_id) AS subquery);


SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.student_id IN (
    SELECT student_id
    FROM enrollments
    GROUP BY student_id
    HAVING AVG(grade) = (
        SELECT MIN(avg_grade)
        FROM (
            SELECT AVG(grade) AS avg_grade
            FROM enrollments
            GROUP BY student_id
        ) AS subquery));

-- 3.5-

UPDATE enrollments
SET grade = 3
WHERE grade = 4;


DELETE FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);


INSERT INTO students (first_name, last_name, date_of_birth, enrollment_date, gpa)
VALUES ('John', 'Doe', '2000-05-15', '2025-01-01', 3.5);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    ((SELECT student_id FROM students WHERE first_name = 'John' AND last_name = 'Doe'), 1, 85),
    ((SELECT student_id FROM students WHERE first_name = 'John' AND last_name = 'Doe'), 2, 90);


-- 4-

SELECT c.course_name, AVG(e.grade) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY average_score DESC;


