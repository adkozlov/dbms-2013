insert into units (abbreviation) values
	('с'),
	('кБ'),
	('шт.')
;

insert into services (service_name) values
	('gsm_in'),
	('gsm_out'),
	('wcdma_in'),
	('wcdma_out'),
	('sms_in'),
	('sms_out'),
	('gprs_in'),
	('gprs_out'),
	('hsdpa_in'),
	('hsdpa_out'),
	('ussd')
;

insert into service_units (service_id, unit_id) values
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
	(5, 3),
	(6, 3),
	(7, 2),
	(8, 2),
	(9, 2),
	(10, 2),
	(11, 3)
;

insert into tariffs (tariff_name) values
	('Всё просто'),
	('Модем')
;

insert into tariff_service_costs (tariff_id, service_id, cost_per_unit) values
	(1, 1, 0.00),
	(1, 2, 0.02),
	(1, 3, 0.00),
	(1, 4, 0.02),
	(1, 5, 0.00),
	(1, 6, 1.50),
	(1, 7, 0.01),
	(1, 8, 0.00),
	(1, 9, 0.01),
	(1, 10, 0.00),
	(1, 11, 0.00),
	(2, 1, 0.00),
	(2, 2, 0.20),
	(2, 3, 0.00),
	(2, 4, 0.20),
	(2, 5, 0.00),
	(2, 6, 3.00),
	(2, 7, 0.00),
	(2, 8, 0.00),
	(2, 9, 0.00),
	(2, 10, 0.00),
	(2, 11, 0.00)
;

start transaction isolation level serializable read write;
	select new_employee('Андрей', 'Козлов');

	select new_number('+79219720152');
	select open_contract_on_date(1, 1, 2, '2003-09-05');
	select close_contract_on_date(1, 1, '2013-08-01');

	select new_number('+79215575300');
	select open_contract_now(1, 2, 1);
commit;

insert into operations (number_id, destination, operation_time, duration, service_id) values
	(1, '+79112318180', '2013-01-01 23:00', 60, 2),
	(1, 'vk.com', '2013-01-01 23:00', 100, 9),
	(2, '+79112318180', '2013-12-13 21:00', 90, 2),
	(2, '+79213109677', '2013-12-13 23:00', 1, 6),
	(2, '+79213109677', '2013-12-13 23:05', 1, 5)
;

start transaction isolation level serializable read only;
	select * from all_employee_contracts('Андрей', 'Козлов');
	select * from open_employee_contracts('Андрей', 'Козлов');

	select * from total_employee_charges('Андрей', 'Козлов');
commit;