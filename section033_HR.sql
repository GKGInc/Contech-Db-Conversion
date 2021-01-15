
-- =========================================================
-- Section 033: fmmaster
-- =========================================================

-- *** NOT USED ***

-- Column changes:
--  - Set [fmmasterid] to be primary key
--  - Changed [fmdesc] from text to varchar(2000)

--USE Contech_Test

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

--SET IDENTITY_INSERT [Contech_Test].[dbo].[fmmaster] ON;

--INSERT INTO [Contech_Test].[dbo].[fmmaster] ([fmmasterid],[fmname],[fmpdfname],[fmdesc])
--SELECT [fmmasterid]
--      ,[fmname]
--      ,[fmpdfname]
--      ,[fmdesc]
--  FROM [rawUpsize_Contech].[dbo].[fmmaster]
  
--SET IDENTITY_INSERT [Contech_Test].[dbo].[fmmaster] OFF;

----SELECT * FROM [Contech_Test].[dbo].[fmmaster]

-- =========================================================
-- Section 033: ftorders
-- =========================================================

-- Column changes:
--  - Changed [job_no] to [ftordersid] to be primary key 
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
-- Maps:
--	- [ftorders].[bom_no]					-- FK = [bom_hdr].[bom_no]
--	- [ftorders].[bom_rev]					-- FK = [bom_hdr].[bom_rev]
--	- ?[tbom_hdr].[bom_hdrid]				-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [ftorders].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [ftorders].[mfg_locid]				-- FK = [mfg_loc].[mfg_locid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ftorders'))
    DROP TABLE [dbo].[ftorders]

CREATE TABLE [dbo].[ftorders](
	--[job_no] [int] NOT NULL,	
	[ftordersid] [int] IDENTITY(1,1) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
	[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
	--[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
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
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[ftorders] ON;

INSERT INTO [Contech_Test].[dbo].[ftorders] ([ftordersid],[bom_no],[bom_rev],[status],[part_no],[part_rev],[cust_po],[qty_ord],[price],[requested],[awk_date],[customerid],[entered],[unit],[bo],[part_desc],[qty_firm_po],[mfg_locid])
SELECT [rawUpsize_Contech].[dbo].[ftorders].[job_no]
      ,[rawUpsize_Contech].[dbo].[ftorders].[bom_no]
      ,[rawUpsize_Contech].[dbo].[ftorders].[bom_rev]	  
	  --,ISNULL([Contech_Test].[dbo].[bom_hdr].[bom_hdrid], 0) AS [bom_hdrid] -- FK = [bom_hdr].[bom_hdrid]
      ,[rawUpsize_Contech].[dbo].[ftorders].[status]
      ,[rawUpsize_Contech].[dbo].[ftorders].[part_no]
      ,[rawUpsize_Contech].[dbo].[ftorders].[part_rev]
      ,[rawUpsize_Contech].[dbo].[ftorders].[cust_po]
      ,[rawUpsize_Contech].[dbo].[ftorders].[qty_ord]
      ,[rawUpsize_Contech].[dbo].[ftorders].[price]
      ,[rawUpsize_Contech].[dbo].[ftorders].[requested]
      ,[rawUpsize_Contech].[dbo].[ftorders].[awk_date]
      --,[rawUpsize_Contech].[dbo].[ftorders].[cust_no]
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) as [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
      ,[rawUpsize_Contech].[dbo].[ftorders].[entered]
      ,[rawUpsize_Contech].[dbo].[ftorders].[unit]
      ,[rawUpsize_Contech].[dbo].[ftorders].[bo]
      ,[rawUpsize_Contech].[dbo].[ftorders].[part_desc]
      ,[rawUpsize_Contech].[dbo].[ftorders].[qty_firm_po]
      ,[rawUpsize_Contech].[dbo].[ftorders].[mfg_locid]
  FROM [rawUpsize_Contech].[dbo].[ftorders]
  -- LEFT JOIN [Contech_Test].[dbo].[bom_hdr] 
	--ON [rawUpsize_Contech].[dbo].[ftorders].[bom_no] = [Contech_Test].[dbo].[bom_hdr].[bom_no] 
	--	AND [rawUpsize_Contech].[dbo].[ftorders].[bom_rev] = [Contech_Test].[dbo].[bom_hdr].[bom_rev]
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[ftorders].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no] 
	
SET IDENTITY_INSERT [Contech_Test].[dbo].[ftorders] OFF;

--SELECT * FROM [Contech_Test].[dbo].[ftorders]

-- =========================================================
-- Section 033: holidays
-- =========================================================

-- Column changes:
--  - Set [holidaysid] to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'holidays'))
    DROP TABLE [dbo].[holidays]

CREATE TABLE [dbo].[holidays](
	[holidaysid] [int] IDENTITY(1,1) NOT NULL,
	[hol_date] [datetime] NULL,
	[hol_desc] [char](25) NOT NULL DEFAULT '',
	CONSTRAINT [PK_holidays] PRIMARY KEY CLUSTERED 
	(
		[holidaysid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[holidays] ON;

INSERT INTO [Contech_Test].[dbo].[holidays] ([holidaysid],[hol_date],[hol_desc])
SELECT [holidaysid]
      ,[hol_date]
      ,[hol_desc]
  FROM [rawUpsize_Contech].[dbo].[holidays]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[holidays] OFF;

--SELECT * FROM [Contech_Test].[dbo].[holidays]

-- =========================================================
-- Section 033: hotcomps
-- =========================================================

-- Column changes:
--  - Added [hotcompsid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [users] table
-- Maps:
--	- [hotcomps].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'hotcomps'))
    DROP TABLE [dbo].[hotcomps]

CREATE TABLE [dbo].[hotcomps](
	[hotcompsid] [int] IDENTITY(1,1) NOT NULL,
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
		[hotcompsid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [Contech_Test].[dbo].[hotcomps] ([componetid],[ent_date],[job_no],[mod_date],[reqd_amt],[rcvd_amt],[reqd_date],[rej_amt])
SELECT --[rawUpsize_Contech].[dbo].[hotcomps].[comp]
	  ISNULL([Contech_Test].[dbo].[componet].[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[hotcomps].[ent_date]
      ,[rawUpsize_Contech].[dbo].[hotcomps].[job_no]
      ,[rawUpsize_Contech].[dbo].[hotcomps].[mod_date]
      ,[rawUpsize_Contech].[dbo].[hotcomps].[reqd_amt]
      ,[rawUpsize_Contech].[dbo].[hotcomps].[rcvd_amt]
      ,[rawUpsize_Contech].[dbo].[hotcomps].[reqd_date]
      ,[rawUpsize_Contech].[dbo].[hotcomps].[rej_amt]
  FROM [rawUpsize_Contech].[dbo].[hotcomps]
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[hotcomps].[comp] = [Contech_Test].[dbo].[componet].[comp] 

--SELECT * FROM [Contech_Test].[dbo].[hotcomps]

-- =========================================================
-- Section 033: incasdsp
-- =========================================================

-- Column changes:
--  - Set [incasdspid] to be primary key
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [incasdsp].[cmpcasesid]	-- FK = [cmpcases].[cmpcasesid]
--	- [incasdsp].[add_user] --> [userid]	-- FK = [users].[username] --> [users].[userid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'incasdsp'))
    DROP TABLE [dbo].[incasdsp]

CREATE TABLE [dbo].[incasdsp](
	[incasdspid] [int] IDENTITY(1,1) NOT NULL,
	[credit_no] [char](6) NOT NULL DEFAULT '',
	[cmpcasesid] [int] NOT NULL DEFAULT 0,			-- FK = [cmpcases].[cmpcasesid]
	--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
	[userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	[add_dt] [datetime] NULL,
	CONSTRAINT [PK_incasdsp] PRIMARY KEY CLUSTERED 
	(
		[incasdspid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[incasdsp] ON;

INSERT INTO [Contech_Test].[dbo].[incasdsp] ([incasdspid],[credit_no],[cmpcasesid],[userid],[add_dt])
SELECT [rawUpsize_Contech].[dbo].[incasdsp].[incasdspid]
      ,[rawUpsize_Contech].[dbo].[incasdsp].[credit_no]
      ,[rawUpsize_Contech].[dbo].[incasdsp].[cmpcasesid]
      --,[rawUpsize_Contech].[dbo].[incasdsp].[add_user]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid]	
      ,[rawUpsize_Contech].[dbo].[incasdsp].[add_dt]
  FROM [rawUpsize_Contech].[dbo].[incasdsp]
  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[incasdsp].[add_user] = [Contech_Test].[dbo].[users].[username]	-- FK = [users].[username] --> [users].[userid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[incasdsp] OFF;

--SELECT * FROM [Contech_Test].[dbo].[incasdsp]

-- =========================================================