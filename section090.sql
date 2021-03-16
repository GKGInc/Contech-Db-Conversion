-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section009_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 009: qrn
-- =========================================================

-- Column changes:
--  - Changed [qrnid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [ven_id] [char](6) to [vendorid] [int] to reference [vendor] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
--  - Changed [reason] from [text] to [varchar](2000)
--  - Changed [comments] from [text] to [varchar](2000)
-- Maps:
--	- [qrn].[cust_no] --> [customerid]	 -- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [qrn].[ven_id] --> [vendorid]		 -- FK = [vendor].[ven_id] --> [vendor].[vendorid]
--	- [qrn].[matlinid]					 -- FK = [matlin].[matlin_key] == [matlin].[matlinid]
--	- [qrn].[empnumber]	--> [employeeid] -- FK = [employee].[empnumber] --> [employee].[employeeid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrn: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrn')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrn')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrn')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrn]
		PRINT 'Table [dbo].[qrn] dropped'
    END
	
	CREATE TABLE [dbo].[qrn](
		[qrnid] [int] IDENTITY(1,1) NOT NULL,
		[qrn_no] [char](8) NOT NULL DEFAULT '',
		[source] [char](2) NOT NULL DEFAULT '',
		[comp] [char](5) NOT NULL DEFAULT '',
		[fin_good] [char](15) NOT NULL DEFAULT '',
		[fin_lot] [char](8) NOT NULL DEFAULT '',
		[ct_lot] [char](4) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no] 
		[customerid] [int] NULL,						-- FK = [customer].[cust_no] --> [customer].[customerid]	
		[cust_lot] [char](15) NOT NULL DEFAULT '',
		--[ven_id] [char](6) NOT NULL DEFAULT 0,		-- FK = [vendor].[ven_id] 
		[vendorid] [int] NULL,							-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		[ven_lot] [char](15) NOT NULL DEFAULT '',
		[po_no] [char](8) NOT NULL DEFAULT '',
		[cust_po] [char](15) NOT NULL DEFAULT '',
		[recd] [numeric](10, 0) NOT NULL DEFAULT 0,
		[rejected] [numeric](10, 0) NOT NULL DEFAULT 0,
		[inspected] [numeric](10, 0) NOT NULL DEFAULT 0,
		[defective] [numeric](10, 0) NOT NULL DEFAULT 0,
		[inspector] [char](10) NOT NULL DEFAULT '',
		[qrn_date] [datetime] NULL,
		[reason] [varchar](2000) NOT NULL DEFAULT '',
		[ct_cpa] [char](10) NOT NULL DEFAULT '',
		[action] [bit] NOT NULL DEFAULT 0,
		[post] [bit] NOT NULL DEFAULT 0,
		[matlinid] [int] NULL,							-- FK = [matlin].[matlinid]
		[matlincrid] [int] NOT NULL DEFAULT 0,
		[use_as] [bit] NOT NULL DEFAULT 0,
		[rework] [bit] NOT NULL DEFAULT 0,
		[return] [bit] NOT NULL DEFAULT 0,
		[scrap] [bit] NOT NULL DEFAULT 0,
		[mrc] [bit] NOT NULL DEFAULT 0,
		[returned] [numeric](10, 0) NOT NULL DEFAULT 0,
		[kept] [numeric](10, 0) NOT NULL DEFAULT 0,
		[comments] [varchar](2000) NOT NULL DEFAULT '',
		[rev_dt] [datetime] NULL,
		[hold] [bit] NOT NULL DEFAULT 0,
		[reopen_po] [bit] NOT NULL DEFAULT 0,
		[internal] [bit] NOT NULL DEFAULT 0,
		[comp_desc] [char](75) NOT NULL DEFAULT '',
		--[empnumber] [char](10) NOT NULL DEFAULT 0,	-- FK = [employee].[empnumber]
		[employeeid] [int] NULL,						-- FK = [employee].[empnumber] --> [employee].[employeeid]
		[external] [bit] NOT NULL DEFAULT 0,
		[rework_no] [char](10) NOT NULL DEFAULT '',
		[rjct_close] [datetime] NULL,
		[keep_close] [datetime] NULL,
		[vndnotfied] [datetime] NULL,
		[vndrsponse] [datetime] NULL,
		[sort] [bit] NOT NULL DEFAULT 0,
		[regrade] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_qrn] PRIMARY KEY CLUSTERED 
		(
			[qrnid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_qrn_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_qrn_vendor FOREIGN KEY ([vendorid]) REFERENCES [dbo].[vendor] ([vendorid]) ON DELETE NO ACTION
		,CONSTRAINT FK_qrn_matlin FOREIGN KEY ([matlinid]) REFERENCES [dbo].[matlin] ([matlinid]) ON DELETE NO ACTION
		,CONSTRAINT FK_qrn_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
  
	ALTER TABLE [dbo].[qrn] NOCHECK CONSTRAINT [FK_qrn_customer];
	ALTER TABLE [dbo].[qrn] NOCHECK CONSTRAINT [FK_qrn_vendor];
	ALTER TABLE [dbo].[qrn] NOCHECK CONSTRAINT [FK_qrn_matlin];
	ALTER TABLE [dbo].[qrn] NOCHECK CONSTRAINT [FK_qrn_employee];

	SET IDENTITY_INSERT [dbo].[qrn] ON;

	INSERT INTO [dbo].[qrn] ([qrnid],[qrn_no],[source],[comp],[fin_good],[fin_lot],[ct_lot],[customerid],[cust_lot],[vendorid],[ven_lot],[po_no],[cust_po],[recd],[rejected],[inspected],[defective],[inspector],[qrn_date],[reason],[ct_cpa],[action],[post],[matlinid],[matlincrid],[use_as],[rework],[return],[scrap],[mrc],[returned],[kept],[comments],[rev_dt],[hold],[reopen_po],[internal],[comp_desc],[employeeid],[external],[rework_no],[rjct_close],[keep_close],[vndnotfied],[vndrsponse],[sort],[regrade])
	SELECT [rawUpsize_Contech].[dbo].[qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[qrn_no]
		  ,[rawUpsize_Contech].[dbo].[qrn].[source]
		  ,[rawUpsize_Contech].[dbo].[qrn].[comp]
		  ,[rawUpsize_Contech].[dbo].[qrn].[fin_good]
		  ,[rawUpsize_Contech].[dbo].[qrn].[fin_lot]
		  ,[rawUpsize_Contech].[dbo].[qrn].[ct_lot]
		  --,[rawUpsize_Contech].[dbo].[qrn].[cust_no]	
		  ,ISNULL(customer.[customerid], NULL) AS [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[cust_lot]
		  --,[rawUpsize_Contech].[dbo].[qrn].[ven_id]		
		  ,ISNULL(vendor.[vendorid], NULL) AS [vendorid]		-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[ven_lot]
		  ,[rawUpsize_Contech].[dbo].[qrn].[po_no]
		  ,[rawUpsize_Contech].[dbo].[qrn].[cust_po]
		  ,[rawUpsize_Contech].[dbo].[qrn].[recd]
		  ,[rawUpsize_Contech].[dbo].[qrn].[rejected]
		  ,[rawUpsize_Contech].[dbo].[qrn].[inspected]
		  ,[rawUpsize_Contech].[dbo].[qrn].[defective]
		  ,[rawUpsize_Contech].[dbo].[qrn].[inspector]
		  ,[rawUpsize_Contech].[dbo].[qrn].[qrn_date]
		  ,[rawUpsize_Contech].[dbo].[qrn].[reason]
		  ,[rawUpsize_Contech].[dbo].[qrn].[ct_cpa]
		  ,[rawUpsize_Contech].[dbo].[qrn].[action]
		  ,[rawUpsize_Contech].[dbo].[qrn].[post]
		  --,[rawUpsize_Contech].[dbo].[qrn].[matlinid]	
		  ,ISNULL(matlin.[matlinid], NULL) AS [matlinid]		-- FK = [matlin].[matlin_key] == [matlin].[matlinid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[matlincrid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[use_as]
		  ,[rawUpsize_Contech].[dbo].[qrn].[rework]
		  ,[rawUpsize_Contech].[dbo].[qrn].[return]
		  ,[rawUpsize_Contech].[dbo].[qrn].[scrap]
		  ,[rawUpsize_Contech].[dbo].[qrn].[mrc]
		  ,[rawUpsize_Contech].[dbo].[qrn].[returned]
		  ,[rawUpsize_Contech].[dbo].[qrn].[kept]
		  ,[rawUpsize_Contech].[dbo].[qrn].[comments]
		  ,[rawUpsize_Contech].[dbo].[qrn].[rev_dt]
		  ,[rawUpsize_Contech].[dbo].[qrn].[hold]
		  ,[rawUpsize_Contech].[dbo].[qrn].[reopen_po]
		  ,[rawUpsize_Contech].[dbo].[qrn].[internal]
		  ,[rawUpsize_Contech].[dbo].[qrn].[comp_desc]
		  --,[rawUpsize_Contech].[dbo].[qrn].[empnumber]	
		  ,ISNULL(employee.[employeeid], NULL) AS [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[external]
		  ,[rawUpsize_Contech].[dbo].[qrn].[rework_no]
		  ,[rawUpsize_Contech].[dbo].[qrn].[rjct_close]
		  ,[rawUpsize_Contech].[dbo].[qrn].[keep_close]
		  ,[rawUpsize_Contech].[dbo].[qrn].[vndnotfied]
		  ,[rawUpsize_Contech].[dbo].[qrn].[vndrsponse]
		  ,[rawUpsize_Contech].[dbo].[qrn].[sort]
		  ,[rawUpsize_Contech].[dbo].[qrn].[regrade]
	  FROM [rawUpsize_Contech].[dbo].[qrn]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[qrn].[cust_no] = customer.[cust_no]
	  LEFT JOIN [dbo].[vendor] vendor ON [rawUpsize_Contech].[dbo].[qrn].[ven_id] = vendor.[ven_id]
	  LEFT JOIN [dbo].[matlin] matlin ON [rawUpsize_Contech].[dbo].[qrn].[matlinid] = matlin.[matlinid]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[qrn].[empnumber] = employee.[empnumber]

	SET IDENTITY_INSERT [dbo].[qrn] OFF;

	--SELECT * FROM [dbo].[qrn]

    PRINT 'Table: dbo.qrn: end'

-- =========================================================
-- Section 009: qrn_dtl
-- =========================================================

-- Column changes:
--  - Changed [qrn_dtlid] to be primary key
--  - Changed [qrn_no] [char](8) to [qrnid] [int] to reference [qrn] table
--  - Changed [cmpcasesid] to [cmpcaseid]
-- Maps:
--	- [qrn_dtl].[qrn_no] --> [qrnid]	-- FK = [qrn].[qrnid]
--	- [qrn_dtl].[cmpcaseid]			-- FK = [cmpcases].[cmpcaseid]

    PRINT 'Table: dbo.qrn_dtl: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrn_dtl')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrn_dtl')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrn_dtl')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrn_dtl]
		PRINT 'Table [dbo].[qrn_dtl] dropped'
    END

	CREATE TABLE [dbo].[qrn_dtl](
		[qrn_dtlid] [int] IDENTITY(1,1) NOT NULL,	-- PK
		--[qrn_no] [char](8) NOT NULL DEFAULT '',	-- FK = [qrn].[qrn_no]  
		[qrnid] [int] NOT NULL DEFAULT 0,			-- FK = [qrn].[qrnid]
		[cmpcaseid] [int] NOT NULL DEFAULT 0,		-- FK = [cmpcases].[cmpcaseid]
		[qty_rej] [int] NOT NULL DEFAULT 0,
		[id_type] [char](5) NOT NULL DEFAULT '',
		[picked] [bit] NOT NULL DEFAULT 0,
		[bar_code] [char](13) NOT NULL DEFAULT '',
		CONSTRAINT [PK_qrn_dtl] PRIMARY KEY CLUSTERED 
		(
			[qrn_dtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_qrn_dtl_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_qrn_dtl_cmpcases FOREIGN KEY ([cmpcaseid]) REFERENCES [dbo].[cmpcases] ([cmpcaseid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[qrn_dtl] NOCHECK CONSTRAINT [FK_qrn_dtl_cmpcases];

	SET IDENTITY_INSERT [dbo].[qrn_dtl] ON;

	INSERT INTO [dbo].[qrn_dtl] ([qrn_dtlid],[qrnid],[cmpcaseid],[qty_rej],[id_type],[picked],[bar_code])
	SELECT [rawUpsize_Contech].[dbo].[qrn_dtl].[qrn_dtlid]
		  --,[rawUpsize_Contech].[dbo].[qrn_dtl].[qrn_no]				
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		 ,[rawUpsize_Contech].[dbo].[qrn_dtl].[cmpcasesid]		-- FK = [cmpcases].[cmpcasesid]
		  ,[rawUpsize_Contech].[dbo].[qrn_dtl].[qty_rej]
		  ,[rawUpsize_Contech].[dbo].[qrn_dtl].[id_type]
		  ,[rawUpsize_Contech].[dbo].[qrn_dtl].[picked]
		  ,[rawUpsize_Contech].[dbo].[qrn_dtl].[bar_code]
	  FROM [rawUpsize_Contech].[dbo].[qrn_dtl]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[qrn_dtl].[qrn_no] = qrn.[qrn_no] 
	  WHERE [qrnid] IN (SELECT [qrnid] FROM [dbo].[qrn])

	SET IDENTITY_INSERT [dbo].[qrn_dtl] OFF;

	--SELECT * FROM [dbo].[qrn_dtl]

    PRINT 'Table: dbo.qrn_dtl: end'

-- =========================================================
-- Section 009: qrnexcpt
-- =========================================================

-- Column changes:
--  - Set [qrnexcptid] as primary key
-- Maps:
--	- [qrnexcpt].[qrnid]	-- FK = [qrn].[qrnid]
--	- [qrnexcpt].[bom_no]	-- FK = [bom_hdr].[bom_no]

    PRINT 'Table: dbo.qrnexcpt: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnexcpt')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrnexcpt')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrnexcpt')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrnexcpt]
		PRINT 'Table [dbo].[qrnexcpt] dropped'
    END
	
	CREATE TABLE [dbo].[qrnexcpt](
		[qrnexcptid] [int] IDENTITY(1,1) NOT NULL,
		[qrnid] [int] NOT NULL DEFAULT 0,				-- FK = [qrn].[qrnid]
		[extype] [char](1) NOT NULL DEFAULT '',
		[bom_no] [numeric](5, 0) NULL,					-- FK = [bom_hdr].[bom_no]
		CONSTRAINT [PK_qrnexcpt] PRIMARY KEY CLUSTERED 
		(
			[qrnexcptid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_qrnexcpt_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE CASCADE NOT FOR REPLICATION 
		--,CONSTRAINT FK_qrnexcpt_bom_hdr FOREIGN KEY ([bom_no]) REFERENCES [dbo].[bom_hdr] ([bom_no]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	--ALTER TABLE [dbo].[qrnexcpt] NOCHECK CONSTRAINT [FK_qrnexcpt_bom_hdr];

	SET IDENTITY_INSERT [dbo].[qrnexcpt] ON;

	INSERT INTO [dbo].[qrnexcpt] ([qrnexcptid],[qrnid],[extype],[bom_no])
	SELECT [rawUpsize_Contech].[dbo].[qrnexcpt].[qrnexcptid]
		  ,[rawUpsize_Contech].[dbo].[qrnexcpt].[qrnid]		-- FK = [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrnexcpt].[extype]
		  ,[rawUpsize_Contech].[dbo].[qrnexcpt].[bom_no]	-- FK = [bom_hdr].[bom_no]
	  FROM [rawUpsize_Contech].[dbo].[qrnexcpt]
  
	SET IDENTITY_INSERT [dbo].[qrnexcpt] OFF;

	--SELECT * FROM [dbo].[qrnexcpt]

    PRINT 'Table: dbo.qrnexcpt: end'

-- =========================================================
-- Section 009: qrnissue
-- =========================================================

-- Column changes:
--  - Set [qrnissueid] as primary key
-- Maps:
--	- [qrnissue].[issuesid]		-- FK = [issues].[issuesid]
--	- [qrnmachn].[qrnid]		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
--	- [qrnissue].[issuesdtid]	-- FK = [issuesdt].[issuesdtid]

    PRINT 'Table: dbo.qrnissue: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnissue')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrnissue')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrnissue')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrnissue]
		PRINT 'Table [dbo].[qrnissue] dropped'
    END
	
	CREATE TABLE [dbo].[qrnissue](
		[qrnissueid] [int] IDENTITY(1,1) NOT NULL,
		[issueid] [int] NULL,							-- FK = [issues].[issueid]
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NOT NULL DEFAULT 0,				-- FK = [qrn].[qrnid]
		[issuesdtid] [int] NULL,						-- FK = [issuesdt].[issuesdtid]
		CONSTRAINT [PK_qrnissue] PRIMARY KEY CLUSTERED 
		(
			[qrnissueid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_qrnissue_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_qrnissue_issues FOREIGN KEY ([issueid]) REFERENCES [dbo].[issues] ([issueid]) ON DELETE NO ACTION
		,CONSTRAINT FK_qrnissue_issuesdt FOREIGN KEY ([issuesdtid]) REFERENCES [dbo].[issuesdt] ([issuesdtid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[qrnissue] NOCHECK CONSTRAINT [FK_qrnissue_issues];
	ALTER TABLE [dbo].[qrnissue] NOCHECK CONSTRAINT [FK_qrnissue_issuesdt];

	SET IDENTITY_INSERT [dbo].[qrnissue] ON;

	INSERT INTO [dbo].[qrnissue] ([qrnissueid],[issueid],[qrnid],[issuesdtid])
	SELECT [rawUpsize_Contech].[dbo].[qrnissue].[qrnissueid]
		  ,[rawUpsize_Contech].[dbo].[qrnissue].[issuesid]
		  --,[rawUpsize_Contech].[dbo].[qrnmachn].[qrn_no]		-- FK = [qrn].[qrn_no]
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrnissue].[issuesdtid]
	  FROM [rawUpsize_Contech].[dbo].[qrnissue]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[qrnissue].[qrn_no] = qrn.[qrn_no]
	WHERE [qrnid] > 0

	SET IDENTITY_INSERT [dbo].[qrnissue] OFF;

	--SELECT * FROM [dbo].[qrnissue]

    PRINT 'Table: dbo.qrnissue: end'

-- =========================================================
-- Section 009: qrnmachn
-- =========================================================

-- Column changes:
--  - Set [qrnmachnid] as primary key
-- Maps:
--	- [qrnmachn].[qrnid]		-- FK = [qrn].[qrnid]

    PRINT 'Table: dbo.qrnmachn: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnmachn')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrnmachn')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrnmachn')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrnmachn]
		PRINT 'Table [dbo].[qrnmachn] dropped'
    END

	CREATE TABLE [dbo].[qrnmachn](
		[qrnmachnid] [int] IDENTITY(1,1) NOT NULL,
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NOT NULL DEFAULT 0,				-- FK = [qrn].[qrnid]
		[machine] [char](10) NOT NULL DEFAULT '',
		CONSTRAINT [PK_qrnmachn] PRIMARY KEY CLUSTERED 
		(
			[qrnmachnid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_qrnmachn_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE CASCADE NOT FOR REPLICATION 
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[qrnmachn] ON;

	INSERT INTO [dbo].[qrnmachn] ([qrnmachnid],[qrnid],[machine])
	SELECT [rawUpsize_Contech].[dbo].[qrnmachn].[qrnmachnid]
		  --,[rawUpsize_Contech].[dbo].[qrnmachn].[qrn_no]		-- FK = [qrn].[qrn_no]
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrnmachn].[machine]
	  FROM [rawUpsize_Contech].[dbo].[qrnmachn]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[qrnmachn].[qrn_no] = qrn.[qrn_no]
  
	SET IDENTITY_INSERT [dbo].[qrnmachn] OFF;

	--SELECT * FROM [dbo].[qrnmachn]

    PRINT 'Table: dbo.qrnmachn: end'
	
-- =========================================================
-- Section 009: qrnsource
-- =========================================================

-- Column changes:
--  - Added [qrnsourceid] as primary key

    PRINT 'Table: dbo.qrnsource: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnsource')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrnsource')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrnsource')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrnsource]
		PRINT 'Table [dbo].[qrnsource] dropped'
    END
	
	CREATE TABLE [dbo].[qrnsource](
		[qrnsourceid] [int] identity(1,1) NOT NULL,
		[source] [char](2) NOT NULL DEFAULT '',
		[descript] [char](25) NOT NULL DEFAULT '',
		CONSTRAINT [PK_qrnsource] PRIMARY KEY CLUSTERED 
		(
			[qrnsourceid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[qrnsource] 
		SELECT * FROM [rawUpsize_Contech].[dbo].[qrnsource]
  
	--SELECT * FROM [dbo].[qrnsource]

    PRINT 'Table: dbo.qrnsource: end'

-- =========================================================
-- Section 009: qrntable
-- =========================================================

-- Column changes:
--  - Set [qrntableid] as primary key
-- Maps:
--	- [qrnmachn].[qrnid]		-- FK = [qrn].[qrnid]

    PRINT 'Table: dbo.qrntable: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrntable')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('qrntable')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('qrntable')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[qrntable]
		PRINT 'Table [dbo].[qrntable] dropped'
    END

	CREATE TABLE [dbo].[qrntable](
		[qrntableid] [int] IDENTITY(1,1) NOT NULL,
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NOT NULL DEFAULT '',				-- FK = [qrn].[qrnid]
		[table] [char](10) NOT NULL DEFAULT '',
		[insertused] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_qrntable] PRIMARY KEY CLUSTERED 
		(
			[qrntableid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_qrntable_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE CASCADE NOT FOR REPLICATION 
	) ON [PRIMARY] 
	
	SET IDENTITY_INSERT [dbo].[qrntable] ON;

	INSERT INTO [dbo].[qrntable] ([qrntableid],[qrnid],[table],[insertused])
	SELECT [rawUpsize_Contech].[dbo].[qrntable].[qrntableid]
		  --,[rawUpsize_Contech].[dbo].[qrntable].[qrn_no]		-- FK = [qrn].[qrn_no]
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrntable].[table]
		  ,[rawUpsize_Contech].[dbo].[qrntable].[insertused]
	  FROM [rawUpsize_Contech].[dbo].[qrntable]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[qrntable].[qrn_no] = qrn.[qrn_no]
  
	SET IDENTITY_INSERT [dbo].[qrntable] OFF;

	--SELECT * FROM [dbo].[qrntable]

    PRINT 'Table: dbo.qrntable: end'

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section009_HR.sql'

-- =========================================================