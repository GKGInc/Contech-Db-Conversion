-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section044_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 044: shporder
-- =========================================================

-- Column changes:
--  - Set [shporderid] to be primary key
--  - Changed [palletqty] from [text] to [varchar](2000)
--  - Changed [comments] from [text] to [varchar](2000)
--  - Renamed [job_no] to [orderid] to reference [orders] table
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
-- Maps:
--	- [shporder].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [shporder].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [shporder].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[add_userid]

    PRINT 'Table: dbo.shporder: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'shporder')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('shporder')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('shporder')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[shporder]
		PRINT 'Table [dbo].[shporder] dropped'
    END

	CREATE TABLE [dbo].[shporder](
		[shporderid] [int] IDENTITY(1,1) NOT NULL,
		--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no]
		[orderid] [int] NULL,							-- FK = [orders].[job_no] --> [orders].[orderid]
		--[invoice_no] [int] NOT NULL DEFAULT 0,		-- FK = [aropen].[invoice_no]
		[aropenid] [int] NULL,							-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[shipdate] [datetime] NULL,
		[palletqty] [varchar](2000) NOT NULL DEFAULT '',
		[ship_via] [char](30) NOT NULL DEFAULT '',
		[comments] [varchar](2000) NOT NULL DEFAULT '',
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[add_userid]
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_shporder] PRIMARY KEY CLUSTERED 
		(
			[shporderid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_shporder_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_shporder_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
		,CONSTRAINT FK_shporder_users FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[shporder] NOCHECK CONSTRAINT [FK_shporder_orders];
	ALTER TABLE [dbo].[shporder] NOCHECK CONSTRAINT [FK_shporder_aropen];
	ALTER TABLE [dbo].[shporder] NOCHECK CONSTRAINT [FK_shporder_users];

	SET IDENTITY_INSERT [dbo].[shporder] ON;

	INSERT INTO [dbo].[shporder] ([shporderid],[orderid],[aropenid],[shipdate],[palletqty],[ship_via],[comments],[add_userid],[add_dt])
	SELECT [rawUpsize_Contech].[dbo].[shporder].[shporderid]
		  --,[rawUpsize_Contech].[dbo].[shporder].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]    
		  --,[rawUpsize_Contech].[dbo].[shporder].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) AS [aropenid] 		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[shporder].[shipdate]
		  ,[rawUpsize_Contech].[dbo].[shporder].[palletqty]
		  ,[rawUpsize_Contech].[dbo].[shporder].[ship_via]
		  ,[rawUpsize_Contech].[dbo].[shporder].[comments]
		  --,[rawUpsize_Contech].[dbo].[shporder].[add_user]
		  ,ISNULL(users.[userid], NULL) as [userid]				-- FK = [users].[username] --> [users].[add_userid]
		  ,[rawUpsize_Contech].[dbo].[shporder].[add_dt]
	  FROM [rawUpsize_Contech].[dbo].[shporder]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[shporder].[job_no] = orders.[job_no]			-- FK = [orders].[job_no] --> [orders].[ordersid]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[shporder].[invoice_no] = aropen.[invoice_no]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[shporder].[add_user] = users.[username]			-- FK = [users].[username] --> [users].[add_userid]
  
	SET IDENTITY_INSERT [dbo].[shporder] OFF;

	--SELECT * FROM [dbo].[shporder]

    PRINT 'Table: dbo.shporder: end'

-- =========================================================
-- Section 044: system
-- =========================================================

