-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section030_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 030: cyclcomp
-- =========================================================

-- Column changes:
--  - Set [cyclcompid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [cyclcomp].[comp]			-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.cyclcomp: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cyclcomp'))
		DROP TABLE [dbo].[cyclcomp]

	CREATE TABLE [dbo].[cyclcomp](
		[cyclcompid] [int] IDENTITY(1,1) NOT NULL,
		[inv_sessid] [char](9) NOT NULL DEFAULT '',
		--[comp] [char](5) NOT NULL DEFAULT '',
		[componetid] [int] NOT NULL,		-- FK = [componet].[comp] --> [componet].[componetid]
		CONSTRAINT [PK_cyclcomp] PRIMARY KEY CLUSTERED 
		(
			[cyclcompid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[cyclcomp] ON;

	INSERT INTO [dbo].[cyclcomp] ([cyclcompid],[inv_sessid],[componetid])
	SELECT [rawUpsize_Contech].[dbo].[cyclcomp].[cyclcompid]
		  ,[rawUpsize_Contech].[dbo].[cyclcomp].[inv_sessid]
		  --,[rawUpsize_Contech].[dbo].[cyclcomp].[comp]
		  ,ISNULL(componet.[componetid], 0) AS [componetid] 
	  FROM [rawUpsize_Contech].[dbo].[cyclcomp]
	  LEFT JOIN [componet] componet ON [rawUpsize_Contech].[dbo].[cyclcomp].[comp] = componet.[comp] 
  
	SET IDENTITY_INSERT [dbo].[cyclcomp] OFF;

	--SELECT * FROM [dbo].[cyclcomp]

    PRINT 'Table: dbo.cyclcomp: end'

-- =========================================================
-- Section 030: disposit
-- =========================================================

-- Column changes:
--  - Added [dispositid] to be primary key
--  - Changed [price_note] from [text] to [varchar](2000)
-- Maps:
--	- [bom_hist].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.disposit: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'disposit'))
		DROP TABLE [dbo].[disposit]

	CREATE TABLE [dbo].[disposit](
		[dispositid] [int] IDENTITY(1,1) NOT NULL,
		[dispos] [char](2) NOT NULL DEFAULT '',
		[descript] [char](25) NOT NULL DEFAULT '',
		CONSTRAINT [PK_disposit] PRIMARY KEY CLUSTERED 
		(
			[dispositid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[disposit] ([dispos],[descript])
	SELECT [dispos]
		  ,[descript]
	  FROM [rawUpsize_Contech].[dbo].[disposit]
  
	--SELECT * FROM [dbo].[disposit]

    PRINT 'Table: dbo.disposit: end'

-- =========================================================
-- Section 030: doc_mngr
-- =========================================================

-- Column changes:
--  - Set [doc_mngrid] to be primary key
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--  - [doc_mngr].[parent_id]					-- FK = [matlin].[matlin_key] or [corractn].[corractnid] -- used with [parent_tbl] (MATLIN, CORRACTN)
--	- [doc_mngr].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]
--	- [doc_mngr].[add_user] --> [mod_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.doc_mngr: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'doc_mngr'))
		DROP TABLE [dbo].[doc_mngr]

	CREATE TABLE [dbo].[doc_mngr](
		[doc_mngrid] [int] IDENTITY(1,1) NOT NULL,
		[parent_id] [char](15) NOT NULL DEFAULT '',			-- FK = [matlin].[matlin_key] or [corractn].[corractnid] -- used with [parent_tbl] (MATLIN, CORRACTN)
		[parent_tbl] [char](15) NOT NULL DEFAULT '',
		[document] [char](100) NOT NULL DEFAULT '',
		[doc_desc] [char](150) NOT NULL DEFAULT '',
		--[add_user] [char](10) NOT NULL DEFAULT '',
		[add_userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL DEFAULT '',
		[mod_userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		CONSTRAINT [PK_doc_mngr] PRIMARY KEY CLUSTERED 
		(
			[doc_mngrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [doc_mngr] ON;

	INSERT INTO [doc_mngr] ([doc_mngrid],[parent_id],[parent_tbl],[document],[doc_desc],[add_userid],[add_dt],[mod_userid],[mod_dt])
	SELECT [rawUpsize_Contech].[dbo].[doc_mngr].[doc_mngrid]
		  --,[rawUpsize_Contech].[dbo].[doc_mngr].[parent_id]
		  ,CASE WHEN [parent_tbl] = 'CORRACTN' THEN ISNULL(corractn.[corractnid], 0)	-- FK = [corractn].[car_no] --> corractn.[corractnid]
		  WHEN [parent_tbl] = 'MATLIN' THEN ISNULL(matlin.[matlin_key], 0)
		  ELSE '' END AS [parent_id]
		  ,[rawUpsize_Contech].[dbo].[doc_mngr].[parent_tbl]
		  ,[rawUpsize_Contech].[dbo].[doc_mngr].[document]
		  ,[rawUpsize_Contech].[dbo].[doc_mngr].[doc_desc]
		  --,[rawUpsize_Contech].[dbo].[doc_mngr].[add_user]
		  ,ISNULL(add_user.[userid] , 0) as [add_userid]		-- FK = [users].[userid]	
		  ,[rawUpsize_Contech].[dbo].[doc_mngr].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[doc_mngr].[mod_user]
		  ,ISNULL(mod_user.[userid] , 0) as [mod_userid]		-- FK = [users].[userid]	
		  ,[rawUpsize_Contech].[dbo].[doc_mngr].[mod_dt]
	  FROM [rawUpsize_Contech].[dbo].[doc_mngr]
	  LEFT JOIN [rawUpsize_Contech].[dbo].[matlin] matlin ON [rawUpsize_Contech].[dbo].[doc_mngr].[parent_id] = matlin.[matlin_key]		-- [parent_tbl] = 'CORRACTN'
	  LEFT JOIN [rawUpsize_Contech].[dbo].[corractn] corractn ON [rawUpsize_Contech].[dbo].[doc_mngr].[parent_id] = corractn.[car_no]	-- [parent_tbl] = 'MATLIN'
	  LEFT JOIN [dbo].[users] add_user ON [rawUpsize_Contech].[dbo].[doc_mngr].[add_user] = add_user.[username]	-- FK = [users].[userid]
	  LEFT JOIN [dbo].[users] mod_user ON [rawUpsize_Contech].[dbo].[doc_mngr].[mod_user] = mod_user.[username]	-- FK = [users].[userid]
    
	SET IDENTITY_INSERT [dbo].[doc_mngr] OFF;

	--SELECT * FROM [dbo].[doc_mngr]

    PRINT 'Table: dbo.doc_mngr: end'

-- =========================================================
-- Section 030: docs_dtl -- MOVED to section 003
-- =========================================================

-- Column changes:
--  - Set [docs_dtlid] to be primary key
--  - Changed [descript] from [text] to [varchar](2000)
--  - Changed [rev_emp] [char](10) to [rev_employeeid] [int] to reference [employee] table
-- Maps:
--	- [docs_dtl].[docs_hdrid]					-- FK = [docs_hdr].[docs_hdrid]
--	- [docs_dtl].[rev_emp] --> [rev_employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

 --   PRINT 'Table: dbo.docs_dtl: start'
	
	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'docs_dtl'))
	--	DROP TABLE [dbo].[docs_dtl]

	--CREATE TABLE [dbo].[docs_dtl](
	--	[docs_dtlid] [int] IDENTITY(1,1) NOT NULL,
	--	[doctype] [char](4) NOT NULL DEFAULT '',
	--	[series] [char](4) NOT NULL DEFAULT '',
	--	[extension] [char](20) NOT NULL DEFAULT '',
	--	[document] [char](15) NOT NULL DEFAULT '',
	--	[descript] [varchar](2000) NOT NULL DEFAULT '',
	--	[rev] [char](4) NOT NULL DEFAULT '',
	--	[rev_date] [datetime] NULL,
	--	[move_date] [datetime] NULL,
	--	[docmod] [bit] NOT NULL DEFAULT 0,
	--	[docs_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [docs_hdr].[docs_hdrid]
	--	[cpmr_rev] [char](4) NOT NULL DEFAULT '',
	--	[cpmr_date] [datetime] NULL,
	--	[rev_rec] [int] NOT NULL DEFAULT 0,
	--	[rev_dt] [datetime] NULL,
	--	--[rev_emp] [char](10) NOT NULL DEFAULT '',
	--	[rev_employeeid] [int] NOT NULL DEFAULT 0,		-- FK = [employee].[empnumber] -> [employee].[employeeid]
	--	CONSTRAINT [PK_docs_dtl] PRIMARY KEY CLUSTERED 
	--	(
	--		[docs_dtlid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	--) ON [PRIMARY]

	--SET IDENTITY_INSERT [dbo].[docs_dtl] ON;

	--INSERT INTO [dbo].[docs_dtl] ([docs_dtlid],[doctype],[series],[extension],[document],[descript],[rev],[rev_date],[move_date],[docmod],[docs_hdrid],[cpmr_rev],[cpmr_date],[rev_rec],[rev_dt],[rev_employeeid])
	--SELECT [rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[doctype]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[series]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[extension]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[document]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[descript]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_date]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[move_date]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docmod]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docs_hdrid]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_rev]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_date]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_rec]
	--	  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_dt]
	--	  --,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp]
	--	  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	--  FROM [rawUpsize_Contech].[dbo].[docs_dtl]
	--  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp] = employee.[empnumber]	
  
	--SET IDENTITY_INSERT [dbo].[docs_dtl] OFF;

	----SELECT * FROM [dbo].[docs_dtl]

 --   PRINT 'Table: dbo.docs_dtl: end'

-- =========================================================
-- Section 030: docs_hdr -- MOVED to section 003
-- =========================================================

-- Column changes:
--  - Set [docs_hdrid] to be primary key
--  - Changed [doctype] [char](4) to [doctypeid] [int] to reference [docs_dtl] table
-- Maps:
--	- [docs_hdr].[doctype] --> [doctypeid]	-- FK = [doctypes].[doctype] --> [doctypes].[doctypeid]

 --   PRINT 'Table: dbo.docs_hdr: start'
	
	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'docs_hdr'))
	--	DROP TABLE [dbo].[docs_hdr]

	--CREATE TABLE [dbo].[docs_hdr](
	--	[docs_hdrid] [int] IDENTITY(1,1) NOT NULL,
	--	--[doctype] [char](4) NOT NULL DEFAULT '',		-- FK = [doctypes].[doctype]
	--	[doctypeid] [int] NOT NULL DEFAULT 0,			-- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
	--	[series] [char](4) NOT NULL DEFAULT '',
	--	[descript] [char](75) NOT NULL DEFAULT '',
	--	CONSTRAINT [PK_docs_hdr] PRIMARY KEY CLUSTERED 
	--	(
	--		[docs_hdrid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	--) ON [PRIMARY]

	--SET IDENTITY_INSERT [dbo].[docs_hdr] ON;

	--INSERT INTO [dbo].[docs_hdr] ([docs_hdrid],[doctypeid],[series],[descript])
	--SELECT [rawUpsize_Contech].[dbo].[docs_hdr].[docs_hdrid]
	--	  --,[rawUpsize_Contech].[dbo].[docs_hdr].[doctype]
	--	  ,ISNULL(doctypes.[doctypeid], 0) AS [docs_dtlid] -- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
	--	  ,[rawUpsize_Contech].[dbo].[docs_hdr].[series]
	--	  ,[rawUpsize_Contech].[dbo].[docs_hdr].[descript]
	--  FROM [rawUpsize_Contech].[dbo].[docs_hdr]
	--  LEFT JOIN [doctypes] doctypes ON [rawUpsize_Contech].[dbo].[docs_hdr].[doctype] = doctypes.[doctype]
  
	--SET IDENTITY_INSERT [dbo].[docs_hdr] OFF;

	----SELECT * FROM [dbo].[docs_hdr]

 --   PRINT 'Table: dbo.docs_hdr: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section030_HR.sql'

-- =========================================================