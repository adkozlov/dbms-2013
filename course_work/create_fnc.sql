drop function if exists new_employee (varchar, varchar) cascade;
create function new_employee (first_name_ varchar(25), last_name_ varchar(25)) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into employees (first_name, last_name) values (first_name_, last_name_);
        return currval('employees_employee_id_seq');
    end;
$$ language plpgsql;

drop function if exists new_number (varchar) cascade;
create function new_number (phone_ varchar(10)) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into numbers (phone) values (phone_);
        return currval('numbers_number_id_seq');
    end;
$$ language plpgsql;

drop function if exists open_contract_on_date (int, int, int, timestamp) cascade;
create function open_contract_on_date (employee_id_ int, number_id_ int, tariff_id_ int, start_time_ timestamp) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into contracts (employee_id, number_id, tariff_id, start_time) values (employee_id_, number_id_, tariff_id_, start_time_);
        return currval('contracts_contract_id_seq');
    end;
$$ language plpgsql;

drop function if exists open_contract_now (int, int, int) cascade;
create function open_contract_now (employee_id_ int, number_id_ int, tariff_id_ int) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into contracts (employee_id, number_id, tariff_id, start_time) values (employee_id_, number_id_, tariff_id_, now ());
        return currval('contracts_contract_id_seq');
    end;
$$ language plpgsql;

drop function if exists check_contract_is_open () cascade;
create function check_contract_is_open () returns trigger as $$
    begin
        if exists (select * from contracts where employee_id = new.employee_id and number_id = new.number_id and finish_time is null) then
            raise exception 'contract of employee % on number % is already open', new.employee_id, new.number_id;
        end if;
        return new;
    end;
$$ language plpgsql;

drop trigger if exists check_contract_is_open on contracts cascade;
create trigger check_contract_is_open before insert on contracts
    for each row execute procedure check_contract_is_open ();

drop function if exists close_contract_on_date (int, int, timestamp with time zone) cascade;
create function close_contract_on_date (employee_id_ int, number_id_ int, finish_time_ timestamp with time zone) returns void as $$
    begin
        set transaction isolation level serializable read write;
        update contracts set finish_time = finish_time_ where employee_id = employee_id_ and number_id = number_id_ and finish_time is null;
    end;
$$ language plpgsql;

drop function if exists close_contract_now (int, int) cascade;
create function close_contract_now (employee_id_ int, number_id_ int) returns void as $$
    begin
        set transaction isolation level serializable read write;
        perform close_contract_on_date (employee_id_, number_id_, now ());
    end;
$$ language plpgsql;

drop function if exists check_contract_is_closed () cascade;
create function check_contract_is_closed () returns trigger as $$
    begin
        if not exists (select * from contracts where employee_id = new.employee_id and number_id = new.number_id and finish_time is null) then
            raise exception 'there is no opened contract of employee % on number %', new.employee_id, new.number_id;
        end if;
        return new;
    end;
$$ language plpgsql;

drop trigger if exists check_contract_is_closed on contracts cascade;
create trigger check_contract_is_closed before update on contracts
    for each row execute procedure check_contract_is_closed ();

drop function if exists change_tariff (int, int) cascade;
create function change_tariff (number_id_ int, new_tariff_id int) returns int as $$
    declare
        contract_id_ int;
        employee_id_ int;
        old_tariff_id int;
    begin
        set transaction isolation level serializable read write;
        select contract_id into contract_id_ from contracts where number_id = number_id_ and finish_time is null;

        if (contract_id_ is null) then
            raise exception 'there is no opened contract on number %', number_id_;
        else
            select tariff_id into old_tariff_id from contracts where contract_id = contract_id_;

            if (old_tariff_id != new_tariff_id) then
                update contracts set finish_time = current_timestamp where contract_id = contract_id_;
                select employee_id into employee_id_ from contracts where contract_id = contract_id_;
                return open_contract_now (employee_id_, number_id_, new_tariff_id);
            else
                raise notice 'tariff on number % is already %', number_id_, old_tariff_id;
                return contract_id_;
            end if;
        end if;
    end;
$$ language plpgsql;