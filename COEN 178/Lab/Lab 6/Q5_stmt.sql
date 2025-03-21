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
