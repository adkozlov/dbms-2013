INSERT INTO persons (first_name, second_name, last_name, sex, birth_date) VALUES
	('Николай', 'Юрьевич', 'Додонов', 'MASCULINE', '1955-01-17'),
	('Георгий', 'Александрович', 'Корнеев', 'MASCULINE', '1981-02-23'),
	('Андрей', 'Сергеевич', 'Станкевич', 'MASCULINE', '1982-10-02'),
	('Андрей', 'Юрьевич', 'Васин', 'MASCULINE', '1993-07-22'),
	('Алина', 'Димитрова', 'Димитрова', 'FEMININE', '1993-01-21'),
	('Андрей', 'Дмитриевич', 'Козлов', 'MASCULINE', '1993-09-05'),
	('Артём', 'Тарасович', 'Васильев', 'MASCULINE', '1993-04-08'),
	('Дмитрий', 'Анатольевич', 'Дешевой', 'MASCULINE', '1994-04-02')
;

INSERT INTO groups (group_number) VALUES
	('4538'),
	('4539')
;

INSERT INTO students (person_id, group_id) VALUES
	(4, 1),
	(5, 1),
	(6, 1),
	(7, 2),
	(8, 2)
;

INSERT INTO professors (person_id) VALUES
	(1),
	(2),
	(3)
;

INSERT INTO subjects (subject_name) VALUES
	('Математический анализ'),
	('Java-технологии'),
	('Базы данных и экспертные системы'),
	('Дискретная математика'),
	('Алгоритмы и структуры данных'),
	('Языки программирования и методы трансляции'),
	('Теория вычислительной сложности')
;

INSERT INTO courses (professor_id, subject_id, term_number, type) VALUES
	(1, 1, 1, 'GRADE'),
	(1, 1, 2, 'GRADE'),
	(1, 1, 3, 'GRADE'),
	(1, 1, 4, 'GRADE'),
	(1, 1, 5, 'GRADE'),
	(1, 1, 6, 'GRADE'),
	(2, 2, 4, 'CREDIT'),
	(2, 3, 7, 'GRADE'),
	(3, 4, 1, 'GRADE'),
	(3, 4, 2, 'GRADE'),
	(3, 5, 3, 'GRADE'),
	(3, 5, 4, 'GRADE'),
	(3, 6, 5, 'GRADE'),
	(3, 6, 6, 'CREDIT'),
	(3, 7, 6, 'CREDIT')
;

INSERT INTO group_courses (group_id, course_id)
	SELECT 1, course_id FROM courses
	UNION
	SELECT 2, course_id FROM courses
;

INSERT INTO marks (student_id, group_course_id, points, credit_date)
	SELECT 4, group_course_id, 100, now() FROM group_courses where group_id = 2;
;