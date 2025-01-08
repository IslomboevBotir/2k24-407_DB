CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    birth_date DATE,
    age INT,
    enrollment_year INT
);

create table if not exists courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE if not exists enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

INSERT INTO students (name, age, birth_date)
VALUES
('Mahliyo', 22, '2002-01-01'),
('Aziza', 20, '2003-05-10'),
('Gulnoza', 22, '2001-12-12'),
('Nozima', 19, '2004-03-21'),
('Diana', 21, '2002-09-15'),
('Rayyona', 19, '2003-07-23');

INSERT INTO courses (course_name, credit_hours)
VALUES
('English', 3),
('History', 3),
('Physics', 4),
('Art', 2),
('Science', 4),
('Mathematics', 3),
('Biology', 4),
('Chemistry', 4),
('Geography', 3),
('Computer Science', 3);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
(1, 1, 5),
(1, 2, 4),
(2, 3, 3),
(2, 4, 5),
(3, 5, 4),
(4, 1, 3),
(5, 2, 2),
(3, 4, 5),
(4, 5, 3),
(1, 3, 4),
(2, 5, 5),
(5, 6, 3),
(1, 7, 4),
(2, 8, 5),
(3, 9, 2),
(4, 10, 4),
(5, 3, 5),
(1, 4, 4),
(2, 6, 5),
(3, 7, 3),
(4, 8, 2),
(5, 9, 4),
(1, 10, 5),
(2, 1, 4),
(3, 2, 5),
(4, 3, 3),
(5, 4, 4),
(1, 5, 3),
(2, 7, 2),
(3, 8, 4);

-- -- 3.1. Queries
-- 1
SELECT name, age, birth_date
FROM students;

-- 2
select students.name, courses.course_name
from students
join enrollments on students.student_id = enrollments.student_id
join courses on enrollments.course_id = courses.course_id
where courses.course_name = 'Mathematics';

-- 3
select students.name, avg(enrollments.grade)
from enrollments
join courses on enrollments.course_id = courses.course_id
join students on enrollments.student_id = students.student_id
group by students.name
having avg(enrollments.grade) < 4;

-- -- 3.2. Joining data (JOIN)
-- 1
select students.name, courses.course_name
from enrollments
join students on enrollments.student_id = students.student_id
join courses on enrollments.course_id = courses.course_id
order by students.name;

-- 2
select students.name
from students
left join enrollments on students.student_id = enrollments.student_id
where enrollments.student_id is NULL;

-- -- 3.3. Grouping and Aggregates
-- 1
select courses.course_name, count(enrollments.student_id)
from courses
join enrollments on courses.course_id = enrollments.course_id
group by courses.course_name;

-- 2
select courses.course_name, count(enrollments.student_id)
from courses
join enrollments on courses.course_id = enrollments.course_id
group by courses.course_name
order by count(enrollments.student_id) desc
limit 1;

-- -- 3.4. Filtering and Sorting
-- 1
SELECT name
FROM students
ORDER BY name;

-- 2
select students.name, students.enrollment_year
from students
join enrollments on students.student_id = enrollments.student_id
join courses on enrollments.course_id = courses.course_id
where students.enrollment_year > 2015 and courses.course_name = 'History';

-- -- 3.5. Working with Subqueries
-- 1
select students.name
from students
join enrollments on students.student_id = enrollments.student_id
group by students.student_id
having count(enrollments.course_id) > (
	select avg(course_count)
	from (
		select count(enrollments.course_id) as course_count
		from enrollments
		group by enrollments.student_id
	)
);

-- 2
SELECT courses.course_name, enrollments.grade, students.name
FROM courses
JOIN enrollments ON courses.course_id = enrollments.course_id
JOIN students ON students.student_id = enrollments.student_id
WHERE enrollments.student_id = (
    SELECT student_id
    FROM enrollments
    GROUP BY student_id
    ORDER BY AVG(grade)
    LIMIT 1
);

-- -- 3.6. Modifying Data
-- 1
UPDATE enrollments
SET grade = 3
WHERE grade = 4;

-- 2
DELETE FROM students
WHERE student_id NOT IN (SELECT DISTINCT student_id FROM enrollments);

-- 3
INSERT INTO students (name, age, birth_date, enrollment_year)
VALUES ('Sardorbek', 20, '2004-01-01', 2011);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES 
    ((SELECT student_id FROM students WHERE name = 'Sardorbek'), 1, 5),
    ((SELECT student_id FROM students WHERE name = 'Sardorbek'), 2, 5);