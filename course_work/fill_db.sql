start transaction isolation level serializable read write;

	select * from new_employee('Андрей', 'Козлов');
	select * from new_employee('Андрей', 'Васин');

	select * from new_number('9215575300');
	select * from open_contract_now(1, 1);

	select * from close_contract_now(1, 1);
commit;

select * from contracts where employee_id = 1 and number_id = 1 and finish_time is null;
update contracts set finish_time = now() where employee_id = 1 and number_id = 1 and finish_time is null;