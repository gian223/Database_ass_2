USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW vw_guest_room_payable AS 
SELECT g.[first_name], g.[last_name], b.[booking_id], b.[nights], r.[amount] * [nights] AS 'Payable'
FROM [dbo].[booking] b
INNER JOIN [dbo].[rate] r ON b.[room_type_requested] = r.[room_type] AND b.[occupants] = [occupancy]
INNER JOIN [dbo].[guest] g ON b.[guest_id] = g.[id]
GROUP BY g.[first_name], g.[last_name], b.[booking_id], r.[amount], b.[nights]
GO

SELECT * FROM [dbo].[vw_guest_room_payable]

SELECT * FROM [dbo].[vw_guest_room_payable] WHERE [first_name] LIKE 'Sir%' AND [last_name] LIKE '%rd'
