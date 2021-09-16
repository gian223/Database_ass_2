USE GuestHousegrc0396
GO

SELECT g.[first_name] AS "Guest", b.[room_type_requested] as "Room Type"
FROM [dbo].[guest] g
join [dbo].[booking] b
on g.[id] = b.[guest_id]