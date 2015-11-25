/*
*	Filter output of the SP_WHO2 command
*/

DECLARE @Table TABLE(
        SPID INT,
        Status VARCHAR(MAX),
        Login VARCHAR(MAX),
        HostName VARCHAR(MAX),
        BlkBy VARCHAR(MAX),
        DBName VARCHAR(MAX),
        Command VARCHAR(MAX),
        CPUTime INT,
        DiskIO INT,
        LastBatch VARCHAR(MAX),
        ProgramName VARCHAR(MAX),
        SPID INT
)

INSERT INTO @Table EXEC sp_who2

SELECT  *
FROM    @Table
WHERE DBName = 'MYDB';



/*
* In SQL 2000 you will have to use a temp table
*/


create table #temp
(
spid int,
status varchar(100),
loginname varchar(2000),
hostname varchar(2000),
blkby varchar(100),
dbname varchar(200),
cmd varchar(2000),
cputime int,
diskio int,
lastbatch varchar(100),
pgmname varchar(500),
parentspid int,
)
insert into #temp
EXEC sp_who2
select * from #temp where dbname ='MYDB'
drop table #temp