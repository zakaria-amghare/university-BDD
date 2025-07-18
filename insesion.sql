-- Insert data into Classrooms
INSERT INTO Classrooms VALUES (
  Classroom_t(101, 'Science Building', 'S101', 60, 1)
);

INSERT INTO Classrooms VALUES (
  Classroom_t(102, 'Science Building', 'S102', 40, 1)
);

INSERT INTO Classrooms VALUES (
  Classroom_t(201, 'Engineering Building', 'E201', 80, 1)
);

INSERT INTO Classrooms VALUES (
  Classroom_t(202, 'Arts Building', 'A202', 35, 0)
);

INSERT INTO Classrooms VALUES (
  Classroom_t(301, 'Library', 'L301', 25, 1)
);

-- Insert data into Departments
-- Note: We'll need to update head_prof_ref after inserting professors
INSERT INTO Departments VALUES (
  Department_t(10, 'Computer Science', NULL)
);

INSERT INTO Departments VALUES (
  Department_t(20, 'Mathematics', NULL)
);

INSERT INTO Departments VALUES (
  Department_t(30, 'Physics', NULL)
);

INSERT INTO Departments VALUES (
  Department_t(40, 'Literature', NULL)
);

-- Insert data into Professors
-- First without department reference (we'll update it later)
INSERT INTO Professors VALUES (
  Professor_t(1001, 'Dr. Alan Turing', 'turing@university.edu', '555-1001', NULL, 'Professor')
);

INSERT INTO Professors VALUES (
  Professor_t(1002, 'Dr. Ada Lovelace', 'lovelace@university.edu', '555-1002', NULL, 'Associate Professor')
);

INSERT INTO Professors VALUES (
  Professor_t(1003, 'Dr. Albert Einstein', 'einstein@university.edu', '555-1003', NULL, 'Professor')
);

INSERT INTO Professors VALUES (
  Professor_t(1004, 'Dr. Marie Curie', 'curie@university.edu', '555-1004', NULL, 'Professor')
);

INSERT INTO Professors VALUES (
  Professor_t(1005, 'Dr. Jane Austen', 'austen@university.edu', '555-1005', NULL, 'Assistant Professor')
);

-- Update professor department references
UPDATE Professors p
SET p.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 10)
WHERE p.person_id IN (1001, 1002);

UPDATE Professors p
SET p.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 20)
WHERE p.person_id = 1003;

UPDATE Professors p
SET p.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 30)
WHERE p.person_id = 1004;

UPDATE Professors p
SET p.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 40)
WHERE p.person_id = 1005;

-- Update department head references
UPDATE Departments d
SET d.head_prof_ref = (SELECT REF(p) FROM Professors p WHERE p.person_id = 1001)
WHERE d.dept_id = 10;

UPDATE Departments d
SET d.head_prof_ref = (SELECT REF(p) FROM Professors p WHERE p.person_id = 1003)
WHERE d.dept_id = 20;

UPDATE Departments d
SET d.head_prof_ref = (SELECT REF(p) FROM Professors p WHERE p.person_id = 1004)
WHERE d.dept_id = 30;

UPDATE Departments d
SET d.head_prof_ref = (SELECT REF(p) FROM Professors p WHERE p.person_id = 1005)
WHERE d.dept_id = 40;

-- Insert Students
INSERT INTO Students VALUES (
  Student_t(2001, 'John Smith', 'jsmith@university.edu', '555-2001', TO_DATE('1998-05-15', 'YYYY-MM-DD'), '123 College Ave', NULL)
);

INSERT INTO Students VALUES (
  Student_t(2002, 'Emily Johnson', 'ejohnson@university.edu', '555-2002', TO_DATE('1999-08-22', 'YYYY-MM-DD'), '456 University Blvd', NULL)
);

INSERT INTO Students VALUES (
  Student_t(2003, 'Michael Wang', 'mwang@university.edu', '555-2003', TO_DATE('1997-12-10', 'YYYY-MM-DD'), '789 Campus Dr', NULL)
);

INSERT INTO Students VALUES (
  Student_t(2004, 'Sophia Lee', 'slee@university.edu', '555-2004', TO_DATE('2000-02-28', 'YYYY-MM-DD'), '321 Student St', NULL)
);

INSERT INTO Students VALUES (
  Student_t(2005, 'James Wilson', 'jwilson@university.edu', '555-2005', TO_DATE('1998-11-03', 'YYYY-MM-DD'), '654 Scholar Rd', NULL)
);

