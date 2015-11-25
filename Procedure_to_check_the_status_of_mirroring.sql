USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[usp_mirror_monitor]    Script Date: 02/12/2014 09:40:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joe Hegarty
-- Create date: 12/02/14
-- Description:	Procedure to cycle through DB's
--  and check the status of mirroring.
-- # Role - Current mirroring role of the server instance:
-- 1 = Principal
-- 2 = Mirror
-- 
-- # Mirroring_state - State of the database:
-- 0 = Suspended
-- 1 = Disconnected
-- 2 = Synchronizing
-- 3 = Pending Failover
-- 4 = Synchronized
-- 
-- #Witness_status - Connection status of the witness 
-- in the database mirroring session of the database, can be:
-- 0 = Unknown
-- 1 = Connected
-- 2 = Disconnected
-- =============================================
CREATE PROCEDURE [dbo].[usp_mirror_monitor]
AS
DECLARE @Database VARCHAR(255)
DECLARE @cmd VARCHAR(1000)

DECLARE DatabaseCursor CURSOR
FOR
SELECT NAME
FROM master.sys.databases
WHERE state_desc = 'ONLINE'
	AND NAME NOT IN (
		'tempdb'
		,'ReportServerTempDB'
		)
ORDER BY 1

OPEN DatabaseCursor

FETCH NEXT
FROM DatabaseCursor
INTO @Database

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC sp_dbmmonitorresults @Database

	FETCH NEXT
	FROM DatabaseCursor
	INTO @Database
END

CLOSE DatabaseCursor

DEALLOCATE DatabaseCursor

GO


