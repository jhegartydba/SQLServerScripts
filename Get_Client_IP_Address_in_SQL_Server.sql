/* ***************************************
*                                        *
* Get Client IP Address in SQL Server    *
*                                        *
******************************************
*/ 

-- Execute the function and call this function through a Stored Procedure. It will return the IP address of the client system.
 
--Method 1
CREATE FUNCTION [dbo].[GetCurrentIP] ()
RETURNS varchar(255)
AS
BEGIN
    DECLARE @IP_Address varchar(255);
 
    SELECT @IP_Address = client_net_address
    FROM sys.dm_exec_connections
    WHERE Session_id = @@SPID;
 
    Return @IP_Address;
END

--Method 2 - we can also get the same result by using the below query:

SELECT CONVERT(char(15), CONNECTIONPROPERTY('client_net_address'))