INSERT INTO Students VALUES (
  Student_t(2006, 'Olivia Garcia', 'ogarcia@university.edu', '555-2006', TO_DATE('1999-04-17', 'YYYY-MM-DD'), '987 Academic Ct', NULL)
);

-- Update student department references
UPDATE Students s
SET s.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 10)
WHERE s.person_id IN (2001, 2004);

UPDATE Students s
SET s.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 20)
WHERE s.person_id IN (2002, 2005);

UPDATE Students s
SET s.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 30)
WHERE s.person_id = 2003;

UPDATE Students s
SET s.dept_ref = (SELECT REF(d) FROM Departments d WHERE d.dept_id = 40)
WHERE s.person_id = 2006;

-- Insert Courses
-- First create basic course records (we'll add nested tables later)
INSERT INTO Course_tab (course_id, course_name, coefficient, syllabus, dept_ref, room_ref, day_of_week, start_time, end_time)
VALUES (
  101, 
  'Introduction to Programming', 
  4, 
  'This course introduces fundamental programming concepts including data types, control structures, functions, and object-oriented programming.',
  (SELECT REF(d) FROM Departments d WHERE d.dept_id = 10),
  (SELECT REF(r) FROM Classrooms r WHERE r.classroom_id = 101),
  'Monday',
  '09:00',
  '11:00'
);

INSERT INTO Course_tab (course_id, course_name, coefficient, syllabus, dept_ref, room_ref, day_of_week, start_time, end_time)
VALUES (
  102, 
  'Data Structures', 
  5, 
  'This course covers the implementation and application of common data structures like arrays, linked lists, stacks, queues, trees, and graphs.',
  (SELECT REF(d) FROM Departments d WHERE d.dept_id = 10),
  (SELECT REF(r) FROM Classrooms r WHERE r.classroom_id = 101),
  'Wednesday',
  '13:00',
  '15:00'
);

INSERT INTO Course_tab (course_id, course_name, coefficient, syllabus, dept_ref, room_ref, day_of_week, start_time, end_time)
VALUES (
  201, 
  'Calculus I', 
  4, 
  'This course introduces differential and integral calculus of functions of one variable.',
  (SELECT REF(d) FROM Departments d WHERE d.dept_id = 20),
  (SELECT REF(r) FROM Classrooms r WHERE r.classroom_id = 201),
  'Tuesday',
  '10:00',
  '12:00'
);

INSERT INTO Course_tab (course_id, course_name, coefficient, syllabus, dept_ref, room_ref, day_of_week, start_time, end_time)
VALUES (
  301, 
  'Classical Physics', 
  4, 
  'This course covers Newtonian mechanics, oscillations, waves, and thermodynamics.',
  (SELECT REF(d) FROM Departments d WHERE d.dept_id = 30),
  (SELECT REF(r) FROM Classrooms r WHERE r.classroom_id = 202),
  'Thursday',
  '09:00',
  '11:00'
);

INSERT INTO Course_tab (course_id, course_name, coefficient, syllabus, dept_ref, room_ref, day_of_week, start_time, end_time)
VALUES (
  401, 
  'World Literature', 
  3, 
  'This course examines masterpieces of world literature from various cultures and historical periods.',
  (SELECT REF(d) FROM Departments d WHERE d.dept_id = 40),
  (SELECT REF(r) FROM Classrooms r WHERE r.classroom_id = 301),
  'Friday',
  '14:00',
  '16:00'
);

-- Add professors to courses
-- For course 101: Introduction to Programming
DECLARE
  prof_refs NT_PROFESSORS := NT_PROFESSORS();
BEGIN
  prof_refs.EXTEND(1);
  SELECT REF(p) INTO prof_refs(1) FROM Professors p WHERE p.person_id = 1001;
  
  UPDATE Course_tab c
  SET c.professors = prof_refs
  WHERE c.course_id = 101;
END;
/

-- For course 102: Data Structures
DECLARE
  prof_refs NT_PROFESSORS := NT_PROFESSORS();
BEGIN
  prof_refs.EXTEND(1);
  SELECT REF(p) INTO prof_refs(1) FROM Professors p WHERE p.person_id = 1002;
  
  UPDATE Course_tab c
  SET c.professors = prof_refs
  WHERE c.course_id = 102;
END;
/

-- For course 201: Calculus I
DECLARE
  prof_refs NT_PROFESSORS := NT_PROFESSORS();
BEGIN
  prof_refs.EXTEND(1);
  SELECT REF(p) INTO prof_refs(1) FROM Professors p WHERE p.person_id = 1003;
  
  UPDATE Course_tab c
  SET c.professors = prof_refs
  WHERE c.course_id = 201;
END;
/

-- For course 301: Classical Physics
DECLARE
  prof_refs NT_PROFESSORS := NT_PROFESSORS();
BEGIN
  prof_refs.EXTEND(1);
  SELECT REF(p) INTO prof_refs(1) FROM Professors p WHERE p.person_id = 1004;
  
  UPDATE Course_tab c
  SET c.professors = prof_refs
  WHERE c.course_id = 301;
END;
/

-- For course 401: World Literature
DECLARE
  prof_refs NT_PROFESSORS := NT_PROFESSORS();
BEGIN
  prof_refs.EXTEND(1);
  SELECT REF(p) INTO prof_refs(1) FROM Professors p WHERE p.person_id = 1005;
  
  UPDATE Course_tab c
  SET c.professors = prof_refs
  WHERE c.course_id = 401;
END;
/

-- Create students nested tables for courses
-- For course 101: Introduction to Programming
DECLARE
  student_refs NT_STUDENTS := NT_STUDENTS();
BEGIN
  student_refs.EXTEND(4);
  SELECT REF(s) INTO student_refs(1) FROM Students s WHERE s.person_id = 2001;
  SELECT REF(s) INTO student_refs(2) FROM Students s WHERE s.person_id = 2002;
  SELECT REF(s) INTO student_refs(3) FROM Students s WHERE s.person_id = 2003;
  SELECT REF(s) INTO student_refs(4) FROM Students s WHERE s.person_id = 2004;
  
  UPDATE Course_tab c
  SET c.students = student_refs
  WHERE c.course_id = 101;
END;
/

-- For course 102: Data Structures
DECLARE
  student_refs NT_STUDENTS := NT_STUDENTS();
BEGIN
  student_refs.EXTEND(3);
  SELECT REF(s) INTO student_refs(1) FROM Students s WHERE s.person_id = 2001;
  SELECT REF(s) INTO student_refs(2) FROM Students s WHERE s.person_id = 2004;
  SELECT REF(s) INTO student_refs(3) FROM Students s WHERE s.person_id = 2005;
  
  UPDATE Course_tab c
  SET c.students = student_refs
  WHERE c.course_id = 102;
END;
/

-- For course 201: Calculus I
DECLARE
  student_refs NT_STUDENTS := NT_STUDENTS();
BEGIN
  student_refs.EXTEND(4);
  SELECT REF(s) INTO student_refs(1) FROM Students s WHERE s.person_id = 2002;
  SELECT REF(s) INTO student_refs(2) FROM Students s WHERE s.person_id = 2003;
  SELECT REF(s) INTO student_refs(3) FROM Students s WHERE s.person_id = 2005;
  SELECT REF(s) INTO student_refs(4) FROM Students s WHERE s.person_id = 2006;
  
  UPDATE Course_tab c
  SET c.students = student_refs
  WHERE c.course_id = 201;
END;
/

-- For course 301: Classical Physics
DECLARE
  student_refs NT_STUDENTS := NT_STUDENTS();
BEGIN
  student_refs.EXTEND(2);
  SELECT REF(s) INTO student_refs(1) FROM Students s WHERE s.person_id = 2003;
  SELECT REF(s) INTO student_refs(2) FROM Students s WHERE s.person_id = 2005;
  
  UPDATE Course_tab c
  SET c.students = student_refs
  WHERE c.course_id = 301;
END;
/

-- For course 401: World Literature
DECLARE
  student_refs NT_STUDENTS := NT_STUDENTS();
BEGIN
  student_refs.EXTEND(3);
  SELECT REF(s) INTO student_refs(1) FROM Students s WHERE s.person_id = 2002;
  SELECT REF(s) INTO student_refs(2) FROM Students s WHERE s.person_id = 2004; 
  SELECT REF(s) INTO student_refs(3) FROM Students s WHERE s.person_id = 2006;
  
  UPDATE Course_tab c
  SET c.students = student_refs
  WHERE c.course_id = 401;
END;
/

-- Insert Enrollments
-- For Course 101: Intro to Programming
INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2001),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 101),
  'A',
  TO_DATE('2024-09-01', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 101),
  'B+',
  TO_DATE('2024-09-01', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2003),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 101),
  'A-',
  TO_DATE('2024-09-01', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2004),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 101),
  'B',
  TO_DATE('2024-09-01', 'YYYY-MM-DD')
);

