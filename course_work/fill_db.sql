insert into units (abbreviation) values
	('с'),
	('кБ'),
	('шт.')
;

insert into services (service_name, unit_id) values
	('gsm_in', 1),
	('gsm_out', 1),
	('wcdma_in', 1),
	('wcdma_out', 1),
	('sms_in', 3),
	('sms_out', 3),
	('gprs', 2),
	('hsdpa', 2)
;

insert into tariffs (tariff_name) values
	('Всё просто')
;

insert into tariff_service_costs (tariff_id, service_id, cost_per_unit) values
	(1, 1, 0.00),
	(1, 2, 0.02),
	(1, 3, 0.00),
	(1, 4, 0.02),
	(1, 5, 0.00),
	(1, 6, 1.50),
	(1, 7, 0.01),
	(1, 8, 0.01)
;

start transaction isolation level serializable read write;
	select new_employee('Андрей', 'Козлов');
	select new_employee('Андрей', 'Васин');

	select new_number('+79219720152');
	select open_contract_on_date(1, 1, 1, '2003-09-05');
	select close_contract_on_date(1, 1, '2013-08-01');

	select new_number('+79215575300');
	select open_contract_now(1, 2, 1);
commit;

insert into operations (number_id, destination, start_time, duration, service_id) values
	(2, '+79112318180', '2013-12-13 21:00', 90, 2),
	(2, '+79213109677', '2013-12-13 23:00', 1, 6),
	(2, '+79213109677', '2013-12-13 23:05', 1, 5)
;

select first_name, last_name, sum(duration * cost_per_unit) from operations inner join contracts on operations.number_id = contracts.number_id natural join employees natural join tariff_service_costs group by first_name, last_name;