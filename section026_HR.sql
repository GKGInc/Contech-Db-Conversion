-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section026_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 026: clsficat
-- =========================================================

-- Column changes:
--  - Set [clsficatid] to be primary key

    PRINT 'Table: dbo.clsficat: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'clsficat'))
		DROP TABLE [dbo].[clsficat]

	CREATE TABLE [dbo].[clsficat](
		[clsficatid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](60) NOT NULL DEFAULT '',
		CONSTRAINT [PK_clsficat] PRIMARY KEY CLUSTERED 
		(
			[clsficatid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
-- Section 026: doctypes -- Moved from section 031
-- =========================================================

-- Column changes:
--  - Added [doctypesid] to be primary key
--  - Changed [doctypesid] to [doctypeid]

	PRINT 'Table: dbo.doctypes: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'doctypes'))
		DROP TABLE [dbo].[doctypes]

	CREATE TABLE [dbo].[doctypes](
		[doctypeid] [int] IDENTITY(1,1) NOT NULL,
		[doctype] [char](4) NOT NULL DEFAULT '',
		[descript] [char](50) NOT NULL DEFAULT '',
		[order] [char](2) NOT NULL DEFAULT '',
		CONSTRAINT [PK_doctypes] PRIMARY KEY CLUSTERED 
		(
			[doctypeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[doctypes] ([doctype],[descript],[order])
	SELECT [doctype]
		  ,[descript]
		  ,[order]
	  FROM [rawUpsize_Contech].[dbo].[doctypes]
  
	--SELECT * FROM [dbo].[doctypes]

    PRINT 'Table: dbo.doctypes: end'
		
-- =========================================================
-- Section 026: docs_dtl -- Moved from section 030
-- =========================================================

-- Column changes:
--  - Set [docs_dtlid] to be primary key
--  - Changed [descript] from [text] to [varchar](2000)
--  - Changed [rev_emp] [char](10) to [rev_employeeid] [int] to reference [employee] table
-- Maps:
--	- [docs_dtl].[docs_hdrid]					-- FK = [docs_hdr].[docs_hdrid]
--	- [docs_dtl].[rev_emp] --> [rev_employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.docs_dtl: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'docs_dtl'))
		DROP TABLE [dbo].[docs_dtl]

	CREATE TABLE [dbo].[docs_dtl](
		[docs_dtlid] [int] IDENTITY(1,1) NOT NULL,
		[doctype] [char](4) NOT NULL DEFAULT '',
		[series] [char](4) NOT NULL DEFAULT '',
		[extension] [char](20) NOT NULL DEFAULT '',
		[document] [char](15) NOT NULL DEFAULT '',
		[descript] [varchar](2000) NOT NULL DEFAULT '',
		[rev] [char](4) NOT NULL DEFAULT '',
		[rev_date] [datetime] NULL,
		[move_date] [datetime] NULL,
		[docmod] [bit] NOT NULL DEFAULT 0,
		[docs_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [docs_hdr].[docs_hdrid]
		[cpmr_rev] [char](4) NOT NULL DEFAULT '',
		[cpmr_date] [datetime] NULL,
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		--[rev_emp] [char](10) NOT NULL DEFAULT '',
		[rev_employeeid] [int] NOT NULL DEFAULT 0,		-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_docs_dtl] PRIMARY KEY CLUSTERED 
		(
			[docs_dtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[docs_dtl] ON;

	INSERT INTO [dbo].[docs_dtl] ([docs_dtlid],[doctype],[series],[extension],[document],[descript],[rev],[rev_date],[move_date],[docmod],[docs_hdrid],[cpmr_rev],[cpmr_date],[rev_rec],[rev_dt],[rev_employeeid])
	SELECT [rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[doctype]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[series]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[extension]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[document]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[descript]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[move_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docmod]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docs_hdrid]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_rev]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp]
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[docs_dtl]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp] = employee.[empnumber]	
  
	SET IDENTITY_INSERT [dbo].[docs_dtl] OFF;

	--SELECT * FROM [dbo].[docs_dtl]

    PRINT 'Table: dbo.docs_dtl: end'

-- =========================================================
-- Section 026: docs_hdr -- Moved from section 030
-- =========================================================

-- Column changes:
--  - Set [docs_hdrid] to be primary key
--  - Changed [doctype] [char](4) to [doctypeid] [int] to reference [docs_dtl] table
-- Maps:
--	- [docs_hdr].[doctype] --> [doctypeid]	-- FK = [doctypes].[doctype] --> [doctypes].[doctypeid]

    PRINT 'Table: dbo.docs_hdr: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'docs_hdr'))
		DROP TABLE [dbo].[docs_hdr]

	CREATE TABLE [dbo].[docs_hdr](
		[docs_hdrid] [int] IDENTITY(1,1) NOT NULL,
		--[doctype] [char](4) NOT NULL DEFAULT '',		-- FK = [doctypes].[doctype]
		[doctypeid] [int] NOT NULL DEFAULT 0,			-- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
		[series] [char](4) NOT NULL DEFAULT '',
		[descript] [char](75) NOT NULL DEFAULT '',
		CONSTRAINT [PK_docs_hdr] PRIMARY KEY CLUSTERED 
		(
			[docs_hdrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[docs_hdr] ON;

	INSERT INTO [dbo].[docs_hdr] ([docs_hdrid],[doctypeid],[series],[descript])
	SELECT [rawUpsize_Contech].[dbo].[docs_hdr].[docs_hdrid]
		  --,[rawUpsize_Contech].[dbo].[docs_hdr].[doctype]
		  ,ISNULL(doctypes.[doctypeid], 0) AS [docs_dtlid] -- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
		  ,[rawUpsize_Contech].[dbo].[docs_hdr].[series]
		  ,[rawUpsize_Contech].[dbo].[docs_hdr].[descript]
	  FROM [rawUpsize_Contech].[dbo].[docs_hdr]
	  LEFT JOIN [doctypes] doctypes ON [rawUpsize_Contech].[dbo].[docs_hdr].[doctype] = doctypes.[doctype]
  
	SET IDENTITY_INSERT [dbo].[docs_hdr] OFF;

	--SELECT * FROM [dbo].[docs_hdr]

    PRINT 'Table: dbo.docs_hdr: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section026_HR.sql'

-- =========================================================