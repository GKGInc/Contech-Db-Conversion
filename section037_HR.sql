-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section037_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 037: jobsetup *** NOT USED ***
-- =========================================================

-- Column changes:
--  - Set [jobsetupid] to be primary key
--  - Changed [job_no] to [ordersid] to match updated standards
-- Maps:
--	- [jobsetup].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]

--    PRINT 'Table: dbo.jobsetup: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'jobsetup'))
	--    DROP TABLE [dbo].[jobsetup]

	--CREATE TABLE [dbo].[jobsetup](
	--	[jobsetupid] [int] IDENTITY(1,1) NOT NULL,
	--	[tooldate] [datetime] NULL,
	--	--[job_no] [int] NOT NULL DEFAULT 0,
	--	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
	--	[machine] [char](10) NOT NULL DEFAULT'',
	--	[toolid] [char](10) NOT NULL DEFAULT'',
	--	[sampverfid] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[sampmatch] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[sampmatbom] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[tooltime] [char](8) NOT NULL DEFAULT'',
	--	[toolbyprnt] [char](10) NOT NULL DEFAULT'',
	--	[setupreq] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[stationclr] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[jobrbomrev] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[jobmatcbom] [numeric](1, 0) NOT NULL DEFAULT 0,
	--	[setupbyprn] [char](10) NOT NULL DEFAULT'',
	--	[setuptime] [char](8) NOT NULL DEFAULT'',
	--	[setupdate] [datetime] NULL,
	--	[approvedat] [datetime] NULL,
	--	[approvetim] [char](8) NOT NULL DEFAULT'',
	--	[approveprn] [char](10) NOT NULL DEFAULT'',
	--	[jobmachine] [char](20) NOT NULL DEFAULT'',
	--	CONSTRAINT [PK_jobsetup] PRIMARY KEY CLUSTERED 
	--	(
	--		[jobsetupid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	--) ON [PRIMARY]
	--GO

	--SET IDENTITY_INSERT [dbo].[jobsetup] ON;

	--INSERT INTO [Contech_Test].[dbo].[jobsetup] ([jobsetupid],[tooldate],[ordersid],[machine],[toolid],[sampverfid],[sampmatch],[sampmatbom],[tooltime],[toolbyprnt],[setupreq],[stationclr],[jobrbomrev],[jobmatcbom],[setupbyprn],[setuptime],[setupdate],[approvedat],[approvetim],[approveprn],[jobmachine])
	--SELECT [rawUpsize_Contech].[dbo].[jobsetup].[jobsetupid]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[tooldate]
	--      --,[rawUpsize_Contech].[dbo].[jobsetup].[job_no]
	--	  ,ISNULL(orders.[ordersid], 0) AS [ordersid] -- FK = [orders].[job_no] --> [orders].[ordersid] 
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[machine]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[toolid]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[sampverfid]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[sampmatch]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[sampmatbom]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[tooltime]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[toolbyprnt]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[setupreq]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[stationclr]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[jobrbomrev]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[jobmatcbom]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[setupbyprn]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[setuptime]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[setupdate]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[approvedat]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[approvetim]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[approveprn]
	--      ,[rawUpsize_Contech].[dbo].[jobsetup].[jobmachine]
	--  FROM [rawUpsize_Contech].[dbo].[jobsetup] 
	--  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[jobsetup].[job_no] = orders.[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
  
	--SET IDENTITY_INSERT [dbo].[jobsetup] OFF;

	--SELECT * FROM [dbo].[jobsetup]

--    PRINT 'Table: dbo.jobsetup: end'

-- =========================================================
-- Section 037: lab001 *** NOT USED ***
-- =========================================================

-- Column changes:
--  - Set [lab001id] to be primary key
--  - Changed [job_no] to [ordersid] to match updated standards
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [lab001].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
--	- [lab001].[add_user]		-- FK = [users].[username] --> [users].[userid]

--    PRINT 'Table: dbo.lab001: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lab001'))
	--    DROP TABLE [dbo].[lab001]

	--CREATE TABLE [dbo].[lab001](
	--	[lab001id] [int] IDENTITY(1,1) NOT NULL,
	--	[shppack_id] [int] NOT NULL DEFAULT 0,			-- FK ???
	--	--[job_no] [int] NOT NULL DEFAULT 0,
	--	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
	--	[add_dt] [datetime] NULL,
	--	--[add_user] [char](10) NOT NULL,
	--	[userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	--	CONSTRAINT [PK_lab001] PRIMARY KEY CLUSTERED 
	--	(
	--		[lab001id] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	--) ON [PRIMARY]
	--GO

	--SET IDENTITY_INSERT [dbo].[lab001] ON;

	--INSERT INTO [dbo].[lab001] ([lab001id],[shppack_id],[ordersid],[add_dt],[add_dt],[userid])
	--SELECT [rawUpsize_Contech].[dbo].[lab001].[lab001id]
	--      ,[rawUpsize_Contech].[dbo].[lab001].[shppack_id]
	--      --,[rawUpsize_Contech].[dbo].[lab001].[job_no]
	--	  ,ISNULL(orders.[ordersid], 0) AS [ordersid] -- FK = [orders].[job_no] --> [orders].[ordersid] 
	--      ,[rawUpsize_Contech].[dbo].[lab001].[add_dt]
	--      --,[rawUpsize_Contech].[dbo].[lab001].[add_user]
	--	  ,ISNULL(users.[userid] , 0) as [userid]
	--  FROM [rawUpsize_Contech].[dbo].[lab001]
	--  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[lab001].[job_no] = orders.[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
	--  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[lab001].[add_user] = users.[username]	-- FK = [users].[userid]

	--SET IDENTITY_INSERT [dbo].[lab001] OFF;

	--SELECT * FROM [dbo].[lab001]

--    PRINT 'Table: dbo.lab001: end'

-- =========================================================
-- Section 037: ladinghd
-- =========================================================

-- Column changes:
--  - Added [ladinghdid] to be primary key to replace [shipper_no] [char](6)
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [ship_to] [char](1) to [custshipid] [int] to reference [custship] table
-- Maps:
--	- [ladinghd].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [ladinghd].[ship_to] --> [custshipid]	-- FK = [custship].[ship_to] --> [custship].[custshipid] {composite key with [cust_no] to [custship] table}

    PRINT 'Table: dbo.ladinghd: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ladinghd'))
		DROP TABLE [dbo].[ladinghd]

	CREATE TABLE [dbo].[ladinghd](
		--[shipper_no] [char](6) NOT NULL DEFAULT '',
		[ladinghdid] [int] IDENTITY(1,1) NOT NULL,
		[carrier] [char](20) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT '',	-- FK = [customer].[cust_no] 
		[customerid] [int] NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] --> [customer].[customerid]			
		--[ship_to] [char](1) NOT NULL DEFAULT '',	-- FK = [custship].[ship_to] 
		[custshipid] [int] NOT NULL DEFAULT 0,		-- FK = [custship].[ship_to] --> [custship].[custshipid]	
		[ship_date] [datetime] NULL,
		[skids] [numeric](2, 0) NOT NULL DEFAULT 0,
		[cases] [numeric](4, 0) NOT NULL DEFAULT 0,
		[weight] [numeric](4, 0) NOT NULL DEFAULT 0,
		[tot_charge] [numeric](9, 2) NOT NULL,
		[remitcod] [char](25) NOT NULL DEFAULT '',
		[codamt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[codfee] [numeric](6, 2) NOT NULL DEFAULT 0.0,
		[tot_inv] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[pay_type] [char](1) NOT NULL DEFAULT '',
		CONSTRAINT [PK_ladinghd] PRIMARY KEY CLUSTERED 
		(
			[ladinghdid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[ladinghd] ON;

	INSERT INTO [dbo].[ladinghd] ([ladinghdid],[carrier],[customerid],[custshipid],[ship_date],[skids],[cases],[weight],[tot_charge],[remitcod],[codamt],[codfee],[tot_inv],[pay_type])
	SELECT [rawUpsize_Contech].[dbo].[ladinghd].[shipper_no]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[carrier]      
		  --,[rawUpsize_Contech].[dbo].[ladinghd].[cust_no]		
		  ,ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
		  --,[rawUpsize_Contech].[dbo].[ladinghd].[ship_to]		
		  ,ISNULL(custship.[custshipid], 0) AS [custshipid]		-- FK = [custship].[ship_to] --> [custship].[custshipid] 
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[ship_date]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[skids]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[cases]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[weight]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[tot_charge]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[remitcod]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[codamt]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[codfee]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[tot_inv]
		  ,[rawUpsize_Contech].[dbo].[ladinghd].[pay_type]
	  FROM [rawUpsize_Contech].[dbo].[ladinghd]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[ladinghd].[cust_no] = customer.[cust_no]
	  LEFT JOIN [dbo].[custship] custship -- {composite key with [cust_no] to [custship] table}
		ON [rawUpsize_Contech].[dbo].[ladinghd].[ship_to] COLLATE SQL_Latin1_General_CP1_CS_AS = custship.[ship_to] COLLATE SQL_Latin1_General_CP1_CS_AS 	
			AND [rawUpsize_Contech].[dbo].[ladinghd].[cust_no] = customer.[cust_no] AND customer.[customerid] = custship.[customerid] 
			
	SET IDENTITY_INSERT [dbo].[ladinghd] OFF;

	--SELECT * FROM [dbo].[ladinghd]

    PRINT 'Table: dbo.ladinghd: end'

-- =========================================================
-- Section 037: ladingdt
-- =========================================================

-- Column changes:
--  - Set [ladingdtid] to be primary key
--  - Replace [shipper_no] [char](6) to [ladinghdid] [int] to match updated standards
--  - Replace [invoice_no] [numeric](9, 0) to [aropenid] [int] to match updated standards
-- Maps:
--	- [ladingdt].[shipper_no] --> [ladinghdid]	-- FK = [ladinghd].[shipper_no] == [ladinghd].[ladinghdid]
--	- [ladingdt].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]

    PRINT 'Table: dbo.ladingdt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ladingdt'))
		DROP TABLE [dbo].[ladingdt]

	CREATE TABLE [dbo].[ladingdt](
		[ladingdtid] [int] IDENTITY(1,1) NOT NULL,
		--[shipper_no] [char](6) NOT NULL DEFAULT '',		-- FK = [ladinghd].[shipper_no] 
		[ladinghdid] [int] NOT NULL DEFAULT '',				-- FK = [ladinghd].[shipper_no] == [ladinghd].[ladinghdid]
		--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no] 
		[aropenid] [int] NOT NULL DEFAULT 0,				-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[rev_relid] [int] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_ladingdt] PRIMARY KEY CLUSTERED 
		(
			[ladingdtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[ladingdt] ON;

	INSERT INTO [dbo].[ladingdt] ([ladingdtid],[ladinghdid],[aropenid],[rev_relid])
	SELECT [rawUpsize_Contech].[dbo].[ladingdt].[ladingdtid]
		  ,[rawUpsize_Contech].[dbo].[ladingdt].[shipper_no]		-- FK = [ladinghd].[shipper_no] == [ladinghd].[ladinghdid]
		  --,[rawUpsize_Contech].[dbo].[ladingdt].[invoice_no]
		  ,ISNULL(aropen.[aropenid], 0) AS [aropenid]				-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[ladingdt].[rev_relid]
	  FROM [rawUpsize_Contech].[dbo].[ladingdt]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[ladingdt].[invoice_no] = aropen.[invoice_no]		-- FK = [aropen].[invoice_no] 
	ORDER BY [rawUpsize_Contech].[dbo].[ladingdt].[ladingdtid]

	SET IDENTITY_INSERT [dbo].[ladingdt] OFF;

	--SELECT * FROM [dbo].[ladingdt]

    PRINT 'Table: dbo.ladingdt: end'

-- =========================================================
-- Section 037: lblrecon
-- =========================================================

-- Column changes:
--  - Set [lblreconid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [lblrecon].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [lblrecon].[add_user]					-- FK = [users].[username] --> [users].[userid]
--	- [lblrecon].[mod_user]					-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.lblrecon: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lblrecon'))
		DROP TABLE [dbo].[lblrecon]

	CREATE TABLE [dbo].[lblrecon](
		[lblreconid] [int] IDENTITY(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no] 
		[customerid] [int] NOT NULL DEFAULT 0,			-- FK = [customer].[cust_no] --> [customer].[customerid]
		[cus_lot] [char](12) NOT NULL DEFAULT '',
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL,
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL,
		[mod_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_lblrecon] PRIMARY KEY CLUSTERED 
		(
			[lblreconid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[lblrecon] ON;

	INSERT INTO [dbo].[lblrecon] ([lblreconid],[customerid],[cus_lot],[add_dt],[add_userid],[mod_dt],[mod_userid])
	SELECT [rawUpsize_Contech].[dbo].[lblrecon].[lblreconid]
		  --,[rawUpsize_Contech].[dbo].[lblrecon].[cust_no]	
		  ,ISNULL(customer.[customerid], 0) as [customerid]
		  ,[rawUpsize_Contech].[dbo].[lblrecon].[cus_lot]
		  ,[rawUpsize_Contech].[dbo].[lblrecon].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[lblrecon].[add_user]
		  ,ISNULL(addUser.[userid] , 0) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[lblrecon].[mod_dt]
		  --,[rawUpsize_Contech].[dbo].[lblrecon].[mod_user]
		  ,ISNULL(modUser.[userid] , 0) as [userid]			
	  FROM [rawUpsize_Contech].[dbo].[lblrecon]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[lblrecon].[cust_no] = customer.[cust_no]	-- FK = [customer].[cust_no] --> [customer].[customerid]
	  LEFT JOIN [dbo].[users] addUser ON [rawUpsize_Contech].[dbo].[lblrecon].[add_user] = addUser.[username]					-- FK = [users].[userid]
	  LEFT JOIN [dbo].[users] modUser ON [rawUpsize_Contech].[dbo].[lblrecon].[mod_user] = modUser.[username]					-- FK = [users].[userid]

	SET IDENTITY_INSERT [dbo].[lblrecon] OFF;

	--SELECT * FROM [dbo].[lblrecon]

    PRINT 'Table: dbo.lblrecon: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section037_HR.sql'

-- =========================================================
