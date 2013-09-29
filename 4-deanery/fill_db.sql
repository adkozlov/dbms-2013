INSERT INTO students (student_name) VALUES
	('Васин'),
	('Козлов'),
	('Шагал'),
	('Васильев'),
	('Лытаев')
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

INSERT INTO group_course_lecturer_list (group_id, course_id, lecturer_id) VALUES
	(1, 1, 1),
	(2, 1, 1),
	(1, 2, 2),
	(2, 2, 2),
	(1, 3, 2),
	(2, 3, 2)
;

INSERT INTO student_group_list (student_id, group_id) VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 2)
;