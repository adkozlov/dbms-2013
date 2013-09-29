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

CREATE TABLE group_course_lecturer_list (
	group_id INT NOT NULL,
	course_id INT NOT NULL,
	lecturer_id INT NOT NULL,
	FOREIGN KEY(group_id) REFERENCES groups(group_id),
	FOREIGN KEY(course_id) REFERENCES courses(course_id),
	FOREIGN KEY(lecturer_id) REFERENCES lecturers(lecturer_id)
);

CREATE TABLE student_group_list (
	student_id INT NOT NULL,
	group_id INT NOT NULL,
	FOREIGN KEY(student_id) REFERENCES students(student_id),
	FOREIGN KEY(group_id) REFERENCES groups(group_id)
);

CREATE TABLE student_course_mark_list (
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	mark ENUM('E', 'D', 'C', 'B', 'A'),
	FOREIGN KEY(student_id) REFERENCES students(student_id),
	FOREIGN KEY(course_id) REFERENCES courses(course_id)
);

DELIMITER //

DELIMITER ;