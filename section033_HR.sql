-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section033_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 033: fmmaster *** NOT USED ***
-- =========================================================

-- Column changes:
--  - Set [fmmasterid] to be primary key
--  - Changed [fmdesc] from text to varchar(2000)

-- PRINT 'Table: dbo.fmmaster: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fmmaster'))
	--    DROP TABLE [dbo].[fmmaster]

	--CREATE TABLE [dbo].[fmmaster](
	--	[fmmasterid] [int] IDENTITY(1,1) NOT NULL,
	--	[fmname] [char](50) NOT NULL DEFAULT '',
	--	[fmpdfname] [char](50) NOT NULL DEFAULT '',
	--	[fmdesc] varchar(2000) NOT NULL DEFAULT '',
	--	CONSTRAINT [PK_fmmaster] PRIMARY KEY CLUSTERED 
	--	(
	--		[fmmasterid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	--) ON [PRIMARY] 
	--GO

	--SET IDENTITY_INSERT [dbo].[fmmaster] ON;

	--INSERT INTO [dbo].[fmmaster] ([fmmasterid],[fmname],[fmpdfname],[fmdesc])
	--SELECT [fmmasterid]
	--      ,[fmname]
	--      ,[fmpdfname]
	--      ,[fmdesc]
	--  FROM [rawUpsize_Contech].[dbo].[fmmaster]
  
	--SET IDENTITY_INSERT [dbo].[fmmaster] OFF;

	----SELECT * FROM [dbo].[fmmaster]

-- PRINT 'Table: dbo.fmmaster: end'

-- =========================================================
-- Section 033: ftorders
-- =========================================================

-- Column changes:
--  - Changed [job_no] to [ftordersid] to be primary key 
--  - Added [bom_hdrid] to be foreign key to link [bom_no] & [bom_rev]
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
-- Maps:
--	- [tbom_hdr].[bom_hdrid]				-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [ftorders].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [ftorders].[mfg_locid]				-- FK = [mfg_loc].[mfg_locid]

    PRINT 'Table: dbo.ftorders: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ftorders'))
		DROP TABLE [dbo].[ftorders]

	CREATE TABLE [dbo].[ftorders](
		--[job_no] [int] NOT NULL,	
		[ftordersid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		[status] [char](1) NOT NULL DEFAULT '',
		[part_no] [char](15) NOT NULL DEFAULT '',
		[part_rev] [char](10) NOT NULL DEFAULT '',
		[cust_po] [char](15) NOT NULL DEFAULT '',		
		[qty_ord] [numeric](7, 0) NOT NULL DEFAULT 0.0,
		[price] [numeric](9, 4) NOT NULL DEFAULT 0.0,
		[requested] [datetime] NULL,
		[awk_date] [datetime] NULL,
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no] 
		[customerid] [int] NOT NULL DEFAULT 0,			-- FK = [customer].[cust_no] --> [customer].[customerid]
		[entered] [datetime] NULL,
		[unit] [char](4) NOT NULL DEFAULT '',
		[bo] [numeric](7, 0) NOT NULL DEFAULT 0.0,
		[part_desc] [char](50) NOT NULL DEFAULT '',
		[qty_firm_po] [int] NOT NULL DEFAULT 0,
		[mfg_locid] [int] NOT NULL DEFAULT 0,			-- FK = [mfg_loc].[mfg_locid]
		CONSTRAINT [PK_ftorders] PRIMARY KEY CLUSTERED 
		(
			[ftordersid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[ftorders] ON;

	INSERT INTO [dbo].[ftorders] ([ftordersid],[bom_hdrid],[status],[part_no],[part_rev],[cust_po],[qty_ord],[price],[requested],[awk_date],[customerid],[entered],[unit],[bo],[part_desc],[qty_firm_po],[mfg_locid])
	SELECT [rawUpsize_Contech].[dbo].[ftorders].[job_no]
		  ,ISNULL(bom_hdr.[bom_hdrid], 0) AS [bom_hdrid]		-- FK = [bom_hdr].[bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[ftorders].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[ftorders].[bom_rev]	  
		  ,[rawUpsize_Contech].[dbo].[ftorders].[status]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[part_no]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[part_rev]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[cust_po]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[qty_ord]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[price]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[requested]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[awk_date]
		  --,[rawUpsize_Contech].[dbo].[ftorders].[cust_no]
		  ,ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[entered]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[unit]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[bo]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[part_desc]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[qty_firm_po]
		  ,[rawUpsize_Contech].[dbo].[ftorders].[mfg_locid]
	  FROM [rawUpsize_Contech].[dbo].[ftorders]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[ftorders].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[ftorders].[bom_rev] = bom_hdr.[bom_rev]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[ftorders].[cust_no] = customer.[cust_no] 
	
	SET IDENTITY_INSERT [dbo].[ftorders] OFF;

	--SELECT * FROM [dbo].[ftorders]

    PRINT 'Table: dbo.ftorders: end'

-- =========================================================
-- Section 033: holidays
-- =========================================================

-- Column changes:
--  - Set [holidaysid] to be primary key
--  - Changed [holidaysid] to [holidayid]

    PRINT 'Table: dbo.holidays: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'holidays'))
		DROP TABLE [dbo].[holidays]

	CREATE TABLE [dbo].[holidays](
		[holidayid] [int] IDENTITY(1,1) NOT NULL,
		[hol_date] [datetime] NULL,
		[hol_desc] [char](25) NOT NULL DEFAULT '',
		CONSTRAINT [PK_holidays] PRIMARY KEY CLUSTERED 
		(
			[holidayid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[holidays] ON;

	INSERT INTO [dbo].[holidays] ([holidayid],[hol_date],[hol_desc])
	SELECT [holidaysid]
		  ,[hol_date]
		  ,[hol_desc]
	  FROM [rawUpsize_Contech].[dbo].[holidays]
  
	SET IDENTITY_INSERT [dbo].[holidays] OFF;

	--SELECT * FROM [dbo].[holidays]

    PRINT 'Table: dbo.holidays: end'

-- =========================================================
-- Section 033: hotcomps
-- =========================================================

-- Column changes:
--  - Added [hotcompid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [users] table
-- Maps:
--	- [hotcomps].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.holidays: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'hotcomps'))
		DROP TABLE [dbo].[hotcomps]

	CREATE TABLE [dbo].[hotcomps](
		[hotcompid] [int] IDENTITY(1,1) NOT NULL,
		--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp]
		[componetid] [int] NOT NULL DEFAULT 0,		-- FK = [componet].[comp] --> [componet].[componetid]
		[ent_date] [datetime] NULL,
		[job_no] [int] NOT NULL DEFAULT 0,
		[mod_date] [datetime] NULL,
		[reqd_amt] [int] NOT NULL DEFAULT 0,
		[rcvd_amt] [int] NOT NULL DEFAULT 0,
		[reqd_date] [datetime] NULL,
		[rej_amt] [int] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_hotcomps] PRIMARY KEY CLUSTERED 
		(
			[hotcompid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[hotcomps] ([componetid],[ent_date],[job_no],[mod_date],[reqd_amt],[rcvd_amt],[reqd_date],[rej_amt])
	SELECT --[rawUpsize_Contech].[dbo].[hotcomps].[comp]
		  ISNULL(componet.[componetid], 0) AS [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[ent_date]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[job_no]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[mod_date]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[reqd_amt]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[rcvd_amt]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[reqd_date]
		  ,[rawUpsize_Contech].[dbo].[hotcomps].[rej_amt]
	  FROM [rawUpsize_Contech].[dbo].[hotcomps]
	  LEFT JOIN [dbo].[componet] ON [rawUpsize_Contech].[dbo].[hotcomps].[comp] = componet.[comp] 

	--SELECT * FROM [dbo].[hotcomps]

    PRINT 'Table: dbo.holidays: end'

-- =========================================================
-- Section 033: incasdsp
-- =========================================================

-- Column changes:
--  - Set [incasdspid] to be primary key
--  - Changed [cmpcasesid] to [cmpcaseid]
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
-- Maps:
--	- [incasdsp].[cmpcasesid] --> [cmpcaseid]	-- FK = [cmpcases].[cmpcaseid]
--	- [incasdsp].[credit_no]					-- FK = [matlincr].[ct_cr_no]
--	- [incasdsp].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.incasdsp: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'incasdsp'))
		DROP TABLE [dbo].[incasdsp]

	CREATE TABLE [dbo].[incasdsp](
		[incasdspid] [int] IDENTITY(1,1) NOT NULL,
		[credit_no] [char](6) NOT NULL DEFAULT '',	-- FK = [matlincr].[ct_cr_no]
		[cmpcaseid] [int] NOT NULL DEFAULT 0,			-- FK = [cmpcases].[cmpcaseid]
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_incasdsp] PRIMARY KEY CLUSTERED 
		(
			[incasdspid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[incasdsp] ON;

	INSERT INTO [dbo].[incasdsp] ([incasdspid],[credit_no],[cmpcaseid],[add_userid],[add_dt])
	SELECT DISTINCT [rawUpsize_Contech].[dbo].[incasdsp].[incasdspid]
		  ,[rawUpsize_Contech].[dbo].[incasdsp].[credit_no]
		  ,[rawUpsize_Contech].[dbo].[incasdsp].[cmpcasesid]	-- FK = [cmpcases].[cmpcaseid]
		  --,[rawUpsize_Contech].[dbo].[incasdsp].[add_user]
		  ,ISNULL(users.[userid] , 0) as [userid]	
		  ,[rawUpsize_Contech].[dbo].[incasdsp].[add_dt]
	  FROM [rawUpsize_Contech].[dbo].[incasdsp]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[incasdsp].[add_user] = users.[username]	-- FK = [users].[username] --> [users].[userid]
	  ORDER BY [rawUpsize_Contech].[dbo].[incasdsp].[incasdspid]

	SET IDENTITY_INSERT [dbo].[incasdsp] OFF;

	--SELECT * FROM [dbo].[incasdsp]

    PRINT 'Table: dbo.incasdsp: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section033_HR.sql'

-- =========================================================