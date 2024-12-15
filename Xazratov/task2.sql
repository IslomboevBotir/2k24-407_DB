-- Jadvallarni o'chirish
drop table if exists students;
drop table if exists courses;
drop table if exists enrollment;

-- Students jadvalini yaratish
create table if not exists students
(
    student_id serial primary key,
    first_name varchar(100),
    last_name varchar(100),
    birthdate date,
    enrollment_year integer
);

-- Courses jadvalini yaratish
create table if not exists courses
(
    course_id    serial primary key,
    course_name  varchar(100),
    credit_hours integer
);

-- Enrollment jadvalini yaratish
create table if not exists enrollment
(
    enrollment_id serial primary key,
    student_id    integer references students (student_id) on delete cascade,
    course_id     integer references courses (course_id) on delete cascade,
    grade         integer
);

INSERT INTO students (first_name, last_name, birthdate, enrollment_year)
VALUES ('Ali', 'Karimov', '2003-05-14', 2021),
       ('Malika', 'Toshpulatova', '2002-09-23', 2020),
       ('Said', 'Rustamov', '2001-12-02', 2019),
       ('Dilnoza', 'Xasanova', '2003-03-08', 2021),
       ('Aziz', 'Abdullayev', '2004-07-16', 2022),
       ('Shahlo', 'Rahmonova', '2002-11-25', 2020),
       ('Otabek', 'Norboyev', '2001-02-17', 2019),
       ('Nodira', 'Qurbonova', '2003-08-05', 2021),
       ('Javohir', 'Ergashev', '2004-04-12', 2022),
       ('Nigora', 'Sobirova', '2002-10-30', 2020);


INSERT INTO courses (course_name, credit_hours)
VALUES ('Matematika', 3),
       ('Tarix', 3),
       ('Fizika', 4),
       ('Biologiya', 4),
       ('Kimyo', 4),
       ('Kompyuter Ilmiyoti', 3),
       ('Adabiyot', 3),
       ('Iqtisodiyot', 3),
       ('Falsafa', 2),
       ('San’at Tarixi', 3);


INSERT INTO enrollment (student_id, course_id, grade)
VALUES (1, 1, 5),
       (1, 2, 4),
       (2, 3, 4),
       (2, 4, 5),
       (3, 5, 3),
       (3, 6, 4),
       (4, 7, 5),
       (4, 8, 3),
       (5, 9, 4),
       (5, 10, 5),
       (6, 1, 4),
       (6, 2, 3),
       (7, 3, 5),
       (7, 4, 4),
       (8, 5, 4),
       (8, 6, 3),
       (9, 7, 4),
       (9, 8, 5),
       (10, 9, 3),
       (10, 10, 4);


--3
SELECT first_name AS "Ism",
       last_name AS "Familiya",
       birthdate AS "Tug'ilgan sana",
       enrollment_year AS "O'qishga kirgan yil"
FROM students;

SELECT s.first_name AS "Ism",
       s.last_name AS "Familiya"
FROM students s
         JOIN enrollment e ON s.student_id = e.student_id
         JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Matematika';

SELECT s.first_name AS "Ism",
       s.last_name AS "Familiya",
       AVG(e.grade) AS "O'rtacha baho"
FROM students s
         JOIN enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING AVG(e.grade) < 4;

SELECT s.first_name AS "Ism",
       s.last_name AS "Familiya",
       c.course_name AS "Kurs nomi"
FROM students s
         JOIN enrollment e ON s.student_id = e.student_id
         JOIN courses c ON e.course_id = c.course_id;


SELECT first_name AS "Ism",
       last_name AS "Familiya"
FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollment);


SELECT c.course_name AS "Kurs nomi",
       COUNT(e.student_id) AS "Talabalar soni"
FROM courses c
         LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY "Talabalar soni" DESC;

UPDATE enrollment
SET grade = 3
WHERE grade = 4;

DELETE FROM students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollment);


-- 4

SELECT c.course_name AS "Kurs nomi",
       ROUND(AVG(e.grade), 2) AS "O'rtacha baho"
FROM courses c
         LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY c.course_name;