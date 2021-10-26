USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO


CREATE OR ALTER VIEW v_guest_nights AS 
SELECT [booking_id], [booking_date] AS 'Check in', 
DATEADD(day, CASE WHEN [nights] = 1 THEN 1 ELSE [nights] END, [booking_date]) AS 'Checkout', 
[nights] 
FROM [dbo].[booking]
GO

SELECT * FROM [dbo].[v_guest_nights]

SELECT * FROM [dbo].[v_guest_nights] WHERE [booking_id] = 5204