-- For Course 102: Data Structures
INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2001),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 102),
  'A-',
  TO_DATE('2024-09-02', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2004),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 102),
  'B+',
  TO_DATE('2024-09-02', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 102),
  'A',
  TO_DATE('2024-09-02', 'YYYY-MM-DD')
);

-- Continue for remaining courses and students...
-- For Course 201: Calculus I
INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 201),
  'B',
  TO_DATE('2024-09-03', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2003),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 201),
  'C+',
  TO_DATE('2024-09-03', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 201),
  'A-',
  TO_DATE('2024-09-03', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2006),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 201),
  'B-',
  TO_DATE('2024-09-03', 'YYYY-MM-DD')
);

-- For Course 301: Classical Physics
INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2003),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 301),
  'B+',
  TO_DATE('2024-09-05', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 301),
  'A',
  TO_DATE('2024-09-05', 'YYYY-MM-DD')
);

-- For Course 401: World Literature
INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 401),
  'A',
  TO_DATE('2024-09-06', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2004),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 401),
  'A-',
  TO_DATE('2024-09-06', 'YYYY-MM-DD')
);

INSERT INTO Enrollment (student_ref, course_ref, grade, enrollment_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2006),
  (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 401),
  'B+',
  TO_DATE('2024-09-06', 'YYYY-MM-DD')
);

