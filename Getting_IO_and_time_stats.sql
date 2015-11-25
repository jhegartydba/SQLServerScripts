/*
*	Getting IO and time statistics for SQL Server queries
*	
*/


-- turn on statistics IO
SET STATISTICS IO ON
GO

-- your query goes here
SELECT * FROM Employee
GO

-- turn off statistics IO
SET STATISTICS IO OFF
GO 


-- Your query can then be parsed using the below website
-- Just paste in the output to get a verbose parsered output

/*

http://www.statisticsparser.com/

*/