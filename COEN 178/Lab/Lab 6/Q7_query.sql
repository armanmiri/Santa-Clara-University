INSERT INTO User (phlid, email, pswd) 
VALUES (10005, "george@scu.edu", "simple password");

INSERT INTO PHLogger (phlid, name, address_street, address_city, address_state, address_pcode)
VALUES (10005, "George", "this street", "that city", "CA", "95053");

SELECT * 
FROM Member
WHERE phlid = 10005;
