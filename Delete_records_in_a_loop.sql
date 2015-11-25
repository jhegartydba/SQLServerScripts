/* ***********************************************************
* Delete records in a loop.                                   *
* This is to ensure that the transaction log does not fill up *
* ************************************************************
*/

while (1=1)

begin 
delete top(100000) FROM [Orders].[Message]
where (DATEADD(month, -18, getdate()) > messagedate)
	  
IF @@rowcount < 100000
begin
break;
end

end

-- After deletion don't forget to shrink your data / log files
dbcc shrinkfile ('Order_Log',10)
dbcc shrinkfile ('Order_Data',10)

-- Top, within a delete statement, does not work in SQL 2000
-- As such we have amended the query slightly

while (1=1)

begin 
delete from [Orders].[Message]
where OrderID
in (select top 50000 orderID from [Orders].[Message] where 
(DATEADD(month, -15, getdate()) > messagedate))
	  
IF @@rowcount < 50000
begin
break;
end

end