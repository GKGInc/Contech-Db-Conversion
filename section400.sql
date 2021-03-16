-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section040_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 040: pouches
-- =========================================================

-- Column changes:
--  - Added [pouchesid] to be primary key
--  - Added [bom_hdrid] to be foreign key to link [bom_no] & [bom_rev]
--  - Removed columns [bom_no] & [bom_rev]
-- Maps:
--	- [pouches].[bom_hdrid]		-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

    PRINT 'Table: dbo.pouches: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'pouches')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('pouches')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('pouches')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[pouches]
		PRINT 'Table [dbo].[pouches] dropped'
    END

	CREATE TABLE [dbo].[pouches](
		[pouchesid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,
		[pouch] [char](10) NOT NULL DEFAULT '',
		[pouch2] [char](10) NOT NULL DEFAULT '',
		[lot_no] [char](10) NOT NULL DEFAULT '',
		[lot_no2] [char](10) NOT NULL DEFAULT '',
		[lbl1] [char](10) NOT NULL DEFAULT '',
		[lbl2] [char](10) NOT NULL DEFAULT '',
		[lbl_side] [char](10) NOT NULL DEFAULT '',
		[lbl_side2] [char](10) NOT NULL DEFAULT '',
		[insert_] [char](3) NOT NULL DEFAULT '',
		[insert2] [char](3) NOT NULL DEFAULT '',
		[insertlot] [char](12) NOT NULL DEFAULT '',
		[insertlot2] [char](12) NOT NULL DEFAULT '',
		[lbl_unit] [char](3) NOT NULL DEFAULT '',
		[lbl_unit2] [char](3) NOT NULL DEFAULT '',
		[qty_disp] [char](3) NOT NULL DEFAULT '',
		[qty_oship] [char](3) NOT NULL DEFAULT '',
		[lbl_oship] [char](3) NOT NULL DEFAULT '',
		[lbl_disp] [char](3) NOT NULL DEFAULT '',
		CONSTRAINT [PK_pouches] PRIMARY KEY CLUSTERED 
		(
			[pouchesid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_pouches_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[pouches] NOCHECK CONSTRAINT [FK_pouches_bom_hdr];

	INSERT INTO [dbo].[pouches] ([bom_hdrid],[pouch],[pouch2],[lot_no],[lot_no2],[lbl1],[lbl2],[lbl_side],[lbl_side2],[insert_],[insert2],[insertlot],[insertlot2],[lbl_unit],[lbl_unit2],[qty_disp],[qty_oship],[lbl_oship],[lbl_disp])
	SELECT ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[pouches].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[pouches].[bom_rev]
		  ,[rawUpsize_Contech].[dbo].[pouches].[pouch]
		  ,[rawUpsize_Contech].[dbo].[pouches].[pouch2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lot_no]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lot_no2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl1]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl_side]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl_side2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[insert_]
		  ,[rawUpsize_Contech].[dbo].[pouches].[insert2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[insertlot]
		  ,[rawUpsize_Contech].[dbo].[pouches].[insertlot2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl_unit]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl_unit2]
		  ,[rawUpsize_Contech].[dbo].[pouches].[qty_disp]
		  ,[rawUpsize_Contech].[dbo].[pouches].[qty_oship]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl_oship]
		  ,[rawUpsize_Contech].[dbo].[pouches].[lbl_disp]
	  FROM [rawUpsize_Contech].[dbo].[pouches]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[pouches].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[pouches].[bom_rev] = bom_hdr.[bom_rev] 

	--SELECT * FROM [pouches]

    PRINT 'Table: dbo.pouches: end'
	
-- =========================================================
-- Section 040: prdlinbm
-- =========================================================

-- Column changes:
--  - Set [prdlinbmid] to be primary key
--  - Added [bom_hdrid] to be foreign key to link [bom_no] & [bom_rev]
--  - Removed columns [bom_no] & [bom_rev]
-- Maps:
--	- [prdlinbm].[prdlinhdid]	-- FK = [prdlinhd].[prdlinhdid]
--	- [prdlinbm].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

    PRINT 'Table: dbo.prdlinbm: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlinbm')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prdlinbm')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prdlinbm')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prdlinbm]
		PRINT 'Table [dbo].[prdlinbm] dropped'
    END

	CREATE TABLE [dbo].[prdlinbm](
		[prdlinbmid] [int] IDENTITY(1,1) NOT NULL,
		[prdlinhdid] [int] NOT NULL DEFAULT 0,			-- FK = [prdlinhd].[prdlinhdid]
		[bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,
		CONSTRAINT [PK_prdlinbm] PRIMARY KEY CLUSTERED 
		(
			[prdlinbmid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prdlinbm_prdlinhd FOREIGN KEY ([prdlinhdid]) REFERENCES [dbo].[prdlinhd] ([prdlinhdid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_prdlinbm_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prdlinbm] NOCHECK CONSTRAINT [FK_prdlinbm_bom_hdr];

	SET IDENTITY_INSERT [dbo].[prdlinbm] ON;

	INSERT INTO [dbo].[prdlinbm] ([prdlinbmid],[prdlinhdid],[bom_hdrid])
	SELECT [rawUpsize_Contech].[dbo].[prdlinbm].[prdlinbmid]
		  ,[rawUpsize_Contech].[dbo].[prdlinbm].[prdlinhdid]
		  ,ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[prdlinbm].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[prdlinbm].[bom_rev]
	  FROM [rawUpsize_Contech].[dbo].[prdlinbm]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[prdlinbm].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[prdlinbm].[bom_rev] = bom_hdr.[bom_rev] 
	  WHERE [prdlinhdid] IN (SELECT [prdlinhdid] FROM [prdlinhd])
	  ORDER BY [rawUpsize_Contech].[dbo].[prdlinbm].[prdlinbmid]

	SET IDENTITY_INSERT [dbo].[prdlinbm] OFF;

	--SELECT * FROM [dbo].[prdlinbm]

    PRINT 'Table: dbo.prdlinbm: end'

-- =========================================================
-- Section 40: prdlnqhd
-- =========================================================

-- Column changes:
--  - Set [prdlnqhdid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [user_id] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [prdlnqhd].[cust_no] --> [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [prdlnqhd].[add_user]	--> [userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.prdlnqhd: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlnqhd')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prdlnqhd')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prdlnqhd')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prdlnqhd]
		PRINT 'Table [dbo].[prdlnqhd] dropped'
    END

	CREATE TABLE [dbo].[prdlnqhd](
		[prdlnqhdid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](60) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT '',
		[customerid] [int] NULL,		-- FK = [customer].[cust_no] --> [customer].[customerid]	
		--[user_id] [char](10) NOT NULL DEFAULT '',
		[userid] [int] NULL,			-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_prdlnqhd] PRIMARY KEY CLUSTERED 
		(
			[prdlnqhdid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prdlnqhd_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_prdlnqhd_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prdlnqhd] NOCHECK CONSTRAINT [FK_prdlnqhd_customer];
	ALTER TABLE [dbo].[prdlnqhd] NOCHECK CONSTRAINT [FK_prdlnqhd_users];

	SET IDENTITY_INSERT [dbo].[prdlnqhd] ON;

	INSERT INTO [dbo].[prdlnqhd] ([prdlnqhdid],[descript],[customerid],[userid],[add_dt])
	SELECT [rawUpsize_Contech].[dbo].[prdlnqhd].[prdlnqhdid]
		  ,[rawUpsize_Contech].[dbo].[prdlnqhd].[descript]
		  --,[rawUpsize_Contech].[dbo].[prdlnqhd].[cust_no]
		  ,ISNULL(customer.[customerid], NULL) as [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
		  --,[rawUpsize_Contech].[dbo].[prdlnqhd].[user_id]
		  ,ISNULL(users.[userid], NULL) as [userid]				-- FK = [users].[username] --> [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[prdlnqhd].[add_dt]
	  FROM [rawUpsize_Contech].[dbo].[prdlnqhd]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[prdlnqhd].[cust_no] = customer.[cust_no] 
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[prdlnqhd].[user_id] = users.[username]	
  
	SET IDENTITY_INSERT [dbo].[prdlnqhd] OFF;

	--SELECT * FROM [dbo].[prdlnqhd]

    PRINT 'Table: dbo.prdlnqhd: end'

-- =========================================================
-- Section 040: prdlnqbm
-- =========================================================

-- Column changes:
--  - Added [prdlnqbmid] to be primary key
--  - Added [bom_hdrid] to be foreign key to link [bom_no] & [bom_rev]
--  - Removed columns [bom_no] & [bom_rev]
-- Maps:
--	- [prdlnqbm].[prdlnqhdid]	-- FK = [prdlinhd].[prdlnqhdid]
--	- [prdlnqbm].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
-- Notes:
--  - Multiple [prdlnqbmid] entries. No child records to the table. Ignoring the id and re-assigning [prdlnqbmid]

    PRINT 'Table: dbo.prdlnqbm: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlnqbm')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prdlnqbm')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prdlnqbm')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prdlnqbm]
		PRINT 'Table [dbo].[prdlnqbm] dropped'
    END

	CREATE TABLE [dbo].[prdlnqbm](
		[prdlnqbmid] [int] IDENTITY(1,1) NOT NULL,
		[prdlnqhdid] [int] NOT NULL DEFAULT 0,		-- FK = [prdlnqhd].[prdlnqhdid]
		[bom_hdrid] [int] NULL,						-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL,
		--[bom_rev] [numeric](2, 0) NOT NULL,
		CONSTRAINT [PK_prdlnqbm] PRIMARY KEY CLUSTERED 
		(
			[prdlnqbmid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prdlnqbm_prdlinhd FOREIGN KEY ([prdlnqhdid]) REFERENCES [dbo].[prdlnqhd] ([prdlnqhdid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_prdlnqbm_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prdlnqbm] NOCHECK CONSTRAINT [FK_prdlnqbm_bom_hdr];

	--SET IDENTITY_INSERT [dbo].[prdlnqbm] ON;

	INSERT INTO [dbo].[prdlnqbm] ([prdlnqhdid],[bom_hdrid])
	SELECT --[rawUpsize_Contech].[dbo].[prdlnqbm].[prdlnqbmid]
		  [rawUpsize_Contech].[dbo].[prdlnqbm].[prdlnqhdid]
		  ,ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[prdlnqbm].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[prdlnqbm].[bom_rev]
	  FROM [rawUpsize_Contech].[dbo].[prdlnqbm]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[prdlnqbm].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[prdlnqbm].[bom_rev] = bom_hdr.[bom_rev] 
	  WHERE [prdlnqhdid] IN (SELECT [prdlnqhdid] FROM [prdlnqhd])
	  ORDER BY [rawUpsize_Contech].[dbo].[prdlnqbm].[prdlnqbmid]
  
	--SET IDENTITY_INSERT [dbo].[prdlnqbm] OFF;

	--SELECT * FROM [dbo].[prdlnqbm]

    PRINT 'Table: dbo.prdlnqbm: end'

-- =========================================================
-- Section 040: prdlnqdt
-- =========================================================

-- Column changes:
--  - Set [prdlnqdtid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed [user_id] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [prdlnqdt].[prdlnqhdid]				-- FK = [prdlinhd].[prdlnqhdid]
--	- [prdlindt].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [prdlnqdt].[add_user]	--> [userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.prdlnqdt: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlnqdt')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prdlnqdt')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prdlnqdt')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prdlnqdt]
		PRINT 'Table [dbo].[prdlnqdt] dropped'
    END

	CREATE TABLE [dbo].[prdlnqdt](
		[prdlnqdtid] [int] IDENTITY(1,1) NOT NULL,
		[prdlnqhdid] [int] NULL,					-- FK = [prdlinhd].[prdlnqhdid]
		--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp]
		[componetid] [int] NULL,					-- FK = [componet].[comp] --> [componet].[componetid]
		[type] [char](3) NOT NULL DEFAULT '',
		[sort_order] [int] NOT NULL DEFAULT 0,
		[mod_dt] [datetime] NULL,
		--[user_id] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[as_of_dt] [datetime] NULL,
		CONSTRAINT [PK_prdlnqdt] PRIMARY KEY CLUSTERED 
		(
			[prdlnqdtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prdlnqdt_prdlnqhd FOREIGN KEY ([prdlnqhdid]) REFERENCES [dbo].[prdlnqhd] ([prdlnqhdid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_prdlnqdt_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
		,CONSTRAINT FK_prdlnqdt_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prdlnqdt] NOCHECK CONSTRAINT [FK_prdlnqdt_componet];
	ALTER TABLE [dbo].[prdlnqdt] NOCHECK CONSTRAINT [FK_prdlnqdt_users];

	SET IDENTITY_INSERT [dbo].[prdlnqdt] ON;

	INSERT INTO [dbo].[prdlnqdt] ([prdlnqdtid],[prdlnqhdid],[componetid],[type],[sort_order],[mod_dt],[userid],[as_of_dt])
	SELECT [rawUpsize_Contech].[dbo].[prdlnqdt].[prdlnqdtid]
		  ,[rawUpsize_Contech].[dbo].[prdlnqdt].[prdlnqhdid]
		  --,[rawUpsize_Contech].[dbo].[prdlnqdt].[comp]
		  ,ISNULL(componet.[componetid], NULL) AS [componetid]		-- FK = [componet].[comp] --> [componet].[componetid]
		  ,[rawUpsize_Contech].[dbo].[prdlnqdt].[type]
		  ,[rawUpsize_Contech].[dbo].[prdlnqdt].[sort_order]
		  ,[rawUpsize_Contech].[dbo].[prdlnqdt].[mod_dt]
		  --,[rawUpsize_Contech].[dbo].[prdlnqdt].[user_id]
		  ,ISNULL(users.[userid], NULL) as [userid]				-- FK = [users].[username] --> [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[prdlnqdt].[as_of_dt]
	  FROM [rawUpsize_Contech].[dbo].[prdlnqdt]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[prdlnqdt].[comp] = componet.[comp] 
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[prdlnqdt].[user_id] = users.[username]	
	  WHERE [prdlnqhdid] IN (SELECT [prdlnqhdid] FROM [prdlnqhd])
	  ORDER BY [rawUpsize_Contech].[dbo].[prdlnqdt].[prdlnqdtid]
   
	SET IDENTITY_INSERT [dbo].[prdlnqdt] OFF;

	--SELECT * FROM [dbo].[prdlnqdt]

    PRINT 'Table: dbo.prdlnqdt: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section040_HR.sql'

-- =========================================================