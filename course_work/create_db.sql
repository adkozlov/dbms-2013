drop table if exists employees cascade;
create table employees (
    employee_id serial primary key,
    first_name varchar(25) not null check (first_name != ''),
    last_name varchar(25) not null check (last_name != ''),
    unique (first_name, last_name)
);

drop table if exists numbers cascade;
create table numbers (
    number_id serial primary key,
    phone varchar(12) not null unique check (phone != '')
);

drop table if exists tariffs cascade;
create table tariffs (
    tariff_id serial primary key,
    tariff_name varchar(20) not null unique check (tariff_name != '')
);

drop table if exists contracts cascade;
create table contracts (
    contract_id serial primary key,
    employee_id int not null references employees (employee_id),
    number_id int not null references numbers (number_id),
    tariff_id int not null references tariffs (tariff_id),
    start_time timestamp not null,
    finish_time timestamp check (finish_time >= start_time)
);

drop table if exists units cascade;
create table units (
    unit_id serial primary key,
    abbreviation varchar(5) not null unique check (abbreviation != '')
);

drop table if exists services cascade;
create table services (
    service_id serial primary key,
    service_name varchar(10) not null unique check (service_name != ''),
    unit_id int not null references units(unit_id)
); -- слабая сущность?

drop table if exists tariff_service_costs cascade;
create table tariff_service_costs (
    tariff_id int references tariffs (tariff_id),
    service_id int references services (service_id),
    cost_per_unit money not null,
    primary key (tariff_id, service_id)
);

drop table if exists operations cascade;
create table operations (
    operation_id serial primary key,
    number_id int not null references numbers (number_id),
    destination varchar(20) not null,
    start_time timestamp not null,
    duration int not null,
    service_id int not null references services (service_id)
);