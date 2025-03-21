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
