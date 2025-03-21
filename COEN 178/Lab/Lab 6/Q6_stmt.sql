ALTER TABLE Thought DROP FOREIGN KEY Thought_ibfk_1;

ALTER TABLE Thought 
  ADD FOREIGN KEY (phlid) REFERENCES User(phlid);
