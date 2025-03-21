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
