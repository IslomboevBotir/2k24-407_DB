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
