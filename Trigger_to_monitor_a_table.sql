-- Create new table to store the updates / inserts
CREATE TABLE [dbo].[UK_EMAIL_OPT_UPDATE](
	[MEMBER_NUMBER] [numeric](18, 0) NOT NULL,
	[SERVICE_FLAG] [varchar](10) NOT NULL,
	[STATUS_CODE] [char](1) NULL,
	[UPD_TMS] [datetime] NULL,
	[LAST_UPD_TMS] [datetime] NULL,
	[INSERT_TIME] [datetime] NULL,
	[WHO] [varchar](50) NULL,
	[FROM_HOST] [varchar](50) NULL
)


-- Create a trigger on the table you want to monitor
-- to capture updates and inserts

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joe Hegarty
-- Create date: 08/05/14
-- Description:	Find the process which is updating 
--              this table
-- =============================================
CREATE TRIGGER[dbo].[UK_EMAIL_OPT_TRG]
   ON  [dbo].[UK_EMAIL_OPTIONS]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    Insert into [dbo].[UK_EMAIL_OPT_UPDATE] 
	select MEMBER_NUMBER,
	SERVICE_FLAG,
	STATUS_CODE,
	UPD_TMS,
	LAST_UPD_TMS,
	GETDATE(),
	SUSER_NAME(),
	HOST_NAME()
	from Inserted;

END
GO
