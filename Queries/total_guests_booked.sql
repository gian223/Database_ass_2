USE GuestHousegrc0396
GO

SET STATISTICS IO OFF
GO

SET STATISTICS IO OFF
GO

SELECT COUNT(DISTINCT [guest_id]) AS "Total Guests Booked" FROM [dbo].[booking]

SELECT SUM (b.[occupants]) AS 'Total Guests Booked'
FROM [dbo].[booking] b