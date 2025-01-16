DROP TABLE IF EXISTS university;

CREATE TABLE university (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100)
);

create database university;
DROP TABLE IF EXISTS students;

create table students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    enrollment_year INTEGER
);
insert into students (first_name, last_name, birthdate, enrollment_year) values
('John', 'Doe', '2000-01-15', 2018),
('Jane', 'Smith', '1999-05-20', 2017),
('Mike', 'Brown', '2001-09-12', 2019),
('Emily', 'Davis', '2000-07-22', 2018),
('Chris', 'Wilson', '1998-11-02', 2016),
('Sarah', 'Taylor', '2002-03-18', 2020),
('David', 'Clark', '1997-06-25', 2015),
('Sophia', 'Lewis', '2001-08-14', 2019),
('Daniel', 'Walker', '1999-12-30', 2017),
('Olivia', 'Hall', '2000-04-10', 2018),
('James', 'Young', '2002-02-05', 2020),
('Isabella', 'King', '1998-10-19', 2016),
('Andrew', 'Scott', '2001-01-25', 2019),
('Emma', 'Green', '2000-03-12', 2018),
('Matthew', 'Adams', '1997-07-20', 2015),
('Ella', 'Nelson', '2002-06-15', 2020),
('Benjamin', 'Baker', '1999-09-09', 2017),
('Chloe', 'Carter', '2001-05-05', 2019),
('Alexander', 'Parker', '2000-08-23', 2018),
('Mia', 'Evans', '1998-12-14', 2016);

select * from students;

select * from students where enrollment_year > 2017;

select enrollment_year, count(*) as student_count
from students
group by enrollment_year
order by enrollment_year;