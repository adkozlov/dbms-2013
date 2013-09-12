DROP DATABASE deanery;

CREATE DATABASE deanery;

USE deanery;

CREATE TABLE persons (
	person_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(20) NOT NULL,
	second_name VARCHAR(25),
	last_name VARCHAR(25) NOT NULL,
	sex ENUM('masculine', 'feminine') NOT NULL,
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
