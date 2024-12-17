-- 1. Talabalar jadvali yaratish
CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    enrollment_year INTEGER
);

-- 2. Kurslar jadvali yaratish
CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

-- 3. Roʻyxatga olish jadvali yaratish
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

-- 4. Talabalar jadvaliga ma'lumot kiritish
INSERT INTO students (first_name, last_name, birthdate, enrollment_year)
VALUES 
('Ali', 'Karimov', '2003-05-14', 2021),
('Malika', 'Toshpulatova', '2002-09-23', 2020),
('Said', 'Rustamov', '2001-12-02', 2019),
('Dilnoza', 'Xasanova', '2003-03-08', 2021),
('Aziz', 'Abdullayev', '2004-07-16', 2022),
('Shahlo', 'Rahmonova', '2002-11-25', 2020),
('Otabek', 'Norboyev', '2001-02-17', 2019),
('Nodira', 'Qurbonova', '2003-08-05', 2021),
('Javohir', 'Ergashev', '2004-04-12', 2022),
('Nigora', 'Sobirova', '2002-10-30', 2020);

-- 5. Kurslar jadvaliga ma'lumot kiritish
INSERT INTO courses (course_name, credit_hours)
VALUES 
('Matematika', 3),
('Tarix', 3),
('Fizika', 4),
('Biologiya', 4),
('Kimyo', 4),
('Kompyuter Ilmiyoti', 3),
('Adabiyot', 3),
('Iqtisodiyot', 3),
('Falsafa', 2),
('San’at Tarixi', 3);

-- 6. Roʻyxatga olish jadvaliga ma'lumot kiritish
INSERT INTO enrollments (student_id, course_id, grade)
VALUES 
(1, 1, 5),
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

-- 7. Talabalarning ismi, familiyasi va tug‘ilgan sanasini olish
SELECT first_name, last_name, birthdate 
FROM students;

-- 8. Matematika kursiga yozilgan talabalarni topish
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Matematika';

-- 9. Bahosi 4 dan kichik bo‘lgan talabalarni topish
SELECT first_name, last_name
FROM students
JOIN enrollments e ON students.student_id = e.student_id
WHERE e.grade < 4;

-- 10. Talabalar va ularning yozilgan kurslarini ko‘rsatish
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 11. Hech qanday kursga yozilmagan talabalarni topish
SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- 12. Kurslar bo‘yicha yozilgan talabalar sonini sanash
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 13. Eng ko‘p talabaga ega bo‘lgan kursni aniqlash
SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY COUNT(e.student_id) DESC
LIMIT 1;

-- 14. Talabalarni familiyasi bo‘yicha saralash
SELECT first_name, last_name
FROM students
ORDER BY last_name;

-- 15. Tarix kursiga yozilgan va 2015-yildan keyin tug‘ilgan talabalarni topish
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Tarix' AND s.birthdate > '2015-01-01';

-- 16. O‘rtachadan ko‘proq kursga yozilgan talabalarni topish
SELECT s.first_name, s.last_name
FROM students s
WHERE (SELECT COUNT(e.course_id) 
       FROM enrollments e 
       WHERE e.student_id = s.student_id) > 
      (SELECT AVG(course_count) 
       FROM (SELECT COUNT(e.course_id) AS course_count 
             FROM enrollments e 
             GROUP BY e.student_id) subquery);

-- 17. Eng past o‘rtacha bahoga ega talabaning kurslarini topish
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

-- 18. Bahosi 4 bo‘lganlarni 3 ga o‘zgartirish
UPDATE enrollments
SET grade = 3
WHERE grade = 4;

-- 19. Kursga yozilmagan talabalarni o‘chirish
DELETE FROM students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);

-- 20. Kurslar bo‘yicha o‘rtacha bahoni hisoblash
SELECT c.course_name, AVG(e.grade) AS average_score
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;
