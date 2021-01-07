
-- =========================================================
--Section 3: lookups
-- =========================================================

-- Column changes:
--	- Set lookupid as primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lookups'))
    DROP TABLE [dbo].[lookups]
	
CREATE TABLE [lookups]
(
	[lookupid]	int PRIMARY KEY IDENTITY(1,1),
	[code]		char(10) NOT NULL DEFAULT '',
	[meaning]	char(50) NOT NULL DEFAULT '',
	[type]		char(20) NOT NULL DEFAULT '',
	[code_len]	numeric(2,0) NOT NULL DEFAULT 0
)

SET IDENTITY_INSERT [Contech_Test].[dbo].[lookups] ON;

INSERT INTO [Contech_Test].[dbo].[lookups]
([lookupid] -- PK
      ,[code]
      ,[meaning]
      ,[type]
      ,[code_len])
SELECT [lookupid] -- PK
      ,[code]
      ,[meaning]
      ,[type]
      ,[code_len]
  FROM [rawUpsize_Contech].[dbo].[lookups]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[lookups] OFF;
  
--SELECT * FROM [Contech_Test].[dbo].[lookups] WHERE code  = 'PRO'
--SELECT * FROM [Contech_Test].[dbo].[lookups] ORDER BY code

-- =========================================================
--Section 3: vendor
-- =========================================================

-- Column changes:
--	- pk to first column

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'vendor'))
    DROP TABLE [dbo].[vendor]
	
