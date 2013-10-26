DROP DATABASE IF EXISTS deanery;
CREATE DATABASE deanery;
USE deanery;

CREATE TABLE students (
	student_id INT NOT NULL AUTO_INCREMENT,
	student_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(student_id)
);

CREATE TABLE groups (
	group_id INT NOT NULL AUTO_INCREMENT,
	group_name VARCHAR(4) NOT NULL,
	PRIMARY KEY(group_id)
);

CREATE TABLE courses (
	course_id INT NOT NULL AUTO_INCREMENT,
	course_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(course_id)
);

CREATE TABLE lecturers (
	lecturer_id INT NOT NULL AUTO_INCREMENT,
	lecturer_name VARCHAR(50) NOT NULL,
	PRIMARY KEY(lecturer_id)
);

CREATE TABLE schedule (
	group_id INT NOT NULL,
	course_id INT NOT NULL,
	lecturer_id INT NOT NULL,
	PRIMARY KEY(group_id, course_id),
	FOREIGN KEY(group_id) REFERENCES groups(group_id),
	FOREIGN KEY(course_id) REFERENCES courses(course_id),
	FOREIGN KEY(lecturer_id) REFERENCES lecturers(lecturer_id)
);

CREATE TABLE grouplists (
	student_id INT NOT NULL,
	group_id INT NOT NULL,
	PRIMARY KEY(student_id),
	FOREIGN KEY(student_id) REFERENCES students(student_id),
	FOREIGN KEY(group_id) REFERENCES groups(group_id)
);

CREATE TABLE marks (
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	points INT,
	PRIMARY KEY(student_id, course_id),
	FOREIGN KEY(student_id) REFERENCES students(student_id),
	FOREIGN KEY(course_id) REFERENCES courses(course_id)
);

DELIMITER //

DROP TRIGGER IF EXISTS check_marks_insert//
CREATE TRIGGER check_marks_insert
	BEFORE INSERT ON marks FOR EACH ROW
	BEGIN
		DECLARE message VARCHAR(255);
		IF EXISTS (SELECT group_id FROM grouplists WHERE student_id = NEW.student_id AND group_id NOT IN (SELECT group_id FROM schedule WHERE course_id = NEW.course_id)) THEN
			SET message = CONCAT('Student \"', CAST(NEW.student_id AS CHAR), '\" cannot have a mark for \"', CAST(NEW.course_id AS CHAR), '\" course.');
			SIGNAL SQLSTATE '45000' SET message_text = message;
		END IF;
	END//

DROP TRIGGER IF EXISTS check_marks_update//
CREATE TRIGGER check_marks_update
	BEFORE UPDATE ON marks FOR EACH ROW
	BEGIN
		DECLARE message VARCHAR(255);
		IF EXISTS (SELECT group_id FROM grouplists WHERE student_id = NEW.student_id AND group_id NOT IN (SELECT group_id FROM schedule WHERE course_id = NEW.course_id)) THEN
			SET message = CONCAT('Student \"', CAST(NEW.student_id AS CHAR), '\" cannot have a mark for \"', CAST(NEW.course_id AS CHAR), '\" course.');
			SIGNAL SQLSTATE '45000' SET message_text = message;
		END IF;
	END//

DELIMITER ;