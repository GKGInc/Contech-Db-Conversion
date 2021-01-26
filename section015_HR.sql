-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section015_HR.sql'

-- =========================================================
-- Section 015: issues
-- =========================================================

-- Column changes:
--  - Changed [issuesid] to be primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.issues: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issues'))
		DROP TABLE [dbo].[issues]

	CREATE TABLE [dbo].[issues](
		[issuesid] [int] IDENTITY(1,1) NOT NULL,
		[issue_type] [char](15) NOT NULL DEFAULT '',
		[issue_desc] [char](35) NOT NULL DEFAULT '',
		CONSTRAINT [PK_issues] PRIMARY KEY CLUSTERED 
		(
			[issuesid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[issues] ON;

	INSERT INTO [dbo].[issues] ([issuesid],[issue_type],[issue_desc])
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
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 015: issuesdt
-- =========================================================

-- Column changes:
--  - Changed [issuesdtid] to be primary key
-- Maps:
--	- [issuesdtid].[issuesid]	-- FK = [issues].[issuesid] 

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.issuesdt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issuesdt'))
		DROP TABLE [dbo].[issuesdt]

	CREATE TABLE [dbo].[issuesdt](
		[issuesdtid] [int] IDENTITY(1,1) NOT NULL,
		[issuesid] [int] NOT NULL DEFAULT 0,			-- FK = [issues].[issuesid] 
		[dtl_code] [char](2) NOT NULL DEFAULT '',
		[issue_dtl] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_issuesdt] PRIMARY KEY CLUSTERED 
		(
			[issuesdtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[issuesdt] ON;

	INSERT INTO [dbo].[issuesdt] ([issuesdtid],[issuesid],[dtl_code],[issue_dtl])
	SELECT [issuesdtid]		-- FK = [issues].[issuesid] 
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
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section015_HR.sql'

-- =========================================================