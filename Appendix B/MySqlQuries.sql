-- github https://github.com/gian223/Database_ass_2

USE [GuestHouse2021-grc0396]
GO
USE [GuestHouse2021GC]
GO

SET statistics io ON
GO

SET statistics time ON
GO

-- I BULK INSERTED THE EXTRA TABLE BECAUSE I WANTED TO CLEAN THE DATA FIRST
BULK INSERT Extra
FROM 'C:\Users\Gian\OneDrive - Ara Institute of Canterbury\Database\Assignment_2\Appendix B\extra.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
GO

--Q1. List the people who has booked room number 101 on 17th November 2016.
SELECT * 
FROM [dbo].[booking] 
WHERE [room_no] = 101 AND [booking_date] = '2016-11-17'



--Q2. Give the booking date and the number of nights for guest 1540.
SELECT [guest_id], [booking_date], [nights] 
FROM [dbo].[booking] 
WHERE [guest_id] = 1540



--Q3. List the arrival time and the first and last names for all guests due to arrive on
--2016-11-05, order the output by time of arrival.
SELECT b.[booking_date], b.[arrival_time], CONCAT(g.[first_name], ' ', g.[last_name]) AS 'Guest'
FROM [dbo].[booking] b
INNER JOIN [dbo].[guest] g ON g.[id] = b.[guest_id]
WHERE b.[booking_date] = '2016-11-05'
ORDER BY b.[arrival_time] ASC



--Q4. Give the daily rate that should be paid for bookings with ids 5152, 5165, 5154 and 5295.
--Include booking id, room type, number of occupants and the amount.
-- NOTE: BOOKING ID 5165 DOES NOT EXIST!
SELECT b.[booking_id], r.[room_type], b.[occupants], r.[amount]
FROM [dbo].[booking] b
JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[booking_id] = 5152 OR b.[booking_id] = 5165 OR b.[booking_id] = 5154 OR b.[booking_id] = 5295



--Q5. Find who is staying in room 101 on 2016-12-03, include first name, last name and address.
SELECT b.[guest_id], b.[room_no], b.[booking_date], CONCAT(g.[first_name], ' ', g.[last_name]) AS 'Guest', g.[address]
FROM [dbo].[booking] b
JOIN [dbo].[guest] g ON b.[guest_id] = g.[id]
WHERE b.[room_no] = 101 AND b.[booking_date] = '2016-12-03'



--Q6. For guests 1185 and 1270 show the number of bookings made and the total number of nights. Your output should include
--the guest id and the total number of bookings and the total number of nights.
SELECT [guest_id], COUNT([guest_id]) AS 'Number of Bookings', SUM([nights]) AS 'Total Nights Stayed'
FROM [dbo].[booking]
WHERE [guest_id] = 1185 or [guest_id] = 1270 GROUP BY [guest_id]



--Q7. Show the total amount payable by guest Ruth Cadbury(1064) for her room bookings. You should JOIN to the rate
--table using room_type_requested and occupants.
SELECT b.[guest_id], g.[first_name], g.[last_name], SUM(r.[amount] * b.[nights]) AS 'Amount Payable'
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
INNER JOIN [dbo].[guest] g ON b.[guest_id] = g.[id]
WHERE g.[first_name] = 'Ruth' AND g.[last_name] = 'Cadbury' 
GROUP BY b.[guest_id], g.[first_name], g.[last_name]
GO



--Q8. Calculate the total bill for booking 5346 including extras.
CREATE OR ALTER VIEW guestBookingRate AS 
SELECT b.[booking_id], b.[nights], r.[amount] AS 'rate_per_night'
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
GROUP BY b.[booking_id], r.[amount], b.[nights]
GO

select * from guestBookingRate
go

CREATE OR ALTER VIEW guestExtras AS 
SELECT [booking_id], SUM([amount]) AS 'total_extras'
FROM [dbo].[extra] e 
GROUP BY [booking_id]
GO

select * from guestExtras
go

SELECT ge.[booking_id], SUM(ge.total_extras + (br.rate_per_night * br.[nights])) AS 'Total Payable' 
FROM [dbo].[guestExtras] ge 
INNER JOIN [dbo].[guestBookingRate] br ON ge.[booking_id] = br.[booking_id]
WHERE ge.[booking_id] = 5346
GROUP BY ge.[booking_id]
GO



--Q9. For every guest who has the word “Edinburgh” in their address show the total number of nights booked.
--Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and
--number of nights. Order by last name then first name.
SELECT g.[id], g.[last_name], g.[first_name], g.[address], COALESCE(SUM(b.[nights]),0) AS 'Nights Booked'
FROM [dbo].[guest] g
left outer JOIN [dbo].[booking] b ON b.[guest_id] = g.[id]
WHERE g.[address] LIKE '%Edinburgh%'
GROUP BY g.[id], g.[last_name], g.[first_name], g.[address]
ORDER BY g.[last_name] ASC, g.[first_name] ASC



--Q10. For each day of the week beginning 2016-11-25 show the number of bookings starting that day. Be sure to show
--all the days of the week in the correct order.
SELECT DISTINCT b.[booking_date], DATENAME(dw, b.[booking_date]) AS 'Day of Week', COUNT(b.[booking_date]) AS 'Bookings'
FROM [dbo].[booking] b 
WHERE [booking_date] BETWEEN '2016-11-25' AND '2016-12-01'
GROUP BY b.[booking_date]
ORDER BY b.[booking_date] ASC




--Q11. Show the number of guests in the hotel on the night of 2016-11-21. Include all occupants who checked in that
--day but not those who checked out.
SELECT [booking_id], [booking_date], [nights], 
DATEADD(day, CASE WHEN [nights] = 1 THEN 1 ELSE [nights] END, [booking_date]) AS 'Depparture date' 
FROM [dbo].[booking]
WHERE '2016-11-21' BETWEEN [booking_date] AND DATEADD(day, CASE WHEN [nights] = 1 THEN 1 ELSE [nights]-1 END, [booking_date])
ORDER BY [booking_date] DESC

-- Display the total guests
SELECT SUM([occupants])  AS 'Total Guests'
FROM [dbo].[booking]
WHERE '2016-11-21' BETWEEN [booking_date] AND DATEADD(day, CASE WHEN [nights] = 1 THEN 1 ELSE [nights]-1 END, [booking_date])




--Q12. List the rooms that are free on the day 25th Nov 2016.
select [id] 
from [dbo].[room] 
where [id] NOT IN (
SELECT distinct [room_no] AS 'Rooms Available'
FROM [dbo].[booking]
WHERE '2016-11-25' BETWEEN [booking_date] AND DATEADD(day, CASE WHEN [nights] = 1 THEN 1 ELSE [nights]-1 END, [booking_date])
)










