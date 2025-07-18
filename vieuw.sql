-- View 1: Students along with their enrolled courses
CREATE OR REPLACE VIEW Student_Courses_View AS
SELECT 
    s.person_id AS student_id,
    s.name AS student_name,
    c.course_id,
    c.course_name,
    e.grade
FROM 
    Students s,
    Courses c,
    Enrollment e
WHERE 
    e.student_ref = REF(s)
    AND e.course_ref = REF(c)
ORDER BY 
    s.name, c.course_name;

-- View 2: Student's transcript with all grades
CREATE OR REPLACE VIEW Student_Transcript AS
SELECT 
    s.person_id AS student_id,
    s.name AS student_name,
    c.course_id,
    c.course_name,
    c.coefficient AS course_coefficient,
    e.grade AS course_grade,
    a.title AS assignment_title,
    sg.grade AS assignment_grade,
    sg.submission_date
FROM 
    Students s,
    Courses c,
    Enrollment e,
    Assignments a,
    Student_Grades sg
WHERE 
    e.student_ref = REF(s)
    AND e.course_ref = REF(c)
    AND a.course_ref = REF(c)
    AND sg.student_ref = REF(s)
    AND sg.assignment_ref = REF(a)
ORDER BY 
    s.name, c.course_name, a.title;
/
-- View 3: Weekly schedule for a student or professor
CREATE OR REPLACE VIEW Weekly_Schedule AS
SELECT 
    'Student' AS person_type,
    s.person_id,
    s.name,
    c.course_id,
    c.course_name,
    c.day_of_week,
    c.start_time,
    c.end_time,
    r.building,
    r.room_number
FROM 
    Students s,
    Courses c,
    Enrollment e,
    Classrooms r
WHERE 
    e.student_ref = REF(s)
    AND e.course_ref = REF(c)
    AND c.room_ref = REF(r)
UNION ALL
SELECT 
    'Professor' AS person_type,
    p.person_id,
    p.name,
    c.course_id,
    c.course_name,
    c.day_of_week,
    c.start_time,
    c.end_time,
    r.building,
    r.room_number
FROM 
    Professors p,
    Courses c,
    Classrooms r,
    TABLE(c.professors) prof_list
WHERE 
    prof_list.COLUMN_VALUE = REF(p)
    AND c.room_ref = REF(r)
ORDER BY 
    person_type, name, day_of_week, start_time;
/
-- View 4: Total number of students in each course
CREATE OR REPLACE VIEW Course_Enrollment_Count AS
SELECT 
    c.course_id,
    c.course_name,
    COUNT(e.student_ref) AS total_students
FROM 
    Courses c
    LEFT JOIN Enrollment e ON e.course_ref = REF(c)
GROUP BY 
    c.course_id, c.course_name
ORDER BY 
    total_students DESC;
/
-- View 5: Students who haven't submitted any assignments
CREATE OR REPLACE VIEW Students_With_Missing_Submissions AS
SELECT DISTINCT
    s.person_id AS student_id,
    s.name AS student_name,
    c.course_id,
    c.course_name,
    a.assignment_id,
    a.title AS assignment_title,
    a.due_date
FROM 
    Students s,
    Courses c,
    Enrollment e,
    Assignments a
WHERE 
    e.student_ref = REF(s)
    AND e.course_ref = REF(c)
    AND a.course_ref = REF(c)
    AND NOT EXISTS (
        SELECT 1 
        FROM Student_Grades sg 
        WHERE sg.student_ref = REF(s) 
        AND sg.assignment_ref = REF(a)
    )
    AND a.due_date < SYSDATE
ORDER BY 
    s.name, c.course_name, a.due_date;
/
-- View 6: Student with the highest average
CREATE OR REPLACE VIEW Top_Student_Overall AS
WITH StudentAverages AS (
    SELECT 
        s.person_id,
        s.name,
        AVG(CASE 
            WHEN sg.grade = 'A+' THEN 97
            WHEN sg.grade = 'A' THEN 93
            WHEN sg.grade = 'A-' THEN 90
            WHEN sg.grade = 'B+' THEN 87
            WHEN sg.grade = 'B' THEN 83
            WHEN sg.grade = 'B-' THEN 80
            WHEN sg.grade = 'C+' THEN 77
            WHEN sg.grade = 'C' THEN 73
            WHEN sg.grade = 'C-' THEN 70
            WHEN sg.grade = 'D+' THEN 67
            WHEN sg.grade = 'D' THEN 63
            WHEN sg.grade = 'D-' THEN 60
            WHEN sg.grade = 'F' THEN 0
        END) AS avg_percentage
    FROM 
        Students s,
        Student_Grades sg,
        Assignments a
    WHERE 
        sg.student_ref = REF(s)
        AND sg.assignment_ref = REF(a)
    GROUP BY 
        s.person_id, s.name
)
SELECT 
    person_id AS student_id,
    name AS student_name,
    avg_percentage
FROM 
    StudentAverages
WHERE 
    avg_percentage = (SELECT MAX(avg_percentage) FROM StudentAverages);

/
-- View 7: Average grade for each course
CREATE OR REPLACE VIEW Course_Average_Grades AS
WITH CourseAssignmentScores AS (
    SELECT 
        c.course_id,
        c.course_name,
        s.person_id AS student_id,
        AVG(CASE 
            WHEN sg.grade = 'A+' THEN 97
            WHEN sg.grade = 'A' THEN 93
            WHEN sg.grade = 'A-' THEN 90
            WHEN sg.grade = 'B+' THEN 87
            WHEN sg.grade = 'B' THEN 83
            WHEN sg.grade = 'B-' THEN 80
            WHEN sg.grade = 'C+' THEN 77
            WHEN sg.grade = 'C' THEN 73
            WHEN sg.grade = 'C-' THEN 70
            WHEN sg.grade = 'D+' THEN 67
            WHEN sg.grade = 'D' THEN 63
            WHEN sg.grade = 'D-' THEN 60
            WHEN sg.grade = 'F' THEN 0
        END) AS student_avg_percentage
    FROM 
        Courses c,
        Students s,
        Enrollment e,
        Assignments a,
        Student_Grades sg
    WHERE 
        e.student_ref = REF(s)
        AND e.course_ref = REF(c)
        AND a.course_ref = REF(c)
        AND sg.student_ref = REF(s)
        AND sg.assignment_ref = REF(a)
    GROUP BY 
        c.course_id, c.course_name, s.person_id
)
SELECT 
    course_id,
    course_name,
    AVG(student_avg_percentage) AS course_avg_percentage,
    COUNT(student_id) AS students_count
FROM 
    CourseAssignmentScores
GROUP BY 
    course_id, course_name
ORDER BY 
    course_avg_percentage DESC;