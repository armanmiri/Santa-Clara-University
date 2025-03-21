-- q1 query

SELECT p.phlid, p.name, ( 
    SELECT MAX(e.start) 
    FROM Event e 
    WHERE e.phlid = p.phlid
) AS recent_event_start
FROM PHLogger p
WHERE p.phlid IN (
    SELECT m.phlid
    FROM Member m, Interest i
    WHERE m.iname = i.iname
        AND i.topic = 'alcoholism'
)
AND p.phlid IN (
    SELECT t.phlid
    FROM Thought t, About a, Interest i2
    WHERE t.phlid = a.phlid
        AND t.tnum = a.tnum
        AND a.iname = i2.iname
        AND t.text LIKE '%wasted%'
        AND i2.topic = 'alcoholism'
)
AND p.phlid IN (
    SELECT e.phlid
    FROM Event e
)
ORDER BY p.phlid;


-- q2 query

SELECT p.phlid, p.name, ( 
    SELECT MAX(e.start) 
    FROM Event e 
    WHERE e.phlid = p.phlid
) AS recent_event_start
FROM PHLogger p
WHERE p.phlid IN (
    SELECT m.phlid
    FROM Member m, Interest i
    WHERE m.iname = i.iname
        AND i.topic = 'alcoholism'
)
AND p.phlid IN (
    SELECT t.phlid
    FROM Thought t, About a, Interest i2
    WHERE t.phlid = a.phlid
        AND t.tnum = a.tnum
        AND a.iname = i2.iname
        AND t.text LIKE '%wasted%'
        AND i2.topic = 'alcoholism'
)
AND p.phlid IN (
    SELECT e.phlid
    FROM Event e
)
ORDER BY p.phlid;

-- q3 query

SELECT COUNT(DISTINCT m.phlid) as num_users_no_post
FROM Member m
WHERE NOT EXISTS (
  SELECT *
    FROM About a, Thought t
    WHERE a.phlid = t.phlid
    And t.phlid = m.phlid
    AND a.iname = m.iname
    AND a.tnum = t.tnum
)

-- q4a stmt

DROP VIEW IF EXISTS Heart_rate_view;
CREATE VIEW Heart_rate_view AS
  SELECT ob.observation_id, p.phlid, 
    p.name, ob.rate, obs.kind, obs.software_version, 
    obs.manufacturer, obs.model
  FROM PHLogger p, Observer obs, Observable ob, Observation o
  WHERE p.phlid = obs.phlid
    AND ob.observer_id = obs.observer_id
    AND ob.kind = 'heartrate';

-- q4b query

WITH
h1 AS (
  SELECT h1.phlid, h1.name, h1.kind, h1.manufacturer, 
    h1.model, h1.software_version,
         AVG(h1.rate) AS series_avg_rate
  FROM Heart_rate_view h1
  GROUP BY h1.phlid, h1.name, h1.kind, 
    h1.manufacturer, h1.model, h1.software_version
),
h2 AS (
  SELECT h2.phlid, AVG(h2.rate) AS overall_avg_rate
  FROM Heart_rate_view h2
  GROUP BY h2.phlid
)
SELECT h1.phlid, h1.name, h1.kind, h1.manufacturer, 
  h1.model, h1.software_version, h1.series_avg_rate, 
  h2.overall_avg_rate
FROM h1, h2
WHERE h1.phlid = h2.phlid
  AND h1.series_avg_rate < h2.overall_avg_rate * 0.8
ORDER BY h1.phlid;

-- q5 smt

DROP PROCEDURE IF EXISTS AddThought;
DELIMITER //
CREATE PROCEDURE AddThought(
    IN in_phlid VARCHAR(8),
    IN in_iname VARCHAR(20),
    IN in_text VARCHAR(300)
)
BEGIN
    DECLARE new_tnum INT;
    SELECT IFNULL(MAX(t.tnum), 0) + 1 INTO new_tnum
    FROM Thought t
    WHERE t.phlid = in_phlid;
    INSERT INTO Thought(phlid, tnum, text, date)
    VALUES (in_phlid, new_tnum, in_text, NOW());
    INSERT INTO About(phlid, tnum, iname)
    VALUES (in_phlid, new_tnum, in_iname);
END//
DELIMITER ;

-- q5 query

CALL AddThought('1', 'alcoholism 0', 'PHLogger APP IS THE BEST!');

SELECT *
FROM About a, Thought t
WHERE a.phlid = 1
  AND t.phlid = a.phlid
  AND a.tnum = t.tnum
  AND t.text LIKE 'PHLogger%';


-- q6 stmt

ALTER TABLE Thought DROP FOREIGN KEY Thought_ibfk_1;

ALTER TABLE Thought 
  ADD FOREIGN KEY (phlid) REFERENCES User(phlid);

-- q6 query

DELETE FROM PHLogger WHERE phlid = '4';

SELECT COUNT(*) AS num_thoughts FROM Thought WHERE phlid = '4';


-- q7a stmt


DROP TRIGGER IF EXISTS CheckPHLoggerExist;
DELIMITER //
CREATE TRIGGER CheckPHLoggerExist
BEFORE INSERT ON Thought
FOR EACH ROW
BEGIN
    IF NEW.phlid IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM PHLogger WHERE phlid = NEW.phlid
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'ERROR: PHLogger does not exist!';
        END IF;
    END IF;
END//
DELIMITER ;


-- q7b stmt


DROP TRIGGER IF EXISTS AutoJoinAndHello;

DELIMITER //
CREATE TRIGGER AutoJoinAndHello
AFTER INSERT ON PHLogger
FOR EACH ROW
BEGIN
    DECLARE rand_iname VARCHAR(20);
    DECLARE new_tnum   INT;

    SELECT iname
    INTO rand_iname
    FROM Interest
    ORDER BY RAND()
    LIMIT 1;

    INSERT INTO Member (phlid, iname)
    VALUES (NEW.phlid, rand_iname);

    SELECT IFNULL(MAX(t.tnum), 0) + 1
    INTO new_tnum
    FROM Thought t
    WHERE t.phlid = NEW.phlid;

    INSERT INTO Thought (phlid, tnum, text, date)
    VALUES (NEW.phlid, new_tnum, 'Hello!', NOW());

    INSERT INTO About (phlid, tnum, iname)
    VALUES (NEW.phlid, new_tnum, rand_iname);
END;
//
DELIMITER ;


-- q7c query

INSERT INTO User (phlid, email, pswd) 
VALUES (10005, "george@scu.edu", "simple password");

INSERT INTO PHLogger (phlid, name, address_street, address_city, address_state, address_pcode)
VALUES (10005, "George", "this street", "that city", "CA", "95053");

SELECT * 
FROM Member
WHERE phlid = 10005;
