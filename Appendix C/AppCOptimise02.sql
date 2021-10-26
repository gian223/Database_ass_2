USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW v_guest_address AS 
SELECT [id], CONCAT([first_name], ' ', [last_name]) AS 'Name', [address] 
FROM [dbo].[guest]
GO

SELECT * FROM [v_guest_address]
