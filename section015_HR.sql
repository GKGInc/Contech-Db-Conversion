
-- =========================================================
-- Section 015: issues
-- =========================================================

-- Column changes:
--  - Changed [issuesid] to be primary key

USE Contech_Test

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
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[issues] ON;

INSERT INTO [Contech_Test].[dbo].[issues] ([issuesid],[issue_type],[issue_desc])
SELECT [issuesid]
      ,[issue_type]
      ,[issue_desc]
  FROM [rawUpsize_Contech].[dbo].[issues]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[issues] OFF;

--SELECT * FROM [Contech_Test].[dbo].[issues]

-- =========================================================
-- Section 015: issuesdt
-- =========================================================

-- Column changes:
--  - Changed [issuesdtid] to be primary key
-- Maps:
--	- [issuesdtid].[issuesid]	-- FK = [issues].[issuesid] 

USE Contech_Test

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
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[issuesdt] ON;

INSERT INTO [Contech_Test].[dbo].[issuesdt] ([issuesdtid],[issuesid],[dtl_code],[issue_dtl])
SELECT [issuesdtid]		-- FK = [issues].[issuesid] 
      ,[issuesid]
      ,[dtl_code]
      ,[issue_dtl]
  FROM [rawUpsize_Contech].[dbo].[issuesdt]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[issuesdt] OFF;

--SELECT * FROM [Contech_Test].[dbo].[issuesdt]

-- =========================================================