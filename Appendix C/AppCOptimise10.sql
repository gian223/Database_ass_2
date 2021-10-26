USE [GuestHouse2021-grc0396]
GO

SET statistics io ON
GO

SET statistics time ON
GO

CREATE OR ALTER VIEW vw_guest_east AS 
SELECT g.[last_name], g.[first_name], g.[address], ISNULL(SUM(b.[nights]),0) AS 'Nights' 
FROM [dbo].[guest] g 
FULL OUTER JOIN [dbo].[booking] b ON g.[id] = b.[guest_id]
GROUP BY g.[last_name], g.[first_name], g.[address]
GO

SELECT * FROM [dbo].[vw_guest_east]

SELECT * FROM [dbo].[vw_guest_east] WHERE [address] LIKE '%East%' 
ORDER BY [last_name] ASC, [first_name] ASC