CREATE TABLE [dbo].[vendor](
	pk int identity(1,1) not null,
	[ven_id] [char](6) NOT NULL,
	[vendor] [char](75) NOT NULL,
	[active] [bit] NOT NULL,
	[type] [char](10) NOT NULL,
	[maddress] [char](35) NOT NULL,
	[address2] [char](35) NOT NULL,
	[city] [char](30) NOT NULL,
	[state] [char](3) NOT NULL,
	[zip] [char](11) NOT NULL,
	[country] [char](15) NOT NULL,
	[plant_loc] [char](3) NOT NULL,
	[phone] [char](17) NOT NULL,
	[fax] [char](17) NOT NULL,
	[email] [char](100) NOT NULL,
	[memo] [text] NOT NULL,
	[rating] [char](1) NOT NULL,
	[approved] [char](1) NOT NULL,
	[terms] [char](10) NOT NULL,
	[grade] [char](2) NOT NULL,
	[fob] [char](15) NOT NULL,
	[department] [char](4) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[vendor]
	SELECT * FROM [rawUpsize_Contech].[dbo].[vendor] 

--SELECT * FROM [Contech_Test].[dbo].[vendor]

-- =========================================================
--Section 3: assets
-- =========================================================

-- Column changes:
--	- Moved assetsid (primary key) to first column
--  - Changed ven_id to int to reference vendor table
--  - Changed location to int to reference location in lookups table
--  - Changed asset_type to int to reference type in lookups table
-- Maps:
--	- [assets].[ven_id]		-- FK = [vendor].[ven_id] -> [vendor].[pk]
--	- [assets].[location]	-- FK = [lookups].[code]  -> ([lookups].[lookupid])
--	- [assets].[asset_type]	-- FK = [lookups].[code]  -> ([lookups].[lookupid])

USE Contech_Test

IF (EXISTS (SELECT *FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'assets'))
    DROP TABLE [dbo].[assets]

CREATE TABLE [dbo].[assets]
(
	[assetsid] int identity(1,1) not null,
	[asset_no] [char](10) NOT NULL,
	[asset_desc] [char](75) NOT NULL,
	[ven_id] [int] NOT NULL,
	[pur_date] [datetime] NULL,
	[location] [int] NOT NULL,
	[asset_type] [int] NOT NULL,
	[pur_cost] [numeric](9, 2) NOT NULL,
	[contact] [char](50) NOT NULL,
	[serial_no] [char](30) NOT NULL,
	[model_no] [char](30) NOT NULL,
	[status] [char](1) NOT NULL,
	[status_dt] [datetime] NULL,
	[building] [char](2) NOT NULL,
	[qty] [int] NOT NULL,
	[owner] [char](2) NOT NULL,
	[cal_notreq] [bit] NOT NULL,
	[calnorsn] [char](100) NOT NULL,
	[calnoinitl] [char](3) NOT NULL,
	[rev_rec] [int] NOT NULL,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[assets] ON;

INSERT INTO [Contech_Test].[dbo].[assets]
	([assetsid]
      ,[asset_no]
      ,[asset_desc]
      ,[ven_id]
      ,[pur_date]
      ,[location]
      ,[asset_type]
      ,[pur_cost]
      ,[contact]
      ,[serial_no]
      ,[model_no]
      ,[status]
      ,[status_dt]
      ,[building]
      ,[qty]
      ,[owner]
      ,[cal_notreq]
      ,[calnorsn]
      ,[calnoinitl]
      ,[rev_rec]
      ,[rev_dt]
      ,[rev_emp])
SELECT [rawUpsize_Contech].[dbo].[assets].[assetsid] -- PK
	  ,[rawUpsize_Contech].[dbo].[assets].[asset_no]
      ,[rawUpsize_Contech].[dbo].[assets].[asset_desc]
      --,[rawUpsize_Contech].[dbo].[assets].[ven_id]		-- FK = [vendor].[ven_id] -> [vendor].[pk188]
	  ,ISNULL([Contech_Test].[dbo].[vendor].[pk], 0) AS [vend_pk]
      ,[rawUpsize_Contech].[dbo].[assets].[pur_date]
      --,[rawUpsize_Contech].[dbo].[assets].[location]	-- FK = [lookups].[code] -> ([lookups].[lookupid])
	  ,ISNULL(assetLocation.[lookupid], 0) AS [location_lookupid]
      --,[rawUpsize_Contech].[dbo].[assets].[asset_type]	-- FK = [lookups].[code] -> ([lookups].[lookupid])
	  ,ISNULL(assetType.[lookupid], 0) AS [type_lookupid]
      ,[rawUpsize_Contech].[dbo].[assets].[pur_cost]
      ,[rawUpsize_Contech].[dbo].[assets].[contact]
      ,[rawUpsize_Contech].[dbo].[assets].[serial_no]
      ,[rawUpsize_Contech].[dbo].[assets].[model_no]
      ,[rawUpsize_Contech].[dbo].[assets].[status]
      ,[rawUpsize_Contech].[dbo].[assets].[status_dt]
      ,[rawUpsize_Contech].[dbo].[assets].[building]
      ,[rawUpsize_Contech].[dbo].[assets].[qty]
      ,[rawUpsize_Contech].[dbo].[assets].[owner]
      ,[rawUpsize_Contech].[dbo].[assets].[cal_notreq]
      ,[rawUpsize_Contech].[dbo].[assets].[calnorsn]
      ,[rawUpsize_Contech].[dbo].[assets].[calnoinitl]
      ,[rawUpsize_Contech].[dbo].[assets].[rev_rec]
      ,[rawUpsize_Contech].[dbo].[assets].[rev_dt]
      ,[rawUpsize_Contech].[dbo].[assets].[rev_emp]
  FROM [rawUpsize_Contech].[dbo].[assets] 
  LEFT JOIN [Contech_Test].[dbo].[vendor] ON [rawUpsize_Contech].[dbo].[assets].[ven_id] = [Contech_Test].[dbo].[vendor].[ven_id]
  LEFT JOIN [Contech_Test].[dbo].[lookups] assetLocation ON [rawUpsize_Contech].[dbo].[assets].[asset_type] = assetLocation.[code] AND assetLocation.[type] = 'ASSET LOCATION'
  LEFT JOIN [Contech_Test].[dbo].[lookups] assetType ON [rawUpsize_Contech].[dbo].[assets].[asset_type] = assetType.[code] AND assetType.[type] = 'ASSET TYPE'
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[assets] ON;

--SELECT * FROM [Contech_Test].[dbo].[assets]

-- =========================================================