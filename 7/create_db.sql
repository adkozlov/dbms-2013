DROP TABLE IF EXISTS students CASCADE;
CREATE TABLE students (
	student_id SERIAL,
	student_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(student_id)
);

DROP TABLE IF EXISTS groups CASCADE;
CREATE TABLE groups (
	group_id SERIAL,
	group_name VARCHAR(4) NOT NULL,
	PRIMARY KEY(group_id)
);

DROP TABLE IF EXISTS courses CASCADE;
CREATE TABLE courses (
	course_id SERIAL,
	course_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(course_id)
);

DROP TABLE IF EXISTS lecturers CASCADE;
CREATE TABLE lecturers (
	lecturer_id SERIAL,
	lecturer_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(lecturer_id)
);

DROP TABLE IF EXISTS schedule CASCADE;
CREATE TABLE schedule (
	group_id INT NOT NULL,
	course_id INT NOT NULL,
	lecturer_id INT NOT NULL,
	PRIMARY KEY(group_id, course_id),
	FOREIGN KEY(group_id) REFERENCES groups(group_id) ON DELETE CASCADE,
	FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
	FOREIGN KEY(lecturer_id) REFERENCES lecturers(lecturer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS grouplists CASCADE;
CREATE TABLE grouplists (
	student_id INT NOT NULL,
	group_id INT NOT NULL,
	PRIMARY KEY(student_id),
	FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE,
	FOREIGN KEY(group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS marks CASCADE;
CREATE TABLE marks (
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	points INT CHECK(points BETWEEN 0 AND 100),
	PRIMARY KEY(student_id, course_id),
	FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE,
	FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

DROP FUNCTION IF EXISTS check_mark();
CREATE FUNCTION check_mark() RETURNS trigger AS $check_mark$ 
BEGIN 
	IF EXISTS (SELECT group_id FROM grouplists WHERE student_id = NEW.student_id AND group_id NOT IN (SELECT group_id FROM schedule WHERE course_id = NEW.course_id)) THEN	
		RAISE EXCEPTION 'student % cannot have mark for the % course', NEW.student_id, NEW.course_id;
	END IF;
	RETURN NEW;
END; 
$check_mark$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_marks_update ON marks;
CREATE TRIGGER check_marks_update BEFORE UPDATE ON marks
	FOR EACH ROW EXECUTE PROCEDURE check_mark();

DROP TRIGGER IF EXISTS check_marks_insert ON marks;
CREATE TRIGGER check_marks_insert BEFORE INSERT ON marks
	FOR EACH ROW EXECUTE PROCEDURE check_mark();