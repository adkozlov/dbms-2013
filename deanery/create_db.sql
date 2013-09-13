DROP DATABASE IF EXISTS deanery;
CREATE DATABASE deanery;
USE deanery;

CREATE TABLE persons (
	person_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(20) NOT NULL,
	second_name VARCHAR(25),
	last_name VARCHAR(25) NOT NULL,
	sex ENUM('MASCULINE', 'FEMININE') NOT NULL,
	birth_date DATE NOT NULL,
	PRIMARY KEY(person_id)
);

CREATE TABLE groups (
	group_id INT NOT NULL AUTO_INCREMENT,
	group_number VARCHAR(4) NOT NULL,
	PRIMARY KEY(group_id)
);

CREATE TABLE students (
	student_id INT NOT NULL AUTO_INCREMENT,
	person_id INT NOT NULL,
	PRIMARY KEY(student_id),
	FOREIGN KEY(person_id) REFERENCES persons(person_id)
);

CREATE TABLE professors (
	professor_id INT NOT NULL AUTO_INCREMENT,
	person_id INT NOT NULL,
	PRIMARY KEY(professor_id),
	FOREIGN KEY(person_id) REFERENCES persons(person_id)
);

CREATE TABLE subjects (
	subject_id INT NOT NULL AUTO_INCREMENT,
	subject_name VARCHAR(50) NOT NULL,
	term_number INT NOT NULL,
	type ENUM('CREDIT', 'GRADE') NOT NULL,
	PRIMARY KEY(subject_id)
);

CREATE TABLE marks (
	student_id INT NOT NULL,
	subject_id INT NOT NULL,
	points DECIMAL(5,2) NOT NULL,
	credit_date DATE NOT NULL,
	grade ENUM('E', 'D', 'C', 'B', 'A'),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
	FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

DELIMITER //

DROP TRIGGER IF EXISTS check_subject_ins//
CREATE TRIGGER check_subject_ins
	BEFORE INSERT ON subjects FOR EACH ROW
	BEGIN
	    DECLARE msg VARCHAR(255);
	    IF NEW.term_number < 1 OR NEW.term_number > 12 THEN
	        SET msg = CONCAT('Invalid term number: ', CAST(NEW.term_number as CHAR));
	        SIGNAL SQLSTATE '45000' SET message_text = msg;
	    END IF;
	END//

DROP TRIGGER IF EXISTS check_subject_term_number_upd//
CREATE TRIGGER check_subject_upd
	BEFORE UPDATE ON subjects FOR EACH ROW
	BEGIN
	    DECLARE msg VARCHAR(255);
	    IF NEW.term_number < 1 OR NEW.term_number > 12 THEN
	        SET msg = CONCAT('Invalid term number: ', CAST(NEW.term_number as CHAR));
	        SIGNAL SQLSTATE '45000' SET message_text = msg;
	    END IF;
	END//

DROP TRIGGER IF EXISTS auto_marks_grade_ins//
CREATE TRIGGER auto_marks_grade_ins
	BEFORE INSERT ON marks FOR EACH ROW
	BEGIN
		DECLARE msg VARCHAR(255);
		IF NEW.grade IS NOT NULL THEN
			SET msg = 'Automatic grading';
	        SIGNAL SQLSTATE '45000' SET message_text = msg;
		ELSEIF NEW.points < 0 OR NEW.points > 100 THEN
			SET msg = CONCAT('Invalid points count: ', CAST(NEW.points as CHAR));
	        SIGNAL SQLSTATE '45000' SET message_text = msg;
	    ELSEIF (SELECT type FROM subjects WHERE subject_id = NEW.subject_id) = 'GRADE' THEN
		    IF NEW.points > 90 THEN
		    	SET NEW.grade = 'A';
		    ELSEIF NEW.points > 83 THEN
		    	SET NEW.grade = 'B';
		    ELSEIF NEW.points > 74 THEN
		    	SET NEW.grade = 'C';
		    ELSEIF NEW.points > 67 THEN
		    	SET NEW.grade = 'D';
		    ELSEIF NEW.points >= 60 THEN
		    	SET NEW.grade = 'E';
		    ELSE
		    	SET msg = CONCAT(CONCAT('Not credited: ', CAST(NEW.points as CHAR), ' points'));
	        	SIGNAL SQLSTATE '45000' SET message_text = msg;
		    END IF;
		END IF;
	END//

DROP TRIGGER IF EXISTS auto_marks_grade_upd//
CREATE TRIGGER auto_marks_grade_upd
	BEFORE UPDATE ON marks FOR EACH ROW
	BEGIN
		DECLARE msg VARCHAR(255);
		IF (OLD.grade IS NOT NULL) THEN
	    	SET msg = CONCAT('Cannot change fixed grade: ', CAST(NEW.grade as CHAR));
	    ELSE
	    	SET msg = 'Cannot set grade: credite course';
	    END IF;
    	SIGNAL SQLSTATE '45000' SET message_text = msg;
	END//

DELIMITER ;