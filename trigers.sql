-- 1. Trigger to ensure unique student enrollments (prevent duplicate enrollments)
CREATE OR REPLACE TRIGGER trg_unique_enrollment
BEFORE INSERT OR UPDATE ON Enrollment
FOR EACH ROW
DECLARE
    student_already_enrolled NUMBER;
BEGIN
    -- Check if student is already enrolled in the course through Courses.students
    SELECT COUNT(*) INTO student_already_enrolled
    FROM TABLE(SELECT students FROM Courses WHERE REF(Courses) = :NEW.course_ref)
    WHERE COLUMN_VALUE = :NEW.student_ref;
    
    IF student_already_enrolled > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student is already enrolled in this course');
    END IF;
END;
/

-- 2. Trigger to ensure classroom capacity is not exceeded
CREATE OR REPLACE TRIGGER trg_classroom_capacity
BEFORE INSERT OR UPDATE ON Courses
FOR EACH ROW
DECLARE
    classroom_capacity NUMBER;
    current_enrollment NUMBER;
BEGIN
    -- Get the capacity of the classroom
    SELECT c.capacity INTO classroom_capacity
    FROM Classrooms c
    WHERE REF(c) = :NEW.room_ref;
    
    -- Count the number of students enrolled in the course
    SELECT COUNT(*) INTO current_enrollment
    FROM TABLE(:NEW.students);
    
    -- Check if capacity would be exceeded
    IF current_enrollment > classroom_capacity THEN
        RAISE_APPLICATION_ERROR(-20002, 'Classroom capacity exceeded. Cannot add more students.');
    END IF;
END;
/

-- 3. Trigger to ensure no scheduling conflicts for classrooms
CREATE OR REPLACE TRIGGER trg_classroom_schedule
BEFORE INSERT OR UPDATE ON Courses
FOR EACH ROW
DECLARE
    conflict_count_1 NUMBER;
    conflict_count_2 NUMBER;
    conflict_count_3 NUMBER;
BEGIN
    -- Check for time overlap with same classroom
    SELECT COUNT(*) INTO conflict_count_1
    FROM Courses c
    WHERE c.room_ref = :NEW.room_ref
      AND c.day_of_week = :NEW.day_of_week
      AND c.course_id <> :NEW.course_id
      AND (
          -- Case 1: New course starts during an existing course
          (:NEW.start_time >= c.start_time AND :NEW.start_time < c.end_time)
      );

      SELECT COUNT(*) INTO conflict_count_2
    FROM Courses c
    WHERE c.room_ref = :NEW.room_ref
      AND c.day_of_week = :NEW.day_of_week
      AND c.course_id <> :NEW.course_id
      AND (
          -- Case 2: New course ends during an existing course
          (:NEW.end_time > c.start_time AND :NEW.end_time <= c.end_time)
      );

      SELECT COUNT(*) INTO conflict_count_3
    FROM Courses c
    WHERE c.room_ref = :NEW.room_ref
      AND c.day_of_week = :NEW.day_of_week
      AND c.course_id <> :NEW.course_id
      AND (
          -- Case 3: New course completely contains an existing course
          (:NEW.start_time <= c.start_time AND :NEW.end_time >= c.end_time)
      );
    
    IF conflict_count_1 > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, ' CASE 1 Classroom scheduling conflict. This classroom is already booked during this time.');
    END IF;

    IF conflict_count_2 > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, ' CASE 2 Classroom scheduling conflict. This classroom is already booked during this time.');
    END IF;
    
    IF conflict_count_3 > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, ' CASE 3 Classroom scheduling conflict. This classroom is already booked during this time.');
    END IF;

END;
/

-- 4. Trigger to prevent deletion of courses with enrolled students
CREATE OR REPLACE TRIGGER trg_prevent_course_deletion
BEFORE DELETE ON Courses
FOR EACH ROW
DECLARE
    enrollment_count NUMBER;
BEGIN
    -- Check if there are any enrollments for this course
    SELECT COUNT(*) INTO enrollment_count
    FROM Enrollment e
    WHERE e.course_ref = REF(:OLD);
    
    -- Also check if there are students in the course's nested table
    IF enrollment_count > 0 OR (:OLD.students IS NOT NULL AND :OLD.students.COUNT > 0) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Cannot delete course with enrolled students');
    END IF;
END;
/

-- 5. Trigger to ensure only head professor can teach multiple courses
CREATE OR REPLACE TRIGGER trg_head_professor_multiple_courses
BEFORE INSERT OR UPDATE ON Courses
FOR EACH ROW
DECLARE
    prof_course_count NUMBER;
    is_head_professor NUMBER;
BEGIN
    -- For each professor assigned to this course
    FOR prof_rec IN (SELECT COLUMN_VALUE as prof_ref FROM TABLE(:NEW.professors))
    LOOP
        -- Check if this professor is a head of any department
        SELECT COUNT(*) INTO is_head_professor
        FROM Departments d
        WHERE d.head_prof_ref = prof_rec.prof_ref;
        
        -- If not a head professor, check course count
        IF is_head_professor = 0 THEN
            -- Count existing courses for this professor
            SELECT COUNT(*) INTO prof_course_count
            FROM Courses c,
                 TABLE(c.professors) t
            WHERE t.COLUMN_VALUE = prof_rec.prof_ref
              AND c.course_id <> :NEW.course_id; -- Exclude current course for updates
            
            -- Allow only one course for non-head professors
            IF prof_course_count >= 1 THEN
                RAISE_APPLICATION_ERROR(-20005, 'Only head professors can teach multiple courses');
            END IF;
        END IF;
    END LOOP;
END;
/