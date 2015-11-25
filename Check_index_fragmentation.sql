/* ************************************
*  Check database index fragmentation  *
*  ************************************
*/


SELECT ps.database_id, object_name(ps.OBJECT_ID) as table_name,
ps.index_id, b.name,
ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID
AND ps.index_id = b.index_id
WHERE ps.database_id = DB_ID()
ORDER BY ps.OBJECT_ID

-- Check SQL Server - database index fragmentation above a given percentage (30%)

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind  
ON ind.object_id = indexstats.object_id 
AND ind.index_id = indexstats.index_id 
WHERE indexstats.avg_fragmentation_in_percent > 30 
ORDER BY indexstats.avg_fragmentation_in_percent DESC