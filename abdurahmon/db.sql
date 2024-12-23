CREATE TABLE if not exists students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gpa FLOAT
);


CREATE TABLE if not exists courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credit_hours INTEGER NOT NULL
);


CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade INTEGER,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


INSERT INTO students (first_name, last_name, date_of_birth, gpa) VALUES
('Ali', 'Valiyev', '2000-01-01', 3.5),
('Laylo', 'Karimova', '1999-05-15', 4.0),
('Aziz', 'Nurmuhammadov', '2001-07-22', 3.2),
('Oydin', 'Bekmurodova', '2000-03-18', 3.8),
('Kamol', 'Shodmonov', '1998-11-30', 2.9),
('Gulnoza', 'Xolmurodova', '1997-09-10', 3.7),
('Rustam', 'Abdullayev', '2000-06-25', 3.4),
('Shoxrux', 'Ismoilov', '2002-02-12', 2.8),
('Madina', 'Rahimova', '2001-04-04', 4.0),
('Dilshod', 'Olimov', '1999-08-29', 3.3),
('Sarvinoz', 'Rashidova', '2001-12-20', 3.9),
('Zafar', 'Yoqubov', '2000-10-17', 3.1),
('Nilufar', 'Eshonqulova', '1998-03-11', 3.6),
('Javohir', 'Haydarov', '2002-05-05', 2.7),
('Mansur', 'Toshmatov', '1999-12-01', 4.0),
('Nodira', 'Qo‘chqorova', '2000-07-14', 3.0),
('Shahzod', 'Mahmudov', '1997-11-05', 2.9),
('Ravshan', 'Nurmatov', '2001-01-15', 3.5),
('Dildora', 'Asqarova', '1999-10-30', 3.4),
('Umida', 'Oripova', '2002-09-20', 3.8);

INSERT INTO courses (course_name, credit_hours) VALUES
('Mathematics', 3),
('Physics', 4),
('History', 2),
('Biology', 3),
('Chemistry', 3),
('Computer Science', 4),
('Economics', 3),
('Psychology', 2),
('Philosophy', 2),
('Literature', 3);


INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 85), (1, 2, 90), (1, 3, 78),
(2, 1, 88), (2, 4, 92), (2, 5, 84),
(3, 6, 75), (3, 7, 80), (3, 2, 89),
(4, 8, 95), (4, 9, 85), (4, 10, 88),
(5, 1, 73), (5, 6, 82), (5, 7, 79),
(6, 8, 90), (6, 2, 87), (6, 3, 76),
(7, 4, 89), (7, 5, 91), (7, 9, 85),
(8, 1, 70), (8, 6, 72), (8, 10, 78),
(9, 3, 88), (9, 4, 93), (9, 5, 84),
(10, 7, 79), (10, 2, 81), (10, 8, 74);





-- 3.1. Barcha talabalarni ism, familiya va tug‘ilgan sanasi bilan chiqarish
SELECT first_name, last_name, date_of_birth FROM students;

-- 3.2. Matematika kursida o‘qiyotgan barcha talabalarni topish
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';

-- 3.3. Bahosi 4 dan past bo‘lgan talabalarni chiqarish
SELECT first_name, last_name, gpa
FROM students
WHERE gpa < 4;

-- 3.2.1. Talabalar va ular o‘qiyotgan kurslar nomini ro‘yxatda ko‘rsating
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 3.2.2. Hech qanday kursga yozilmagan talabalarni topish
SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- 3.3.1. Har bir kursga yozilgan talabalar sonini hisoblang
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 3.3.2. Eng ko‘p talaba yozilgan kursni toping
SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

-- 3.4.1. Talabalarni familiyasi bo‘yicha tartiblangan holda ro‘yxatda ko‘rsating
SELECT first_name, last_name
FROM students
ORDER BY last_name;

-- 3.4.2. 2015-yildan keyin ro‘yxatdan o‘tgan va Tarix kursida qatnashayotgan talabalarni toping
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.enrollment_date > '2015-01-01' AND c.course_name = 'History';

-- 3.5.1. Har bir talabadan o‘rtacha ko‘p kursga yozilgan talabalarni toping
SELECT s.first_name, s.last_name
FROM students s
WHERE (SELECT COUNT(e.course_id)
       FROM enrollments e
       WHERE e.student_id = s.student_id) >
      (SELECT AVG(course_count)
       FROM (SELECT COUNT(course_id) AS course_count
             FROM enrollments
             GROUP BY student_id) sub);

-- 3.5.2. Baholar o‘rtacha eng past bo‘lgan talabalar yozilgan kurslarni ro‘yxatda ko‘rsating
SELECT course_name
FROM courses c
WHERE c.course_id IN (
    SELECT e.course_id
    FROM enrollments e
    GROUP BY e.course_id
    HAVING AVG(e.grade) = (
        SELECT MIN(avg_grade)
        FROM (SELECT AVG(grade) AS avg_grade
              FROM enrollments
              GROUP BY course_id) sub));

-- 3.6.1. 4 bahosi bor talabalar bahosini 3 ga o‘zgartiring
UPDATE enrollments
SET grade = 3
WHERE grade = 4;

-- 3.6.2. Hech bir kursga yozilmagan barcha talabalarni o‘chiring
DELETE FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

-- 3.6.3. Yangi talaba qo‘shing va uni ikki kursga yozing
INSERT INTO students (first_name, last_name, date_of_birth)
VALUES ('New', 'Student', '2000-01-01');

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    ((SELECT student_id FROM students WHERE first_name = 'New' AND last_name = 'Student'), 1, 85),
    ((SELECT student_id FROM students WHERE first_name = 'New' AND last_name = 'Student'), 2, 90);