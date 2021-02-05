-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section023_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 023: bom_alt
-- =========================================================

-- Column changes:
--  - Added [bom_altid] to be primary key
--  - Added [bom_hdrid] to reference [bom_hdr] table using columns [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed the [bom_dtlid] field name to [bom_dtlref]. It will reference the existing value in the bom_dtlref field 
-- Maps:
--	- [bom_alt].[bom_hdrid]				-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [bom_alt].[bom_dtlid]				-- FK = [bom_dtl].[bom_dtlid] 
--	- [bom_alt].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.bom_alt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_alt'))
		DROP TABLE [dbo].[bom_alt]

	CREATE TABLE [dbo].[bom_alt](
		[bom_altid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_dtlid] [int] NOT NULL DEFAULT 0,	-- FK = [bom_dtl].[bom_dtlid] 
		[bom_dtlref] [int] NOT NULL DEFAULT 0,	-- FK = [bom_dtl].[bom_dtlid] 
		--[comp] [char](5) NOT NULL DEFAULT '',	-- FK = [componet].[comp] 
		[componetid] [int] NOT NULL DEFAULT 0,	-- FK = [componet].[comp] --> [componet].[componetid]
		--[bom_no] [int] NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [int] NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		CONSTRAINT [PK_bom_alt] PRIMARY KEY CLUSTERED 
		(
			[bom_altid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[bom_alt] ([bom_hdrid],[bom_dtlref],[componetid])
	SELECT ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  ,[rawUpsize_Contech].[dbo].[bom_alt].[bom_dtlid] AS [bom_dtlref]
		  --,[rawUpsize_Contech].[dbo].[bom_alt].[comp]
		  ,ISNULL(componet.[componetid], 0) AS [componetid] 
		  --,[rawUpsize_Contech].[dbo].[bom_alt].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[bom_alt].[bom_rev]
	  FROM [rawUpsize_Contech].[dbo].[bom_alt]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[bom_alt].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[bom_alt].[bom_rev] = bom_hdr.[bom_rev] 
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[bom_alt].[comp] = componet.[comp] -- FK = [componet].[comp] --> [componet].[componetid]
  
	--SELECT * FROM [dbo].[bom_alt]

    PRINT 'Table: dbo.bom_alt: end'
	
-- =========================================================
-- Section 023: bom_cust
-- =========================================================

-- Column changes:
--  - Set [bom_custid] to be primary key
--  - Added [bom_hdrid] to reference [bom_hdr] table using columns [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [bom_cust].[bom_hdrid]				-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [bom_cust].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [bom_cust].[add_user]	--> userid		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.bom_cust: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_cust'))
		DROP TABLE [dbo].[bom_cust]

	CREATE TABLE [dbo].[bom_cust](
		[bom_custid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no] 
		[customerid] [int] NOT NULL DEFAULT 0,			-- FK = [customer].[cust_no] -> [customer].[customerid]
		[sts] [char](1) NOT NULL DEFAULT '',
		[kanban] [char](1) NOT NULL DEFAULT '',
		[add_date] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] --> 
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[bom_main] [bit] NOT NULL DEFAULT 0,
		[sts_loc] [char](20) NOT NULL DEFAULT '',
		[kanban_loc] [char](20) NOT NULL DEFAULT '',
		[suppdata] [char](1) NOT NULL DEFAULT '',
		[sd_loc] [char](20) NOT NULL DEFAULT '',
		CONSTRAINT [PK_bom_cust] PRIMARY KEY CLUSTERED 
		(
			[bom_custid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[bom_cust] ON;

	INSERT INTO [dbo].[bom_cust] ([bom_custid],[bom_hdrid],[customerid],[sts],[kanban],[add_date],[add_userid],[bom_main],[sts_loc],[kanban_loc],[suppdata],[sd_loc])
	SELECT [rawUpsize_Contech].[dbo].[bom_cust].[bom_custid]
		  ,ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[bom_cust].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[bom_cust].[bom_rev]
		  --,[rawUpsize_Contech].[dbo].[bom_cust].[cust_no]
		  ,ISNULL(customer.[customerid], 0) as [customerid]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[sts]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[kanban]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[add_date]
		  --,[rawUpsize_Contech].[dbo].[bom_cust].[add_user]
		  ,ISNULL(users.[userid] , 0) as [userid]		
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[bom_main]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[sts_loc]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[kanban_loc]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[suppdata]
		  ,[rawUpsize_Contech].[dbo].[bom_cust].[sd_loc]
	  FROM [rawUpsize_Contech].[dbo].[bom_cust]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[bom_cust].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[bom_cust].[bom_rev] = bom_hdr.[bom_rev] 
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[bom_cust].[cust_no] = customer.[cust_no] 
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[bom_cust].[add_user] = users.[username]	
  
	SET IDENTITY_INSERT [dbo].[bom_cust] OFF;

	--SELECT * FROM [dbo].[bom_cust]

    PRINT 'Table: dbo.bom_cust: end'

-- =========================================================
-- Section 023: bom_hist
-- =========================================================

-- Column changes:
--  - Added bom_histid to be primary key
--  - Changed [emp_no] [char](10) to [employeeid] [int] to reference [employee] table
--  - Changed [notes] from [text] to [varchar](2000)
-- Maps:
--	- [bom_hist].[bom_no]					-- FK = [bom_hdr].[bom_no]
--	- [bom_hist].[emp_no] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.bom_hist: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_hist'))
		DROP TABLE [dbo].[bom_hist]

	CREATE TABLE [dbo].[bom_hist](
		[bom_histid] [int] IDENTITY(1,1) NOT NULL,
		[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		[type] [char](4) NOT NULL DEFAULT '',			
		[notes] [varchar](2000) NOT NULL DEFAULT '',
		[number] [char](5) NOT NULL DEFAULT '',
		[rev] [char](2) NOT NULL DEFAULT '',
		[daterev] [datetime] NULL,
		--[emp_no] [char](10) NOT NULL DEFAULT '',		-- FK = [employee].[empnumber] 
		[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
		[rev_dt] [datetime] NULL,
		CONSTRAINT [PK_bom_hist] PRIMARY KEY CLUSTERED 
		(
			[bom_histid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 
  
	INSERT INTO [dbo].[bom_hist] ([bom_no],[type],[notes],[number],[rev],[daterev],[employeeid],[rev_dt])
	SELECT [rawUpsize_Contech].[dbo].[bom_hist].[bom_no]
		  ,[rawUpsize_Contech].[dbo].[bom_hist].[type]
		  ,[rawUpsize_Contech].[dbo].[bom_hist].[notes]
		  ,[rawUpsize_Contech].[dbo].[bom_hist].[number]
		  ,[rawUpsize_Contech].[dbo].[bom_hist].[rev]
		  ,[rawUpsize_Contech].[dbo].[bom_hist].[daterev]
		  --,[rawUpsize_Contech].[dbo].[bom_hist].[emp_no]
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
		  ,[rawUpsize_Contech].[dbo].[bom_hist].[rev_dt]
	  FROM [rawUpsize_Contech].[dbo].[bom_hist]
		LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[bom_hist].[emp_no] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

	--SELECT * FROM [dbo].[bom_hist]

    PRINT 'Table: dbo.bom_hist: end'

-- =========================================================
-- Section 023: bom_pend
-- =========================================================

-- Column changes:
--  - Added bom_pendid to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Added [bom_hdrid] to reference [bom_hdr] table using columns [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
-- Maps:
--	- [bom_pend].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [bom_pend].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

    PRINT 'Table: dbo.bom_pend: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_pend'))
		DROP TABLE [dbo].[bom_pend]

	CREATE TABLE [dbo].[bom_pend](
		[bom_pendid] [int] IDENTITY(1,1) NOT NULL,
		--[comp] [char](5) NOT NULL DEFAULT '',			-- FK = [componet].[comp] 
		[componetid] [int] NOT NULL DEFAULT 0,			-- FK = [componet].[comp] --> [componet].[componetid]
		[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		[status] [char](1) NOT NULL DEFAULT '',
		[date] [datetime] NULL,
		CONSTRAINT [PK_bom_pend] PRIMARY KEY CLUSTERED 
		(
			[bom_pendid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 
  
	INSERT INTO [dbo].[bom_pend] ([componetid],[bom_hdrid],[status],[date])
	SELECT --[rawUpsize_Contech].[dbo].[bom_pend].[comp]
		  ISNULL(componet.[componetid], 0) AS [componetid] 
		  ,ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[bom_pend].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[bom_pend].[bom_rev]
		  ,[rawUpsize_Contech].[dbo].[bom_pend].[status]
		  ,[rawUpsize_Contech].[dbo].[bom_pend].[date]
	  FROM [rawUpsize_Contech].[dbo].[bom_pend]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[bom_pend].[comp] = componet.[comp] 
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[bom_pend].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[bom_pend].[bom_rev] = bom_hdr.[bom_rev] 
  
	--SELECT * FROM [dbo].[bom_pend]

    PRINT 'Table: dbo.bom_pend: end'

-- =========================================================
-- Section 023: bom_pric
-- =========================================================

-- Column changes:
--  - Set [bom_pricid] to be primary key
--  - Changed [price_note] from text to varchar(2000)
-- Maps:
--	- [bom_pend].[bom_no]		-- FK = [bom_hdr].[bom_no]

    PRINT 'Table: dbo.bom_pric: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_pric'))
		DROP TABLE [dbo].[bom_pric]

	CREATE TABLE [dbo].[bom_pric](
		[bom_pricid] [int] IDENTITY(1,1) NOT NULL,
		[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		[qty_from] [int] NOT NULL DEFAULT 0,
		[qty_to] [int] NOT NULL DEFAULT 0,
		[price] [numeric](8, 4) NOT NULL DEFAULT 0.0,
		[price_rev] [datetime] NULL,
		[price_note] varchar(2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_bom_pric] PRIMARY KEY CLUSTERED 
		(
			[bom_pricid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 
  
	SET IDENTITY_INSERT [dbo].[bom_pric] ON;

	INSERT INTO [dbo].[bom_pric] ([bom_pricid],[bom_no],[qty_from],[qty_to],[price],[price_rev],[price_note])
	SELECT [bom_pricid]
		  ,[bom_no]
		  ,[qty_from]
		  ,[qty_to]
		  ,[price]
		  ,[price_rev]
		  ,[price_note]
	  FROM [rawUpsize_Contech].[dbo].[bom_pric]
  
	SET IDENTITY_INSERT [dbo].[bom_pric] OFF;

	--SELECT * FROM [dbo].[bom_pric]

    PRINT 'Table: dbo.bom_pric: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section023_HR.sql'

-- =========================================================