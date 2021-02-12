-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section015_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 015: issues
-- =========================================================

-- Column changes:
--  - Changed [issuesid] to be primary key
--  - Changed [issuesid] to [issueid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.issues: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issues')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('issues')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('issues')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[issues]
		PRINT 'Table [dbo].[issues] dropped'
    END

	CREATE TABLE [dbo].[issues](
		[issueid] [int] IDENTITY(1,1) NOT NULL,
		[issue_type] [char](15) NOT NULL DEFAULT '',
		[issue_desc] [char](35) NOT NULL DEFAULT '',
		CONSTRAINT [PK_issues] PRIMARY KEY CLUSTERED 
		(
			[issueid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[issues] ON;

	INSERT INTO [dbo].[issues] ([issueid],[issue_type],[issue_desc])
	SELECT [issuesid]
		  ,[issue_type]
		  ,[issue_desc]
	  FROM [rawUpsize_Contech].[dbo].[issues]
  
	SET IDENTITY_INSERT [dbo].[issues] OFF;

	--SELECT * FROM [dbo].[issues]

	COMMIT

    PRINT 'Table: dbo.issues: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 015: issuesdt
-- =========================================================

-- Column changes:
--  - Changed [issuesdtid] to be primary key
-- Maps:
--	- [issuesdtid].[issueid]	-- FK = [issues].[issueid] 

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.issuesdt: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issuesdt')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('issuesdt')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('issuesdt')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[issuesdt]
		PRINT 'Table [dbo].[issuesdt] dropped'
    END

	CREATE TABLE [dbo].[issuesdt](
		[issuesdtid] [int] IDENTITY(1,1) NOT NULL,
		[issuesid] [int] NOT NULL DEFAULT 0,			-- FK = [issues].[issueid] 
		[dtl_code] [char](2) NOT NULL DEFAULT '',
		[issue_dtl] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_issuesdt] PRIMARY KEY CLUSTERED 
		(
			[issuesdtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_issues_issuesdt FOREIGN KEY ([issuesid]) REFERENCES [dbo].[issues] ([issueid]) ON DELETE CASCADE NOT FOR REPLICATION 
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[issuesdt] ON;

	INSERT INTO [dbo].[issuesdt] ([issuesdtid],[issuesid],[dtl_code],[issue_dtl])
	SELECT [issuesdtid]		-- FK = [issues].[issueid] 
		  ,[issuesid]
		  ,[dtl_code]
		  ,[issue_dtl]
	  FROM [rawUpsize_Contech].[dbo].[issuesdt]
  
	SET IDENTITY_INSERT [dbo].[issuesdt] OFF;

	--SELECT * FROM [dbo].[issuesdt]

    COMMIT

    PRINT 'Table: dbo.issuesdt: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section015_HR.sql'

-- =========================================================