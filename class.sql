-- Forward declarations to handle circular references
CREATE OR REPLACE TYPE Student_t      ;
/
CREATE OR REPLACE TYPE Professor_t    ;
/
CREATE OR REPLACE TYPE Department_t   ;
/
CREATE OR REPLACE TYPE Classroom_t    ;
/
CREATE OR REPLACE TYPE Course_t       ;
/
CREATE OR REPLACE TYPE Assignment_t   ;
/


-- Create collection types first to avoid references to non-existent types
CREATE OR REPLACE TYPE NT_STUDENTS    AS TABLE OF REF Student_t;
/ 
CREATE OR REPLACE TYPE NT_PROFESSORS  AS TABLE OF REF Professor_t;
/ 
CREATE OR REPLACE TYPE NT_COURSES     AS TABLE OF REF Course_t;  
/
CREATE OR REPLACE TYPE NT_ASSIGNMENTS AS TABLE OF REF Assignment_t;
/
CREATE OR REPLACE TYPE NT_CLASSROOMS  AS TABLE OF REF Classroom_t;
/
--                Basic type definitions                    --
--------------------------------------------------------------
CREATE OR REPLACE TYPE Person_t FORCE AS OBJECT (
  person_id     NUMBER,
  name          VARCHAR2(100),
  email         VARCHAR2(100),
  phone         VARCHAR2(20)
) NOT FINAL;
/

CREATE OR REPLACE TYPE Student_t UNDER Person_t (
  date_of_birth   DATE,
  address         VARCHAR2(200),
  dept_ref        REF Department_t,  -- Department reference
  courses_taken   NT_COURSES,
  assignments     NT_ASSIGNMENTS
);
/


CREATE OR REPLACE TYPE Professor_t UNDER Person_t (
  title            VARCHAR2(50),    -- Added title field (e.g., "Associate Professor")
  dept_ref         REF Department_t,
  courses_conducted NT_COURSES
);
/

CREATE OR REPLACE TYPE Department_t FORCE AS OBJECT (
  dept_id       NUMBER,
  dept_name     VARCHAR2(100),
  head_prof_ref REF Professor_t,  -- Head professor (can be NULL initially)
  professors    NT_PROFESSORS,    -- List of professors in the department
  students      NT_STUDENTS,      -- List of students in the department
  courses       NT_COURSES        -- List of courses in the department
);
/

CREATE OR REPLACE TYPE Classroom_t FORCE AS OBJECT (
  classroom_id   NUMBER,
  building       VARCHAR2(50),
  room_number    VARCHAR2(20),
  capacity       NUMBER,
  has_projector  NUMBER(1,0)      -- Boolean (0/1)
);
/


CREATE OR REPLACE TYPE Assignment_t FORCE AS OBJECT (
  assignment_id   NUMBER,
  title           VARCHAR2(100),
  description     CLOB,
  due_date        DATE,
  max_points      NUMBER(5,2),    -- To track assignment total points
  course_ref      REF Course_t    -- Link to the parent course
);
/

CREATE OR REPLACE TYPE Course_t FORCE AS OBJECT (
  course_id      NUMBER,
  course_name    VARCHAR2(100),
  coefficient    NUMBER,
  syllabus       CLOB,
  day_of_week    VARCHAR2(10),
  start_time     VARCHAR2(5),      -- Format for time
  end_time       VARCHAR2(5),
  students       NT_STUDENTS,
  professors     NT_PROFESSORS,
  dept_ref       REF Department_t,
  room_ref       REF Classroom_t,
  assignments    NT_ASSIGNMENTS
);
/

