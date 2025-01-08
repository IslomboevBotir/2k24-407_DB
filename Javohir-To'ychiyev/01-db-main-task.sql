create table if not exists students(
student_id serial primary key,
first_name varchar(50),
last_name varchar(50),
birthdate date,
enrollment_year int
);

CREATE TABLE if not exists enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);
INSERT INTO courses (course_name, credit_hours)
VALUES
('Tarix', 3),
('Falsafa', 2),
('Iqtisodiyot', 4),
('Astronomiya', 3),
('Sotsiologiya', 3),
('Psixologiya', 2),
('San’at', 3),
('Web Dasturlash', 5),
('Sun’iy Intellekt', 4),
('Blockchain', 3);
('Fizila',4)

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
(1, 6, 5), (2, 1, 4), (3, 1, 3),
(1, 2, 5), (4, 2, 4), (5, 2, 3),
(6, 3, 4), (7, 3, 5), (8, 3, 3),
(2, 4, 3), (9, 4, 4), (10, 4, 5),
(3, 5, 5), (1, 5, 4), (2, 5, 3),
(8, 6, 5), (6, 6, 4), (7, 6, 3),
(3, 7, 5), (9, 7, 4), (10, 7, 3),
(1, 8, 5), (4, 8, 4), (5, 8, 3),
(6, 9, 5), (2, 9, 4), (8, 9, 3),
(7, 10, 5), (10, 10, 4), (3, 10, 8);
-- 3.1.1
SELECT first_name, last_name, birthdate FROM students;
--3.1.2
SELECT s.first_name, s.last_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Tarix';
--3.1.3
SELECT s.first_name, s.last_name, AVG(e.grade) AS ortacha_bahosi 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id,s.first_name, s.last_name
HAVING AVG(e.grade) < 4;
--3.2.1
SELECT DISTINCT s.first_name, s.last_name, c.course_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;
--3.2.2
SELECT first_name, last_name FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);
--3.3.1
SELECT courses.course_name, COUNT(enrollments.student_id)FROM courses
LEFT JOIN enrollments ON courses.course_id = enrollments.course_id 
GROUP BY courses.course_name;
--3.3.2

SELECT course_name, COUNT(enrollments.student_id) AS num_students
FROM courses
JOIN enrollments ON courses.course_id = enrollments.course_id
GROUP BY course_name;

SELECT course_name, COUNT(enrollments.student_id) AS num_students
FROM courses
JOIN enrollments ON courses.course_id = enrollments.course_id
GROUP BY course_name
ORDER BY num_students DESC
LIMIT 1;


--3.4.2
SELECT students.first_name, students.last_name FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
JOIN courses ON enrollments.course_id = courses.course_id
WHERE students.enrollment_year > 2015-01-01 and courses.course_name = 'Tarix';
--3.5
-- Talabalarni topish uchun, ular qabul qilgan kurslar soni o'rtacha kurs sonidan yuqori bo'lganlar
SELECT s.student_id, s.first_name, s.last_name
FROM students s
JOIN (
    SELECT student_id
    FROM enrollments
    GROUP BY student_id
    HAVING COUNT(course_id) > (
        SELECT AVG(course_count)
        FROM (
            SELECT COUNT(course_id) AS course_count
            FROM enrollments
            GROUP BY student_id
        ) AS avg_courses
    )
) AS above_avg ON s.student_id = above_avg.student_id;


SELECT c.course_name
FROM courses c
WHERE c.course_id IN (
    SELECT e.course_id
    FROM enrollments e
    WHERE e.student_id = (
        SELECT student_id
        FROM enrollments
        GROUP BY student_id
        ORDER BY AVG(grade) DESC
        LIMIT 1
    )
);



--3.6.1
UPDATE enrollments
SET grade = 3
WHERE grade = 4;
--3.6.2
DELETE FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);
--3.6.3
INSERT INTO students (first_name, last_name, birthdate)
VALUES ('Javohir', 'Tuychiev', '2004-11-25');
INSERT INTO enrollments (student_id, course_id, grade)
VALUES (
    (SELECT student_id FROM students WHERE first_name = 'Vera' AND last_name = 'Negaeva'),
    1,
    5
);





select * from enrollments;




select * from students;








select * from courses;
