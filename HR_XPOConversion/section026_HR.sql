-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section026_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 026: clsficat
-- =========================================================

-- Column changes:
--  - Set [clsficatid] to be primary key

    PRINT 'Table: dbo.clsficat: start'

	SET IDENTITY_INSERT [dbo].[clsficat] ON;

	INSERT INTO [dbo].[clsficat] ([clsficatid],[descript])
	SELECT [clsficatid]
		  ,[descript]
	  FROM [rawUpsize_Contech].[dbo].[clsficat]
  
	SET IDENTITY_INSERT [dbo].[clsficat] OFF;

	--SELECT * FROM [dbo].[clsficat]
	
    PRINT 'Table: dbo.clsficat: end'
	
-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section026_HR.sql'

-- =========================================================