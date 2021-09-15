CREATE DATABASE GuestHousegrc0396
GO

USE GuestHousegrc0396
GO

DROP TABLE calandar
DROP TABLE guest
DROP TABLE extra
DROP TABLE rate
DROP TABLE room
DROP TABLE room_type
DROP TABLE booking


--Questions
--1. Naming conventions
--2. Do forign keys have to have same name as forign table primary key
--3. Does our ERD have to look exactly like yours or can we add/remove fields
--4. Do we need to document what we did?

CREATE TABLE calandar (
    i DATETIME PRIMARY KEY
);

BULK INSERT calandar
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\calendar.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO


CREATE TABLE guest (
    id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    address VARCHAR(50)
);

BULK INSERT guest
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\guest.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

CREATE TABLE extra (
    extra_id INT PRIMARY KEY,
	booking_id INT,
	description VARCHAR(30),
	amount decimal
);
BULK INSERT extra
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\extra.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO
select * from extra

CREATE TABLE rate (
    room_type VARCHAR(6),
    occupancy INT,
    amount INT,
	PRIMARY KEY(room_type, occupancy)
);
BULK INSERT rate
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\rate.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO
select * from rate

CREATE TABLE room (
    id INT PRIMARY KEY,
    room_type VARCHAR(6),
    max_occupancy INT
);
BULK INSERT room
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\room.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO
select * from room

CREATE TABLE room_type (
    id VARCHAR(6) PRIMARY KEY,
    description VARCHAR(50)
);
BULK INSERT room_type
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\room_type.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

CREATE TABLE booking (
    booking_id INT PRIMARY KEY,
    booking_date DATETIME,
    room_no INT FOREIGN KEY REFERENCES room(id) NOT NULL,
    guest_id INT FOREIGN KEY REFERENCES guest(id) NOT NULL,
    occupants INT,
    room_type_requested VARCHAR(6),
    nights INT,
    arrival_time VARCHAR(10),
	FOREIGN KEY (room_type_requested, occupants) REFERENCES rate(room_type, occupancy),
	FOREIGN KEY (room_type_requested) REFERENCES room_type(id)
);
BULK INSERT booking
FROM 'C:\Users\grc0396\OneDrive - Ara Institute of Canterbury\Database\Assignment 2\DataFiles\booking.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO
select * from booking













