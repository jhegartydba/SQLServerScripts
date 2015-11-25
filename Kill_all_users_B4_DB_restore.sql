/* ***************************************************************
*  Kill all USer Sessions before starting to restore a Database   *
*  ***************************************************************
*/ 

SET ANSI_WARNINGS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

SET NOCOUNT ON
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'usp_KillBeforeRestoreDB')
                    AND type =  N'P')

DROP PROCEDURE [usp_KillBeforeRestoreDB];
GO


CREATE PROCEDURE [dbo].[usp_KillBeforeRestoreDB] (@db_name sysname)
AS

/*To Run: Exec [usp_KillBeforeRestoreDB] @db_name = 'AdventureWorks_2005' */

DECLARE @cmdKill VARCHAR (50)

DECLARE killCursor
    CURSOR FOR
    SELECT 'KILL ' + CONVERT (VARCHAR (5),
                              p.spid)
    FROM master.dbo.sysprocesses AS p
    WHERE p.dbid = DB_ID (@db_name)

OPEN killCursor

FETCH killCursor INTO @cmdKill

WHILE
    0 = @@FETCH_STATUS
    BEGIN
        EXECUTE (@cmdKill)
        FETCH killCursor INTO @cmdKill
    END

CLOSE killCursor

DEALLOCATE killCursor


GO

SET NOCOUNT OFF