CREATE DATABASE GuestHousegrc0396
GO

DROP DATABASE GuestHousegrc0396
GO

USE GuestHousegrc0396
GO
use MagazineEX
GO

DROP TABLE calendar

-- CALENDAR TABLE
CREATE TABLE calendar (
    i DATE PRIMARY KEY
);

BULK INSERT calendar
FROM 'C:\Users\grc0396\DataFiles\calendar.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

-- GUEST TABLE
CREATE TABLE guest (
    id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    address VARCHAR(50)
);

BULK INSERT guest
FROM 'C:\Users\grc0396\DataFiles\guest.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

-- ROOM_TYPE TABLE
CREATE TABLE room_type (
    id VARCHAR(6) PRIMARY KEY,
    description VARCHAR(50)
);
BULK INSERT room_type
FROM 'C:\Users\grc0396\DataFiles\room_type.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

-- RATE TABLE
CREATE TABLE rate (
    room_type VARCHAR(6) FOREIGN KEY REFERENCES room_type(id) NOT NULL,
    occupancy INT,
    amount INT,
	PRIMARY KEY(room_type, occupancy)
);
BULK INSERT rate
FROM 'C:\Users\grc0396\DataFiles\rate.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

-- ROOM TABLE
CREATE TABLE room (
    id INT PRIMARY KEY,
    room_type VARCHAR(6) FOREIGN KEY REFERENCES room_type(id) NOT NULL,
    max_occupancy INT
);
BULK INSERT room
FROM 'C:\Users\grc0396\DataFiles\room.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

-- BOOKING TABLE
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
FROM 'C:\Users\grc0396\DataFiles\booking.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

-- EXTRA TABLE
CREATE TABLE extra (
    extra_id INT PRIMARY KEY,
	booking_id INT FOREIGN KEY REFERENCES booking(booking_id) NOT NULL,
	description VARCHAR(30),
	amount decimal
);
BULK INSERT extra
FROM 'C:\Users\grc0396\DataFiles\extra.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

select * from booking













