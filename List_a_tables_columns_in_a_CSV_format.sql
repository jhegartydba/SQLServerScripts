/* ***************************************
*  List a tables columns in a CSV format  *
*  ***************************************
*/ 

DECLARE @TableName SYSNAME = 'tablename'

SELECT REPLACE(REVERSE(STUFF(REVERSE((SELECT name + ',' AS [data()]
FROM sys.columns
WHERE OBJECT_NAME(object_id) = @TableName
ORDER BY column_id
FOR XML PATH(''))),1,1,'')),' ','')


-- Example output - 
-- BatchID, AddedOn, Action, Item, Parent, Param, BoolParam, Content, Properties