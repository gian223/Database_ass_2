USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW v_booking_date AS 
SELECT g.[id], g.[first_name], g.[last_name], b.[booking_date], b.[room_no]
FROM [dbo].[guest] g 
INNER JOIN [dbo].[booking] b ON b.[guest_id] = g.[id]
GO

SELECT * FROM v_booking_date WHERE [booking_date] = '2016-11-26'


