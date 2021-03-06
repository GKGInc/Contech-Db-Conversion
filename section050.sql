-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section005_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 005: orders -- Moved from Section 007
-- =========================================================

-- Column changes:
--  - Added [orderid] as primary key
--  - Added [bom_hdrid] [int] to reference [bom_hdr] table using [bom_no] and [bom_rev] 
--  - Removed columns [bom_no] and [bom_rev] 
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [mfg_cat] [char](2) to [mfgcatid] [int] to reference [mfgcat] table
--  - Changed [memo] from [text] to [varchar](2000)
--  - Changed [ar_memo] from [text] to [varchar](2000)
--  - Changed [coc_memo] from [text] to [varchar](2000)
-- Maps:
--	- [orders].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [vendor].[customerid]
--	- [orders].[bom_hdrid]					-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [orders].[mfg_cat]	-- FK = [mfgcat].[mfg_cat] --> [mfgcat].[mfgcatid]
--	- [orders].[mfg_locid]	-- FK = [mfg_loc].[mfg_locid] 

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.orders: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'orders'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('orders')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('orders')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[orders]
	END
	
	CREATE TABLE [dbo].[orders](
		[orderid] [int] IDENTITY(1,1) NOT NULL,			-- new PK
		[job_no] [int] NOT NULL DEFAULT 0,
		[job_rev] [numeric](2, 0) NOT NULL,
		--[bom_no] [numeric](5, 0) NOT NULL,			-- FK = [bom_hdr].[bom_no] 
		--[bom_rev] [numeric](2, 0) NOT NULL,			-- FK = [bom_hdr].[bom_rev] 
		[bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		[status] [char](1) NOT NULL DEFAULT '',
		[cus_lot] [char](12) NOT NULL DEFAULT '',
		[ct_lot] [char](8) NOT NULL DEFAULT '',
		[part_no] [char](15) NOT NULL DEFAULT '',
		[part_rev] [char](10) NOT NULL DEFAULT '',
		[cust_po] [char](15) NOT NULL DEFAULT '',
		[qty_ord] [numeric](7, 0) NOT NULL DEFAULT 0,
		[price] [numeric](9, 4) NOT NULL DEFAULT 0.0,
		[requested] [datetime] NULL,
		[awk_date] [datetime] NULL,
		--[cust_no] [int] NOT NULL,						-- FK = [customer].[cust_no]
		[customerid] [int] NULL,						-- FK = [customer].[cust_no] --> [vendor].[customerid]
		[ship_to] [char](1) NOT NULL DEFAULT '',
		[entered] [datetime] NULL,
		[unit] [char](4) NOT NULL DEFAULT '',
		[code_po] [char](1) NOT NULL DEFAULT '',
		[bo] [numeric](7, 0) NOT NULL DEFAULT 0,
		[code] [char](1) NOT NULL DEFAULT '',
		[memo] [varchar](2000) NOT NULL DEFAULT '',
		[rev] [numeric](1, 0) NOT NULL DEFAULT 0,
		--[mfg_cat] [char](2) NOT NULL DEFAULT 0,		-- FK = [mfgcat].[mfg_cat] 
		[mfgcatid] [int] NULL,							-- FK = [mfgcat].[mfg_cat] --> [mfgcat].[mfgcatid]
		[ar_qty_shi] [numeric](7, 0) NOT NULL DEFAULT 0,
		[ar_qty_cr] [numeric](7, 0) NOT NULL DEFAULT 0,
		[part_desc] [char](50) NOT NULL DEFAULT '',
		[price_ire] [numeric](8, 4) NOT NULL,
		[over_ride] [bit] NOT NULL DEFAULT 0,
		[ar_memo] [varchar](2000) NOT NULL DEFAULT '',
		[ip_no] [char](5) NOT NULL DEFAULT '',
		[mfg_no] [char](5) NOT NULL DEFAULT '',
		[coc_memo] [varchar](2000) NOT NULL DEFAULT '',
		[orderkbno] [int] NOT NULL DEFAULT 0,
		[kb_tot_qty] [int] NOT NULL DEFAULT 0,
		[qty_fp] [int] NOT NULL DEFAULT 0,
		[proforma] [bit] NOT NULL DEFAULT 0,
		[boxtype] [char](10) NOT NULL DEFAULT '',
		[add_dt] [datetime] NULL,
		[currency] [char](3) NOT NULL DEFAULT '',
		[fprice] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[fexchrate] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[cust_po_ln] [char](5) NOT NULL DEFAULT '',
		[cust_po_um] [char](5) NOT NULL DEFAULT '',
		[bill_to] [char](1) NOT NULL DEFAULT '',
		[mfg_locid] [int] NULL,							-- FK = [mfg_loc].[mfg_locid]
		CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
		(
			[orderid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_orders_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_orders_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_orders_mfgcat FOREIGN KEY ([mfgcatid]) REFERENCES [dbo].[mfgcat] ([mfgcatid]) ON DELETE NO ACTION
		,CONSTRAINT FK_orders_mfg_loc FOREIGN KEY ([mfg_locid]) REFERENCES [dbo].[mfg_loc] ([mfg_locid]) ON DELETE NO ACTION
	) ON [PRIMARY]

	ALTER TABLE [dbo].[orders] NOCHECK CONSTRAINT [FK_orders_bom_hdr];
	ALTER TABLE [dbo].[orders] NOCHECK CONSTRAINT [FK_orders_customer];
	ALTER TABLE [dbo].[orders] NOCHECK CONSTRAINT [FK_orders_mfgcat];
	ALTER TABLE [dbo].[orders] NOCHECK CONSTRAINT [FK_orders_mfg_loc];

	INSERT INTO [dbo].[orders]
	SELECT [rawUpsize_Contech].[dbo].[orders].[job_no]
		  ,[rawUpsize_Contech].[dbo].[orders].[job_rev]
		  --,[rawUpsize_Contech].[dbo].[orders].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[orders].[bom_rev]
		  ,ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
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
		  ,ISNULL(customer.[customerid], NULL) as [customerid]
		  ,[rawUpsize_Contech].[dbo].[orders].[ship_to]
		  ,[rawUpsize_Contech].[dbo].[orders].[entered]
		  ,[rawUpsize_Contech].[dbo].[orders].[unit]
		  ,[rawUpsize_Contech].[dbo].[orders].[code_po]
		  ,[rawUpsize_Contech].[dbo].[orders].[bo]
		  ,[rawUpsize_Contech].[dbo].[orders].[code]
		  ,[rawUpsize_Contech].[dbo].[orders].[memo]
		  ,[rawUpsize_Contech].[dbo].[orders].[rev]
		  --,[rawUpsize_Contech].[dbo].[orders].[mfg_cat] --
		  ,ISNULL(mfgcat.[mfgcatid], NULL) AS [mfgcatid]
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
		  ,[rawUpsize_Contech].[dbo].[orders].[mfg_locid] 
	  FROM [rawUpsize_Contech].[dbo].[orders] -- 119,815
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[orders].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[orders].[bom_rev] = bom_hdr.[bom_rev] 
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[orders].[cust_no] = customer.[cust_no] 
	  LEFT JOIN [dbo].[mfgcat] mfgcat ON [rawUpsize_Contech].[dbo].[orders].[mfg_cat] = mfgcat.[mfg_cat] 

    PRINT 'Table: dbo.orders: end'

    COMMIT
	
END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 005: venship -- Moved from section046
-- =========================================================

-- Column changes:
--  - Added [venshipid] to be primary key
-- Maps:
--	- [venship].[mfg_locid]	-- FK = [mfg_loc].[mfg_locid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.venship: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'venship'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('venship')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('venship')
			PRINT (@SQL)	
			EXEC (@SQL)
		END

		DROP TABLE [dbo].[venship]
	END

	CREATE TABLE [dbo].[venship](
		[venshipid] [int] IDENTITY(1,1) NOT NULL,
		[company] [char](35) NOT NULL DEFAULT '',
		[shven_no] [char](5) NOT NULL DEFAULT '',
		[saddress] [char](35) NOT NULL DEFAULT '',
		[saddress2] [char](35) NOT NULL DEFAULT '',
		[city] [char](21) NOT NULL DEFAULT '',
		[state] [char](3) NOT NULL DEFAULT '',
		[zip] [char](11) NOT NULL DEFAULT '',
		[ship_via] [char](20) NOT NULL DEFAULT '',
		[fob_point] [char](15) NOT NULL DEFAULT '',
		[country] [char](10) NOT NULL DEFAULT '',
		[mfg_locid] [int] NOT NULL DEFAULT 0,		-- FK = [mfg_loc].[mfg_locid]
		CONSTRAINT [PK_venship] PRIMARY KEY CLUSTERED 
		(
			[venshipid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_venship_mfg_loc FOREIGN KEY ([mfg_locid]) REFERENCES [dbo].[mfg_loc] ([mfg_locid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[venship] NOCHECK CONSTRAINT [FK_venship_mfg_loc];

	INSERT INTO [dbo].[venship] ([company],[shven_no],[saddress],[saddress2],[city],[state],[zip],[ship_via],[fob_point],[country],[mfg_locid])
	SELECT [rawUpsize_Contech].[dbo].[venship].[company]
		  ,[rawUpsize_Contech].[dbo].[venship].[shven_no]
		  ,[rawUpsize_Contech].[dbo].[venship].[saddress]
		  ,[rawUpsize_Contech].[dbo].[venship].[saddress2]
		  ,[rawUpsize_Contech].[dbo].[venship].[city]
		  ,[rawUpsize_Contech].[dbo].[venship].[state]
		  ,[rawUpsize_Contech].[dbo].[venship].[zip]
		  ,[rawUpsize_Contech].[dbo].[venship].[ship_via]
		  ,[rawUpsize_Contech].[dbo].[venship].[fob_point]
		  ,[rawUpsize_Contech].[dbo].[venship].[country]
		  ,[rawUpsize_Contech].[dbo].[venship].[mfg_locid]
	  FROM [rawUpsize_Contech].[dbo].[venship]
  
	--SELECT * FROM [dbo].[venship]

    PRINT 'Table: dbo.venship: end'

    COMMIT
	
END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 005: material -- Moved from section017
-- =========================================================

-- Column changes:
--  - Added [materialid] to be primary key
--  - Changed [description] from [text] to [varchar](2000)

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.material: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'material'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('material')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('material')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[material]
	END				

	CREATE TABLE [dbo].[material](
		[materialid] [int] IDENTITY(1,1) NOT NULL,
		[material] [char](3) NOT NULL DEFAULT '',
		[description] [varchar](2000) NOT NULL DEFAULT '',
		[type] [char](20) NOT NULL DEFAULT '',
		CONSTRAINT [PK_material] PRIMARY KEY CLUSTERED 
		(
			[materialid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[material] SELECT * FROM [rawUpsize_Contech].[dbo].[material]
  
	--SELECT * FROM [dbo].[material]

    COMMIT

    PRINT 'Table: dbo.material: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section005_HR.sql'

-- =========================================================