-- Insert Assignments
-- First insert into base Assignment table
-- For Course 101: Intro to Programming
INSERT INTO Assignments VALUES (
  Assignment_t(1001, 'Hello World Program', 'Write a program that prints "Hello, World!" to the console.', 
  TO_DATE('2024-09-15', 'YYYY-MM-DD'), 10.0, NULL)
);

INSERT INTO Assignments VALUES (
  Assignment_t(1002, 'Calculator App', 'Create a simple calculator application that can add, subtract, multiply, and divide.', 
  TO_DATE('2024-10-01', 'YYYY-MM-DD'), 20.0, NULL)
);

-- For Course 102: Data Structures
INSERT INTO Assignments VALUES (
  Assignment_t(2001, 'Linked List Implementation', 'Implement a singly linked list with basic operations: insert, delete, and search.', 
  TO_DATE('2024-09-20', 'YYYY-MM-DD'), 25.0, NULL)
);

INSERT INTO Assignments VALUES (
  Assignment_t(2002, 'Binary Search Tree', 'Implement a binary search tree with insert, delete, and traversal operations.', 
  TO_DATE('2024-10-10', 'YYYY-MM-DD'), 30.0, NULL)
);

-- For Course 201: Calculus I
INSERT INTO Assignments VALUES (
  Assignment_t(3001, 'Derivatives Practice', 'Complete the derivatives problems in chapter 3.', 
  TO_DATE('2024-09-25', 'YYYY-MM-DD'), 15.0, NULL)
);

INSERT INTO Assignments VALUES (
  Assignment_t(3002, 'Integration Homework', 'Solve the integration problems from chapter 5.', 
  TO_DATE('2024-10-15', 'YYYY-MM-DD'), 20.0, NULL)
);

-- For Course 301: Classical Physics
INSERT INTO Assignments VALUES (
  Assignment_t(4001, 'Newton\'s Laws Lab', 'Conduct the lab experiment and write a report on Newton\'s laws of motion.', 
  TO_DATE('2024-09-30', 'YYYY-MM-DD'), 30.0, NULL)
);

-- For Course 401: World Literature
INSERT INTO Assignments VALUES (
  Assignment_t(5001, 'Literary Analysis', 'Write a 5-page analysis of a major theme in one of the assigned readings.', 
  TO_DATE('2024-09-28', 'YYYY-MM-DD'), 25.0, NULL)
);

-- Now update the course reference for each assignment
UPDATE Assignments a
SET a.course_ref = (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 101)
WHERE a.assignment_id IN (1001, 1002);

UPDATE Assignments a
SET a.course_ref = (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 102)
WHERE a.assignment_id IN (2001, 2002);

UPDATE Assignments a
SET a.course_ref = (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 201)
WHERE a.assignment_id IN (3001, 3002);

