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

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'clsficat')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('clsficat')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('clsficat')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[clsficat]
		PRINT 'Table [dbo].[clsficat] dropped'
    END

	CREATE TABLE [dbo].[clsficat](
		[clsficatid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](60) NOT NULL DEFAULT '',
		CONSTRAINT [PK_clsficat] PRIMARY KEY CLUSTERED 
		(
			[clsficatid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

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