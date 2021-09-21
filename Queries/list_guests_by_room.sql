USE GuestHousegrc0396
GO

SET STATISTICS IO OFF
GO

SET STATISTICS IO OFF
GO

SELECT CONCAT(g.[first_name], ' ', g.[last_name]) AS "Guest", b.[room_type_requested] as "Room Type"
FROM [dbo].[guest] g
join [dbo].[booking] b
on g.[id] = b.[guest_id]
ORDER BY b.[room_type_requested] ASC

SELECT CONCAT(g.[first_name],' ', g.[last_name]) AS 'Guest',
b.[room_type_requested] as 'Family Room'
FROM [dbo].[guest] g
INNER JOIN [dbo].[booking] b ON g.[id] = b.[guest_id]
WHERE b.[room_type_requested] = 'family'

SELECT CONCAT(g.[first_name],' ', g.[last_name]) AS 'Guest',
b.[room_type_requested] as 'Single Room'
FROM [dbo].[guest] g
INNER JOIN [dbo].[booking] b ON g.[id] = b.[guest_id]
WHERE b.[room_type_requested] = 'single'

SELECT CONCAT(g.[first_name],' ', g.[last_name]) AS 'Guest',
b.[room_type_requested] as 'Double Room'
FROM [dbo].[guest] g
INNER JOIN [dbo].[booking] b ON g.[id] = b.[guest_id]
WHERE b.[room_type_requested] = 'double'

