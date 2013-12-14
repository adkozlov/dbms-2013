start transaction isolation level serializable read write;

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
	select new_employee('Андрей', 'Козлов');
	select new_employee('Андрей', 'Васин');

	select new_number('9215575300');
	select open_contract_now(1, 1, 1);

	select close_contract_now(1, 1);

	--select change_tariff(1, 1);
commit;