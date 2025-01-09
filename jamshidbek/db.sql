create table if not exists courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);


create table if not exists enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);


insert into courses (course_name, credit_hours) values
 ('Mathematics 101', 3),
 ('Introduction to Programming', 4),
 ('Database Systems', 3),
 ('Web Development', 4),
 ('Machine Learning', 3),
 ('Data Structures and Algorithms', 2),
 ('Computer Networks', 3),
 ('Artificial Intelligence', 3),
 ('Software Engineering', 4),
 ('Computer Graphics', 2);


insert into enrollments (student_id, course_id, grade) values
    (4, 2, 4), (7, 5, 3), (1, 8, 5), (5, 1, 2), (10, 3, 4),
    (2, 7, 3), (15, 10, 4), (20, 6, 5), (13, 9, 2), (11, 4, 3),
    (14, 2, 4), (19, 5, 5), (17, 8, 3), (8, 10, 4), (16, 7, 5),
    (1, 1, 2), (2, 3, 3), (15, 6, 4), (10, 9, 2), (5, 4, 5),
    (4, 7, 3), (13, 10, 5), (8, 6, 2), (19, 9, 4), (14, 2, 5),
    (11, 8, 3), (17, 4, 2), (20, 1, 5), (7, 5, 4), (16, 3, 3);

select * from students;

select first_name, last_name, birth_date
from students;


select students.first_name as name, courses.course_name as course
from students
join enrollments 
on students.student_id = enrollments.student_id
join courses 
on courses.course_id = enrollments.course_id
where courses.course_name = 'Introduction to Programming';


select students.first_name, AVG(enrollments.grade) as GPA
from students
join enrollments 
on students.student_id = enrollments.student_id
group by students.first_name
having AVG(enrollments.grade) < 4;


select students.first_name, students.last_name, courses.course_name
from students 
join enrollments  
on students.student_id = enrollments.student_id
join courses  
on courses.course_id = enrollments.course_id;


select students.first_name, students.last_name
from students 
left join enrollments 
ON students.student_id = enrollments.student_id
where enrollments.enrollment_id IS NULL;


select courses.course_name, COUNT(enrollments.student_id) as student_count
from courses 
join enrollments  
on courses.course_id = enrollments.course_id
group by courses.course_name;


select courses.course_name, COUNT(enrollments.student_id) as student_count
from courses 
join enrollments 
on courses.course_id = enrollments.course_id
group by courses.course_name
order by student_count DESC
LIMIT 1;


select last_name, first_name
from students
order by last_name;

ALTER TABLE students ADD COLUMN enrollment_year INT;

select students.first_name, students.last_name
from students 
join enrollments 
on students.student_id = enrollments.student_id
JOIN courses 
on enrollments.course_id = courses.course_id
where students.enrollment_year > 2015 and courses.course_name = 'History';


select students.first_name, students.last_name
from students 
where 
    (select COUNT(enrollments.course_id) 
     from enrollments 
     where enrollments.student_id = students.student_id) > 
    (select AVG(course_count) 
     from (select COUNT(enrollments.course_id) as course_count 
           from enrollments  
           group by enrollments.student_id) subquery);


select courses.course_name
from courses 
join enrollments  
on courses.course_id = enrollments.course_id
join 
    (select student_id, AVG(grade) as avg_grade
     from enrollments
     group by student_id
     order by avg_grade ASC
     LIMIT 1) subquery 
	 on enrollments.student_id = subquery.student_id;


update enrollments
set grade = 3
where grade = 4;


delete from students
where student_id NOT IN (select distinct student_id
from enrollments);


insert into students (first_name, last_name, birth_date, enrollment_year) values 
('Iroda', 'Mahmudzoda', '2001-12-23', 2011);

insert into enrollments (student_id, course_id, grade) values 
((select MAX(student_id) 
from students), 2, 5);

insert into students (first_name, last_name, birth_date, enrollment_year) values 
('Alex', 'Dmetriy', '2003-02-03', 2009);

insert into enrollments (student_id, course_id, grade) values 
((select MAX(student_id) from students), 9, 4);


select courses.course_name, AVG(enrollments.grade) as average_score
from courses 
join enrollments 
on courses.course_id = enrollments.course_id
group by courses.course_name;
