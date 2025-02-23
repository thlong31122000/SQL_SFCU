-- Get number of pages a table is currently occupied
-- Source: https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-allocation-units-transact-sql?view=sql-server-ver16

SELECT t.object_id AS ObjectID,
       OBJECT_NAME(t.object_id) AS ObjectName,
	   SUM(u.total_pages) AS  Total_Page,
	   SUM(u.used_pages) AS  Total_Used_Page,
       SUM(u.total_pages) * 8 AS Total_Reserved_kb,
       SUM(u.used_pages) * 8 AS Used_Space_kb,
       u.type_desc AS TypeDesc,
       MAX(p.rows) AS RowsCount
FROM sys.allocation_units AS u
JOIN sys.partitions AS p ON u.container_id = p.hobt_id
JOIN sys.tables AS t ON p.object_id = t.object_id
GROUP BY t.object_id,
         OBJECT_NAME(t.object_id),
         u.type_desc
ORDER BY Used_Space_kb DESC,
         ObjectName;