UPDATE Assignments a
SET a.course_ref = (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 301)
WHERE a.assignment_id = 4001;

UPDATE Assignments a
SET a.course_ref = (SELECT REF(c) FROM Course_tab c WHERE c.course_id = 401)
WHERE a.assignment_id = 5001;

-- Add assignments to course nested tables
-- For course 101: Introduction to Programming
DECLARE
  assignment_list NT_ASSIGNMENTS;
BEGIN
  SELECT c.assignments INTO assignment_list FROM Course_tab c WHERE c.course_id = 101;
  
  IF assignment_list IS NULL THEN
    assignment_list := NT_ASSIGNMENTS();
  END IF;
  
  assignment_list.EXTEND(2);
  SELECT VALUE(a) INTO assignment_list(1) FROM Assignments a WHERE a.assignment_id = 1001;
  SELECT VALUE(a) INTO assignment_list(2) FROM Assignments a WHERE a.assignment_id = 1002;
  
  UPDATE Course_tab c
  SET c.assignments = assignment_list
  WHERE c.course_id = 101;
END;
/

-- For course 102: Data Structures
DECLARE
  assignment_list NT_ASSIGNMENTS;
BEGIN
  SELECT c.assignments INTO assignment_list FROM Course_tab c WHERE c.course_id = 102;
  
  IF assignment_list IS NULL THEN
    assignment_list := NT_ASSIGNMENTS();
  END IF;
  
  assignment_list.EXTEND(2);
  SELECT VALUE(a) INTO assignment_list(1) FROM Assignments a WHERE a.assignment_id = 2001;
  SELECT VALUE(a) INTO assignment_list(2) FROM Assignments a WHERE a.assignment_id = 2002;
  
  UPDATE Course_tab c
  SET c.assignments = assignment_list
  WHERE c.course_id = 102;
END;
/

-- Continue for remaining courses...
-- For course 201: Calculus I
DECLARE
  assignment_list NT_ASSIGNMENTS;
BEGIN
  SELECT c.assignments INTO assignment_list FROM Course_tab c WHERE c.course_id = 201;
  
  IF assignment_list IS NULL THEN
    assignment_list := NT_ASSIGNMENTS();
  END IF;
  
  assignment_list.EXTEND(2);
  SELECT VALUE(a) INTO assignment_list(1) FROM Assignments a WHERE a.assignment_id = 3001;
  SELECT VALUE(a) INTO assignment_list(2) FROM Assignments a WHERE a.assignment_id = 3002;
  
  UPDATE Course_tab c
  SET c.assignments = assignment_list
  WHERE c.course_id = 201;
END;
/

-- For course 301: Classical Physics
DECLARE
  assignment_list NT_ASSIGNMENTS;
BEGIN
  SELECT c.assignments INTO assignment_list FROM Course_tab c WHERE c.course_id = 301;
  
  IF assignment_list IS NULL THEN
    assignment_list := NT_ASSIGNMENTS();
  END IF;
  
  assignment_list.EXTEND(1);
  SELECT VALUE(a) INTO assignment_list(1) FROM Assignments a WHERE a.assignment_id = 4001;
  
  UPDATE Course_tab c
  SET c.assignments = assignment_list
  WHERE c.course_id = 301;
END;
/

-- For course 401: World Literature
DECLARE
  assignment_list NT_ASSIGNMENTS;
BEGIN
  SELECT c.assignments INTO assignment_list FROM Course_tab c WHERE c.course_id = 401;
  
  IF assignment_list IS NULL THEN
    assignment_list := NT_ASSIGNMENTS();
  END IF;
  
  assignment_list.EXTEND(1);
  SELECT VALUE(a) INTO assignment_list(1) FROM Assignments a WHERE a.assignment_id = 5001;
  
  UPDATE Course_tab c
  SET c.assignments = assignment_list
  WHERE c.course_id = 401;
END;
/

-- Insert Student_Grades
-- For Assignment 1001: Hello World Program
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2001),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 1001),
  10.0,
  TO_DATE('2024-09-14', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 1001),
  9.0,
  TO_DATE('2024-09-14', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2003),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 1001),
  9.5,
  TO_DATE('2024-09-15', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2004),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 1001),
  8.5,
  TO_DATE('2024-09-13', 'YYYY-MM-DD')
);

-- For Assignment 1002: Calculator App
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2001),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 1002),
  19.0,
  TO_DATE('2024-09-30', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 1002),
  17.5,
  TO_DATE('2024-09-29', 'YYYY-MM-DD')
);

