drop table if exists employees cascade;
drop index if exists lowercased_employees_idx cascade;
drop table if exists numbers cascade;
drop index if exists numbers_idx;
drop table if exists tariffs cascade;
drop function if exists inf () cascade;
drop table if exists contracts cascade;
drop table if exists units cascade;
drop table if exists services cascade;
drop table if exists service_units cascade;
drop table if exists tariff_service_costs cascade;
drop table if exists operations cascade;
drop index operations_idx cascade;

create table employees (
    employee_id serial primary key,
    first_name varchar(25) not null check (first_name != ''),
    last_name varchar(25) not null check (last_name != '')
);
create index lowercased_employees_idx on employees (lower(first_name), lower(last_name));

create table numbers (
    number_id serial primary key,
    phone_number varchar(12) not null unique check (phone_number != '')
);
create unique index numbers_idx on numbers (phone_number);

create table tariffs (
    tariff_id serial primary key,
    tariff_name varchar(20) not null unique check (tariff_name != '')
);

create function inf () returns timestamp as $$
    begin
        return '9999-12-31 23:59:59';
    end;
$$ language plpgsql;

create table contracts (
    contract_id serial primary key,
    employee_id int not null references employees (employee_id),
    number_id int not null references numbers (number_id),
    tariff_id int not null references tariffs (tariff_id),
    start_time timestamp not null,
    finish_time timestamp not null default inf() check (finish_time >= start_time)
);

create table units (
    unit_id serial primary key,
    abbreviation varchar(5) not null unique check (abbreviation != '')
);

create table services (
    service_id serial primary key,
    service_name varchar(10) not null unique check (service_name != '')
);

create table service_units (
    service_id int not null unique references services (service_id),
    unit_id int not null references units (unit_id)
);

create table tariff_service_costs (
    tariff_id int not null references tariffs (tariff_id),
    service_id int not null references services (service_id),
    cost_per_unit money not null,
    primary key (tariff_id, service_id)
);

create table operations (
    operation_id serial primary key,
    number_id int not null references numbers (number_id),
    destination varchar(20) not null,
    operation_time timestamp not null,
    duration int not null,
    service_id int not null references services (service_id)
);
create index operations_idx on operations (number_id, start_time, service_id);