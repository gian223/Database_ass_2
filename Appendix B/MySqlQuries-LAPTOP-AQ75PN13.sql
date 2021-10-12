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

SET STATISTICS IO ON
GO

SET STATISTICS TIME ON
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
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[booking_id] = 5152 OR b.[booking_id] = 5165 OR b.[booking_id] = 5154 OR b.[booking_id] = 5295


--Q5. Find who is staying in room 101 on 2016-12-03, include first name, last name and address.
SELECT b.[guest_id], b.[room_no], b.[booking_date], CONCAT(g.[first_name], ' ', g.[last_name]) AS 'Guest', g.[address]
FROM [dbo].[booking] b
JOIN [dbo].[guest] g ON b.[guest_id] = g.[id]
WHERE b.[room_no] = 101 AND b.[booking_date] = '2016-12-03'

--Q6. For guests 1185 and 1270 show the number of bookings made and the total number of nights. Your output should include
--the guest id and the total number of bookings and the total number of nights.

SELECT * FROM [dbo].[booking] WHERE [guest_id] = 1185

SELECT [guest_id], COUNT([guest_id]) AS 'Number of Bookings', SUM([nights]) AS 'Total Nights Stayed'
FROM [dbo].[booking]
WHERE [guest_id] = 1185 or [guest_id] = 1270 GROUP BY [guest_id]


--Q7. Show the total amount payable by guest Ruth Cadbury(1064) for her room bookings. You should JOIN to the rate
--table using room_type_requested and occupants.
SELECT * FROM [dbo].[booking] WHERE [guest_id] = 1064
select * from [dbo].[rate]

SELECT b.[guest_id], SUM(r.[amount] * b.[nights]) AS 'Amount Payable'
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[guest_id] = 1064 
GROUP BY b.[guest_id]


--Q8. Calculate the total bill for booking 5346 including extras.
-- NOTE: HOW DOES TWO PEOPLE FOR ONE NIGHT CONSUME X5 BREAKFAST??????????
SELECT * FROM [dbo].[booking] WHERE [booking_id] = 5346 -- COST $72 +
SELECT * FROM [dbo].[extra] WHERE [booking_id] = 5346 -- COST $ 46.56 = 118.56



SELECT [booking_id], SUM(TOTAL) AS 'Total Bill'  
FROM 
(SELECT b.[booking_id], SUM(r.[amount]) AS 'TOTAL' 
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[booking_id] = 5346
GROUP BY b.[booking_id]
UNION 
select e.[booking_id], SUM(e.amount)  AS 'TOTAL' 
FROM [dbo].[extra] e 
WHERE e.[booking_id] = 5346
GROUP BY e.[booking_id]
) d 
GROUP BY [booking_id]


-- Average execution time 40 ms
WITH total as(
SELECT SUM(r.[amount]) AS 'rowtotal'
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[booking_id] = 5346
UNION
select SUM(e.amount) 
FROM [dbo].[extra] e 
WHERE e.[booking_id] = 5346
) SELECT SUM(rowtotal) AS 'Total Bill' from total 


SELECT(
(SELECT SUM(r.[amount])
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
WHERE b.[booking_id] = 5346)
+
(select SUM(e.amount) 
FROM [dbo].[extra] e 
WHERE e.[booking_id] = 5346)
) AS 'Total Bill'



--Q9. For every guest who has the word “Edinburgh” in their address show the total number of nights booked.
--Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and
--number of nights. Order by last name then first name.
select g.[id], g.[last_name], g.[first_name], g.[address], COALESCE(SUM(b.[nights]),0) AS 'Nights Booked'
FROM [dbo].[guest] g
left outer JOIN [dbo].[booking] b ON b.[guest_id] = g.[id]
where g.[address] LIKE '%Edinburgh%'
GROUP BY g.[id], g.[last_name], g.[first_name], g.[address]
ORDER BY g.[last_name] ASC, g.[first_name] ASC


--Q10. For each day of the week beginning 2016-11-25 show the number of bookings starting that day. Be sure to show
--all the days of the week in the correct order.
SELECT COUNT(*) 
FROM [dbo].[booking] b 
WHERE [booking_date] = '2016-11-25'

SELECT DISTINCT b.[booking_date], DATENAME(dw, b.[booking_date]) AS 'Day of Week', COUNT(b.[booking_date]) AS 'Nights'
FROM [dbo].[booking] b 
WHERE [booking_date] BETWEEN '2016-11-25' AND '2016-12-01'
GROUP BY b.[booking_date]
ORDER BY b.[booking_date] ASC

--Q11. Show the number of guests in the hotel on the night of 2016-11-21. Include all occupants who checked in that
--day but not those who checked out.
--NOTE: THERE IS ONLY ARRIVAL TIME NOT CHECKOUT TIME?
SELECT b.[booking_id], b.[booking_date], b.[room_no], b.[nights] 
FROM [dbo].[booking] b 
WHERE b.[booking_date] BETWEEN '2016-11-17' AND '2016-11-21'
ORDER BY b.[booking_date] ASC

SELECT [booking_id], [booking_date] + [nights], [room_no], [nights] 
FROM [dbo].[booking] 
WHERE [booking_date] BETWEEN '2016-11-17' AND '2016-11-21'
ORDER BY [booking_date] ASC

DECLARE @date DATE
SET @date = '2016-11-21'
SELECT [booking_date], [nights] 
FROM [dbo].[booking] 
WHERE [booking_date] <= @date 
ORDER BY [booking_date] desc

SELECT DATEADD(day, [nights], [booking_date]) AS 'DateAdd' 
FROM [dbo].[booking] 
WHERE [booking_date] = '2016-11-21'

SELECT [booking_id], SUM([booking_date])
FROM 
(SELECT [booking_id], COUNT([booking_date]) 
FROM [dbo].[booking] 
WHERE [booking_date] BETWEEN '2016-11-17' AND '2016-11-21' AND [nights] >= 5
GROUP BY [booking_id]
UNION 


SELECT * 
FROM [dbo].[booking] b 
WHERE [booking_date] = '2016-11-21'

SELECT SUM(b.[occupants]) 
FROM [dbo].[booking] b 
WHERE [booking_date] = '2016-11-21'


--Q12. List the rooms that are free on the day 25th Nov 2016.
SELECT DISTINCT b.[room_no]
FROM [dbo].[booking] b
WHERE b.[booking_date] = '2016-11-25'

SELECT r.[id]  
FROM [dbo].[room] r
WHERE r.[id] NOT IN 
(SELECT b.[room_no]
FROM [dbo].[booking] b
WHERE b.[booking_date] = '2016-11-25')









