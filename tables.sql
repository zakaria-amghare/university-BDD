CREATE TABLE Students OF Student_t (
  person_id PRIMARY KEY,
  name NOT NULL,
  email NOT NULL,
  CONSTRAINT chk_student_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
)
NESTED TABLE courses_taken STORE AS Student_Courses_ntab
NESTED TABLE assignments STORE AS Student_Assignments_ntab;
/

CREATE TABLE Professors OF Professor_t (
  person_id PRIMARY KEY,
  name NOT NULL,
  email NOT NULL,
  CONSTRAINT chk_prof_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
)
NESTED TABLE courses_conducted STORE AS Professor_Courses_ntab;
/
CREATE TABLE Departments OF Department_t (
  dept_id PRIMARY KEY,
  dept_name NOT NULL
)
NESTED TABLE students STORE AS Department_Students_ntab
NESTED TABLE professors STORE AS Department_Professors_ntab
NESTED TABLE courses STORE AS Department_Courses_ntab;
/
CREATE TABLE Classrooms OF Classroom_t (
  classroom_id PRIMARY KEY,
  CONSTRAINT chk_capacity CHECK (capacity > 0)
);
/
CREATE TABLE Courses OF Course_t (
  course_id PRIMARY KEY,
  course_name NOT NULL,
  CONSTRAINT chk_coefficient CHECK (coefficient BETWEEN 0 AND 10)
)
NESTED TABLE students STORE AS Course_Students_ntab
NESTED TABLE professors STORE AS Course_Professors_ntab
NESTED TABLE assignments STORE AS Course_Assignments_ntab;
/
CREATE TABLE Assignments OF Assignment_t (
  assignment_id PRIMARY KEY,
  title NOT NULL,
  due_date NOT NULL,
  CONSTRAINT chk_max_points CHECK (max_points > 0)
);
/
CREATE TABLE Enrollment (
  student_ref REF Student_t,
  course_ref REF Course_t,
  grade VARCHAR2(2),
  enrollment_date DATE DEFAULT SYSDATE,
  CONSTRAINT chk_grade1 CHECK (grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D','D-', 'F'))
);
/
CREATE TABLE Student_Grades (
  student_ref REF Student_t,
  assignment_ref REF Assignment_t,
  grade VARCHAR2(2),
  submission_date DATE,
  CONSTRAINT chk_grade2 CHECK (grade IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D','D-', 'F'))
);
/
