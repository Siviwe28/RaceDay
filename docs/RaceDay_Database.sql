CREATE DATABASE RaceDayPOE_Part1;

CREATE TABLE ROLES (
    Role_ID INT IDENTITY(1,1) PRIMARY KEY,
    Role_name VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(255)
);

CREATE TABLE USERS (
    User_ID INT IDENTITY(1,1) PRIMARY KEY,
    Role_ID INT NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(20),
    FOREIGN KEY (Role_ID) REFERENCES ROLES(Role_ID)
);

CREATE TABLE EVENTS (
    Event_ID INT IDENTITY(1,1) PRIMARY KEY,
    Organiser_ID INT NOT NULL,
    Event_Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500),
    Event_type VARCHAR(50) NOT NULL,
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NOT NULL,
    Location VARCHAR(200) NOT NULL,
    FOREIGN KEY (Organiser_ID) REFERENCES USERS(User_ID)
);

CREATE TABLE CATEGORIES (
    Cat_ID INT IDENTITY(1,1) PRIMARY KEY,
    Event_ID INT NOT NULL,
    Cat_Name VARCHAR(50) NOT NULL,
    Distance_KM DECIMAL(5,2) NOT NULL,
    Entry_Fee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Event_ID) REFERENCES EVENTS(Event_ID)
);

CREATE TABLE ENROLMENT (
    Enrol_ID INT IDENTITY(1,1) PRIMARY KEY,
    User_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Cat_ID INT NOT NULL,
    Reg_Date DATETIME NOT NULL DEFAULT GETDATE(),
    Status VARCHAR(20) NOT NULL DEFAULT 'Registered',
    Race_Number INT UNIQUE,
    FOREIGN KEY (User_ID) REFERENCES USERS(User_ID),
    FOREIGN KEY (Event_ID) REFERENCES EVENTS(Event_ID),
    FOREIGN KEY (Cat_ID) REFERENCES CATEGORIES(Cat_ID)
);
CREATE TABLE RESULTS (
    Results_ID INT IDENTITY(1,1) PRIMARY KEY,
    Enrol_ID INT NOT NULL UNIQUE,
    Finish_Time TIME,
    Position INT,
    Chip_Time TIME,
    FOREIGN KEY (Enrol_ID) REFERENCES ENROLMENT(Enrol_ID)
);

INSERT INTO ROLES (Role_name, Description) VALUES
('Organiser', 'Can create and manage events'),
('Participant', 'Can register for events and view results');

INSERT INTO USERS (Role_ID, Email, Password, First_Name, Last_Name, Phone) VALUES
(1, 'sarah.johnson@raceday.com', 'hashed_password_1', 'Sarah', 'Johnson', '0412345678'),
(1, 'michael.zhang@raceday.com', 'hashed_password_2', 'Michael', 'Zhang', '0423456789'),
(2, 'emma.wilson@email.com', 'hashed_password_3', 'Emma', 'Wilson', '0434567890'),
(2, 'james.anderson@email.com', 'hashed_password_4', 'James', 'Anderson', '0445678901'),
(2, 'olivia.martinez@email.com', 'hashed_password_5', 'Olivia', 'Martinez', '0456789012'),
(2, 'william.taylor@email.com', 'hashed_password_6', 'William', 'Taylor', '0467890123');

INSERT INTO EVENTS (Organiser_ID, Event_Name, Description, Event_type, Start_Date, End_Date, Location) VALUES
(1, 'Sydney Harbour 5K Run', 'Scenic 5K run around Sydney Harbour', '5K', '2026-10-15 08:00:00', '2026-10-15 12:00:00', 'Sydney Harbour, NSW'),
(1, 'Melbourne Marathon 2026', 'Full marathon through Melbourne CBD', 'Marathon', '2026-11-01 06:00:00', '2026-11-01 14:00:00', 'Melbourne CBD, VIC'),
(2, 'Brisbane Fun Run', 'Family-friendly 10K and 5K event', 'Fun Run', '2026-09-20 07:30:00', '2026-09-20 11:30:00', 'South Bank, Brisbane');

INSERT INTO CATEGORIES (Event_ID, Cat_Name, Distance_KM, Entry_Fee) VALUES
(1, 'Open 5K', 5.00, 45.00),
(1, 'Junior 5K', 5.00, 25.00),
(2, 'Full Marathon', 42.20, 120.00),
(2, 'Half Marathon', 21.10, 85.00),
(3, '10K Run', 10.00, 55.00),
(3, '5K Walk', 5.00, 35.00);

INSERT INTO ENROLMENT (User_ID, Event_ID, Cat_ID, Reg_Date, Status, Race_Number) VALUES
(3, 1, 1, '2026-08-01 10:30:00', 'Registered', 101),
(4, 1, 2, '2026-08-05 14:15:00', 'Registered', 102),
(5, 2, 3, '2026-07-15 09:00:00', 'Registered', 201),
(3, 2, 4, '2026-07-20 11:45:00', 'Registered', 202),
(6, 3, 5, '2026-08-10 08:20:00', 'Registered', 301),
(4, 3, 6, '2026-08-12 16:30:00', 'Registered', 302);

INSERT INTO RESULTS (Enrol_ID, Finish_Time, Position, Chip_Time) VALUES
(1, '00:22:15', 3, '00:22:10'),
(2, '00:28:45', 15, '00:28:30'),
(3, '03:45:22', 8, '03:45:15'),
(4, '01:52:30', 12, '01:52:25'),
(5, '00:48:10', 5, '00:48:05'),
(6, '00:32:00', 20, '00:31:50');

select * from EVENTS


