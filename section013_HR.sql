-- =========================================================
-- Section 013: fplocatn
-- =========================================================

-- Column changes:
--  - Change [fplocatnid] to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fplocatn'))
    DROP TABLE [dbo].[fplocatn]

CREATE TABLE [dbo].[fplocatn](
	[fplocatnid] [int] IDENTITY(1,1) NOT NULL,
	[staging] [bit] NOT NULL DEFAULT 0,
	[location] [char](5) NOT NULL DEFAULT '',
	[locfloor] [int] NOT NULL DEFAULT 0,
	[allowmix] [bit] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_fplocatn] PRIMARY KEY CLUSTERED 
	(
		[fplocatnid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[fplocatn] ON;

INSERT INTO [Contech_Test].[dbo].[fplocatn] ([fplocatnid],[staging],[location],[locfloor],[allowmix])
SELECT [fplocatnid]
      ,[staging]
      ,[location]
      ,[locfloor]
      ,[allowmix]
  FROM [rawUpsize_Contech].[dbo].[fplocatn]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[fplocatn] OFF;

--SELECT * FROM [Contech_Test].[dbo].[fplocatn]

-- =========================================================
-- Section 013: prodctra
-- =========================================================

-- Column changes:
--  - Moved [prodctraid] to first column
--  - Changed [prodctraid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Renamed [complnt_no] to [complntid] to reference [complnts] table
--  - Renamed [job_no] to [ordersid] to reference [orders] table

--  - Changed [inspection] from [text] to [varchar](2000)
--  - Changed [mrc_disp] from [text] to [varchar](2000)
--  - Changed [cust_issue] from [text] to [varchar](2000)
-- Maps:
--	- [prodctra].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [prodctra].[complnt_no] --> [complntid]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
--	- [prodctra].[job_no] --> [ordersid]		-- FK = [orders].[job_no] --> [orders].[ordersid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prodctra'))
    DROP TABLE [dbo].[prodctra]

CREATE TABLE [dbo].[prodctra](
	[prodctraid] [int] IDENTITY(1,1) NOT NULL,
	[ra_no] [char](9) NOT NULL DEFAULT '',
	[ra_dt] [datetime] NULL,
	--[invoice_no] [numeric](9, 0) NOT NULL,		-- FK = [aropen].[invoice_no] 
	[aropenid] [int] NOT NULL DEFAULT 0,			-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	[ra_qty] [int] NOT NULL DEFAULT 0,
	--[complnt_no] [int] NOT NULL DEFAULT 0,		-- FK = [complnts].[complnt_no] 
	[complntid] [int] NOT NULL DEFAULT 0,			-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
	[contact] [char](3) NOT NULL DEFAULT '',
	[ship_via] [char](30) NOT NULL DEFAULT '',
	[rcvd_dt] [datetime] NULL,
	[rcvd_qty] [int] NOT NULL DEFAULT 0,
	[rcvr_init] [char](3) NOT NULL DEFAULT '',
	[rcvd_cond] [char](90) NOT NULL DEFAULT '',
	[inspection] [varchar](2000) NOT NULL DEFAULT '',
	[qasign] [char](50) NOT NULL DEFAULT '',
	[qasign_dt] [datetime] NULL,
	[mrc_disp] [varchar](2000) NOT NULL DEFAULT '',
	[sign2] [char](50) NOT NULL DEFAULT '',
	[sign2_dt] [datetime] NULL,
	[sign1] [char](50) NOT NULL DEFAULT '',
	[sign1_dt] [datetime] NULL,
	[cr_invoice] [numeric](9, 0) NOT NULL DEFAULT 0,
	[officeinit] [char](3) NOT NULL DEFAULT '',
	[credit] [numeric](1, 0) NOT NULL DEFAULT 0,
	[freight] [numeric](1, 0) NOT NULL DEFAULT 0,
	[cust_issue] [varchar](2000) NOT NULL DEFAULT '',
	--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] 
	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
	[rework_no] [char](10) NOT NULL DEFAULT '',
	[viapay] [char](1) NOT NULL DEFAULT '',
	[shpcustvia] [char](30) NOT NULL DEFAULT '',
	[materltobe] [char](1) NOT NULL DEFAULT '',
	[special] [char](50) NOT NULL DEFAULT '',
	[jobstatus] [char](1) NOT NULL DEFAULT '',
	[disposition] [int] NOT NULL DEFAULT 0,
	[disp_doc] [char](10) NOT NULL DEFAULT '',
	[inspresult] [char](1) NOT NULL DEFAULT '',
	CONSTRAINT [PK_prodctra] PRIMARY KEY CLUSTERED 
	(
		[prodctraid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prodctra] ON;

INSERT INTO [Contech_Test].[dbo].[prodctra] ([prodctraid],[ra_no],[ra_dt],[aropenid],[ra_qty],[complntid],[contact],[ship_via],[rcvd_dt],[rcvd_qty],[rcvr_init],[rcvd_cond],[inspection],[qasign],[qasign_dt],[mrc_disp],[sign2],[sign2_dt],[sign1],[sign1_dt],[cr_invoice],[officeinit],[credit],[freight],[cust_issue],[ordersid],[rework_no],[viapay],[shpcustvia],[materltobe],[special],[jobstatus],[disposition],[disp_doc],[inspresult])
SELECT [rawUpsize_Contech].[dbo].[prodctra].[prodctraid]
      ,[rawUpsize_Contech].[dbo].[prodctra].[ra_no]
      ,[rawUpsize_Contech].[dbo].[prodctra].[ra_dt]
      --,[rawUpsize_Contech].[dbo].[prodctra].[invoice_no]
	  ,ISNULL([Contech_Test].[dbo].[aropen].[aropenid], 0) AS [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
      ,[rawUpsize_Contech].[dbo].[prodctra].[ra_qty]
      --,[rawUpsize_Contech].[dbo].[prodctra].[complnt_no]
	  ,ISNULL([Contech_Test].[dbo].[complnts].[complntid], 0) AS [complntid] -- FK = [complnts].[complnt_no] --> [complnts].[complntid]
      ,[rawUpsize_Contech].[dbo].[prodctra].[contact]
      ,[rawUpsize_Contech].[dbo].[prodctra].[ship_via]
      ,[rawUpsize_Contech].[dbo].[prodctra].[rcvd_dt]
      ,[rawUpsize_Contech].[dbo].[prodctra].[rcvd_qty]
      ,[rawUpsize_Contech].[dbo].[prodctra].[rcvr_init]
      ,[rawUpsize_Contech].[dbo].[prodctra].[rcvd_cond]
      ,[rawUpsize_Contech].[dbo].[prodctra].[inspection]
      ,[rawUpsize_Contech].[dbo].[prodctra].[qasign]
      ,[rawUpsize_Contech].[dbo].[prodctra].[qasign_dt]
      ,[rawUpsize_Contech].[dbo].[prodctra].[mrc_disp]
      ,[rawUpsize_Contech].[dbo].[prodctra].[sign2]
      ,[rawUpsize_Contech].[dbo].[prodctra].[sign2_dt]
      ,[rawUpsize_Contech].[dbo].[prodctra].[sign1]
      ,[rawUpsize_Contech].[dbo].[prodctra].[sign1_dt]
      ,[rawUpsize_Contech].[dbo].[prodctra].[cr_invoice]
      ,[rawUpsize_Contech].[dbo].[prodctra].[officeinit]
      ,[rawUpsize_Contech].[dbo].[prodctra].[credit]
      ,[rawUpsize_Contech].[dbo].[prodctra].[freight]
      ,[rawUpsize_Contech].[dbo].[prodctra].[cust_issue]
      --,[rawUpsize_Contech].[dbo].[prodctra].[job_no]
	  ,ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid]	-- FK = [orders].[job_no] --> [orders].[ordersid]
      ,[rawUpsize_Contech].[dbo].[prodctra].[rework_no]
      ,[rawUpsize_Contech].[dbo].[prodctra].[viapay]
      ,[rawUpsize_Contech].[dbo].[prodctra].[shpcustvia]
      ,[rawUpsize_Contech].[dbo].[prodctra].[materltobe]
      ,[rawUpsize_Contech].[dbo].[prodctra].[special]
      ,[rawUpsize_Contech].[dbo].[prodctra].[jobstatus]
      ,[rawUpsize_Contech].[dbo].[prodctra].[disposition]
      ,[rawUpsize_Contech].[dbo].[prodctra].[disp_doc]
      ,[rawUpsize_Contech].[dbo].[prodctra].[inspresult]
  FROM [rawUpsize_Contech].[dbo].[prodctra]
  LEFT JOIN [Contech_Test].[dbo].[aropen] ON [rawUpsize_Contech].[dbo].[prodctra].[invoice_no] = [Contech_Test].[dbo].[aropen].[invoice_no]		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
  LEFT JOIN [Contech_Test].[dbo].[complnts] ON [rawUpsize_Contech].[dbo].[prodctra].[complnt_no] = [Contech_Test].[dbo].[complnts].[complnt_no] -- FK = [complnts].[complnt_no] --> [complnts].[complntid]
  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[prodctra].[job_no] = [Contech_Test].[dbo].[orders].[job_no]				-- FK = [orders].[job_no] --> [orders].[ordersid]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[prodctra] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prodctra]

-- =========================================================
-- Section 013: prodschd
-- =========================================================

-- Column changes:
--  - Changed prodschdid to be primary key
--  - Changed empnumber to int to reference employee table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
--  - Renamed [job_no] to [ordersid] to reference [orders] table
--  - Changed [comments] from [text] to [varchar](2000)
-- Maps:
--	- [prodschd].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid] 
--	- [prodschd].[job_no] --> [ordersid]		-- FK = [orders].[job_no] --> [orders].[ordersid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prodschd'))
    DROP TABLE [dbo].[prodschd]

CREATE TABLE [dbo].[prodschd](
	[prodschdid] [int] IDENTITY(1,1) NOT NULL,
	--[empnumber] [char](10) NOT NULL DEFAULT '', -- FK = [employee].[empnumber] 
	[employeeid] [int] NOT NULL DEFAULT 0,		-- FK = [employee].[empnumber] --> [employee].[employeeid] 
	--[job_no] [int] NOT NULL DEFAULT 0,		-- FK = [orders].[job_no] 
	[ordersid] [int] NOT NULL DEFAULT 0,		-- FK = [orders].[job_no] --> [orders].[ordersid]
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[qty_comp] [numeric](7, 0) NOT NULL DEFAULT 0,
	[comments] varchar(2000) NOT NULL DEFAULT '',
	[totemps] [int] NOT NULL DEFAULT 0,
	[calcdstart] [datetime] NULL,
	CONSTRAINT [PK_prodschd] PRIMARY KEY CLUSTERED 
	(
		[prodschdid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prodschd] ON;

INSERT INTO [Contech_Test].[dbo].[prodschd] ([prodschdid],[employeeid],[ordersid],[start_date],[end_date],[qty_comp],[comments],[totemps],[calcdstart])
SELECT [rawUpsize_Contech].[dbo].[prodschd].[prodschdid]
      --,[rawUpsize_Contech].[dbo].[prodschd].[empnumber]
	  ,ISNULL([Contech_Test].[dbo].[employee].[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid] 
      --,[rawUpsize_Contech].[dbo].[prodschd].[job_no]
	  ,ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid]		-- FK = [orders].[job_no] --> [orders].[ordersid]
      ,[rawUpsize_Contech].[dbo].[prodschd].[start_date]
      ,[rawUpsize_Contech].[dbo].[prodschd].[end_date]
      ,[rawUpsize_Contech].[dbo].[prodschd].[qty_comp]
      ,[rawUpsize_Contech].[dbo].[prodschd].[comments]
      ,[rawUpsize_Contech].[dbo].[prodschd].[totemps]
      ,[rawUpsize_Contech].[dbo].[prodschd].[calcdstart]
  FROM [rawUpsize_Contech].[dbo].[prodschd]  
  LEFT JOIN [Contech_Test].[dbo].[employee] ON [rawUpsize_Contech].[dbo].[prodschd].[empnumber] = [Contech_Test].[dbo].[employee].[empnumber]
  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[prodschd].[job_no] = [Contech_Test].[dbo].[orders].[job_no]

SET IDENTITY_INSERT [Contech_Test].[dbo].[prodschd] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prodschd]

-- =========================================================
-- Section 013: prodtabl
-- =========================================================

-- Column changes:
--  - Changed [prodtablid] to be primary key
-- Maps:
--	- [prodtabl].[prodschdid]	-- FK = [prodschd].[prodschdid] 

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prodtabl'))
    DROP TABLE [dbo].[prodtabl]

CREATE TABLE [dbo].[prodtabl](
	[prodtablid] [int] IDENTITY(1,1) NOT NULL,
	[prodschdid] [int] NOT NULL DEFAULT 0,	-- FK = [prodschd].[prodschdid]
	[table] [char](10) NOT NULL DEFAULT '',
	CONSTRAINT [PK_prodtabl] PRIMARY KEY CLUSTERED 
	(
		[prodtablid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prodtabl] ON;

INSERT INTO [Contech_Test].[dbo].[prodtabl] ([prodtablid],[prodschdid],[table])
SELECT [prodtablid]
      ,[prodschdid]
      ,[table]
  FROM [rawUpsize_Contech].[dbo].[prodtabl]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[prodtabl] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prodtabl]

-- =========================================================