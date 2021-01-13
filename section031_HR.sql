
-- =========================================================
--Section 031: doctypes
-- =========================================================

-- Column changes:
--  - Added [doctypesid] to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'doctypes'))
    DROP TABLE [dbo].[doctypes]

CREATE TABLE [dbo].[doctypes](
	[doctypesid] [int] identity(1,1) NOT NULL,
	[doctype] [char](4) NOT NULL DEFAULT '',
	[descript] [char](50) NOT NULL DEFAULT '',
	[order] [char](2) NOT NULL DEFAULT '',
	CONSTRAINT [PK_doctypes] PRIMARY KEY CLUSTERED 
	(
		[doctypesid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[doctypes] ([doctype],[descript],[order])
SELECT [doctype]
      ,[descript]
      ,[order]
  FROM [rawUpsize_Contech].[dbo].[doctypes]
  
--SELECT * FROM [Contech_Test].[dbo].[doctypes]

-- =========================================================
--Section 031: dspnsers
-- =========================================================

-- Column changes:
--  - Added [dspnsersid] to be primary key
--  - Added [bom_hdrid] to be foreign key to link [bom_no] & [bom_rev]
-- Maps:
--	- [dspnsers].[bom_no]	-- FK = [bom_hdr].[bom_no]
--	- [dspnsers].[bom_rev]	-- FK = [bom_hdr].[bom_rev]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'dspnsers'))
    DROP TABLE [dbo].[dspnsers]

CREATE TABLE [dbo].[dspnsers](
	[dspnsersid] [int] identity(1,1) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL,		-- FK = [bom_hdr].[bom_no]
	[bom_rev] [numeric](2, 0) NOT NULL,		-- FK = [bom_hdr].[bom_rev]
	--[bom_hdrid] [int] NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_hdrid]
	[coil_od] [char](20) NOT NULL DEFAULT '',
	[qtypolybag] [char](3) NOT NULL DEFAULT '',
	[no_twist] [char](3) NOT NULL DEFAULT '',
	[qty_bag] [char](6) NOT NULL DEFAULT '',
	[qty_corr] [char](6) NOT NULL DEFAULT '',
	[lbl_corr] [char](3) NOT NULL DEFAULT '',
	[start] [char](20) NOT NULL DEFAULT '',
	[ending] [char](20) NOT NULL DEFAULT '',
	[window] [char](20) NOT NULL DEFAULT '',
	[luer_req] [char](1) NOT NULL DEFAULT '',
	[luer_fit] [char](15) NOT NULL DEFAULT '',
	[luer_place] [char](10) NOT NULL DEFAULT '',
	[j_req] [char](1) NOT NULL DEFAULT '',
	[j_place] [char](10) NOT NULL DEFAULT '',
	CONSTRAINT [PK_dspnsers] PRIMARY KEY CLUSTERED 
	(
		[dspnsersid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[dspnsers] ([bom_no],[bom_rev],[coil_od],[qtypolybag],[no_twist],[qty_bag],[qty_corr],[lbl_corr],[start],[ending],[window],[luer_req],[luer_fit],[luer_place],[j_req],[j_place])
SELECT [rawUpsize_Contech].[dbo].[dspnsers].[bom_no]						-- FK = [bom_hdr].[bom_no]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[bom_rev]						-- FK = [bom_hdr].[bom_rev]
	  --,ISNULL([Contech_Test].[dbo].[bom_hdr].[bom_hdrid], 0) AS [bom_hdrid] -- FK = [bom_hdr].[bom_hdrid]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[coil_od]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[qtypolybag]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[no_twist]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[qty_bag]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[qty_corr]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[lbl_corr]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[start]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[ending]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[window]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[luer_req]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[luer_fit]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[luer_place]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[j_req]
      ,[rawUpsize_Contech].[dbo].[dspnsers].[j_place]
  FROM [rawUpsize_Contech].[dbo].[dspnsers]
 -- LEFT JOIN [Contech_Test].[dbo].[bom_hdr] 
	--ON [rawUpsize_Contech].[dbo].[dspnsers].[bom_no] = [Contech_Test].[dbo].[bom_hdr].[bom_no] 
	--	AND [rawUpsize_Contech].[dbo].[dspnsers].[bom_rev] = [Contech_Test].[dbo].[bom_hdr].[bom_rev]
  
--SELECT * FROM [Contech_Test].[dbo].[dspnsers]

-- =========================================================
--Section 031: ecoc
-- =========================================================

-- Column changes:
--  - Set [ecocid] to be primary key
--  - ??Changed [invoice_no] to int to reference [aropen] table??
--  - ??Changed [invoice_no] to [aropenid] to reference [aropen] table??
--  - Changed [gen_user] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [ecoc].[invoice_no]	-- FK = [aropen].[invoice_no]
--	- [ecoc].[gen_user]		-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ecoc'))
    DROP TABLE [dbo].[ecoc]

CREATE TABLE [dbo].[ecoc](
	[ecocid] [int] identity(1,1) NOT NULL,
	[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no]
	[add_dt] [datetime] NULL,
	[gen_dt] [datetime] NULL,
	--[gen_user] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
	[sent_dt] [datetime] NULL,
	[type] [char](3) NOT NULL DEFAULT '',
	CONSTRAINT [PK_ecoc] PRIMARY KEY CLUSTERED 
	(
		[ecocid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[ecoc] ON;

INSERT INTO [Contech_Test].[dbo].[ecoc] ([ecocid],[invoice_no],[add_dt],[gen_dt],[employeeid],[sent_dt],[type])
SELECT [rawUpsize_Contech].[dbo].[ecoc].[ecocid]
      ,[rawUpsize_Contech].[dbo].[ecoc].[invoice_no]
	  --,ISNULL([Contech_Test].[dbo].[aropen].[aropenid] , 0) as [aropenid]
      ,[rawUpsize_Contech].[dbo].[ecoc].[add_dt]
      ,[rawUpsize_Contech].[dbo].[ecoc].[gen_dt]
      --,[rawUpsize_Contech].[dbo].[ecoc].[gen_user]
	  ,ISNULL([Contech_Test].[dbo].[employee].[employeeid], 0) AS [employeeid]	-- [asstevnt].[evntperson]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
      ,[rawUpsize_Contech].[dbo].[ecoc].[sent_dt]
      ,[rawUpsize_Contech].[dbo].[ecoc].[type]
  FROM [rawUpsize_Contech].[dbo].[ecoc]
  LEFT JOIN [Contech_Test].[dbo].[aropen] ON [rawUpsize_Contech].[dbo].[ecoc].[invoice_no] = [Contech_Test].[dbo].[aropen].[invoice_no]		-- FK = [aropen].[invoice_no] 
  LEFT JOIN [Contech_Test].[dbo].[employee] ON [rawUpsize_Contech].[dbo].[ecoc].[gen_user] = [Contech_Test].[dbo].[employee].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
  WHERE [rawUpsize_Contech].[dbo].[ecoc].[ecocid] != 0

SET IDENTITY_INSERT [Contech_Test].[dbo].[ecoc] OFF;

--SELECT * FROM [Contech_Test].[dbo].[ecoc]

-- =========================================================
--Section 031: ecust
-- =========================================================

-- Column changes:
--  - Set [ecustid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [ecode] from text to varchar(2000)
--  - Changed [equery] from text to varchar(2000)
-- Maps:
--	- [ecust].[cust_no]		-- FK = [customer].[cust_no] --> [customer].[customerid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ecust'))
    DROP TABLE [dbo].[ecust]

CREATE TABLE [dbo].[ecust](
	[ecustid] [int] identity(1,1) NOT NULL,
	--[cust_no] [char](5) NOT NULL DEFAULT '',	-- FK = [customer].[cust_no] --> [customer].[customerid]
	[customerid] [int] NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] --> [customer].[customerid]
	[emodule] [char](2) NOT NULL DEFAULT '',
	[ecode] varchar(2000) NOT NULL DEFAULT '',
	[equery] varchar(2000) NOT NULL DEFAULT '',
	CONSTRAINT [PK_ecust] PRIMARY KEY CLUSTERED 
	(
		[ecustid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[ecust] ON;

INSERT INTO [Contech_Test].[dbo].[ecust] ([ecustid],[customerid],[emodule],[ecode],[equery])
SELECT [rawUpsize_Contech].[dbo].[ecust].[ecustid]
      --,[rawUpsize_Contech].[dbo].[ecust].[cust_no]
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) as [customerid]
      ,[rawUpsize_Contech].[dbo].[ecust].[emodule]
      ,[rawUpsize_Contech].[dbo].[ecust].[ecode]
      ,[rawUpsize_Contech].[dbo].[ecust].[equery]
  FROM [rawUpsize_Contech].[dbo].[ecust]
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[ecust].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no] 

SET IDENTITY_INSERT [Contech_Test].[dbo].[ecust] OFF;

--SELECT * FROM [Contech_Test].[dbo].[ecust]

-- =========================================================
--Section 31: einvoice
-- =========================================================

-- Column changes:
--  - Set [einvoiceid] to be primary key
--  - ??Changed [invoice_no] to int to reference [aropen] table??
--  - ??Changed [invoice_no] to [aropenid] to reference [aropen] table??
--  - Changed [gen_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [einvoice].[invoice_no]	-- FK = [aropen].[invoice_no]
--	- [einvoice].[userid]		-- FK = [users].[username] --> [users].[userid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'einvoice'))
    DROP TABLE [dbo].[einvoice]

CREATE TABLE [dbo].[einvoice](
	[einvoiceid] [int] identity(1,1) NOT NULL,
	[invoice_no] [numeric](9, 0) NOT NULL,			-- FK = [aropen].[invoice_no]
	[gen_dt] [datetime] NULL,
	--[gen_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] --> [users].[userid]
	[userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	[sent_dt] [datetime] NULL,
	[invoice_hd] [numeric](9, 0) NOT NULL,
	CONSTRAINT [PK_einvoice] PRIMARY KEY CLUSTERED 
	(
		[einvoiceid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[einvoice] ON;

INSERT INTO [Contech_Test].[dbo].[einvoice] ([einvoiceid],[invoice_no],[gen_dt],[userid],[sent_dt],[invoice_hd])
SELECT [rawUpsize_Contech].[dbo].[einvoice].[einvoiceid]
      ,[rawUpsize_Contech].[dbo].[einvoice].[invoice_no]
	  --,ISNULL([Contech_Test].[dbo].[aropen].[aropenid] , 0) as [aropenid]
      ,[rawUpsize_Contech].[dbo].[einvoice].[gen_dt]
      --,[rawUpsize_Contech].[dbo].[einvoice].[gen_user]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid]		
      ,[rawUpsize_Contech].[dbo].[einvoice].[sent_dt]
      ,[rawUpsize_Contech].[dbo].[einvoice].[invoice_hd]
  FROM [rawUpsize_Contech].[dbo].[einvoice]
  LEFT JOIN [Contech_Test].[dbo].[aropen] ON [rawUpsize_Contech].[dbo].[einvoice].[invoice_no] = [Contech_Test].[dbo].[aropen].[invoice_no]		-- FK = [aropen].[invoice_no] 
  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[einvoice].[gen_user] = [Contech_Test].[dbo].[users].[username]			-- FK = [users].[userid]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[einvoice] OFF;

--SELECT * FROM [Contech_Test].[dbo].[einvoice]

-- =========================================================