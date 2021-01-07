
-- =========================================================
--Section 007: mfgcat
-- =========================================================

-- Column changes:
--  - Added mfgcatid as primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfgcat'))
    DROP TABLE [dbo].[mfgcat]
	
CREATE TABLE [dbo].[mfgcat](
	[mfgcatid] [int] identity(1,1) NOT NULL,
	[acct_code] [char](1) NOT NULL,
	[mfg_cat] [char](2) NOT NULL,
	[desc] [char](35) NOT NULL,
	CONSTRAINT [PK_mfgcat] PRIMARY KEY CLUSTERED 
	(
		[mfgcatid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [Contech_Test].[dbo].[mfgcat] SELECT * FROM [rawUpsize_Contech].[dbo].[mfgcat] 

--SELECT * FROM [Contech_Test].[dbo].[mfgcat]

-- =========================================================
--Section 007: mfg_loc
-- =========================================================

-- Column changes:
--  - Changed mfg_locid to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfg_loc'))
    DROP TABLE [dbo].[mfg_loc]
	
CREATE TABLE [dbo].[mfg_loc](
	[mfg_locid] [int] identity(1,1) NOT NULL,
	[loc_description] [char](50) NOT NULL,
	[lot_suffix] [char](2) NOT NULL,
	[address] [char](75) NOT NULL,
	[address2] [char](75) NOT NULL,
	[city] [char](75) NOT NULL,
	[state] [char](2) NOT NULL,
	[country] [char](75) NOT NULL,
	[phone] [char](20) NOT NULL,
	[fax] [char](20) NOT NULL,
	[email] [char](100) NOT NULL,
	[zip] [char](15) NOT NULL,
	[cust_no] [char](5) NOT NULL,
	[ven_id] [char](6) NOT NULL,
	CONSTRAINT [PK_mfg_loc] PRIMARY KEY CLUSTERED 
	(
		[mfg_locid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[mfg_loc] ON;

INSERT INTO [Contech_Test].[dbo].[mfg_loc] ([mfg_locid],[loc_description],[lot_suffix],[address],[address2],[city],[state],[country],[phone],[fax],[email],[zip],[cust_no],[ven_id]) 
SELECT [mfg_locid],[loc_description],[lot_suffix],[address],[address2],[city],[state],[country],[phone],[fax],[email],[zip],[cust_no],[ven_id]
FROM [rawUpsize_Contech].[dbo].[mfg_loc] ORDER BY 1
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[mfg_loc] ON;

--SELECT * FROM [Contech_Test].[dbo].[mfg_loc]

-- =========================================================
--Section 007: orders
-- =========================================================

-- Column changes:
--  - Added ordersid as primary key
--  - Changed cust_no to int to reference customer table
--  - Changed mfg_cat to int to reference mfgcat table
-- Maps:
--	- [orders].[cust_no]	-- FK = [customer].[cust_no] -> [vendor].[customerid]
--	- [orders].[bom_no]		-- FK = [bom_hdr].[bom_no] 
--	- [orders].[bom_rev]	-- FK = [bom_hdr].[bom_rev] 
--	- [orders].[mfg_cat]	-- FK = [mfgcat].[mfg_cat] -> [mfgcat].[mfgcatid]
--	- [orders].[mfg_locid]	-- FK = [mfg_loc].[mfg_locid] 

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'orders'))
    DROP TABLE [dbo].[orders]
	
CREATE TABLE [dbo].[orders](
	[ordersid] [int] identity(1,1) NOT NULL, -- new PK
	[job_no] [int] NOT NULL,
	[job_rev] [numeric](2, 0) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL,  -- [bom_hdr].[bom_no]
	[bom_rev] [numeric](2, 0) NOT NULL,	-- [bom_hdr].[bom_rev]
	[status] [char](1) NOT NULL,
	[cus_lot] [char](12) NOT NULL,
	[ct_lot] [char](8) NOT NULL,
	[part_no] [char](15) NOT NULL,
	[part_rev] [char](10) NOT NULL,
	[cust_po] [char](15) NOT NULL,
	[qty_ord] [numeric](7, 0) NOT NULL,
	[price] [numeric](9, 4) NOT NULL,
	[requested] [datetime] NULL,
	[awk_date] [datetime] NULL,
	[cust_no] [int] NOT NULL,			-- FK = [customer].[cust_no] -> [vendor].[customerid]
	[ship_to] [char](1) NOT NULL,
	[entered] [datetime] NULL,
	[unit] [char](4) NOT NULL,
	[code_po] [char](1) NOT NULL,
	[bo] [numeric](7, 0) NOT NULL,
	[code] [char](1) NOT NULL,
	[memo] [text] NOT NULL,
	[rev] [numeric](1, 0) NOT NULL,
	[mfg_cat] [int] NOT NULL,			-- FK = [mfgcat].[mfg_cat] -> [mfgcat].[mfgcatid]
	[ar_qty_shi] [numeric](7, 0) NOT NULL,
	[ar_qty_cr] [numeric](7, 0) NOT NULL,
	[part_desc] [char](50) NOT NULL,
	[price_ire] [numeric](8, 4) NOT NULL,
	[over_ride] [bit] NOT NULL,
	[ar_memo] [text] NOT NULL,
	[ip_no] [char](5) NOT NULL,
	[mfg_no] [char](5) NOT NULL,
	[coc_memo] [text] NOT NULL,
	[orderkbno] [int] NOT NULL,
	[kb_tot_qty] [int] NOT NULL,
	[qty_fp] [int] NOT NULL,
	[proforma] [bit] NOT NULL,
	[boxtype] [char](10) NOT NULL,
	[add_dt] [datetime] NULL,
	[currency] [char](3) NOT NULL,
	[fprice] [numeric](8, 2) NOT NULL,
	[fexchrate] [numeric](9, 5) NOT NULL,
	[cust_po_ln] [char](5) NOT NULL,
	[cust_po_um] [char](5) NOT NULL,
	[bill_to] [char](1) NOT NULL,
	[mfg_locid] [int] NOT NULL,			-- FK = [mfgcat].[mfg_locid] -> [mfg_loc].[mfg_locid]
	CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
	(
		[ordersid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[orders]
SELECT [rawUpsize_Contech].[dbo].[orders].[job_no]
      ,[rawUpsize_Contech].[dbo].[orders].[job_rev]
      ,[rawUpsize_Contech].[dbo].[orders].[bom_no]
      ,[rawUpsize_Contech].[dbo].[orders].[bom_rev]
      ,[rawUpsize_Contech].[dbo].[orders].[status]
      ,[rawUpsize_Contech].[dbo].[orders].[cus_lot]
      ,[rawUpsize_Contech].[dbo].[orders].[ct_lot]
      ,[rawUpsize_Contech].[dbo].[orders].[part_no]
      ,[rawUpsize_Contech].[dbo].[orders].[part_rev]
      ,[rawUpsize_Contech].[dbo].[orders].[cust_po]
      ,[rawUpsize_Contech].[dbo].[orders].[qty_ord]
      ,[rawUpsize_Contech].[dbo].[orders].[price]
      ,[rawUpsize_Contech].[dbo].[orders].[requested]
      ,[rawUpsize_Contech].[dbo].[orders].[awk_date]
      --,[rawUpsize_Contech].[dbo].[orders].[cust_no] --
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) as [customerid]
      ,[rawUpsize_Contech].[dbo].[orders].[ship_to]
      ,[rawUpsize_Contech].[dbo].[orders].[entered]
      ,[rawUpsize_Contech].[dbo].[orders].[unit]
      ,[rawUpsize_Contech].[dbo].[orders].[code_po]
      ,[rawUpsize_Contech].[dbo].[orders].[bo]
      ,[rawUpsize_Contech].[dbo].[orders].[code]
      ,[rawUpsize_Contech].[dbo].[orders].[memo]
      ,[rawUpsize_Contech].[dbo].[orders].[rev]
      --,[rawUpsize_Contech].[dbo].[orders].[mfg_cat] --
	  ,ISNULL([Contech_Test].[dbo].[mfgcat].[mfgcatid], 0) AS [mfgcatid]
      ,[rawUpsize_Contech].[dbo].[orders].[ar_qty_shi]
      ,[rawUpsize_Contech].[dbo].[orders].[ar_qty_cr]
      ,[rawUpsize_Contech].[dbo].[orders].[part_desc]
      ,[rawUpsize_Contech].[dbo].[orders].[price_ire]
      ,[rawUpsize_Contech].[dbo].[orders].[over_ride]
      ,[rawUpsize_Contech].[dbo].[orders].[ar_memo]
      ,[rawUpsize_Contech].[dbo].[orders].[ip_no]
      ,[rawUpsize_Contech].[dbo].[orders].[mfg_no]
      ,[rawUpsize_Contech].[dbo].[orders].[coc_memo]
      ,[rawUpsize_Contech].[dbo].[orders].[orderkbno]
      ,[rawUpsize_Contech].[dbo].[orders].[kb_tot_qty]
      ,[rawUpsize_Contech].[dbo].[orders].[qty_fp]
      ,[rawUpsize_Contech].[dbo].[orders].[proforma]
      ,[rawUpsize_Contech].[dbo].[orders].[boxtype]
      ,[rawUpsize_Contech].[dbo].[orders].[add_dt]
      ,[rawUpsize_Contech].[dbo].[orders].[currency]
      ,[rawUpsize_Contech].[dbo].[orders].[fprice]
      ,[rawUpsize_Contech].[dbo].[orders].[fexchrate]
      ,[rawUpsize_Contech].[dbo].[orders].[cust_po_ln]
      ,[rawUpsize_Contech].[dbo].[orders].[cust_po_um]
      ,[rawUpsize_Contech].[dbo].[orders].[bill_to]
      ,[rawUpsize_Contech].[dbo].[orders].[mfg_locid] --
  FROM [rawUpsize_Contech].[dbo].[orders] -- 119,815
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[orders].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no] 
  LEFT JOIN [Contech_Test].[dbo].[mfgcat] ON [rawUpsize_Contech].[dbo].[orders].[mfg_cat] = [Contech_Test].[dbo].[mfgcat].[mfg_cat] 
  --LEFT JOIN [Contech_Test].[dbo].[mfg_loc] ON [rawUpsize_Contech].[dbo].[orders].[mfg_locid] = [Contech_Test].[dbo].[mfg_loc].[mfg_locid] 

--SELECT * FROM [Contech_Test].[dbo].[orders]

-- =========================================================