-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section001_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 001: lookups
-- =========================================================

-- Column changes:
--	- Set lookupid as primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.lookups: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lookups'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('lookups')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('lookups')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[lookups]
	END	
	
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

    PRINT 'Table: dbo.vendor: Start'

	INSERT INTO [dbo].[vendor] (
		  [ven_id]
		  ,[vendor]
		  ,[active]
		  ,[type]
		  ,[maddress]
		  ,[address2]
		  ,[city]
		  ,[state]
		  ,[zip]
		  ,[country]
		  ,[plant_loc]
		  ,[phone]
		  ,[fax]
		  ,[email]
		  ,[memo]
		  ,[rating]
		  ,[approved]
		  ,[terms]
		  ,[grade]
		  ,[fob]
		  ,[department])
		SELECT * FROM [rawUpsize_Contech].[dbo].[vendor] 

	--SELECT * FROM [dbo].[vendor]

    COMMIT
	
    PRINT 'Table: dbo.vendor: End'
	
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
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('assets')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('assets')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[assets]
	END	

	CREATE TABLE [dbo].[assets]
	(
		[assetid] [int] IDENTITY(1,1) NOT NULL,
		[asset_no] [char](10) NOT NULL DEFAULT '',
		[asset_desc] [char](75) NOT NULL DEFAULT '',
		--[ven_id] [char](10) NOT NULL DEFAULT 0,		-- FK = [vendor].[ven_id] 
		[vendorid] [int] NULL,							-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		[pur_date] [datetime] NULL,
		--[location] [char](3) NOT NULL DEFAULT 0,		-- FK = [lookups].[code]  
		[locationid] [int] NULL,						-- FK = [lookups].[code]  --> ([lookups].[lookupid])
		--[asset_type] [char](3) NOT NULL DEFAULT 0,	-- FK = [lookups].[code]  
		[asset_typeid] [int] NULL,						-- FK = [lookups].[code]  --> ([lookups].[lookupid])
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
		,CONSTRAINT FK_assets_vendor FOREIGN KEY ([vendorid]) REFERENCES [dbo].[vendor] ([vendorid])  ON DELETE NO ACTION
		,CONSTRAINT FK_assets_lookupslocation FOREIGN KEY ([locationid]) REFERENCES [dbo].[lookups] ([lookupid])  ON DELETE NO ACTION
		,CONSTRAINT FK_assets_lookupsasset_type FOREIGN KEY ([asset_typeid]) REFERENCES [dbo].[lookups] ([lookupid]) ON DELETE NO ACTION
	) ON [PRIMARY] 

	ALTER TABLE [dbo].[assets] NOCHECK CONSTRAINT [FK_assets_vendor];
	ALTER TABLE [dbo].[assets] NOCHECK CONSTRAINT [FK_assets_lookupslocation];
	ALTER TABLE [dbo].[assets] NOCHECK CONSTRAINT [FK_assets_lookupsasset_type];
	
	SET IDENTITY_INSERT [dbo].[assets] ON;

	INSERT INTO [dbo].[assets] ([assetid],[asset_no],[asset_desc],[vendorid],[pur_date],[locationid],[asset_typeid],[pur_cost],[contact],[serial_no],[model_no],[status],[status_dt],[building],[qty],[owner],[cal_notreq],[calnorsn],[calnoinitl],[rev_rec],[rev_dt],[rev_emp])
	SELECT [rawUpsize_Contech].[dbo].[assets].[assetsid]				-- PK
		  ,[rawUpsize_Contech].[dbo].[assets].[asset_no]
		  ,[rawUpsize_Contech].[dbo].[assets].[asset_desc]
		  --,[rawUpsize_Contech].[dbo].[assets].[ven_id]		
		  ,ISNULL(vendor.[vendorid], NULL) AS [vend_pk]					-- FK = [vendor].[ven_id] --> [vendor].[pk188]
		  ,[rawUpsize_Contech].[dbo].[assets].[pur_date]
		  --,[rawUpsize_Contech].[dbo].[assets].[location]		
		  ,ISNULL(assetLocation.[lookupid], NULL) AS [location_lookupid]-- FK = [lookups].[code] --> ([lookups].[lookupid])
		  --,[rawUpsize_Contech].[dbo].[assets].[asset_type]	
		  ,ISNULL(assetType.[lookupid], NULL) AS [type_lookupid]		-- FK = [lookups].[code] --> ([lookups].[lookupid])
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
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('units')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('units')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[units]
	END	

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

	INSERT INTO [dbo].[employee](
		   [empnumber]
		  ,[emplastnam]
		  ,[empfirstna]
		  ,[empmidinit]
		  ,[empstatus]
		  ,[emptmpfull]
		  ,[emp_rate]
		  ,[job_title]
		  ,[empassword]
		  ,[department]
		  ,[manager_of]
		  ,[last_rvw]
		  ,[barcode]
		  ,[email] 
		  --,OptimisticLockField
		  --,GCRecord
		  )
		SELECT -- row_number() OVER (ORDER BY [empnumber]) AS pk,
		   [empnumber]
		  ,TRIM([emplastnam])
		  ,TRIM([empfirstna])
		  ,[empmidinit]
		  ,[empstatus]
		  ,[emptmpfull]
		  ,[emp_rate]
		  ,[job_title]
		  ,[empassword]
		  ,[department]
		  ,[manager_of]
		  ,[last_rvw]
		  ,[barcode]
		  ,[email] 
		  --,null,null
		FROM [rawUpsize_Contech].[dbo].[employee]

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