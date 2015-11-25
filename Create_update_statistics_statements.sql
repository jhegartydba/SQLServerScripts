/* *****************************************************************
*                     Update Statistics                             *
*  Create scripts for update statistics older 1 day for current DB  *
*                                                                   *
* ******************************************************************
*/

SELECT DISTINCT 'UPDATE STATISTICS [' + s.NAME + '].[' + o.NAME + ']([' + si.NAME + ']) WITH RESAMPLE' --, STATS_DATE(i.object_id, i.index_id) AS StatsUpdated
FROM [sys].[sysindexes] si
JOIN [sys].[objects] o ON si.id = o.object_id
JOIN sys.indexes i ON i.object_id = o.object_id
LEFT JOIN sys.schemas s ON s.schema_id = o.schema_id
WHERE o.type = 'U'
AND STATS_DATE(i.object_id, i.index_id) < DATEADD(DAY, - 1, GETDATE())

