-- 1 --
drop table if exists students;
drop table if exists courses;
drop table if exists enrollment;


create table if not exists students
(
    student_id      serial primary key,
    first_name      varchar(100),
    last_name       varchar(100),
    birthdate       date,
    enrollment_year integer
);

create table if not exists courses
(
    course_id    serial primary key,
    course_name  varchar(100),
    credit_hours integer
);

create table if not exists enrollment
(
    enrollment_id serial primary key,
    student_id    integer references students (student_id) on delete cascade,
    course_id     integer references courses (course_id) on delete cascade,
    grade         integer
);

-- 2 --
INSERT INTO students (first_name, last_name, birthdate, enrollment_year)
VALUES ('Alexander', 'Davis', '2000-01-15', 2019),
       ('Briana', 'Taylor', '1999-03-25', 2018),
       ('Caleb', 'Anderson', '1998-06-30', 2017),
       ('Danielle', 'Moore', '2001-08-14', 2020),
       ('Evan', 'Clark', '2002-11-12', 2021),
       ('Felicity', 'White', '1999-09-19', 2018),
       ('Gavin', 'Hall', '1998-02-04', 2017),
       ('Hailey', 'Thomas', '2001-07-20', 2020),
       ('Isaac', 'Lee', '2002-05-11', 2021),
       ('Jasmine', 'Harris', '1999-12-03', 2018);


INSERT INTO courses (course_name, credit_hours)
VALUES ('Linear Algebra', 3),
       ('Modern World History', 3),
       ('Astrophysics', 4),
       ('Genetics', 4),
       ('Biochemistry', 4),
       ('Data Science', 3),
       ('Creative Writing', 3),
       ('International Trade', 3),
       ('Logic and Critical Thinking', 2),
       ('Impressionist Art', 3);

INSERT INTO enrollment (student_id, course_id, grade)
VALUES (1, 1, 3),
       (1, 2, 5),
       (1, 3, 4),
       (2, 4, 5),
       (2, 5, 3),
       (2, 6, 4),
       (3, 7, 5),
       (3, 8, 3),
       (3, 9, 4),
       (4, 10, 5),
       (4, 1, 4),
       (4, 2, 3),
       (5, 3, 5),
       (5, 4, 4),
       (5, 5, 3),
       (6, 6, 5),
       (6, 7, 4),
       (6, 8, 3),
       (7, 9, 5),
       (7, 10, 4),
       (7, 1, 3),
       (8, 2, 4),
       (8, 3, 5),
       (8, 4, 3),
       (9, 5, 4),
       (9, 6, 3),
       (9, 7, 5),
       (10, 8, 4),
       (10, 9, 3),
       (10, 10, 5);

-- 3 --
-- 3.1 --
select students.first_name,
       students.last_name,
       students.birthdate
from students;
select s.first_name,
       s.last_name,
       s.birthdate,
       c.course_name
from students s
         join
     enrollment e on s.student_id = e.student_id
         join
     courses c ON e.course_id = c.course_id
where c.course_name = 'Mathematics';


select s.first_name,
       s.last_name,
       avg(e.grade) as gpa
from students s
         join
     enrollment e on s.student_id = e.student_id
group by s.student_id, s.first_name, s.last_name
having avg(e.grade) < 4;

-- 3.2 --

select s.first_name,
       s.last_name,
       c.course_name
from students s
         join
     enrollment e on s.student_id = e.student_id
         join
     courses c on e.course_id = c.course_id;


select s.first_name,
       s.last_name
from students s
         left join
     enrollment e on s.student_id = e.student_id
where e.student_id is null;

-- 3.3 --


select c.course_name,
       count(e.student_id) as student_count
from courses c
         left join
     enrollment e ON c.course_id = e.course_id
group by c.course_name
order by student_count desc;


select c.course_name,
       count(e.student_id) as student_count
from courses c
         left join
     enrollment e on c.course_id = e.course_id
group by c.course_name
order by student_count desc
limit 1;

-- 3.4 --

select first_name, last_name
from students
order by last_name;


select s.first_name, s.last_name
from students s
         join enrollment e on s.student_id = e.student_id
         join courses c on e.course_id = c.course_id
where s.enrollment_year > 2015
  and c.course_name = 'History';

-- 3.5 --

with course_counts as (select student_id,
                              COUNT(*) AS course_count
                       from enrollment
                       group by student_id),
     average_course_count as (select avg(course_count) as avg_courses_per_student
                              from course_counts)
select s.first_name,
       s.last_name,
       cc.course_count
from students s
         join course_counts cc on s.student_id = cc.student_id,
     average_course_count avg_cc
where cc.course_count > avg_cc.avg_courses_per_student;


with average_grades as (select student_id,
                               avg(grade) as avg_grade
                        from enrollment
                        group by student_id),
     lowest_avg_grade as (select min(avg_grade) as min_avg_grade
                          from average_grades),
     students_with_lowest_avg as (select student_id
                                  from average_grades
                                  where avg_grade = (select min_avg_grade from lowest_avg_grade))
select s.first_name,
       s.last_name,
       c.course_name
from students s
         join enrollment e on s.student_id = e.student_id
         join courses c on e.course_id = c.course_id
where s.student_id in (select student_id from students_with_lowest_avg);


-- 3.6 --
update enrollment
set grade = 3
where grade = 4;

delete
from students
where student_id not in (select distinct student_id
                         from enrollment);

-- 4 --
select c.course_name          as "Course Name",
       round(avg(e.grade), 2) as "Average Score"
from courses c
         left join enrollment e on c.course_id = e.course_id
group by c.course_name
order by c.course_name;


select c.course_name          as "Course Name",
       round(AVG(e.grade), 2) as "Average Score"
from courses c
         join enrollment e on c.course_id = e.course_id
where e.grade is not null
group by c.course_name
order by c.course_name;