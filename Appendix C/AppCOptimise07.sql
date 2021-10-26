USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW vw_guest_payable AS 
SELECT b.[booking_id], b.[nights], r.[amount] * [nights] + SUM(e.[amount]) AS 'Payable'
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
FULL OUTER JOIN [dbo].[extra] e ON b.[booking_id] = e.[booking_id]
GROUP BY b.[booking_id], r.[amount], b.[nights]
GO

select * from [dbo].[booking] where [booking_id] = 5011

SELECT * FROM [dbo].[vw_guest_payable] WHERE [booking_id] = 5128
