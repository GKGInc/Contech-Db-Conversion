-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section031_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 031: doctypes -- MOVED to section 003
-- =========================================================

-- Column changes:
--  - Added [doctypesid] to be primary key
--  - Changed [doctypesid] to [doctypeid]

	--PRINT 'Table: dbo.doctypes: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'doctypes'))
	--	DROP TABLE [dbo].[doctypes]

	--CREATE TABLE [dbo].[doctypes](
	--	[doctypeid] [int] IDENTITY(1,1) NOT NULL,
	--	[doctype] [char](4) NOT NULL DEFAULT '',
	--	[descript] [char](50) NOT NULL DEFAULT '',
	--	[order] [char](2) NOT NULL DEFAULT '',
	--	CONSTRAINT [PK_doctypes] PRIMARY KEY CLUSTERED 
	--	(
	--		[doctypeid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	--) ON [PRIMARY]

	--INSERT INTO [dbo].[doctypes] ([doctype],[descript],[order])
	--SELECT [doctype]
	--	  ,[descript]
	--	  ,[order]
	--  FROM [rawUpsize_Contech].[dbo].[doctypes]
  
	----SELECT * FROM [dbo].[doctypes]

 --   PRINT 'Table: dbo.doctypes: end'

-- =========================================================
-- Section 031: dspnsers
-- =========================================================

-- Column changes:
--  - Added [dspnsersid] to be primary key
--  - Added [bom_hdrid] to be foreign key to link [bom_no] & [bom_rev]
--  - Removed columns [bom_no] & [bom_rev]
-- Maps:
--	- [dspnsers].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

    PRINT 'Table: dbo.dspnsers: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'dspnsers')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('dspnsers')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('dspnsers')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[dspnsers]
		PRINT 'Table [dbo].[dspnsers] dropped'
    END

	CREATE TABLE [dbo].[dspnsers](
		[dspnsersid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NULL,								-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,		-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,		-- FK = [bom_hdr].[bom_rev]
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
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_dspnsers_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[dspnsers] NOCHECK CONSTRAINT [FK_dspnsers_bom_hdr];

	INSERT INTO [dbo].[dspnsers] ([bom_hdrid],[coil_od],[qtypolybag],[no_twist],[qty_bag],[qty_corr],[lbl_corr],[start],[ending],[window],[luer_req],[luer_fit],[luer_place],[j_req],[j_place])
	SELECT --[rawUpsize_Contech].[dbo].[dspnsers].[bom_no]		-- FK = [bom_hdr].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[dspnsers].[bom_rev]		-- FK = [bom_hdr].[bom_rev]
		  ISNULL(bom_hdr.[bom_hdrid], NULL) AS [bom_hdrid]		-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
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
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[dspnsers].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[dspnsers].[bom_rev] = bom_hdr.[bom_rev]
  
	--SELECT * FROM [dbo].[dspnsers]

    PRINT 'Table: dbo.dspnsers: end'

-- =========================================================
-- Section 031: ecoc
-- =========================================================

-- Column changes:
--  - Set [ecocid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [gen_user] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [ecoc].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [ecoc].[gen_user] --> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]

    PRINT 'Table: dbo.ecoc: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ecoc')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('ecoc')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('ecoc')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[ecoc]
		PRINT 'Table [dbo].[ecoc] dropped'
    END

	CREATE TABLE [dbo].[ecoc](
		[ecocid] [int] IDENTITY(1,1) NOT NULL,
		--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no]
		[aropenid] [int] NULL,								-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[add_dt] [datetime] NULL,
		[gen_dt] [datetime] NULL,
		--[gen_user] [char](10) NOT NULL DEFAULT '',		-- FK = [employee].[empnumber] 
		[employeeid] [int] NULL,							-- FK = [employee].[empnumber] -> [employee].[employeeid]
		[sent_dt] [datetime] NULL,
		[type] [char](3) NOT NULL DEFAULT '',
		CONSTRAINT [PK_ecoc] PRIMARY KEY CLUSTERED 
		(
			[ecocid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_ecoc_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
		,CONSTRAINT FK_ecoc_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[ecoc] NOCHECK CONSTRAINT [FK_ecoc_aropen];
	ALTER TABLE [dbo].[ecoc] NOCHECK CONSTRAINT [FK_ecoc_employee];

	SET IDENTITY_INSERT [dbo].[ecoc] ON;

	INSERT INTO [dbo].[ecoc] ([ecocid],[aropenid],[add_dt],[gen_dt],[employeeid],[sent_dt],[type])
	SELECT [rawUpsize_Contech].[dbo].[ecoc].[ecocid]
		  --,[rawUpsize_Contech].[dbo].[ecoc].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) as [aropenid]			-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[ecoc].[add_dt]
		  ,[rawUpsize_Contech].[dbo].[ecoc].[gen_dt]
		  --,[rawUpsize_Contech].[dbo].[ecoc].[gen_user]
		  ,ISNULL(employee.[employeeid], NULL) AS [employeeid]		-- FK = [employee].[empnumber] -> [employee].[employeeid]
		  ,[rawUpsize_Contech].[dbo].[ecoc].[sent_dt]
		  ,[rawUpsize_Contech].[dbo].[ecoc].[type]
	  FROM [rawUpsize_Contech].[dbo].[ecoc]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[ecoc].[invoice_no] = aropen.[invoice_no]		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[ecoc].[gen_user] = employee.[empnumber]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
	  WHERE [rawUpsize_Contech].[dbo].[ecoc].[ecocid] != 0

	SET IDENTITY_INSERT [dbo].[ecoc] OFF;

	--SELECT * FROM [dbo].[ecoc]

    PRINT 'Table: dbo.ecoc: end'

-- =========================================================
-- Section 031: ecust
-- =========================================================

-- Column changes:
--  - Set [ecustid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [ecode] from text to varchar(2000)
--  - Changed [equery] from text to varchar(2000)
-- Maps:
--	- [ecust].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]

    PRINT 'Table: dbo.ecust: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ecust')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('ecust')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('ecust')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[ecust]
		PRINT 'Table [dbo].[ecust] dropped'
    END

	CREATE TABLE [dbo].[ecust](
		[ecustid] [int] IDENTITY(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL DEFAULT '',	-- FK = [customer].[cust_no] 
		[customerid] [int] NULL,					-- FK = [customer].[cust_no] --> [customer].[customerid]
		[emodule] [char](2) NOT NULL DEFAULT '',
		[ecode] varchar(2000) NOT NULL DEFAULT '',
		[equery] varchar(2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_ecust] PRIMARY KEY CLUSTERED 
		(
			[ecustid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_ecust_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[ecust] NOCHECK CONSTRAINT [FK_ecust_customer];

	SET IDENTITY_INSERT [dbo].[ecust] ON;

	INSERT INTO [dbo].[ecust] ([ecustid],[customerid],[emodule],[ecode],[equery])
	SELECT [rawUpsize_Contech].[dbo].[ecust].[ecustid]
		  --,[rawUpsize_Contech].[dbo].[ecust].[cust_no]
		  ,ISNULL(customer.[customerid], NULL) as [customerid]
		  ,[rawUpsize_Contech].[dbo].[ecust].[emodule]
		  ,[rawUpsize_Contech].[dbo].[ecust].[ecode]
		  ,[rawUpsize_Contech].[dbo].[ecust].[equery]
	  FROM [rawUpsize_Contech].[dbo].[ecust]
	  LEFT JOIN [customer] customer ON [rawUpsize_Contech].[dbo].[ecust].[cust_no] = customer.[cust_no] 

	SET IDENTITY_INSERT [dbo].[ecust] OFF;

	--SELECT * FROM [dbo].[ecust]

    PRINT 'Table: dbo.ecust: end'

-- =========================================================
-- Section 31: einvoice
-- =========================================================

-- Column changes:
--  - Set [einvoiceid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [gen_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [einvoice].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [einvoice].[gen_user] --> [userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.einvoice: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'einvoice')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('einvoice')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('einvoice')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[einvoice]
		PRINT 'Table [dbo].[einvoice] dropped'
    END

	CREATE TABLE [dbo].[einvoice](
		[einvoiceid] [int] IDENTITY(1,1) NOT NULL,
		--[invoice_no] [numeric](9, 0) NOT NULL,		-- FK = [aropen].[invoice_no] 
		[aropenid] [int] NULL,							-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[gen_dt] [datetime] NULL,
		--[gen_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[userid] [int] NULL,							-- FK = [users].[username] --> [users].[userid]
		[sent_dt] [datetime] NULL,
		[invoice_hd] [numeric](9, 0) NOT NULL,
		CONSTRAINT [PK_einvoice] PRIMARY KEY CLUSTERED 
		(
			[einvoiceid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_einvoice_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
		,CONSTRAINT FK_einvoice_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[einvoice] NOCHECK CONSTRAINT [FK_einvoice_aropen];
	ALTER TABLE [dbo].[einvoice] NOCHECK CONSTRAINT [FK_einvoice_users];

	SET IDENTITY_INSERT [dbo].[einvoice] ON;

	INSERT INTO [dbo].[einvoice] ([einvoiceid],[aropenid],[gen_dt],[userid],[sent_dt],[invoice_hd])
	SELECT [rawUpsize_Contech].[dbo].[einvoice].[einvoiceid]
		  --,[rawUpsize_Contech].[dbo].[einvoice].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) as [aropenid]
		  ,[rawUpsize_Contech].[dbo].[einvoice].[gen_dt]
		  --,[rawUpsize_Contech].[dbo].[einvoice].[gen_user]
		  ,ISNULL(users.[userid], NULL) as [userid]		
		  ,[rawUpsize_Contech].[dbo].[einvoice].[sent_dt]
		  ,[rawUpsize_Contech].[dbo].[einvoice].[invoice_hd]
	  FROM [rawUpsize_Contech].[dbo].[einvoice]
	  LEFT JOIN [aropen] ON [rawUpsize_Contech].[dbo].[einvoice].[invoice_no] = aropen.[invoice_no]		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	  LEFT JOIN [users] ON [rawUpsize_Contech].[dbo].[einvoice].[gen_user] = users.[username]			-- FK = [users].[username] --> [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[einvoice] OFF;

	--SELECT * FROM [dbo].[einvoice]

    PRINT 'Table: dbo.einvoice: end'

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section031_HR.sql'

-- =========================================================