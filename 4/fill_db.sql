INSERT INTO students (student_name) VALUES
	('Васин'),
	('Козлов'),
	('Шагал'),
	('Васильев'),
	('Дешевой'),
	('Шаповалов')
;

INSERT INTO groups (group_name) VALUES
	('4538'),
	('4539')
;

INSERT INTO courses (course_name) VALUES
	('Математический анализ'),
	('Дискретная математика'),
	('Алгоритмы и структуры данных')
;

INSERT INTO lecturers (lecturer_name) VALUES
	('Додонов'),
	('Станкевич')
;

INSERT INTO schedule (group_id, course_id, lecturer_id) VALUES
	(1, 1, 1),
	(2, 1, 1),
	(1, 2, 2),
	(2, 2, 2),
	(1, 3, 2),
	(2, 3, 2)
;

INSERT INTO grouplists (student_id, group_id) VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 2),
	(6, 2)
;

INSERT INTO marks (student_id, course_id, points) VALUES
	(1, 1, 68),
	(1, 2, 60),
	(2, 1, 68),
	(2, 2, 75),
	(3, 1, 68),
	(3, 2, 60),
	(4, 1, 100),
	(4, 2, 101),
	(5, 1, 0),
	(5, 2, 0),
	(5, 3, 0),
	(6, 1, 0),
	(6, 2, 0),
	(6, 3, 0)
;