-- Column changes:
--  - Added [systemid] to be primary key
--  - Renamed [job_no] to [orderid] to reference [orders] table
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [qrn_no] [char](8) to [qrnid] [int] to reference [qrn] table
--  - Changed [shipper_no] [char](6) to [ladinghdid] [int] to match updated standards
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
-- Maps:
--	- [system].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [system].[cust_no] --> [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [system].[invoice_no] --> [aropenid]		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [system].[qrn_no]	--> [qrnid]				--  FK = [qrn].[qrn_no] --> [qrn].[qrnid]
--	- [system].[shipper_no] --> [ladinghdid]	-- FK = [ladinghd].[shipper_no] == [ladinghd].[ladinghdid]
--	- [car_empe].[car_no] --> [corractnid]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]

    PRINT 'Table: dbo.system: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'system')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('system')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('system')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[system]
		PRINT 'Table [dbo].[system] dropped'
    END

	CREATE TABLE [dbo].[system](
		[systemid] [int] IDENTITY(1,1) NOT NULL,
		[company] [char](35) NOT NULL DEFAULT '',
		[address] [char](35) NOT NULL DEFAULT '',
		[address2] [char](30) NOT NULL DEFAULT '',
		[city] [char](25) NOT NULL DEFAULT '',
		[state] [char](2) NOT NULL DEFAULT '',
		[zip] [char](9) NOT NULL DEFAULT '',
		[country] [char](20) NOT NULL DEFAULT '',
		[phone] [char](17) NOT NULL DEFAULT '',
		[fax] [char](17) NOT NULL DEFAULT '',
		[email] [char](25) NOT NULL DEFAULT '',
		--[job_no] [int] NOT NULL DEFAULT 0,
		[orderid] [int] NULL,							-- FK = [orders].[job_no] --> [orders].[orderid]
		--[cust_no] [char](5) NOT NULL DEFAULT '',
		[customerid] [int] NULL,						-- FK = [customer].[cust_no] --> [customer].[customerid]
		--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,
		[aropenid] [int] NULL,							-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[po_tax] [numeric](3, 2) NOT NULL DEFAULT 0.0,
		[rollover] [numeric](2, 0) NOT NULL DEFAULT 0,
		[tax] [numeric](2, 2) NOT NULL DEFAULT 0.0,
		[vat] [numeric](2, 2) NOT NULL DEFAULT 0.0,
		[paid_acct] [char](10) NOT NULL DEFAULT '',
		[open_acct] [char](10) NOT NULL DEFAULT '',
		[ass_acct] [char](10) NOT NULL DEFAULT '',
		[cont_acct] [char](10) NOT NULL DEFAULT '',
		[tool_acct] [char](10) NOT NULL DEFAULT '',
		[misc_acct] [char](10) NOT NULL DEFAULT '',
		[resal_acct] [char](10) NOT NULL DEFAULT '',
		[frt_acct] [char](10) NOT NULL DEFAULT '',
		[vat_acct] [char](10) NOT NULL DEFAULT '',
		[frout_acct] [char](10) NOT NULL DEFAULT '',
		[crsl_acct] [char](10) NOT NULL DEFAULT '',
		[labor_acct] [char](10) NOT NULL DEFAULT '',
		[wo_acct] [char](10) NOT NULL DEFAULT '',
		[disc_acct] [char](10) NOT NULL DEFAULT '',
		[misin_acct] [char](10) NOT NULL DEFAULT '',
		[rent_acct] [char](10) NOT NULL DEFAULT '',
		[currency] [char](3) NOT NULL DEFAULT '',
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NULL,								-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		--[shipper_no] [char](6) NOT NULL DEFAULT '',	-- FK = [ladinghd].[shipper_no] 
		[ladinghdid] [int] NULL,						-- FK = [ladinghd].[shipper_no] == [ladinghd].[ladinghdid]
		[crsec] [char](9) NOT NULL DEFAULT '',
		[emp_files] [char](50) NOT NULL DEFAULT '',
		--[car_no] [char](8) NOT NULL DEFAULT '',		-- FK = [corractn].[car_no]
		[corractnid] [int] NULL,						-- FK = [corractn].[car_no] --> [corractn].[corractnid]
		[consign_loc_level] [char](2) NOT NULL DEFAULT '',
		CONSTRAINT [PK_system] PRIMARY KEY CLUSTERED 
		(
			[systemid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_system_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_system_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_system_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
		,CONSTRAINT FK_system_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE NO ACTION
		,CONSTRAINT FK_system_ladinghd FOREIGN KEY ([ladinghdid]) REFERENCES [dbo].[ladinghd] ([ladinghdid]) ON DELETE NO ACTION
		,CONSTRAINT FK_system_corractn FOREIGN KEY ([corractnid]) REFERENCES [dbo].[corractn] ([corractnid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[system] NOCHECK CONSTRAINT [FK_system_orders];
	ALTER TABLE [dbo].[system] NOCHECK CONSTRAINT [FK_system_customer];
	ALTER TABLE [dbo].[system] NOCHECK CONSTRAINT [FK_system_aropen];
	ALTER TABLE [dbo].[system] NOCHECK CONSTRAINT [FK_system_qrn];
	ALTER TABLE [dbo].[system] NOCHECK CONSTRAINT [FK_system_ladinghd];
	ALTER TABLE [dbo].[system] NOCHECK CONSTRAINT [FK_system_corractn];

	INSERT INTO [dbo].[system] ([company],[address],[address2],[city],[state],[zip],[country],[phone],[fax],[email],[orderid],[customerid],[aropenid],[po_tax],[rollover],[tax],[vat],[paid_acct],[open_acct],[ass_acct],[cont_acct]
	,[tool_acct],[misc_acct],[resal_acct],[frt_acct],[vat_acct],[frout_acct],[crsl_acct],[labor_acct],[wo_acct],[disc_acct],[misin_acct],[rent_acct],[currency],[qrnid],[ladinghdid],[crsec],[emp_files],[corractnid],[consign_loc_level])
	SELECT [rawUpsize_Contech].[dbo].[system].[company]
		  ,[rawUpsize_Contech].[dbo].[system].[address]
		  ,[rawUpsize_Contech].[dbo].[system].[address2]
		  ,[rawUpsize_Contech].[dbo].[system].[city]
		  ,[rawUpsize_Contech].[dbo].[system].[state]
		  ,[rawUpsize_Contech].[dbo].[system].[zip]
		  ,[rawUpsize_Contech].[dbo].[system].[country]
		  ,[rawUpsize_Contech].[dbo].[system].[phone]
		  ,[rawUpsize_Contech].[dbo].[system].[fax]
		  ,[rawUpsize_Contech].[dbo].[system].[email]
		  --,[rawUpsize_Contech].[dbo].[system].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]    
		  --,[rawUpsize_Contech].[dbo].[system].[cust_no]		
		  ,ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
		  --,[rawUpsize_Contech].[dbo].[system].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) AS [aropenid] 		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[system].[po_tax]
		  ,[rawUpsize_Contech].[dbo].[system].[rollover]
		  ,[rawUpsize_Contech].[dbo].[system].[tax]
		  ,[rawUpsize_Contech].[dbo].[system].[vat]
		  ,[rawUpsize_Contech].[dbo].[system].[paid_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[open_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[ass_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[cont_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[tool_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[misc_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[resal_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[frt_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[vat_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[frout_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[crsl_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[labor_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[wo_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[disc_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[misin_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[rent_acct]
		  ,[rawUpsize_Contech].[dbo].[system].[currency]
		  --,[rawUpsize_Contech].[dbo].[system].[qrn_no]
		  ,ISNULL(qrn.[qrnid], NULL) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[system].[shipper_no]		-- FK = [ladinghd].[shipper_no] == [ladinghd].[ladinghdid]
		  ,[rawUpsize_Contech].[dbo].[system].[crsec]
		  ,[rawUpsize_Contech].[dbo].[system].[emp_files]
		  --,[rawUpsize_Contech].[dbo].[system].[car_no]
		  ,ISNULL(corractn.[corractnid],NULL) as [corractnid]	-- FK = [corractn].[car_no] --> [corractn].[corractnid]	
		  ,[rawUpsize_Contech].[dbo].[system].[consign_loc_level]
	  FROM [rawUpsize_Contech].[dbo].[system]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[system].[job_no] = orders.[job_no]			-- FK = [orders].[job_no] --> [orders].[ordersid]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[system].[cust_no] = customer.[cust_no]	-- FK = [customer].[cust_no] --> [customer].[customerid]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[system].[invoice_no] = aropen.[invoice_no]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].system.[qrn_no] = qrn.[qrn_no]						-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
	  LEFT JOIN [dbo].[corractn] corractn ON [rawUpsize_Contech].[dbo].[system].[car_no] = corractn.[car_no]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
  
	--SELECT * FROM [dbo].[system]

    PRINT 'Table: dbo.system: end'

-- =========================================================
-- Section 044: turn_tbl
-- =========================================================

-- Column changes:
--  - Added [turn_tblid] to be primary key

    PRINT 'Table: dbo.turn_tbl: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'turn_tbl')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('turn_tbl')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('turn_tbl')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[turn_tbl]
		PRINT 'Table [dbo].[turn_tbl] dropped'
    END

	CREATE TABLE [dbo].[turn_tbl](
		[turn_tblid] [int] IDENTITY(1,1) NOT NULL,
		[table] [char](10) NOT NULL DEFAULT '',		
		[tbl_od] [char](50) NOT NULL DEFAULT '',
		[ct_cm] [char](3) NOT NULL DEFAULT '',
		[mfg] [char](15) NOT NULL DEFAULT '',
		[max_len] [char](10) NOT NULL DEFAULT '',
		[comment] [char](15) NOT NULL DEFAULT '',
		CONSTRAINT [PK_turn_tbl] PRIMARY KEY CLUSTERED 
		(
			[turn_tblid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[turn_tbl] ([table],[tbl_od],[ct_cm],[mfg],[max_len],[comment])
	SELECT [rawUpsize_Contech].[dbo].[turn_tbl].[table]
		  ,[rawUpsize_Contech].[dbo].[turn_tbl].[tbl_od]
		  ,[rawUpsize_Contech].[dbo].[turn_tbl].[ct_cm]
		  ,[rawUpsize_Contech].[dbo].[turn_tbl].[mfg]
		  ,[rawUpsize_Contech].[dbo].[turn_tbl].[max_len]
		  ,[rawUpsize_Contech].[dbo].[turn_tbl].[comment]
	  FROM [rawUpsize_Contech].[dbo].[turn_tbl]
  
	--SELECT * FROM [dbo].[turn_tbl]

    PRINT 'Table: dbo.turn_tbl: end'

-- =========================================================
-- Section 044: turnmemo
-- =========================================================

-- Column changes:
--  - Set [turnmemoid] to be primary key
--  - Changed [memonote] from [text] to [varchar](2000)
--  - Changed [table] [char](10) to [turn_tblid] [int] to reference [turn_tbl] table
--  - Changed [memouser] [char](10) to [memouser] [int] to reference [users] table
-- Maps:
--	- [rev_rel].[table] --> [turn_tblid]	-- FK = [turn_tbl].[table] --> [turn_tbl].[turn_tblid]
--	- [rev_rel].[memouser]					-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.turnmemo: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'turnmemo')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('turnmemo')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('turnmemo')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[turnmemo]
		PRINT 'Table [dbo].[turnmemo] dropped'
    END

	CREATE TABLE [dbo].[turnmemo](
		[turnmemoid] [int] IDENTITY(1,1) NOT NULL,
		--[table] [char](10) NOT NULL DEFAULT '',		-- FK = [turn_tbl].[table] 
		[turn_tblid] [int] NULL,						-- FK = [turn_tbl].[table] --> [turn_tbl].[turn_tblid]
		[memodate] [datetime] NULL,
		--[memouser] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[memouser] [int] NULL,							-- FK = [users].[username] --> [users].[userid]
		[memonote] [varchar](2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_turnmemo] PRIMARY KEY CLUSTERED 
		(
			[turnmemoid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_turnmemo_turn_tbl FOREIGN KEY ([turn_tblid]) REFERENCES [dbo].[turn_tbl] ([turn_tblid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_turnmemo_users FOREIGN KEY ([memouser]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[turnmemo] NOCHECK CONSTRAINT [FK_turnmemo_users];

	SET IDENTITY_INSERT [dbo].[turnmemo] ON;

	INSERT INTO [dbo].[turnmemo] ([turnmemoid],[turn_tblid],[memodate],[memouser],[memonote])
	SELECT [rawUpsize_Contech].[dbo].[turnmemo].[turnmemoid]
		  --,[rawUpsize_Contech].[dbo].[turnmemo].[table]
		  ,ISNULL(turn_tbl.[turn_tblid], NULL) as [turn_tblid]	-- FK = [turn_tbl].[table] --> [turn_tbl].[turn_tblid]	
		  ,[rawUpsize_Contech].[dbo].[turnmemo].[memodate]
		  --,[rawUpsize_Contech].[dbo].[turnmemo].[memouser]
		  ,ISNULL(users.[userid], NULL) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[turnmemo].[memonote]		-- FK = [users].[username] --> [users].[userid]
	  FROM [rawUpsize_Contech].[dbo].[turnmemo]
	  LEFT JOIN [dbo].[turn_tbl] turn_tbl ON [rawUpsize_Contech].[dbo].[turnmemo].[table] = turn_tbl.[table]	
	  LEFT JOIN [dbo].[users] ON [rawUpsize_Contech].[dbo].[turnmemo].[memouser] = users.[username]	
  
	SET IDENTITY_INSERT [dbo].[turnmemo] OFF;

	--SELECT * FROM [dbo].[turnmemo]

    PRINT 'Table: dbo.turnmemo: end'

-- =========================================================
-- Section 044: units --> Moved to section 001
-- =========================================================

-- Column changes:
--  - Added [unitid] to be primary key

 --   PRINT 'Table: dbo.units: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'units'))
	--	DROP TABLE [dbo].[units]

	--CREATE TABLE [dbo].[units](
	--	[unitid] [int] IDENTITY(1,1) NOT NULL,
	--	[unit] [char](4) NOT NULL DEFAULT '',
	--	CONSTRAINT [PK_units] PRIMARY KEY CLUSTERED 
	--	(
	--		[unitid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	--) ON [PRIMARY]

	--INSERT INTO [dbo].[units] ([unit])
	--SELECT [unit] FROM [rawUpsize_Contech].[dbo].[units]
  
	----SELECT * FROM [dbo].[units]

 --   PRINT 'Table: dbo.units: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section044_HR.sql'

-- =========================================================