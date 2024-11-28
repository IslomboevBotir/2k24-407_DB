--- Abdurahimov Abdurahmon


-- create database university;
create table students(
student_id serial primary key,
first_name varchar(50),
last_name varchar(50),
birthdate date,
enrollment_year int
);

insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (1,'Abdulloh','Sobirjonov','2000-10-10', 2016);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (2,'Jalol','Abdumajidov','2001-11-18', 2013);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (3,'Ismatilla','Kambarov','2003-09-14', 2018);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (4,'Asror','Sadullayev','1998-10-10', 2019);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (5,'Abdulbosit','Fazliddinov','2000-08-07', 2020);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (6,'Aziz','Sobitov','1997-03-02', 2023);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (7,'Behruz','Erkinov','2000-01-10', 2024);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (8,'Aleksandr','Yaxshiyev','2004-10-20', 2018);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (9,'Hasan','Abdullayev','2005-10-10', 2019);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (10,'Husan','Komilov','1998-05-05', 2018);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (11,'Daler','Lolayev','1996-12-19', 2015);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (12,'Qosim','Muhammadov','1998-09-02', 2014);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (13,'Ahmadjon','Ahmadov','1995-08-09', 2012);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (14,'Sherzod','Sobirjonov','1993-01-04', 2013);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (15,'Bekzod','Qalandarov','1998-03-04', 2014);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (16,'Abdulloh','Mutalov','2001-02-09', 2020);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (17,'Asad','Burhonov','2000-03-16', 2021);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (18,'Malik','Dadayev','2002-10-17', 2022);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (19,'Elnur','Riskulov','2001-03-11', 2023);
insert into students(student_id, first_name, last_name,birthdate, enrollment_year) values (20,'Aziz','Hojayev','2004-07-08', 2022);

create table courses(
course_id serial primary key,
course_name varchar(100),
credit_hours int
);


create table enrollments(
enrollment_id serial primary key,
student_id integer references students (student_id) on delete cascade,
course_id integer references courses (course_id) on delete cascade,
grade int
);

INSERT INTO courses (course_name, credit_hours) VALUES
('Physics', 4),
('World History', 3),
('Organic Chemistry', 4),
('Mathematics', 3),
('Modern Literature', 3),
('Software Engineering', 4),
('Abnormal Psychology', 3),
('History', 3),
('Ethics', 3),
('Art History', 3);

INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 3),
(2, 1, 4),
(3, 1, 5),
(4, 1, 3),
(5, 2, 3),
(6, 2, 3),
(7, 2, 4),
(8, 2, 5),
(9, 3, 5),
(10, 3, 4),
(1, 3, 4),
(2, 3, 4),
(3, 4, 3),
(4, 4, 4),
(5, 4, 3),
(6, 4, 4),
(7, 5, 3),
(8, 5, 3),
(9, 5, 3),
(10, 5, 4),
(1, 6, 5),
(2, 6, 5),
(3, 6, 4),
(4, 6, 3),
(5, 7, 4),
(6, 7, 3),
(7, 7, 4),
(8, 7, 5),
(9, 8, 5),
(10, 8, 5);



-- 3. Practical tasks
-- 3.1. Queries
-- Display all students with their first name, last name, and date of birth.
-- Find all students enrolled in the Mathematics course.
-- Display all students with a GPA lower than 4.

select first_name,last_name,birthdate from students;

select st.first_name,st.last_name ,cs.course_name
from students st
join enrollments enr
on st.student_id = enr.student_id
join courses cs
on enr.course_id = cs.course_id
where cs.course_name = 'Mathematics';

select st.first_name, st.last_name, avg(enr.grade) as gpa
from students st
join enrollments enr on st.student_id = enr.student_id
group by st.student_id,st.first_name,st.last_name
having avg(enr.grade) <4;

-- 3.2. Joining data (JOIN)
-- List students along with the names of the courses they are enrolled in.
-- Find students who are not enrolled in any courses.

select st.first_name, st.last_name, cs.course_name
from students st
join enrollments enr on st.student_id = enr.student_id
join courses cs on enr.course_id = cs.course_id
order by cs.course_name;

select st.student_id, st.first_name, st.last_name
from students st
left join enrollments enr 
on st.student_id = enr.student_id
where enr.student_id is NUll;


---

-- 3.3. Grouping and Aggregates
-- Count the number of students enrolled in each course.
-- Find the course with the most students.

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
---


-- 3.4. Filtering and Sorting
-- List students sorted by last name.
-- Find all students enrolled after 2015 and enrolled in the History course.

SELECT * 
FROM students
ORDER BY last_name;


SELECT students.*
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
JOIN courses ON enrollments.course_id = courses.course_id
WHERE students.enrollment_year > 2015 AND courses.course_name = 'History';


--- 3.5. Working with Subqueries
-- Find students enrolled in more courses than the average number of courses per student.
-- List the names of courses enrolled by students with the lowest average grade.

SELECT student_id, first_name, last_name
FROM students
WHERE student_id IN (
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
);


SELECT course_name
FROM courses
WHERE course_id IN (
    SELECT course_id
    FROM enrollments
    WHERE student_id IN (
        SELECT student_id
        FROM enrollments
        GROUP BY student_id
        ORDER BY AVG(grade)
        LIMIT 1
    )
);

-- 3.6. Modifying Data
-- Update the grade of all students with a current grade of 4 to 3.
-- Remove all students who are not enrolled in any courses.
-- Add a new student and enroll him in two courses.

UPDATE enrollments
SET grade = 3
WHERE grade = 4;


DELETE FROM students
WHERE student_id NOT IN (
    SELECT DISTINCT student_id
    FROM enrollments
);

INSERT INTO students (student_id, first_name, last_name, birthdate, enrollment_year) 
VALUES (21,'firstname', 'lastname', '2001-04-01', 2024);

INSERT INTO enrollments (student_id, course_id, grade) 
VALUES 
((SELECT student_id FROM students WHERE first_name = 'firstname' AND last_name = 'lastname'), 1, 4),
((SELECT student_id FROM students WHERE first_name = 'firstname' AND last_name = 'lastname'), 2, 4);

---
select * from courses;
select * from enrollments;
select * from students;
select first_name, enrollment_year from students where enrollment_year>2017;
select enrollment_year, count(*) from students group by enrollment_year;
