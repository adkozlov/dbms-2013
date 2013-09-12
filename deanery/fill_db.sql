INSERT INTO persons (first_name, second_name, last_name, sex, birth_date) VALUES
	('Николай', 'Юрьевич', 'Додонов', 'masculine', '1955-01-17'),
	('Георгий', 'Александрович', 'Корнеев', 'masculine', '1981-02-23'),
	('Константин', 'Петрович', 'Кохась', 'masculine', '1966-02-14'),
	('Павел', 'Юрьевич', 'Маврин', 'masculine', '1984-11-26'),
	('Андрей', 'Сергеевич', 'Станкевич', 'masculine', '1982-10-02'),
	('Васин', 'Андрей', 'Юрьевич', 'masculine', '1993-07-22'),
	('Алина', 'Димитрова', 'Димитрова', 'feminine', '1993-01-21'),
	('Андрей', 'Дмитриевич', 'Козлов', 'masculine', '1993-09-05'),
	('Артём', 'Тарасович', 'Васильев', 'masculine', '1993-04-08'),
	('Дмитрий', 'Анатольевич', 'Дешевой', 'masculine', '1994-04-02')
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