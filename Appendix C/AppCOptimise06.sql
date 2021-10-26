USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW v_booking_details AS 
SELECT b.[booking_id], g.[id] AS 'guest_id' , g.[first_name], g.[last_name], b.[occupants], b.[booking_date], 
DATEADD(day, CASE WHEN b.[nights] = 1 THEN 1 ELSE b.[nights] END, b.[booking_date]) AS 'Checkout', 
b.[nights] 
FROM [dbo].[booking] b 
INNER JOIN [dbo].[guest] g ON g.[id] = b.[guest_id]
GO

SELECT * FROM v_booking_details WHERE [booking_id] = 5046
