-- 1
CREATE TABLE studentt (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gpa DECIMAL(3, 2)
);


INSERT INTO studentt (first_name, last_name, date_of_birth, gpa)
VALUES 
('John', 'Doe', '2000-01-15', 3.5),
('Jane', 'Smith', '1999-03-22', 3.9),
('Alice', 'Johnson', '2001-07-10', 2.8),
('Bob', 'Brown', '2000-11-25', 3.2),
('Charlie', 'Davis', '1998-06-18', 3.6),
('Emily', 'Wilson', '2002-02-02', 3.7),
('David', 'Taylor', '2001-09-10', 3.1),
('Grace', 'Miller', '1999-12-01', 3.8),
('Henry', 'Moore', '2000-05-15', 3.4),
('Isabel', 'Anderson', '1998-08-20', 3.9);

select *from studentt;


--  2

 create table courses(
course_id serial primary key,
course_name varchar(100),
credit_hours INTEGER
);

INSERT INTO courses (course_name, credit_hours)
VALUES 
    ('Mathematics', 3),
    ('History', 4),
    ('Physics', 3),
    ('Computer Science', 3),
    ('Chemistry', 4),
    ('Biology', 3),
    ('English Literature', 2),
    ('Economics', 3),
    ('Psychology', 3),
    ('Sociology', 3);
select * from courses;

create table enrollments(
	enrollment_id serial primary key, 
	student_id int,
	foreign key (student_id) REFERENCES studentt(student_id),
	course_id int,
	foreign key (course_id) REFERENCES courses(course_id),
	grade int
	);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES (1, 1, 90),  -- Student 1, Mathematics, grade 90
       (1, 2, 85),  -- Student 1, History, grade 85
       (1, 3, 88),  -- Student 1, Physics, grade 88
       (1, 4, 91),  -- Student 1, Computer Science, grade 91
       (2, 1, 78),  -- Student 2, Mathematics, grade 78
       (2, 2, 84),  -- Student 2, History, grade 84
       (2, 5, 92),  -- Student 2, Chemistry, grade 92
       (2, 6, 76),  -- Student 2, Biology, grade 76
       (3, 3, 87),  -- Student 3, Physics, grade 87
       (3, 4, 93),  -- Student 3, Computer Science, grade 93
       (3, 5, 89),  -- Student 3, Chemistry, grade 89
       (3, 7, 80),  -- Student 3, English Literature, grade 80
       (4, 6, 72),  -- Student 4, Biology, grade 72
       (4, 8, 88),  -- Student 4, Economics, grade 88
       (4, 9, 85),  -- Student 4, Psychology, grade 85
       (5, 2, 90),  -- Student 5, History, grade 90
       (5, 3, 81),  -- Student 5, Physics, grade 81
       (5, 4, 92),  -- Student 5, Computer Science, grade 92
       (6, 1, 85),  -- Student 6, Mathematics, grade 85
       (6, 5, 80),  -- Student 6, Chemistry, grade 80
       (6, 6, 83),  -- Student 6, Biology, grade 83
       (7, 2, 95),  -- Student 7, History, grade 95
       (7, 7, 77),  -- Student 7, English Literature, grade 77
       (7, 8, 70),  -- Student 7, Economics, grade 70
       (8, 9, 91),  -- Student 8, Psychology, grade 91
       (8, 10, 84), -- Student 8, Sociology, grade 84
       (9, 1, 79),  -- Student 9, Mathematics, grade 79
       (9, 2, 80),  -- Student 9, History, grade 80
       (10, 3, 88); -- Student 10, Physics, grade 88

select *from enrollments;

--  3.1
select first_name,last_name,date_of_birth
from studentt;

select s.first_name,s.first_name,s.date_of_birth
from studentt s 
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where course_name = 'Mathematics';

SELECT first_name, last_name, date_of_birth, gpa
FROM studentt
WHERE gpa < 4;

-- 3.2
select studentt.first_name, studentt.last_name, courses.course_name
from studentt 
join enrollments  
on studentt.student_id = enrollments.student_id
join courses  
on courses.course_id = enrollments.course_id;


select studentt.first_name, studentt.last_name
from studentt 
left join enrollments 
ON studentt.student_id = enrollments.student_id
where enrollments.enrollment_id IS NULL;


SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY num_students DESC;


SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY num_students DESC
LIMIT 1;

SELECT s.*
FROM studentt  s
JOIN courses e ON s.student_id = c.course_id
WHERE s.date_of_birth > '2015-01-01'
AND c.course_name = 'History';

select s.first_name, s.last_name
from studentt s 
join enrollments e
on s.student_id = e.student_id
JOIN courses c
on e.course_id = c.course_id
where s.date_of_birth > 2015 and c.course_name = 'History';


WITH average_courses AS (
    SELECT AVG(course_count) AS avg_courses
    FROM (
        SELECT student_id, COUNT(course_id) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) AS course_counts
)
SELECT s.first_name, COUNT(e.course_id) AS total_courses
FROM studentt  s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > (SELECT avg_courses FROM average_courses);


WITH student_avg_grades AS (
    SELECT student_id, AVG(gpa) AS avg_grade
    FROM studentt
    GROUP BY student_id
),
lowest_avg_student AS (
    SELECT student_id
    FROM student_avg_grades
    ORDER BY avg_grade ASC
    LIMIT 1
)
SELECT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.student_id IN (SELECT student_id FROM lowest_avg_student);



SELECT c.course_name, AVG(e.grade) AS average_score
FROM studentt s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name;