-- Intentionally leave some assignments unsubmitted for testing the missing submissions view
-- No submission for student 2003 for assignment 1002
-- No submission for student 2004 for assignment 1002

-- For Assignment 2001: Linked List Implementation
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2001),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 2001),
  23.0,
  TO_DATE('2024-09-19', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2004),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 2001),
  22.0,
  TO_DATE('2024-09-18', 'YYYY-MM-DD')
);

-- Continuing Student_Grades insertions from where we left off

-- For student 2005 in Assignment 2001
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 2001),
  24.5,
  TO_DATE('2024-09-19', 'YYYY-MM-DD')
);

-- For Assignment 2002: Binary Search Tree
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2001),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 2002),
  28.0,
  TO_DATE('2024-10-09', 'YYYY-MM-DD')
);

-- No submission for student 2004 for assignment 2002 (another missing submission for testing)

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 2002),
  29.5,
  TO_DATE('2024-10-08', 'YYYY-MM-DD')
);

-- For Assignment 3001: Derivatives Practice
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3001),
  12.5,
  TO_DATE('2024-09-24', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2003),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3001),
  11.0,
  TO_DATE('2024-09-25', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3001),
  14.5,
  TO_DATE('2024-09-23', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2006),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3001),
  13.0,
  TO_DATE('2024-09-24', 'YYYY-MM-DD')
);

-- For Assignment 3002: Integration Homework
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3002),
  17.0,
  TO_DATE('2024-10-14', 'YYYY-MM-DD')
);

-- No submission for student 2003 for assignment 3002 (for testing missing submissions)

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3002),
  19.5,
  TO_DATE('2024-10-12', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2006),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 3002),
  16.5,
  TO_DATE('2024-10-15', 'YYYY-MM-DD')
);

-- For Assignment 4001: Newton's Laws Lab
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2003),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 4001),
  26.0,
  TO_DATE('2024-09-28', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2005),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 4001),
  29.0,
  TO_DATE('2024-09-29', 'YYYY-MM-DD')
);

-- For Assignment 5001: Literary Analysis
INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2002),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 5001),
  24.0,
  TO_DATE('2024-09-27', 'YYYY-MM-DD')
);

INSERT INTO Student_Grades (student_ref, assignment_ref, grade, submission_date)
VALUES (
  (SELECT REF(s) FROM Students s WHERE s.person_id = 2004),
  (SELECT REF(a) FROM Assignments a WHERE a.assignment_id = 5001),
  23.5,
  TO_DATE('2024-09-26', 'YYYY-MM-DD')
);

-- No submission for student 2006 for assignment 5001 (for testing missing submissions)

-- Update system date to make some assignments appear as overdue for testing
-- Note: This is for demonstration purposes. In a production environment, 
-- you would typically test with real dates instead of manipulating SYSDATE.
-- The following command would require DBA privileges and should be used carefully:
-- ALTER SYSTEM SET fixed_date = '2024-10-20';

-- Commit all changes
COMMIT;

-- Test query to verify data has been properly loaded
SELECT 'Departments' as table_name, COUNT(*) as row_count FROM Departments
UNION ALL
SELECT 'Professors', COUNT(*) FROM Professors
UNION ALL
SELECT 'Students', COUNT(*) FROM Students
UNION ALL
SELECT 'Courses', COUNT(*) FROM Course_tab
UNION ALL
SELECT 'Assignments', COUNT(*) FROM Assignments
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM Enrollment
UNION ALL
SELECT 'Student Grades', COUNT(*) FROM Student_Grades;

-- Test the views to ensure they work properly

-- Test View 1: Student_Courses_View
SELECT * FROM Student_Courses_View
WHERE student_id = 2001;

-- Test View 2: Student_Transcript
SELECT * FROM Student_Transcript
WHERE student_id = 2001;

-- Test View 3: Weekly_Schedule
SELECT * FROM Weekly_Schedule
WHERE person_id = 1001 AND person_type = 'Professor';

-- Test View 4: Course_Enrollment_Count
SELECT * FROM Course_Enrollment_Count;

-- Test View 5: Students_With_Missing_Submissions
SELECT * FROM Students_With_Missing_Submissions;

-- Test View 6: Top_Student_Overall
SELECT * FROM Top_Student_Overall;

-- Test View 7: Course_Average_Grades
SELECT * FROM Course_Average_Grades;