DELETE FROM grouplists WHERE student_id NOT IN (SELECT student_id FROM marks WHERE points < 60); -- 1

DELETE FROM grouplists WHERE student_id IN (SELECT student_id FROM marks WHERE points < 60 GROUP BY student_id HAVING count(*) >= 3); -- 2

DELETE FROM groups WHERE group_id NOT IN (SELECT group_id FROM grouplists); -- 3

DROP VIEW IF EXISTS Losers; -- 4
CREATE VIEW Losers AS SELECT student_name, count(*) FROM marks NATURAL JOIN students NATURAL JOIN grouplists WHERE points < 60 GROUP BY student_name;

DROP MATERIALIZED VIEW IF EXISTS LosersT; -- 5
CREATE MATERIALIZED VIEW LosersT AS (SELECT student_name, count(*) FROM marks NATURAL JOIN students NATURAL JOIN grouplists WHERE points < 60 GROUP BY student_name);

DROP FUNCTION IF EXISTS refresh_loserst() CASCADE;
CREATE FUNCTION refresh_loserst() RETURNS trigger AS $refresh_loserst$ 
BEGIN
	REFRESH MATERIALIZED VIEW LosersT;
	RETURN NEW;
END; 
$refresh_loserst$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS refresh_loserst ON LosersT;
CREATE TRIGGER refresh_loserst AFTER UPDATE ON marks
	EXECUTE PROCEDURE refresh_loserst();

-- DROP FUNCTION IF EXISTS refresh_loserst() CASCADE; -- 6

DROP FUNCTION IF EXISTS not_decrease_mark() CASCADE; -- 9
CREATE FUNCTION not_decrease_mark() RETURNS trigger AS $decrease_mark$ 
BEGIN
	IF (NEW.points < OLD.points) THEN	
		RAISE EXCEPTION 'student % already has % points', NEW.student_id, OLD.points;
	END IF;
	RETURN NEW;
END; 
$decrease_mark$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS not_decrease_marks ON marks;
CREATE TRIGGER not_decrease_marks BEFORE UPDATE ON marks
	FOR EACH ROW EXECUTE PROCEDURE not_decrease_mark();