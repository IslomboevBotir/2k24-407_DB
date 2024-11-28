CREATE TABLE IF NOT EXISTS student (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE
);

CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES student(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

INSERT INTO student (first_name, last_name, birthdate) VALUES
('John', 'Doe', '1990-05-15'),
('Jane', 'Smith', '1992-11-20'),
('Peter', 'Jones', '1991-03-10'),
('Mary', 'Brown', '1989-07-25'),
('David', 'Wilson', '1993-09-05'),
('Sarah', 'Davis', '1994-01-18'),
('Tom', 'Garcia', '1995-06-02'),
('Jessica', 'Rodriguez', '1996-12-12'),
('Kevin', 'Martinez', '1988-04-08'),
('Ashley', 'Anderson', '1997-08-28');


INSERT INTO courses (course_name, credit_hours) 
VALUES 
    ('Mathematics', 3), 
    ('History', 4), 
    ('Physics', 3), 
    ('Chemistry', 4), 
    ('Biology', 3), 
    ('English', 2), 
    ('Computer Science', 3), 
    ('Philosophy', 2), 
    ('Economics', 3), 
    ('Psychology', 2);

INSERT INTO enrollments (student_id, course_id, grade) 
VALUES 
    (1, 1, 5), (1, 2, 4), (1, 3, 3),
    (2, 1, 4), (2, 4, 5), (2, 5, 4),
    (3, 2, 3), (3, 3, 4), (3, 6, 5),
    (4, 7, 3), (4, 1, 2), (4, 5, 4),
    (5, 6, 3), (5, 8, 5), (5, 9, 4),
    (6, 1, 5), (6, 2, 3), (6, 10, 4),
    (7, 3, 5), (7, 4, 2), (7, 6, 4),
    (8, 7, 3), (8, 8, 4), (8, 9, 2),
    (9, 1, 3), (9, 2, 4), (9, 5, 5),
    (10, 6, 3), (10, 7, 5), (10, 8, 4);


SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

SELECT first_name, last_name
FROM student
ORDER BY last_name;

SELECT s.first_name, s.last_name
FROM student s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'History' AND s.birthdate > '2015-01-01';

SELECT s.first_name, s.last_name
FROM student s
WHERE (SELECT COUNT(e.course_id)
       FROM enrollments e
       WHERE e.student_id = s.student_id) >
      (SELECT AVG(course_count)
       FROM (SELECT COUNT(e.course_id) AS course_count
             FROM enrollments e
             GROUP BY e.student_id) subquery);

SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN (
    SELECT student_id, AVG(grade) AS avg_grade
    FROM enrollments
    GROUP BY student_id
    ORDER BY avg_grade ASC
    LIMIT 1
) subquery ON e.student_id = subquery.student_id;

UPDATE enrollments
SET grade = 3
WHERE grade = 4;

DELETE FROM student
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);

INSERT INTO student (first_name, last_name, birthdate)
VALUES ('John', 'Doe', '2003-05-15');

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    ((SELECT MAX(student_id) FROM student), 1, 4),
    ((SELECT MAX(student_id) FROM student), 2, 5);

SELECT c.course_name, AVG(e.grade) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;