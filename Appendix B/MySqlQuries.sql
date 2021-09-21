USE [GuestHouse2021-grc0396]
GO

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
SELECT * FROM [dbo].[booking] WHERE [room_no] = 101 AND [booking_date] = '2016-11-17'

--Q2. Give the booking date and the number of nights for guest 1540.
SELECT [guest_id], [booking_date], [nights] FROM [dbo].[booking] WHERE [guest_id] = 1540

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

SELECT b.[booking_id], b.[room_type_requested], b.[occupants], r.[amount]
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

SELECT * FROM [dbo].[booking] WHERE [guest_id] = 1270

SELECT [guest_id], COUNT([guest_id]) AS 'Number of Bookings', SUM([nights]) AS 'Total Nights Stayed'
FROM [dbo].[booking]
WHERE [guest_id] = 1185 or [guest_id] = 1270 GROUP BY [guest_id]


--Q7. Show the total amount payable by guest Ruth Cadbury(1064) for her room bookings. You should JOIN to the rate
--table using room_type_requested and occupants.
SELECT * FROM [dbo].[booking] WHERE [guest_id] = 1064

SELECT b.[guest_id], SUM(r.[amount]) AS 'Amount Payable'
FROM [dbo].[booking] b
JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[guest_id] = 1064 GROUP BY b.[guest_id]

--Q8. Calculate the total bill for booking 5346 including extras.
-- NOTE: HOW DOES TWO PEOPLE FOR ONE NIGHT CONSUME X5 BREAKFAST??????????
SELECT * FROM [dbo].[booking] WHERE [booking_id] = 5346 -- COST $72 +
SELECT * FROM [dbo].[extra] WHERE [booking_id] = 5346 -- COST $ 46.56 = 118.56

SELECT b.[booking_id], r.[amount] AS 'Total AMount'
FROM [dbo].[booking] b
JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
JOIN [dbo].[extra] e ON b.[booking_id] = e.[booking_id]
WHERE b.[booking_id] = 5346
GROUP BY b.[booking_id]

SELECT b.[booking_id], b.[room_type_requested], b.[occupants], r.[amount], e.[amount]
FROM [dbo].[booking] b
JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
inner JOIN [dbo].[extra] e ON b.[booking_id] = e.[booking_id]
WHERE b.[booking_id] = 5346


