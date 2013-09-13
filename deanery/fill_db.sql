INSERT INTO persons (first_name, second_name, last_name, sex, birth_date) VALUES
	('Николай', 'Юрьевич', 'Додонов', 'MASCULINE', '1955-01-17'),
	('Антон', 'Сергеевич', 'Ковалёв', 'MASCULINE', '1984-10-04'),
	('Георгий', 'Александрович', 'Корнеев', 'MASCULINE', '1981-02-23'),
	('Константин', 'Петрович', 'Кохась', 'MASCULINE', '1966-02-14'),
	('Павел', 'Юрьевич', 'Маврин', 'MASCULINE', '1984-11-26'),
	('Андрей', 'Сергеевич', 'Станкевич', 'MASCULINE', '1982-10-02'),
	('Андрей', 'Юрьевич', 'Васин', 'MASCULINE', '1993-07-22'),
	('Алина', 'Димитрова', 'Димитрова', 'FEMININE', '1993-01-21'),
	('Андрей', 'Дмитриевич', 'Козлов', 'MASCULINE', '1993-09-05'),
	('Артём', 'Тарасович', 'Васильев', 'MASCULINE', '1993-04-08'),
	('Дмитрий', 'Анатольевич', 'Дешевой', 'MASCULINE', '1994-04-02')
;

INSERT INTO groups (group_number) VALUES
	('4528'),
	('4538'),
	('4539')
;

INSERT INTO professors (person_id)
	SELECT person_id FROM persons
		WHERE birth_date < '1991-01-01'
;

INSERT INTO students (person_id)
	SELECT person_id FROM persons
		WHERE birth_date >= '1991-01-01'
;

INSERT INTO subjects (subject_name, term_number, type) VALUES
	('Математический анализ', 1, 'GRADE'),
	('Математический анализ', 2, 'GRADE'),
	('Математический анализ', 3, 'GRADE'),
	('Математический анализ', 4, 'GRADE'),
	('Математический анализ', 5, 'GRADE'),
	('Математический анализ', 6, 'GRADE'),
	('Технологии программирования', 2, 'GRADE'),
	('Практикум на ЭВМ', 3, 'CREDIT'),
	('Практикум на ЭВМ', 4, 'CREDIT'),
	('Java-технологии', 4, 'CREDIT'),
	('Базы данных и экспертные системы', 7, 'GRADE'),
	('Дискретная математика', 1, 'GRADE'),
	('Дискретная математика', 2, 'GRADE'),
	('Алгоритмы и структуры данных', 3, 'GRADE'),
	('Алгоритмы и структуры данных', 4, 'GRADE'),
	('Языки программирования и методы трансляции', 5, 'GRADE'),
	('Языки программирования и методы трансляции', 6, 'CREDIT'),
	('Теория вычислительной сложности', 6, 'CREDIT')
;

INSERT INTO marks (student_id, subject_id, points, credit_date) VALUES
	(1, 1, 100, now())
;