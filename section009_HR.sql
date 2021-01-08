
-- =========================================================
--Section 009: qrn
-- =========================================================

-- Column changes:
--  - Changed qrnid to be primary key
--  - Changed cust_no to int to reference customer table
--  - Changed ven_id to int to reference mfgcat table
--  - Changed empnumber to int to reference employee table
-- Maps:
--	- [qrn].[cust_no]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [qrn].[ven_id]		-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
--	- [qrn].[matlinid]	-- FK = [matlin].[matlin_key] -> [matlin].[matlinid]
--	- [qrn].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrn'))
    DROP TABLE [dbo].[qrn]
	
CREATE TABLE [dbo].[qrn](
	[qrnid] [int] identity(1,1) NOT NULL,
	[qrn_no] [char](8) NOT NULL,
	[source] [char](2) NOT NULL,
	[comp] [char](5) NOT NULL,
	[fin_good] [char](15) NOT NULL,
	[fin_lot] [char](8) NOT NULL,
	[ct_lot] [char](4) NOT NULL,
	[cust_no] [char](5) NOT NULL,	-- FK = [qrn].[cust_no] -> [customer].[customerid]
	[cust_lot] [char](15) NOT NULL,
	[ven_id] [int] NOT NULL,		-- FK = [qrn].[ven_id] -> [vendor].[vendorid]
	[ven_lot] [char](15) NOT NULL,
	[po_no] [char](8) NOT NULL,
	[cust_po] [char](15) NOT NULL,
	[recd] [numeric](10, 0) NOT NULL,
	[rejected] [numeric](10, 0) NOT NULL,
	[inspected] [numeric](10, 0) NOT NULL,
	[defective] [numeric](10, 0) NOT NULL,
	[inspector] [char](10) NOT NULL,
	[qrn_date] [datetime] NULL,
	[reason] [text] NOT NULL,
	[ct_cpa] [char](10) NOT NULL,
	[action] [bit] NOT NULL,
	[post] [bit] NOT NULL,
	[matlinid] [int] NOT NULL,			-- FK = [matlin].[matlinid]
	[matlincrid] [int] NOT NULL,
	[use_as] [bit] NOT NULL,
	[rework] [bit] NOT NULL,
	[return] [bit] NOT NULL,
	[scrap] [bit] NOT NULL,
	[mrc] [bit] NOT NULL,
	[returned] [numeric](10, 0) NOT NULL,
	[kept] [numeric](10, 0) NOT NULL,
	[comments] [text] NOT NULL,
	[rev_dt] [datetime] NULL,
	[hold] [bit] NOT NULL,
	[reopen_po] [bit] NOT NULL,
	[internal] [bit] NOT NULL,
	[comp_desc] [char](75) NOT NULL,
	[empnumber] [int] NOT NULL,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
	[external] [bit] NOT NULL,
	[rework_no] [char](10) NOT NULL,
	[rjct_close] [datetime] NULL,
	[keep_close] [datetime] NULL,
	[vndnotfied] [datetime] NULL,
	[vndrsponse] [datetime] NULL,
	[sort] [bit] NOT NULL,
	[regrade] [bit] NOT NULL,
	CONSTRAINT [PK_qrn] PRIMARY KEY CLUSTERED 
	(
		[qrnid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[qrn] ON;

INSERT INTO [Contech_Test].[dbo].[qrn] ([qrnid],[qrn_no],[source],[comp],[fin_good],[fin_lot],[ct_lot],[cust_no],[cust_lot],[ven_id],[ven_lot],[po_no],[cust_po],[recd],[rejected],[inspected],[defective],[inspector],[qrn_date],[reason],[ct_cpa],[action],[post],[matlinid],[matlincrid],[use_as],[rework],[return],[scrap],[mrc],[returned],[kept],[comments],[rev_dt],[hold],[reopen_po],[internal],[comp_desc],[empnumber],[external],[rework_no],[rjct_close],[keep_close],[vndnotfied],[vndrsponse],[sort],[regrade])
SELECT [rawUpsize_Contech].[dbo].[qrn].[qrnid]
      ,[rawUpsize_Contech].[dbo].[qrn].[qrn_no]
      ,[rawUpsize_Contech].[dbo].[qrn].[source]
      ,[rawUpsize_Contech].[dbo].[qrn].[comp]
      ,[rawUpsize_Contech].[dbo].[qrn].[fin_good]
      ,[rawUpsize_Contech].[dbo].[qrn].[fin_lot]
      ,[rawUpsize_Contech].[dbo].[qrn].[ct_lot]
      --,[rawUpsize_Contech].[dbo].[qrn].[cust_no]	
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) AS [customerid] -- [orders].[cust_no]	-- FK = [customer].[cust_no] -> [customer].[customerid]
      ,[rawUpsize_Contech].[dbo].[qrn].[cust_lot]
      --,[rawUpsize_Contech].[dbo].[qrn].[ven_id]		
	  ,ISNULL([Contech_Test].[dbo].[vendor].[vendorid], 0) AS [vendorid]	-- [orders].[ven_id]		-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
      ,[rawUpsize_Contech].[dbo].[qrn].[ven_lot]
      ,[rawUpsize_Contech].[dbo].[qrn].[po_no]
      ,[rawUpsize_Contech].[dbo].[qrn].[cust_po]
      ,[rawUpsize_Contech].[dbo].[qrn].[recd]
      ,[rawUpsize_Contech].[dbo].[qrn].[rejected]
      ,[rawUpsize_Contech].[dbo].[qrn].[inspected]
      ,[rawUpsize_Contech].[dbo].[qrn].[defective]
      ,[rawUpsize_Contech].[dbo].[qrn].[inspector]
      ,[rawUpsize_Contech].[dbo].[qrn].[qrn_date]
      ,[rawUpsize_Contech].[dbo].[qrn].[reason]
      ,[rawUpsize_Contech].[dbo].[qrn].[ct_cpa]
      ,[rawUpsize_Contech].[dbo].[qrn].[action]
      ,[rawUpsize_Contech].[dbo].[qrn].[post]
      --,[rawUpsize_Contech].[dbo].[qrn].[matlinid]	
	  ,ISNULL([Contech_Test].[dbo].[matlin].[matlinid], 0) AS [matlinid]		-- [orders].[matlinid]	-- FK = [matlin].[matlin_key] -> [matlin].[matlinid]
      ,[rawUpsize_Contech].[dbo].[qrn].[matlincrid]
      ,[rawUpsize_Contech].[dbo].[qrn].[use_as]
      ,[rawUpsize_Contech].[dbo].[qrn].[rework]
      ,[rawUpsize_Contech].[dbo].[qrn].[return]
      ,[rawUpsize_Contech].[dbo].[qrn].[scrap]
      ,[rawUpsize_Contech].[dbo].[qrn].[mrc]
      ,[rawUpsize_Contech].[dbo].[qrn].[returned]
      ,[rawUpsize_Contech].[dbo].[qrn].[kept]
      ,[rawUpsize_Contech].[dbo].[qrn].[comments]
      ,[rawUpsize_Contech].[dbo].[qrn].[rev_dt]
      ,[rawUpsize_Contech].[dbo].[qrn].[hold]
      ,[rawUpsize_Contech].[dbo].[qrn].[reopen_po]
      ,[rawUpsize_Contech].[dbo].[qrn].[internal]
      ,[rawUpsize_Contech].[dbo].[qrn].[comp_desc]
      --,[rawUpsize_Contech].[dbo].[qrn].[empnumber]	
	  ,ISNULL([Contech_Test].[dbo].[employee].[employeeid], 0) AS [employeeid]	-- [orders].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
      ,[rawUpsize_Contech].[dbo].[qrn].[external]
      ,[rawUpsize_Contech].[dbo].[qrn].[rework_no]
      ,[rawUpsize_Contech].[dbo].[qrn].[rjct_close]
      ,[rawUpsize_Contech].[dbo].[qrn].[keep_close]
      ,[rawUpsize_Contech].[dbo].[qrn].[vndnotfied]
      ,[rawUpsize_Contech].[dbo].[qrn].[vndrsponse]
      ,[rawUpsize_Contech].[dbo].[qrn].[sort]
      ,[rawUpsize_Contech].[dbo].[qrn].[regrade]
  FROM [rawUpsize_Contech].[dbo].[qrn]
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[qrn].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no]
  LEFT JOIN [Contech_Test].[dbo].[vendor] ON [rawUpsize_Contech].[dbo].[qrn].[ven_id] = [Contech_Test].[dbo].[vendor].[ven_id]
  LEFT JOIN [Contech_Test].[dbo].[matlin] ON [rawUpsize_Contech].[dbo].[qrn].[matlinid] = [Contech_Test].[dbo].[matlin].[matlinid]
  LEFT JOIN [Contech_Test].[dbo].[employee] ON [rawUpsize_Contech].[dbo].[qrn].[empnumber] = [Contech_Test].[dbo].[employee].[empnumber]

SET IDENTITY_INSERT [Contech_Test].[dbo].[qrn] OFF;

--SELECT * FROM [Contech_Test].[dbo].[qrn]

-- =========================================================
--Section 009: qrn_dtl
-- =========================================================

-- Column changes:
--  - Changed qrn_dtlid to  primary key
-- Maps:
--	- [qrn_dtl].[cmpcasesid]	-- FK = [cmpcases].[cmpcasesid]
--	- [qrn_dtl].[qrn_no]		--> [qrn].[qrn_no]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrn_dtl'))
    DROP TABLE [dbo].[qrn_dtl]
	
CREATE TABLE [dbo].[qrn_dtl](
	[qrn_dtlid] [int] identity(1,1) NOT NULL,		-- PK
	[qrn_no] [char](8) NOT NULL,	-- FK = [qrn].[qrn_no]  ?? [qrnid] (see qrnexcpt)
	[cmpcasesid] [int] NOT NULL,	-- FK = [cmpcases].[cmpcasesid]
	[qty_rej] [int] NOT NULL,
	[id_type] [char](5) NOT NULL,
	[picked] [bit] NOT NULL,
	[bar_code] [char](13) NOT NULL,
	CONSTRAINT [PK_qrn_dtl] PRIMARY KEY CLUSTERED 
	(
		[qrn_dtlid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[qrn_dtl] ON;

INSERT INTO [Contech_Test].[dbo].[qrn_dtl] ([qrn_dtlid],[qrn_no],[cmpcasesid],[qty_rej],[id_type],[picked],[bar_code])
SELECT [qrn_dtlid]
      ,[qrn_no]			--> [qrn].[qrn_no]	?? [qrnid] (see qrnexcpt)
      ,[cmpcasesid]		-- FK = [cmpcases].[cmpcasesid]
      ,[qty_rej]
      ,[id_type]
      ,[picked]
      ,[bar_code]
  FROM [rawUpsize_Contech].[dbo].[qrn_dtl]

SET IDENTITY_INSERT [Contech_Test].[dbo].[qrn_dtl] OFF;

--SELECT * FROM [Contech_Test].[dbo].[qrn_dtl]

-- =========================================================
--Section 009: qrnexcpt
-- =========================================================

-- Column changes:
--  - Set qrnexcptid as primary key
-- Maps:
--	- [qrnexcpt].[qrnid]	-- FK = [qrn].[qrnid]
--	- [qrnexcpt].[bom_no]	--> bom_hdr.bom_no

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnexcpt'))
    DROP TABLE [dbo].[qrnexcpt]
	
CREATE TABLE [dbo].[qrnexcpt](
	[qrnexcptid] [int] identity(1,1) NOT NULL,
	[qrnid] [int] NOT NULL,				--> FK = [qrn].[qrnid]
	[extype] [char](1) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL,	-->	bom_hdr.bom_no
	CONSTRAINT [PK_qrnexcpt] PRIMARY KEY CLUSTERED 
	(
		[qrnexcptid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[qrnexcpt] ON;

INSERT INTO [Contech_Test].[dbo].[qrnexcpt] ([qrnexcptid],[qrnid],[extype],[bom_no])
SELECT [qrnexcptid]
      ,[qrnid]		--> FK = [qrn].[qrnid]
      ,[extype]
      ,[bom_no]		-->	bom_hdr.bom_no
  FROM [rawUpsize_Contech].[dbo].[qrnexcpt]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[qrnexcpt] OFF;

--SELECT * FROM [Contech_Test].[dbo].[qrnexcpt]

-- =========================================================
--Section 009: qrnissue
-- =========================================================

-- Column changes:
--  - Set qrnissue as primary key
-- Maps:
--	- [qrnissue].[issuesid]		-- FK = [issues].[issuesid]
--	- [qrnissue].[qrn_no]		--> [qrn].[qrn_no]
--	- [qrnissue].[issuesdtid]	-- FK = [issuesdt].[issuesdtid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnissue'))
    DROP TABLE [dbo].[qrnissue]
		
CREATE TABLE [dbo].[qrnissue](
	[qrnissueid] [int] identity(1,1) NOT NULL,
	[issuesid] [int] NOT NULL,		--> FK = [issues].[issuesid]
	[qrn_no] [char](8) NOT NULL,	--> [qrn].[qrn_no]
	[issuesdtid] [int] NOT NULL,	--> FK = [issuesdt].[issuesdtid]
	CONSTRAINT [PK_qrnissue] PRIMARY KEY CLUSTERED 
	(
		[qrnissueid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[qrnissue] ON;

INSERT INTO [Contech_Test].[dbo].[qrnissue] ([qrnissueid],[issuesid],[qrn_no],[issuesdtid])
SELECT [qrnissueid]
      ,[issuesid]
      ,[qrn_no]
      ,[issuesdtid]
  FROM [rawUpsize_Contech].[dbo].[qrnissue]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[qrnissue] OFF;

--SELECT * FROM [Contech_Test].[dbo].[qrnissue]

-- =========================================================
--Section 009: qrnmachn
-- =========================================================

-- Column changes:
--  - Set qrnmachnid as primary key
-- Maps:
--	- [qrnissue].[qrn_no]		--> [qrn].[qrn_no]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnmachn'))
    DROP TABLE [dbo].[qrnmachn]

CREATE TABLE [dbo].[qrnmachn](
	[qrnmachnid] [int] identity(1,1) NOT NULL,
	[qrn_no] [char](8) NOT NULL,	--> [qrn].[qrn_no]
	[machine] [char](10) NOT NULL,
	CONSTRAINT [PK_qrnmachn] PRIMARY KEY CLUSTERED 
	(
		[qrnmachnid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[qrnmachn] ON;

INSERT INTO [Contech_Test].[dbo].[qrnmachn] ([qrnmachnid],[qrn_no],[machine])
SELECT [qrnmachnid]
      ,[qrn_no]		--> [qrn].[qrn_no]
      ,[machine]
  FROM [rawUpsize_Contech].[dbo].[qrnmachn]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[qrnmachn] OFF;

--SELECT * FROM [Contech_Test].[dbo].[qrnmachn]

-- =========================================================
--Section 009: qrnsource
-- =========================================================

-- Column changes:
--  - Added qrnsourceid as primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnsource'))
    DROP TABLE [dbo].[qrnsource]
	
CREATE TABLE [dbo].[qrnsource](
	[qrnsourceid] [int] identity(1,1) NOT NULL,
	[source] [char](2) NOT NULL,
	[descript] [char](25) NOT NULL,
	CONSTRAINT [PK_qrnsource] PRIMARY KEY CLUSTERED 
	(
		[qrnsourceid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[qrnsource] 
	SELECT * FROM [rawUpsize_Contech].[dbo].[qrnsource]
  
--SELECT * FROM [Contech_Test].[dbo].[qrnsource]

-- =========================================================
--Section 009: qrntable
-- =========================================================

-- Column changes:
--  - Set qrntableid as primary key
-- Maps:
--	- [qrnissue].[qrn_no]		--> [qrn].[qrn_no]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrntable'))
    DROP TABLE [dbo].[qrntable]
	
CREATE TABLE [dbo].[qrntable](
	[qrntableid] [int] identity(1,1) NOT NULL,
	[qrn_no] [char](8) NOT NULL,	--> [qrn].[qrn_no]
	[table] [char](10) NOT NULL,
	[insertused] [bit] NOT NULL,
	CONSTRAINT [PK_qrntable] PRIMARY KEY CLUSTERED 
	(
		[qrntableid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO
	
SET IDENTITY_INSERT [Contech_Test].[dbo].[qrntable] ON;

INSERT INTO [Contech_Test].[dbo].[qrntable] ([qrntableid],[qrn_no],[table],[insertused])
SELECT [qrntableid]
      ,[qrn_no]
      ,[table]
      ,[insertused]
  FROM [rawUpsize_Contech].[dbo].[qrntable]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[qrntable] OFF;

--SELECT * FROM [Contech_Test].[dbo].[qrntable]

-- =========================================================