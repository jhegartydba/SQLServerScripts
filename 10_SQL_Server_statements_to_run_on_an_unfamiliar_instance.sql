/*
* 10 SQL Server statements to run on an unfamiliar instance
*/

-- 1. Retrieves information such as Hostname, Current instance name, Edition, Server type, ServicePack and version number.

SELECT 
SERVERPROPERTY('MachineName') as Host,
SERVERPROPERTY('InstanceName') as Instance,
SERVERPROPERTY('Edition') as Edition, /*shows 32 bit or 64 bit*/
SERVERPROPERTY('ProductLevel') as ProductLevel, /* RTM or SP1 etc*/
Case SERVERPROPERTY('IsClustered') when 1 then 'CLUSTERED' else
'STANDALONE' end as ServerType,
@@VERSION as VersionNumber

-- 2. Lists all of the information related to Server level configuration.

SELECT * from sys.configurations order by NAME

-- If you are using SQL Server 2000, you can execute the following command instead.

SP_CONFIGURE 'show advanced options',1
go
RECONFIGURE with OVERRIDE
go
SP_CONFIGURE
go


-- 3. Displays information related to the security admin server role and system admin server role.

SELECT l.name, l.denylogin, l.isntname, l.isntgroup, l.isntuser
FROM master.dbo.syslogins l
WHERE l.sysadmin = 1 OR l.securityadmin = 1

-- 4. Lists all of the trace flags that are enabled gloabally on the server.

DBCC TRACESTATUS(-1);

-- Lists all the trace flags that are enabled on the current sql server connection. Refer Fig 1.4

DBCC TRACESTATUS();

-- 5. Lists all of the database names with compatibilty level.

SELECT name,compatibility_level,recovery_model_desc,state_desc  FROM sys.databases

-- If you are using SQL Server 2000, you could execute the following T-SQL Statement. Refer Fig 1.6

SELECT name,cmptlevel,DATABASEPROPERTYEX(name,'Recovery')AS RecoveryModel, 
DATABASEPROPERTYEX(name,'Status') as Status FROM sysdatabases


-- 6. Provides the logical name and the physical location of the data/log files of all the databases available in the current SQL Server instance.

SELECT db_name(database_id) as DatabaseName,name,type_desc,physical_name FROM sys.master_files

-- If you are using SQL Server 2000, you could execute the following T-SQL Statement. Refer Fig 1.8

SELECT db_name(dbid) as DatabaseName,name,filename FROM master.dbo.sysaltfiles

-- 7.Displays the file groups for each DB on the server.

EXEC master.dbo.sp_MSforeachdb @command1 = 'USE [?] SELECT * FROM sys.filegroups'

-- 8. Lists all of the databases in the server and the last day the backup happened

SELECT db.name, 
case when MAX(b.backup_finish_date) is NULL then 'No Backup' else convert(varchar(100), 
	MAX(b.backup_finish_date)) end AS last_backup_finish_date
FROM sys.databases db
LEFT OUTER JOIN msdb.dbo.backupset b ON db.name = b.database_name AND b.type = 'D'
	WHERE db.database_id NOT IN (2) 
GROUP BY db.name
ORDER BY 2 DESC

-- 9. Return all the information related to the current backup location from the msdb database.

SELECT Distinct physical_device_name FROM msdb.dbo.backupmediafamily

-- 10. Check the current users, process and session information

sp_who
sp_who2