CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credit_hours INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(student_id),
    course_id INTEGER NOT NULL REFERENCES courses(course_id),
    grade INTEGER
);
INSERT INTO courses (course_name, credit_hours)
VALUES
('Mathematics', 3),
('History', 4),
('Physics', 3),
('Chemistry', 3),
('Biology', 4),
('Computer Science', 3),
('English', 2),
('Economics', 3),
('Art', 2),
('Philosophy', 3);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
(1, 1, 5), (2, 1, 4), (3, 1, 3),
(1, 2, 4), (2, 2, 3), (4, 2, 5);

;
SELECT first_name, last_name, date_of_birth
FROM students;
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';

SELECT first_name, last_name
FROM students
WHERE gpa < 4;

SELECT first_name, last_name
FROM students
WHERE gpa < 4;

SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.course_id IS NULL;

SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

SELECT first_name, last_name
FROM students
ORDER BY last_name;

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'History' AND s.enrollment_date > '2015-01-01';

SELECT s.first_name, s.last_name
FROM students s
WHERE (
    SELECT COUNT(*)
    FROM enrollments e
    WHERE e.student_id = s.student_id
) > (
    SELECT AVG(course_count)
    FROM (
        SELECT COUNT(*) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) subquery
);

SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.grade = (SELECT MIN(grade) FROM enrollments);

UPDATE enrollments
SET grade = 3
WHERE grade = 4;

DELETE FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

INSERT INTO students (first_name, last_name, date_of_birth)
VALUES ('John', 'Doe', '2000-01-01');

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
((SELECT student_id FROM students WHERE first_name = 'John' AND last_name = 'Doe'), 1, 5),
((SELECT student_id FROM students WHERE first_name = 'John' AND last_name = 'Doe'), 2, 4);

SELECT c.course_name, AVG(e.grade) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;
