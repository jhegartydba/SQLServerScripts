/* ************************
*  Look for Backups older than 24 hrs and Clear Backup History    *
*  ************************
*/

-- Select database backups older than 24 hrs old
SELECT   msdb.dbo.backupset.database_name, MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date,    
DATEDIFF(hh, MAX(msdb.dbo.backupset.backup_finish_date), GETDATE()) AS [Backup Age (Hours)] 
FROM msdb.dbo.backupset WHERE msdb.dbo.backupset.type = 'D'
GROUP BY msdb.dbo.backupset.database_name 
HAVING (MAX(msdb.dbo.backupset.backup_finish_date) < DATEADD(hh, - 24, GETDATE()));

-- Select database backups older than 24 hrs old by 
SELECT   msdb.dbo.backupset.database_name, MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date,    
DATEDIFF(hh, MAX(msdb.dbo.backupset.backup_finish_date), GETDATE()) AS [Backup Age (Hours)] 
FROM msdb.dbo.backupset WHERE msdb.dbo.backupset.type = 'D' and database_name = 'P-AppSenseManagement'
GROUP BY msdb.dbo.backupset.database_name 
HAVING (MAX(msdb.dbo.backupset.backup_finish_date) < DATEADD(hh, - 24, GETDATE()));

-- Clear backup history
USE [msdb]
GO
DECLARE @OldestDate [smalldatetime]
SET @OldestDate = GETDATE() - 1
EXEC [msdb]..[sp_delete_backuphistory] @OldestDate;
GO