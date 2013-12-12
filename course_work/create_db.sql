drop table if exists employees cascade;
create table employees (
    employee_id serial not null primary key,
    first_name varchar(25) not null check (first_name != ''),
    last_name varchar(25) not null check (last_name != ''),
    unique(first_name, last_name)
);

drop table if exists numbers cascade;
create table numbers (
    number_id serial not null primary key,
    phone varchar(10) not null unique check (phone != '')
);

drop table if exists contracts cascade;
create table contracts (
    contract_id serial not null primary key,
    employee_id int not null references employees(employee_id),
    number_id int not null references numbers(number_id),
    start_time timestamp not null,
    finish_time timestamp check (finish_time >= start_time)
);

drop table if exists units cascade;
create table units (
    unit_id serial not null primary key,
    abbreviation varchar(10) not null
);

drop table if exists services cascade;
create table services (
    service_id serial not null primary key,
    service_name varchar(10) not null,
    cost_per_unit money not null,
    unit_id int references units(unit_id)
); -- слабая сущность?

drop table if exists operations cascade;
create table operations (
    operation_id serial not null primary key,
    number_id int not null references numbers(number_id),
    operation_destination varchar(10) not null,
    start_time timestamp not null,
    duration int not null,
    service_id int not null references services(service_id)
);

create or replace function new_employee (first_name_ varchar(25), last_name_ varchar(25)) returns integer as $$
    begin
        set transaction isolation level serializable read write;
        insert into employees (first_name, last_name) values (first_name_, last_name_);
        return currval('employees_employee_id_seq');
    end;
$$ language plpgsql;

create or replace function new_number (phone_ varchar(10)) returns integer as $$
    begin
        set transaction isolation level serializable read write;
        insert into numbers (phone) values (phone_);
        return currval('numbers_number_id_seq');
    end;
$$ language plpgsql;


create or replace function open_contract_now (employee_id_ int, number_id_ int) returns integer as $$
    begin
        set transaction isolation level serializable read write;
        insert into contracts (employee_id, number_id, start_time) values (employee_id_, number_id_, current_timestamp);
        return currval('contracts_contract_id_seq');
    end;
$$ language plpgsql;

create or replace function open_contract_on_date (employee_id_ int, number_id_ int, start_time_ timestamp) returns integer as $$
    begin
        set transaction isolation level serializable read write;
        insert into contracts (employee_id, number_id, start_time) values (employee_id_, number_id_, start_time_);
        return currval('contracts_contract_id_seq');
    end;
$$ language plpgsql;

create or replace function check_contract_is_open() returns trigger as $$
    begin
        if exists (select count(*) from contracts where employee_id = new.employee_id and number_id = new.number_id and finish_time is null) then
            raise exception 'contract of employee % on number % is already open', new.employee_id, new.number_id;
        end if;
        return new;
    end;
$$ language plpgsql;

drop trigger if exists check_contract_is_open on contracts cascade;
create trigger check_contract_is_open before insert on contracts
    for each row execute procedure check_contract_is_open();

create or replace function close_contract_now (employee_id_ int, number_id_ int) returns void as $$
    begin
        set transaction isolation level serializable read write;
        update contracts set finish_time = current_timestamp where employee_id = employee_id_ and number_id = number_id_ and finish_time is null;
    end;
$$ language plpgsql;

create or replace function close_contract_on_date (employee_id_ int, number_id_ int, finish_time_ timestamp) returns void as $$
    begin
        set transaction isolation level serializable read write;
        update contracts set finish_time = finish_time_ where employee_id = employee_id_ and number_id = number_id_ and finish_time is null;
    end;
$$ language plpgsql;

create or replace function check_contract_is_closed() returns trigger as $$
    begin
        if not exists (select count(*) from contracts where employee_id = new.employee_id and number_id = new.number_id and finish_time is null) then
            raise exception 'there is no opened contract of employee % on number %', new.employee_id, new.number_id;
        end if;
        return new;
    end;
$$ language plpgsql;

drop trigger if exists check_contract_is_closed on contracts cascade;
create trigger check_contract_is_closed before update on contracts
    for each row execute procedure check_contract_is_closed();