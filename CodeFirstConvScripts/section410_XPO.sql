-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section041_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 041: quotas
-- =========================================================

-- Column changes:
--  - Added [quotasid] to be primary key
--	- Added [bom_hdrid] [int] to reference [bom_hdr] table
--  - Removed columns [bom_no] & [bom_rev]
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [quotas].[bom_hdrid]		-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [quotas].[add_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [quotas].[mod_userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.quotas: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'quotas')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('quotas')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('quotas')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[quotas]
		PRINT 'Table [dbo].[quotas] dropped'
    END

	CREATE TABLE [dbo].[quotas](
		[quotasid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		[quota] [numeric](6, 0) NOT NULL DEFAULT 0,
		[type] [char](15) NOT NULL DEFAULT '',
		[mfgstageid] [int] NOT NULL DEFAULT 0,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[mod_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		CONSTRAINT [PK_quotas] PRIMARY KEY CLUSTERED 
		(
			[quotasid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_quotas_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_quotas_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_quotas_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[quotas] NOCHECK CONSTRAINT [FK_quotas_bom_hdr];
	ALTER TABLE [dbo].[quotas] NOCHECK CONSTRAINT [FK_quotas_add_user];
	ALTER TABLE [dbo].[quotas] NOCHECK CONSTRAINT [FK_quotas_mod_user];

	INSERT INTO [dbo].[quotas] ([bom_hdrid],[quota],[type],[mfgstageid],[add_userid],[add_dt],[mod_userid],[mod_dt])
	SELECT ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[quotas].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[quotas].[bom_rev]
		  ,[rawUpsize_Contech].[dbo].[quotas].[quota]
		  ,[rawUpsize_Contech].[dbo].[quotas].[type]
		  ,[rawUpsize_Contech].[dbo].[quotas].[mfgstageid]
		  --,[rawUpsize_Contech].[dbo].[quotas].[add_user]
		  ,ISNULL(add_user.[userid], NULL) as [add_userid]			
		  ,[rawUpsize_Contech].[dbo].[quotas].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[quotas].[mod_user]
		  ,ISNULL(mod_user.[userid], NULL) as [mod_userid]			
		  ,[rawUpsize_Contech].[dbo].[quotas].[mod_dt]
	  FROM [rawUpsize_Contech].[dbo].[quotas]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[quotas].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[quotas].[bom_rev] = bom_hdr.[bom_rev] 
	  LEFT JOIN [dbo].[users] add_user ON [rawUpsize_Contech].[dbo].[quotas].[add_user] = add_user.[username]	-- FK = [users].[userid]
	  LEFT JOIN [dbo].[users] mod_user ON [rawUpsize_Contech].[dbo].[quotas].[mod_user] = mod_user.[username]	-- FK = [users].[userid]
  
	--SELECT * FROM [dbo].[quotas]

    PRINT 'Table: dbo.quotas: end'

-- =========================================================
-- Section 041: quotashx
-- =========================================================

-- Column changes:
--  - Set [quotashxid] to be primary key
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
--  - Changed [mod_notes] from [text] to [varchar](2000)

--	- Added [bom_hdrid] [int] to reference [bom_hdr] table
--  - Removed columns [bom_no] & [bom_rev]
-- Maps:
--	- [quotas].[bom_hdrid]		-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [quotas].[mod_userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.quotashx: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'quotashx')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('quotashx')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('quotashx')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[quotashx]
		PRINT 'Table [dbo].[quotashx] dropped'
    END

	CREATE TABLE [dbo].[quotashx](
		[quotashxid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		--[mod_user] [char](10) NOT NULL DEFAULT '',
		[mod_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		[mod_notes] [varchar](2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_quotashx] PRIMARY KEY CLUSTERED 
		(
			[quotashxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_quotashx_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_quotashx_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[quotashx] NOCHECK CONSTRAINT [FK_quotashx_bom_hdr];
	ALTER TABLE [dbo].[quotashx] NOCHECK CONSTRAINT [FK_quotashx_mod_user];

	SET IDENTITY_INSERT [dbo].[quotashx] ON;

	INSERT INTO [dbo].[quotashx] ([quotashxid],[bom_hdrid],[mod_userid],[mod_dt],[mod_notes])
	SELECT [rawUpsize_Contech].[dbo].[quotashx].[quotashxid]
		  ,ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[quotashx].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[quotashx].[bom_rev]
		  --,[rawUpsize_Contech].[dbo].[quotashx].[mod_user]
		  ,ISNULL(mod_user.[userid], NULL) as [mod_userid]		
		  ,[rawUpsize_Contech].[dbo].[quotashx].[mod_dt]
		  ,[rawUpsize_Contech].[dbo].[quotashx].[mod_notes]
	  FROM [rawUpsize_Contech].[dbo].[quotashx]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[quotashx].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[quotashx].[bom_rev] = bom_hdr.[bom_rev] 
	  LEFT JOIN [dbo].[users] mod_user ON [rawUpsize_Contech].[dbo].[quotashx].[mod_user] = mod_user.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[quotashx] OFF;

	--SELECT * FROM [dbo].[quotashx]

    PRINT 'Table: dbo.quotashx: end'

-- =========================================================
-- Section 041: receipts
-- =========================================================

-- Column changes:
--  - Added [receiptid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
-- Maps:
--	- [receipts].[cust_no] --> [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [receipts].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]

    PRINT 'Table: dbo.receipts: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'receipts')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('receipts')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('receipts')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[receipts]
		PRINT 'Table [dbo].[receipts] dropped'
    END

	CREATE TABLE [dbo].[receipts](
		[receiptid] [int] IDENTITY(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL DEFAULT '',			-- FK = [customer].[cust_no]
		[customerid] [int] NULL,							-- FK = [customer].[cust_no] --> [customer].[customerid]
		[cashtype] [char](2) NOT NULL DEFAULT '',
		--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no]
		[aropenid] [int] NULL,								-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[check_no] [char](11) NOT NULL DEFAULT '',
		[check_amt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[check_date] [datetime] NULL,
		[apply_amt] [numeric](8, 2) NOT NULL,
		[comment] [char](30) NOT NULL DEFAULT '',
		[fr_ins] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[vat] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[acct] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[write_off] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[discount] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[misc_inc] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[date_time] [datetime] NULL,
		CONSTRAINT [PK_receipts] PRIMARY KEY CLUSTERED 
		(
			[receiptid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_receipts_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_receipts_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[receipts] NOCHECK CONSTRAINT [FK_receipts_customer];
	ALTER TABLE [dbo].[receipts] NOCHECK CONSTRAINT [FK_receipts_aropen];

	INSERT INTO [dbo].[receipts] ([customerid],[cashtype],[aropenid],[check_no],[check_amt],[check_date],[apply_amt],[comment],[fr_ins],[vat],[acct],[write_off],[discount],[misc_inc],[date_time])
	SELECT --[rawUpsize_Contech].[dbo].[receipts].[cust_no]		
		  ISNULL(customer.[customerid], NULL) as [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[receipts].[cashtype]
		  --,[rawUpsize_Contech].[dbo].[receipts].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) AS [aropenid] 			-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[receipts].[check_no]
		  ,[rawUpsize_Contech].[dbo].[receipts].[check_amt]
		  ,[rawUpsize_Contech].[dbo].[receipts].[check_date]
		  ,[rawUpsize_Contech].[dbo].[receipts].[apply_amt]
		  ,[rawUpsize_Contech].[dbo].[receipts].[comment]
		  ,[rawUpsize_Contech].[dbo].[receipts].[fr_ins]
		  ,[rawUpsize_Contech].[dbo].[receipts].[vat]
		  ,[rawUpsize_Contech].[dbo].[receipts].[acct]
		  ,[rawUpsize_Contech].[dbo].[receipts].[write_off]
		  ,[rawUpsize_Contech].[dbo].[receipts].[discount]
		  ,[rawUpsize_Contech].[dbo].[receipts].[misc_inc]
		  ,[rawUpsize_Contech].[dbo].[receipts].[date_time]
	  FROM [rawUpsize_Contech].[dbo].[receipts]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[receipts].[cust_no] = customer.[cust_no]	-- FK = [customer].[cust_no] --> [customer].[customerid]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[receipts].[invoice_no] = aropen.[invoice_no]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
    
	--SELECT * FROM [dbo].[receipts]

    PRINT 'Table: dbo.receipts: end'

-- =========================================================
-- Section 041: reminder
-- =========================================================

-- Column changes:
--  - Added [reminderid] to be primary key

    PRINT 'Table: dbo.reminder: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'reminder')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('reminder')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('reminder')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[reminder]
		PRINT 'Table [dbo].[reminder] dropped'
    END

	CREATE TABLE [dbo].[reminder](
		[reminderid] [int] IDENTITY(1,1) NOT NULL,
		[reminder] [char](30) NOT NULL DEFAULT '',
		[descript] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_reminder] PRIMARY KEY CLUSTERED 
		(
			[reminderid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[reminder] ([reminder],[descript])
	SELECT [rawUpsize_Contech].[dbo].[reminder].[reminder]
		  ,[rawUpsize_Contech].[dbo].[reminder].[descript]
	  FROM [rawUpsize_Contech].[dbo].[reminder]
  
	--SELECT * FROM [dbo].[reminder]

    PRINT 'Table: dbo.reminder: end'

-- =========================================================
-- Section 041: req_case
-- =========================================================

-- Column changes:
--  - Set [req_caseid] to be primary key
--  - Changed [add_user] to [userid] to reference [users] table
-- Maps:
--	- [req_case].[req_dtlid]	-- FK = [req_dtl].[req_dtlid]
--	- [req_case].[req_hdrid]	-- FK = [req_hdr].[req_hdrid]
--	- [req_case].[cmpcaseid]	-- FK = [cmpcases].[cmpcaseid]
--	- [req_case].[userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.req_case: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'req_case')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('req_case')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('req_case')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[req_case]
		PRINT 'Table [dbo].[req_case] dropped'
    END

	CREATE TABLE [dbo].[req_case](
		[req_caseid] [int] IDENTITY(1,1) NOT NULL,
		[req_dtlid] [int] NULL,						-- FK = [req_dtl].[req_dtlid]
		[req_hdrid] [int] NULL,						-- FK = [req_hdr].[req_hdrid]
		[cmpcaseid] [int] NULL,						-- FK = [cmpcases].[cmpcaseid]
		[qty] [int] NOT NULL DEFAULT 0,			
		[picked] [bit] NOT NULL DEFAULT 0,
		[qty_picked] [int] NOT NULL DEFAULT 0,
		[picked_dt] [datetime] NULL,
		[picked_by] [char](10) NOT NULL DEFAULT '',
		[mod_date] [datetime] NULL,
		[add_dt] [datetime] NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_req_case] PRIMARY KEY CLUSTERED 
		(
			[req_caseid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_req_case_req_dtl FOREIGN KEY ([req_dtlid]) REFERENCES [dbo].[req_dtl] ([req_dtlid]) ON DELETE NO ACTION
		,CONSTRAINT FK_req_case_req_hdr FOREIGN KEY ([req_hdrid]) REFERENCES [dbo].[req_hdr] ([req_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_req_case_cmpcases FOREIGN KEY ([cmpcaseid]) REFERENCES [dbo].[cmpcases] ([cmpcaseid]) ON DELETE NO ACTION
		,CONSTRAINT FK_req_case_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[req_case] NOCHECK CONSTRAINT [FK_req_case_req_dtl];
	ALTER TABLE [dbo].[req_case] NOCHECK CONSTRAINT [FK_req_case_req_hdr];
	ALTER TABLE [dbo].[req_case] NOCHECK CONSTRAINT [FK_req_case_cmpcases];
	ALTER TABLE [dbo].[req_case] NOCHECK CONSTRAINT [FK_req_case_users];

	SET IDENTITY_INSERT [dbo].[req_case] ON;

	INSERT INTO [dbo].[req_case] ([req_caseid],[req_dtlid],[req_hdrid],[cmpcaseid],[qty],[picked],[qty_picked],[picked_dt],[picked_by],[mod_date],[add_dt],[userid])
	SELECT [rawUpsize_Contech].[dbo].[req_case].[req_caseid]
		  ,[rawUpsize_Contech].[dbo].[req_case].[req_dtlid]
		  ,[rawUpsize_Contech].[dbo].[req_case].[req_hdrid]
		  ,[rawUpsize_Contech].[dbo].[req_case].[cmpcasesid]
		  ,[rawUpsize_Contech].[dbo].[req_case].[qty]
		  ,[rawUpsize_Contech].[dbo].[req_case].[picked]
		  ,[rawUpsize_Contech].[dbo].[req_case].[qty_picked]
		  ,[rawUpsize_Contech].[dbo].[req_case].[picked_dt]
		  ,[rawUpsize_Contech].[dbo].[req_case].[picked_by]
		  ,[rawUpsize_Contech].[dbo].[req_case].[mod_date]
		  ,[rawUpsize_Contech].[dbo].[req_case].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[req_case].[userid]
		  ,ISNULL(users.[userid], NULL) as [userid]			
	  FROM [rawUpsize_Contech].[dbo].[req_case]
	  LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[req_case].[userid] = users.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[req_case] OFF;

	--SELECT * FROM [dbo].[req_case]

    PRINT 'Table: dbo.req_case: end'

-- =========================================================
-- Section 041: samplans
-- =========================================================

-- Column changes:
--  - Set [samplansid] to be primary key
--  - Moved [samplansid] to first column
--  - Renamed [samplansid] to [samplanid]
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [samplans].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.samplans: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'samplans')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('samplans')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('samplans')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[samplans]
		PRINT 'Table [dbo].[samplans] dropped'
    END

	CREATE TABLE [dbo].[samplans](
		[samplanid] [int] IDENTITY(1,1) NOT NULL,
		[code] [char](2) NOT NULL DEFAULT '',
		[desc] [char](60) NOT NULL DEFAULT '',
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		--[rev_emp] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber]
		[employeeid] [int] NULL,					-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_samplans] PRIMARY KEY CLUSTERED
		(
			[samplanid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_samplans_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[samplans] NOCHECK CONSTRAINT [FK_samplans_employee];

	SET IDENTITY_INSERT [dbo].[samplans] ON;

	INSERT INTO [dbo].[samplans] ([samplanid],[code],[desc],[rev_rec],[rev_dt],[employeeid])
	SELECT [rawUpsize_Contech].[dbo].[samplans].[samplansid]
		  ,[rawUpsize_Contech].[dbo].[samplans].[code]
		  ,[rawUpsize_Contech].[dbo].[samplans].[desc]
		  ,[rawUpsize_Contech].[dbo].[samplans].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[samplans].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[samplans].[rev_emp]
		  ,ISNULL(employee.[employeeid], NULL) AS [employeeid]	-- [asstevnt].[evntperson]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[samplans]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[samplans].[rev_emp]	 = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

	SET IDENTITY_INSERT [dbo].[samplans] OFF;

	--SELECT * FROM [dbo].[samplans]

    PRINT 'Table: dbo.samplans: end'
	
-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section041_HR.sql'

-- =========================================================