DROP DATABASE IF EXISTS lab2;
CREATE DATABASE lab2;
USE lab2;

CREATE TABLE User (
    phlid INT NOT NULL,
    PRIMARY KEY (phlid),
    email VARCHAR(255) NOT NULL,
    pswd VARCHAR(255) NOT NULL
);

CREATE TABLE PHLogger (
    phlid INT NOT NULL,
    PRIMARY KEY (phlid),
    name VARCHAR(255) NOT NULL,
    address_street VARCHAR(255),
    address_city VARCHAR(255),
    address_state VARCHAR(255),
    address_pcode VARCHAR(255),
    contact VARCHAR(255),
    FOREIGN KEY (phlid) REFERENCES User(phlid) ON DELETE CASCADE
);

CREATE TABLE Supporter (
    phlid INT NOT NULL,
    PRIMARY KEY (phlid),
    role VARCHAR(255),
    phone VARCHAR(255),
    FOREIGN KEY (phlid) REFERENCES User(phlid) ON DELETE CASCADE
);

CREATE TABLE Observation (
    observation_id INT NOT NULL, 
    PRIMARY KEY (observation_id),
    phlid INT NOT NULL,
    start DATETIME NOT NULL,
    end DATETIME,
    FOREIGN KEY (phlid) REFERENCES User(phlid) ON DELETE CASCADE
);

CREATE TABLE Heart_Rate (
    observation_id INT NOT NULL, 
    PRIMARY KEY (observation_id),
    rate INT NOT NULL,
    FOREIGN KEY (observation_id) REFERENCES Observation(observation_id) ON DELETE CASCADE
);

CREATE TABLE Blood_Pr (
    observation_id INT NOT NULL, 
    PRIMARY KEY (observation_id),
    diastolic INT NOT NULL,
    systolic INT NOT NULL,
    FOREIGN KEY (observation_id) REFERENCES Observation(observation_id) ON DELETE CASCADE
);

CREATE TABLE Picture (
    observation_id INT NOT NULL, 
    PRIMARY KEY (observation_id),
    description VARCHAR(255),
    label VARCHAR(255),
    image TEXT,
    FOREIGN KEY (observation_id) REFERENCES Observation(observation_id) ON DELETE CASCADE
);

CREATE TABLE Observer (
    observer_id INT NOT NULL, 
    PRIMARY KEY (observer_id),
    phlid INT NOT NULL,
    kind VARCHAR(255),
    model VARCHAR(255),
    manufacturer VARCHAR(255),
    software_version VARCHAR(255),
    FOREIGN KEY (phlid) REFERENCES PHLogger(phlid) ON DELETE CASCADE
);

CREATE TABLE Obserervable (
    observation_id INT NOT NULL,
    PRIMARY KEY (observation_id),
    observer_Id INT NOT NULL,
    text VARCHAR(255) NOT NULL,
    observation_type ENUM('Heart_Rate', 'Blood_Pr', 'Picture') NOT NULL,
    comment VARCHAR(255),
    rate INT,             
    diastolic INT,        
    systolic INT,   
    description VARCHAR(255),      
    label VARCHAR(255),   
    image TEXT,           
    FOREIGN KEY (observer_Id) REFERENCES Observer(observer_Id),
    FOREIGN KEY (observation_id) REFERENCES Observation(observation_id) ON DELETE CASCADE
);

CREATE TABLE Event (
    eid INT NOT NULL,
    PRIMARY KEY (eid),
    phlid INT NOT NULL,
    ename VARCHAR(255) NOT NULL,
    start DATETIME NOT NULL,
    end DATETIME,
    origin VARCHAR(255),
    FOREIGN KEY (phlid) REFERENCES PHLogger(phlid) ON DELETE CASCADE
);

CREATE TABLE Interest (
    iname VARCHAR(255),
    PRIMARY KEY (iname),
    description TEXT NOT NULL,
    topic VARCHAR(255) NOT NULL,
    date DATE NOT NULL
);

CREATE TABLE Thought (
    tnum INT NOT NULL,
    phlid INT NOT NULL,
    PRIMARY KEY (tnum, phlid),
    text TEXT NOT NULL,
    date DATE
);


/* SQL DDLs for Relationships */


CREATE TABLE Member (
    phlid INT,
    iname INT,
    PRIMARY KEY (phlid, iname),
    FOREIGN KEY (phlid) REFERENCES PHLogger(phlid) ON DELETE CASCADE,
    FOREIGN KEY (iname) REFERENCES Interest(iname) ON DELETE CASCADE
);


CREATE TABLE Indicate (
    observation_id INT,
    eid INT,
    PRIMARY KEY (observation_id, eid),
    FOREIGN KEY (observation_id) REFERENCES Observation(observation_id) ON DELETE CASCADE,
    FOREIGN KEY (eid) REFERENCES Event(eid) ON DELETE CASCADE
);


CREATE TABLE About (
    tnum INT,
    iname INT,
    phlid INT,
    PRIMARY KEY (tnum, iname, phlid),
    FOREIGN KEY (tnum, phlid) REFERENCES Thought(tnum, phlid) ON DELETE CASCADE,
    FOREIGN KEY (iname) REFERENCES Interest(iname) ON DELETE CASCADE
);
