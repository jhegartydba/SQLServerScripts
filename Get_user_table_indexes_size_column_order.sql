/* **********************************************
* Get user table indexes, size and column order  *
* ***********************************************
*/

SELECT OBJECT_NAME(i.object_id) AS TableName
		, ISNULL(i.name, 'HEAP') AS IndexName
		, ISNULL(STUFF((SELECT ', ' + QUOTENAME(c2.name) + 
				CASE ic2.is_descending_key
				WHEN 0 THEN ' ASC'
				ELSE ' DESC'
				END						 
				FROM sys.indexes i2 INNER JOIN sys.index_columns ic2
				ON i2.object_id = ic2.object_id AND i2.index_id = ic2.index_id
				INNER JOIN  sys.columns c2 ON ic2.object_id = c2.object_id AND ic2.column_id = c2.column_id						
				WHERE ic2.object_id = i.object_id AND ic2.index_id = i.index_id
				ORDER BY ic2.object_id	 
				FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 1, N''), 'HEAP') AS IndexColumnOrder
		, i.index_id AS IndexID			
		, i.fill_factor				
		, p.rows AS NumRows			
		, au.total_pages AS NumPages
		, au.total_pages / 128 AS TotMBs
		, au.used_pages / 128 AS UsedMBs
		, au.data_pages / 128 AS DataMBs
FROM sys.indexes i INNER JOIN sys.partitions p 
ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units au ON
CASE 
WHEN au.type IN (1,3) THEN p.hobt_id
WHEN au.type = 2 THEN p.partition_id
END = au.container_id
INNER JOIN sys.objects o ON i.object_id = o.object_id
WHERE o.is_ms_shipped <> 1 AND au.type_desc = 'IN_ROW_DATA'
AND p.partition_number = 1			
ORDER BY OBJECT_NAME(i.object_id), i.index_id;
