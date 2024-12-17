1. Qo'shimcha jadvallar yaratish:

university=# create table courses(
university(# course_id serial primary key,
university(# course_name varchar(100),
university(# credit_hours int);
CREATE TABLE

university=# create table enrollements(
university(# enrollment_id serial primary key,
university(# student_id int,
university(# foreign key (student_id) references students(student_id),
university(# course_id int,
university(# foreign key (course_id) references courses(course_id),
university(# grade int);
CREATE TABLE


2. Ma'lumotlar bilan to'ldirish:

Jadval courses: 10 qator qo'shing (masalan, "Matematika", "Tarix", "Fizika" va boshqalar).

university=# INSERT INTO courses (course_name, credit_hours) VALUES
university-# ('Mathematics', 3),
university-# ('Physics', 4),
university-# ('Chemistry', 4),
university-# ('Biology', 3),
university-# ('History', 2),
university-# ('Computer Science', 3),
university-# ('English Literature', 3),
university-# ('Economics', 3),
university-# ('Philosophy', 2),
university-# ('Statistics', 4);
INSERT 0 10


Jadval enrollments: Talabalarni kurslarga bog'laydigan va baholar qo'yadigan 30 qator qo'shing.

university=# INSERT INTO enrollements (student_id, course_id, grade)
university-# VALUES
university-# (1, 1, 5), (1, 2, 4), (1, 3, 3),
university-# (2, 1, 4), (2, 4, 5), (2, 5, 4),
university-# (3, 2, 3), (3, 3, 4), (3, 6, 5),
university-# (4, 7, 3), (4, 1, 2), (4, 5, 4),
university-# (5, 6, 3), (5, 8, 5), (5, 9, 4),
university-# (6, 1, 5), (6, 2, 3), (6, 10, 4),
university-# (7, 3, 5), (7, 4, 2), (7, 6, 4),
university-# (8, 7, 3), (8, 8, 4), (8, 9, 2),
university-# (9, 1, 3), (9, 2, 4), (9, 5, 5),
university-# (10, 6, 3), (10, 7, 5), (10, 8, 4);
INSERT 0 30


3. Amaliy topshiriqlar:

3.1

Barcha talabalarni ismi, familiyasi va tug'ilgan sanasi bilan ko'rsating.

select first_name, last_name, birthdate from students;


Kursga yozilgan barcha talabalarni toping Mathematics.

university=# select s.first_name, s.last_name
university-# from students s
university-# join enrollements e on s.student_id = e.student_id
university-# join courses c on c.course_id = e.course_id
university-# where course_name = 'Mathematics';


GPA 4 dan past bo'lgan barcha talabalarni ko'rsating.

select s.first_name, s.last_name, e.grade from students s
join enrollements e on s.student_id = e.enrollment_id
where e.grade < 4;


3.2

Talabalar ro'yxatini ular ro'yxatdan o'tgan kurslarning nomlari bilan birga yozing.

select s.first_name, s.last_name, c.course_name from students s
join enrollements e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id;


Hech qanday kursga yozilmagan talabalarni toping.

SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollements e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

3.3

Har bir kursga yozilgan talabalar sonini hisoblang.

select c.course_name, count(*) as count_students from courses c
join enrollements e on c.course_id = e.course_id
group by c.course_name;


Eng ko'p talaba bo'lgan kursni toping.

select c.course_name from courses c
join enrollements e on c.course_id = e.course_id
group by c.course_name order by count(e.student_id) desc limit 1


3.4

Talabalarni familiyasi bo'yicha tartiblash.

select last_name from students
order by last_name;


2015 yildan keyin roʻyxatdan oʻtgan va kursga roʻyxatdan oʻtgan barcha talabalarni toping History.

SELECT s.first_name, s.last_name
FROM students s
JOIN enrollements e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'History' or s.birthdate > '2015-01-01';


3.5

Bir talabaga oʻrtacha kurslar sonidan koʻproq kurslarga yozilgan talabalarni toping.

SELECT s.first_name, s.last_name
FROM students s
WHERE (SELECT COUNT(e.course_id)
       FROM enrollements e
       WHERE e.student_id = s.student_id) >
      (SELECT AVG(course_count)
       FROM (SELECT COUNT(e.course_id) AS course_count
             FROM enrollements e
             GROUP BY e.student_id) subquery);


Eng past o'rtacha bahoga ega bo'lgan talabalar tomonidan yozilgan kurslar nomlarini sanab o'ting.

select c.course_name
from courses c
join enrollements e on c.course_id = e.course_id
join (
    select student_id, avg(grade) as avg_grade
    from enrollements
    group by student_id
    order by avg_grade ASC
    limit 1
) subquery on e.student_id = subquery.student_id;


3.6

Joriy bahosi 4 dan 3 gacha bo'lgan barcha talabalarning bahosini yangilang.

update enrollements
set grade = 3
where grade = 4;


Hech qanday kursga yozilmagan barcha talabalarni olib tashlang.

delete from students
where student_id not in (select DISTINCT student_id from enrollements);


Yangi talaba qo'shing va uni ikkita kursga yozing.

insert into students (name, age, birth_date, enrollement_year)
values ('Asadbek', 19, '2005-08-22', 2023);

insert into enrollements (student_id, course_id, grade)
values
    ((select student_id from students where name = 'Asadbek'), 1, 5),
    ((select student_id from students where name = 'Asadbek'), 2, 5);


4.

select c.course_name, avg(e.grade) as average_score
from courses c
join enrollements e on c.course_id = e.course_id
group by c.course_name;
