USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW v_room_description AS
SELECT r.[id], r.[room_type], r.[max_occupancy], t.[description] 
FROM [dbo].[room] r 
INNER JOIN [dbo].[room_type] t ON t.[id] = r.[room_type]
GO

SELECT * FROM [v_room_description]
GO

