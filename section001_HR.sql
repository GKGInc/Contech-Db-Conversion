-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section001_HR.sql'

-- =========================================================
-- Section 001: lookups
-- =========================================================

-- Column changes:
--	- Set lookupid as primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.lookups: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lookups'))
		DROP TABLE [dbo].[lookups]
	
	CREATE TABLE [dbo].[lookups]
	(
		[lookupid]	[int] IDENTITY(1,1) NOT NULL,
		[code]		[char](10) NOT NULL DEFAULT '',
		[meaning]	[char](50) NOT NULL DEFAULT '',
		[type]		[char](20) NOT NULL DEFAULT '',
		[code_len]	[numeric](2,0) NOT NULL DEFAULT 0,
		CONSTRAINT [PK_lookups] PRIMARY KEY CLUSTERED 
		(
			[lookupid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[lookups] ON;

	INSERT INTO [dbo].[lookups] ([lookupid],[code],[meaning],[type],[code_len])
	SELECT [lookupid]
		  ,[code]
		  ,[meaning]
		  ,[type]
		  ,[code_len]
	  FROM [rawUpsize_Contech].[dbo].[lookups]
  
	SET IDENTITY_INSERT [dbo].[lookups] OFF;
  
	--SELECT * FROM [dbo].[lookups] WHERE code  = 'PRO'
	--SELECT * FROM [dbo].[lookups] ORDER BY code

    COMMIT

    PRINT 'Table: dbo.lookups: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 001: vendor
-- =========================================================

-- Column changes:
--	- Moved [vendorid] to first column
--	- Set [vendorid] to be primary key
--  - Changed [memo] from [text] to [varchar](2000)

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.vendor: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'vendor'))
		DROP TABLE [dbo].[vendor]
	
	CREATE TABLE [dbo].[vendor](
		[vendorid] [int] IDENTITY(1,1) NOT NULL,
		[ven_id] [char](6) NOT NULL DEFAULT '',
		[vendor] [char](75) NOT NULL DEFAULT '',
		[active] [bit] NOT NULL DEFAULT 0,
		[type] [char](10) NOT NULL DEFAULT '',
		[maddress] [char](35) NOT NULL DEFAULT '',
		[address2] [char](35) NOT NULL DEFAULT '',
		[city] [char](30) NOT NULL DEFAULT '',
		[state] [char](3) NOT NULL DEFAULT '',
		[zip] [char](11) NOT NULL DEFAULT '',
		[country] [char](15) NOT NULL DEFAULT '',
		[plant_loc] [char](3) NOT NULL DEFAULT '',
		[phone] [char](17) NOT NULL DEFAULT '',
		[fax] [char](17) NOT NULL DEFAULT '',
		[email] [char](100) NOT NULL DEFAULT '',
		[memo] [varchar](2000) NOT NULL DEFAULT '',
		[rating] [char](1) NOT NULL DEFAULT '',
		[approved] [char](1) NOT NULL DEFAULT '',
		[terms] [char](10) NOT NULL DEFAULT '',
		[grade] [char](2) NOT NULL DEFAULT '',
		[fob] [char](15) NOT NULL DEFAULT '',
		[department] [char](4) NOT NULL DEFAULT '',
		CONSTRAINT [PK_vendor] PRIMARY KEY CLUSTERED 
		(
			[vendorid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 
	

	INSERT INTO [dbo].[vendor]
		SELECT * FROM [rawUpsize_Contech].[dbo].[vendor] 

	--SELECT * FROM [dbo].[vendor]

    COMMIT

    PRINT 'Table: dbo.vendor: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 001: assets
-- =========================================================

-- Column changes:
--	- Moved [assetid] (primary key) to first column
--	- Renamed [assetsid] to [assetid]
--  - Changed [ven_id] [char](10) to [vendorid] [int] to reference [vendor] table
--  - Changed [location] [char](3) to [locationid] [int] to reference [location] in [lookups] table
--  - Changed [asset_type] [char](3) to [asset_typeid] [int] to reference [type] in [lookups] table
-- Maps:
--	- [assets].[ven_id]	--> [vendorid]			-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
--	- [assets].[location] --> [locationid]		-- FK = [lookups].[code]  --> ([lookups].[lookupid])
--	- [assets].[asset_type] --> [asset_typeid]	-- FK = [lookups].[code]  --> ([lookups].[lookupid])

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.assets: start'

	IF (EXISTS (SELECT *FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'assets'))
		DROP TABLE [dbo].[assets]

	CREATE TABLE [dbo].[assets]
	(
		[assetid] [int] IDENTITY(1,1) NOT NULL,
		[asset_no] [char](10) NOT NULL DEFAULT '',
		[asset_desc] [char](75) NOT NULL DEFAULT '',
		--[ven_id] [char](10) NOT NULL DEFAULT 0,		-- FK = [vendor].[ven_id] 
		[vendorid] [int] NOT NULL DEFAULT 0,			-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		[pur_date] [datetime] NULL,
		--[location] [char](3) NOT NULL DEFAULT 0,		-- FK = [lookups].[code]  --> ([lookups].[lookupid])
		[locationid] [int] NOT NULL DEFAULT 0,			-- FK = [lookups].[code]  --> ([lookups].[lookupid])
		--[asset_type] [char](3) NOT NULL DEFAULT 0,	-- FK = [lookups].[code]  --> ([lookups].[lookupid])
		[asset_typeid] [int] NOT NULL DEFAULT 0,		-- FK = [lookups].[code]  --> ([lookups].[lookupid])
		[pur_cost] [numeric](9, 2) NOT NULL,
		[contact] [char](50) NOT NULL DEFAULT '',
		[serial_no] [char](30) NOT NULL DEFAULT '',
		[model_no] [char](30) NOT NULL DEFAULT '',
		[status] [char](1) NOT NULL DEFAULT '',
		[status_dt] [datetime] NULL,
		[building] [char](2) NOT NULL DEFAULT '',
		[qty] [int] NOT NULL DEFAULT 0,
		[owner] [char](2) NOT NULL DEFAULT '',
		[cal_notreq] [bit] NOT NULL DEFAULT 0,
		[calnorsn] [char](100) NOT NULL DEFAULT '',
		[calnoinitl] [char](3) NOT NULL DEFAULT '',
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		[rev_emp] [char](10) NOT NULL DEFAULT '',
		CONSTRAINT [PK_assets] PRIMARY KEY CLUSTERED 
		(
			[assetid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 
	
	SET IDENTITY_INSERT [dbo].[assets] ON;

	INSERT INTO [dbo].[assets] ([assetid],[asset_no],[asset_desc],[vendorid],[pur_date],[locationid],[asset_typeid],[pur_cost],[contact],[serial_no],[model_no],[status],[status_dt],[building],[qty],[owner],[cal_notreq],[calnorsn],[calnoinitl],[rev_rec],[rev_dt],[rev_emp])
	SELECT [rawUpsize_Contech].[dbo].[assets].[assetsid]				-- PK
		  ,[rawUpsize_Contech].[dbo].[assets].[asset_no]
		  ,[rawUpsize_Contech].[dbo].[assets].[asset_desc]
		  --,[rawUpsize_Contech].[dbo].[assets].[ven_id]		
		  ,ISNULL(vendor.[vendorid], 0) AS [vend_pk]					-- FK = [vendor].[ven_id] --> [vendor].[pk188]
		  ,[rawUpsize_Contech].[dbo].[assets].[pur_date]
		  --,[rawUpsize_Contech].[dbo].[assets].[location]		
		  ,ISNULL(assetLocation.[lookupid], 0) AS [location_lookupid]	-- FK = [lookups].[code] --> ([lookups].[lookupid])
		  --,[rawUpsize_Contech].[dbo].[assets].[asset_type]	
		  ,ISNULL(assetType.[lookupid], 0) AS [type_lookupid]			-- FK = [lookups].[code] --> ([lookups].[lookupid])
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
	  LEFT JOIN [dbo].[vendor] vendor ON [rawUpsize_Contech].[dbo].[assets].[ven_id] = vendor.[ven_id]
	  LEFT JOIN [dbo].[lookups] assetLocation ON [rawUpsize_Contech].[dbo].[assets].[asset_type] = assetLocation.[code] AND assetLocation.[type] = 'ASSET LOCATION'
	  LEFT JOIN [dbo].[lookups] assetType ON [rawUpsize_Contech].[dbo].[assets].[asset_type] = assetType.[code] AND assetType.[type] = 'ASSET TYPE'
  
	SET IDENTITY_INSERT [dbo].[assets] OFF;

	--SELECT * FROM [dbo].[assets]

    COMMIT

    PRINT 'Table: dbo.assets: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 001: units --> Moved to from section 044
-- =========================================================

-- Column changes:
--  - Added [unitid] to be primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.units: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'units'))
		DROP TABLE [dbo].[units]

	CREATE TABLE [dbo].[units](
		[unitid] [int] IDENTITY(1,1) NOT NULL,
		[unit] [char](4) NOT NULL DEFAULT '',
		CONSTRAINT [PK_units] PRIMARY KEY CLUSTERED 
		(
			[unitid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[units] ([unit])
	SELECT [unit] FROM [rawUpsize_Contech].[dbo].[units]
  
	--SELECT * FROM [dbo].[units]

    COMMIT

    PRINT 'Table: dbo.units: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 001: employee -- Moved from Section 005
-- =========================================================

-- Column changes:
--	- Changed [employeeid] to be the primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.employee: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'employee'))
		DROP TABLE [dbo].[employee]
	
	CREATE TABLE [dbo].[employee](
		[employeeid] [int] IDENTITY(1,1) NOT NULL,
		[empnumber] [char](10) NOT NULL DEFAULT '',
		[emplastnam] [char](30) NOT NULL DEFAULT '',
		[empfirstna] [char](20) NOT NULL DEFAULT '',
		[empmidinit] [char](1) NOT NULL DEFAULT '',
		[empstatus] [numeric](1, 0) NOT NULL DEFAULT 0,
		[emptmpfull] [numeric](1, 0) NOT NULL DEFAULT 0,
		[emp_rate] [numeric](5, 2) NOT NULL DEFAULT 0.0,
		[job_title] [char](30) NOT NULL DEFAULT '',
		[empassword] [char](15) NOT NULL DEFAULT '',
		[department] [char](4) NOT NULL DEFAULT '',
		[manager_of] [char](4) NOT NULL DEFAULT '',
		[last_rvw] [datetime] NULL,
		[barcode] [char](15) NOT NULL DEFAULT '',
		[email] [char](100) NOT NULL DEFAULT '',
		CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
		(
			[employeeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[employee]
		SELECT * FROM [rawUpsize_Contech].[dbo].[employee]

	--SELECT * FROM [dbo].[employee]

    COMMIT

    PRINT 'Table: dbo.employee: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section001_HR.sql'

-- =========================================================