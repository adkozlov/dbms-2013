-- create
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS planes CASCADE;
CREATE TABLE planes (
	plane_id SERIAL PRIMARY KEY,
	model VARCHAR(10) NOT NULL,
	seats_count INT NOT NULL CHECK (seats_count > 0)
);

DROP TABLE IF EXISTS seats CASCADE;
CREATE TABLE seats (
	seat_id SERIAL PRIMARY KEY,
	plane_id INT NOT NULL REFERENCES planes (plane_id),
	seat_no INT NOT NULL CHECK (seat_no > 0)
);

DROP TABLE IF EXISTS flights CASCADE;
CREATE TABLE flights (
	flight_id SERIAL PRIMARY KEY,
	departure_time TIMESTAMP NOT NULL,
	plane_id INT NOT NULL REFERENCES planes (plane_id),
	is_blocked BOOLEAN NOT NULL DEFAULT FALSE
);

DROP TABLE IF EXISTS bookings CASCADE;
CREATE TABLE bookings (
	booking_id SERIAL PRIMARY KEY,
	last_update TIMESTAMP NOT NULL
);
	

DROP TABLE IF EXISTS tickets;
CREATE TABLE tickets (
	ticket_id SERIAL PRIMARY KEY,
	flight_id INT NOT NULL REFERENCES flights (flight_id),
	seat_id INT NOT NULL REFERENCES seats (seat_id),
	customer_id INT NOT NULL REFERENCES customers (customer_id),
	booking_id INT NOT NULL REFERENCES bookings (booking_id),
	UNIQUE (flight_id, seat_id)
);

-- fill
INSERT INTO customers (name) VALUES
	('Андрей Козлов'),
	('Андрей Васин')
;

INSERT INTO planes (model, seats_count) VALUES
	('Boeing 737', 21),
	('Ту-154', 18)
;

INSERT INTO seats (plane_id, seat_no)
	SELECT 1, x.id FROM generate_series(1, 21) AS x(id);
INSERT INTO seats (plane_id, seat_no)
	SELECT 2, x.id FROM generate_series(1, 18) AS x(id);

INSERT INTO flights (departure_time, plane_id) VALUES
	('2014-01-01 12:00:00', 1),
	('2013-12-02 02:00:00', 1),
	(localtimestamp + '1 day', 1)
;

INSERT INTO bookings (last_update) VALUES
	('2013-11-27')
;

INSERT INTO tickets (flight_id, seat_id, customer_id, booking_id) VALUES
	(3, 5, 1, 1)
;

-- tasks
CREATE OR REPLACE VIEW available_seats AS
	SELECT flight_id, seat_no, seat_id FROM flights NATURAL JOIN seats WHERE ((departure_time - localtimestamp) >= INTERVAL '2 hour') AND NOT is_blocked
	EXCEPT ALL
	SELECT flight_id, seat_no, seat_id FROM tickets NATURAL JOIN seats;

CREATE OR REPLACE VIEW cancelled_bookings AS
	SELECT flight_id, seat_no, seat_id FROM flights NATURAL JOIN tickets NATURAL JOIN seats NATURAL JOIN bookings WHERE (departure_time - last_update >= INTERVAL '2 days') AND (localtimestamp - last_update >= INTERVAL '1 day') AND NOT is_blocked;

-- 1
CREATE OR REPLACE FUNCTION free_seats(flight_id_ INT) RETURNS TABLE (seat_no_ INT, seat_id_ INT) AS $$
	BEGIN
		RETURN QUERY (SELECT seat_no, seat_id FROM (SELECT * FROM available_seats UNION SELECT * FROM cancelled_bookings) AS avs WHERE flight_id = flight_id_);
	END;
$$ LANGUAGE plpgsql;