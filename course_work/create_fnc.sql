drop function if exists new_employee (varchar, varchar) cascade;
drop function if exists new_number (varchar) cascade;
drop function if exists open_contract_on_date (int, int, int, timestamp) cascade;
drop function if exists open_contract_now (int, int, int) cascade;
drop function if exists check_contract_is_open () cascade;
drop trigger if exists check_contract_is_open on contracts cascade;
drop function if exists close_contract_on_date (int, int, timestamp) cascade;
drop function if exists close_contract_now (int, int) cascade;
drop function if exists check_contract_is_closed () cascade;
drop trigger if exists check_contract_is_closed on contracts cascade;
drop function if exists change_tariff (int, int) cascade;

create function new_employee (first_name_ varchar, last_name_ varchar) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into employees (first_name, last_name) values (first_name_, last_name_);
        return currval('employees_employee_id_seq');
    end;
$$ language plpgsql;

create function new_number (phone_number_ varchar) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into numbers (phone_number) values (phone_number_);
        return currval('numbers_number_id_seq');
    end;
$$ language plpgsql;

create function open_contract_on_date (employee_id_ int, number_id_ int, tariff_id_ int, start_time_ timestamp) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into contracts (employee_id, number_id, tariff_id, start_time) values (employee_id_, number_id_, tariff_id_, start_time_);
        return currval('contracts_contract_id_seq');
    end;
$$ language plpgsql;

create function open_contract_now (employee_id_ int, number_id_ int, tariff_id_ int) returns int as $$
    begin
        set transaction isolation level serializable read write;
        insert into contracts (employee_id, number_id, tariff_id, start_time) values (employee_id_, number_id_, tariff_id_, now ());
        return currval('contracts_contract_id_seq');
    end;
$$ language plpgsql;

create function check_contract_is_open () returns trigger as $$
    begin
        if exists (select * from contracts where employee_id = new.employee_id and number_id = new.number_id and finish_time = inf()) then
            raise exception 'contract of employee % on number % is already open', new.employee_id, new.number_id;
        end if;
        return new;
    end;
$$ language plpgsql;

create trigger check_contract_is_open before insert on contracts
    for each row execute procedure check_contract_is_open ();

create function close_contract_on_date (employee_id_ int, number_id_ int, finish_time_ timestamp) returns void as $$
    begin
        set transaction isolation level serializable read write;
        update contracts set finish_time = finish_time_ where employee_id = employee_id_ and number_id = number_id_ and finish_time = inf();
    end;
$$ language plpgsql;

create function close_contract_now (employee_id_ int, number_id_ int) returns void as $$
    begin
        set transaction isolation level serializable read write;
        perform close_contract_on_date (employee_id_, number_id_, now ());
    end;
$$ language plpgsql;

create function check_contract_is_closed () returns trigger as $$
    begin
        if not exists (select * from contracts where employee_id = new.employee_id and number_id = new.number_id and finish_time = inf()) then
            raise exception 'there is no opened contract of employee % on number %', new.employee_id, new.number_id;
        end if;
        return new;
    end;
$$ language plpgsql;

create trigger check_contract_is_closed before update on contracts
    for each row execute procedure check_contract_is_closed ();

create function change_tariff (number_id_ int, new_tariff_id int) returns int as $$
    declare
        contract_id_ int;
        employee_id_ int;
        old_tariff_id int;
    begin
        set transaction isolation level serializable read write;
        select contract_id into contract_id_ from contracts where number_id = number_id_ and finish_time = inf();

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

drop view all_contracts;
create view all_contracts as
    select * from contracts natural join employees natural join numbers natural join tariffs;

drop function get_employee_id (varchar, varchar);
create function get_employee_id (first_name_ varchar, last_name_ varchar) returns int as $$
    declare
        employee_id_ int;
    begin
        set transaction isolation level serializable read only;

        select employee_id into employee_id_ from employees where first_name = first_name_ and last_name = last_name_;

        if (employee_id_ is null) then
            raise exception 'there is no employee % %', first_name_, last_name_;
        else
            return employee_id_;
        end if;
    end;
$$ language plpgsql;

drop function all_employee_contracts (varchar, varchar);
create function all_employee_contracts (first_name_ varchar, last_name_ varchar) returns table(first_name varchar, last_name varchar, phone_number varchar, tariff_name varchar, start_time timestamp, finish_time timestamp) as $$
    begin
        set transaction isolation level serializable read only;

        return query select all_contracts.first_name, all_contracts.last_name, all_contracts.phone_number, all_contracts.tariff_name, all_contracts.start_time, all_contracts.finish_time from all_contracts where employee_id = get_employee_id (first_name_, last_name_);
    end;
$$ language plpgsql;

drop function open_employee_contracts (varchar, varchar);
create function open_employee_contracts (first_name_ varchar, last_name_ varchar) returns table(first_name varchar, last_name varchar, phone_number varchar, tariff_name varchar, start_time timestamp) as $$
    begin
        set transaction isolation level serializable read only;
        
        return query select all_employee_contracts.first_name, all_employee_contracts.last_name, all_employee_contracts.phone_number, all_employee_contracts.tariff_name, all_employee_contracts.start_time from all_employee_contracts (first_name_, last_name_) where finish_time = inf();
    end;
$$ language plpgsql;

drop view all_operations;
create view all_operations as
    select * from operations natural join contracts natural join employees natural join tariff_service_costs;

drop function total_employee_charges (varchar, varchar);
create function total_employee_charges (first_name_ varchar, last_name_ varchar) returns table (total_charges money) as $$
    begin
        set transaction isolation level serializable read only;

        return query select sum(duration * cost_per_unit) from operations natural join contracts natural join employees natural join tariff_service_costs where employee_id = get_employee_id (first_name_, last_name_) group by first_name, last_name;
    end;
$$ language plpgsql;