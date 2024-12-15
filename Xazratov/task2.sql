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