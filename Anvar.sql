CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credit_hours INTEGER
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade INTEGER
);

INSERT INTO
    courses (course_name, credit_hours)
VALUES
    ('Mathematics', 3),
    ('History', 4),
    ('Physics', 3),
    ('Chemistry', 4),
    ('Biology', 3),
    ('English', 2),
    ('Computer Science', 3),
    ('Philosophy', 2),
    ('Economics', 3),
    ('Psychology', 2);

INSERT INTO
    enrollments (student_id, course_id, grade)
VALUES
    (1, 1, 5),
    (1, 2, 4),
    (1, 3, 3),
    (2, 1, 4),
    (2, 4, 5),
    (2, 5, 4),
    (3, 2, 3),
    (3, 3, 4),
    (3, 6, 5),
    (4, 7, 3),
    (4, 1, 2),
    (4, 5, 4),
    (5, 6, 3),
    (5, 8, 5),
    (5, 9, 4),
    (6, 1, 5),
    (6, 2, 3),
    (6, 10, 4),
    (7, 3, 5),
    (7, 4, 2),
    (7, 6, 4),
    (8, 7, 3),
    (8, 8, 4),
    (8, 9, 2),
    (9, 1, 3),
    (9, 2, 4),
    (9, 5, 5),
    (10, 6, 3),
    (10, 7, 5),
    (10, 8, 4);




-- 3.1- Queries
SELECT
    first_name,
    last_name,
    birthdate
FROM
    student;

SELECT
    s.first_name,
    s.last_name
FROM
    student s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
WHERE
    c.course_name = 'Mathematics';

SELECT
    first_name,
    last_name
FROM
    student
    JOIN enrollments e ON student.student_id = e.student_id
WHERE
    e.grade < 4;



-- 3.2. Joining data (JOIN)
SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM
    student s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id;

SELECT
    s.first_name,
    s.last_name
FROM
    student s
    LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE
    e.enrollment_id IS NULL;



-- 3.3. Grouping and Aggregates
SELECT
    c.course_name,
    COUNT(e.student_id) AS student_count
FROM
    courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY
    c.course_name;

SELECT
    c.course_name
FROM
    courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY
    c.course_name
ORDER BY
    COUNT(e.student_id) DESC
LIMIT
    1;



-- 3.4. Filtering and Sorting
SELECT
    first_name,
    last_name
FROM
    student
ORDER BY
    last_name;

SELECT
    s.first_name,
    s.last_name
FROM
    student s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
WHERE
    c.course_name = 'History'
    AND s.birthdate > '2015-01-01';



-- 3.5. Working with Subqueries
SELECT
    s.first_name,
    s.last_name
FROM
    student s
WHERE
    (
        SELECT
            COUNT(e.course_id)
        FROM
            enrollments e
        WHERE
            e.student_id = s.student_id
    ) > (
        SELECT
            AVG(course_count)
        FROM
            (
                SELECT
                    COUNT(e.course_id) AS course_count
                FROM
                    enrollments e
                GROUP BY
                    e.student_id
            ) subq
    );

SELECT
    c.course_name
FROM
    courses c
    JOIN enrollments e ON c.course_id = e.course_id
    JOIN (
        SELECT
            student_id,
            AVG(grade) AS avg_grade
        FROM
            enrollments
        GROUP BY
            student_id
        ORDER BY
            avg_grade ASC
        LIMIT
            1
    ) subq ON e.student_id = subq.student_id;




-- 3.6. Modifying Data
UPDATE
    enrollments
SET
    grade = 3
WHERE
    grade = 4;

DELETE FROM
    student
WHERE
    student_id NOT IN (
        SELECT
            DISTINCT student_id
        FROM
            enrollments
    );

INSERT INTO
    student (first_name, last_name, birthdate)
VALUES
    ('John', 'Doe', '2003-05-15');

INSERT INTO
    enrollments (student_id, course_id, grade)
VALUES
    (
        (
            SELECT
                MAX(student_id)
            FROM
                students
        ),
        1,
        4
    ),
    (
        (
            SELECT
                MAX(student_id)
            FROM
                students
        ),
        2,
        5
    );



-- 4. Additional task (optional)
SELECT
    c.course_name,
    AVG(e.grade) AS average_score
FROM
    courses c
    JOIN enrollments e ON c.course_id = e.course_id
GROUP BY
    c.course_name;