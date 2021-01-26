-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section009_HR.sql'

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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrn'))
		DROP TABLE [dbo].[qrn]
	
	CREATE TABLE [dbo].[qrn](
		[qrnid] [int] IDENTITY(1,1) NOT NULL,
		[qrn_no] [char](8) NOT NULL DEFAULT '',
		[source] [char](2) NOT NULL DEFAULT '',
		[comp] [char](5) NOT NULL DEFAULT '',
		[fin_good] [char](15) NOT NULL DEFAULT '',
		[fin_lot] [char](8) NOT NULL DEFAULT '',
		[ct_lot] [char](4) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no] 
		[customerid] [int] NOT NULL DEFAULT 0,			-- FK = [customer].[cust_no] --> [customer].[customerid]	
		[cust_lot] [char](15) NOT NULL DEFAULT '',
		--[ven_id] [char](6) NOT NULL DEFAULT 0,		-- FK = [vendor].[ven_id] 
		[vendorid] [int] NOT NULL DEFAULT 0,			-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
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
		[matlinid] [int] NOT NULL DEFAULT 0,			-- FK = [matlin].[matlinid]
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
		[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] --> [employee].[employeeid]
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
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 
  
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
		  ,ISNULL(customer.[customerid], 0) AS [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[qrn].[cust_lot]
		  --,[rawUpsize_Contech].[dbo].[qrn].[ven_id]		
		  ,ISNULL(vendor.[vendorid], 0) AS [vendorid]		-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
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
		  ,ISNULL(matlin.[matlinid], 0) AS [matlinid]		-- FK = [matlin].[matlin_key] == [matlin].[matlinid]
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
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
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

    COMMIT

    PRINT 'Table: dbo.qrn: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 009: qrn_dtl
-- =========================================================

-- Column changes:
--  - Changed [qrn_dtlid] to be primary key
--  - Changed [qrn_no] [char](8) to [qrnid] [int] to reference [qrn] table
-- Maps:
--	- [qrn_dtl].[qrn_no] --> [qrnid]	-- FK = [qrn].[qrnid]
--	- [qrn_dtl].[cmpcasesid]			-- FK = [cmpcases].[cmpcasesid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrn_dtl: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrn_dtl'))
		DROP TABLE [dbo].[qrn_dtl]
	
	CREATE TABLE [dbo].[qrn_dtl](
		[qrn_dtlid] [int] IDENTITY(1,1) NOT NULL,	-- PK
		--[qrn_no] [char](8) NOT NULL DEFAULT '',	-- FK = [qrn].[qrn_no]  
		[qrnid] [int] NOT NULL DEFAULT '',			-- FK = [qrn].[qrnid]
		[cmpcasesid] [int] NOT NULL DEFAULT 0,		-- FK = [cmpcases].[cmpcasesid]
		[qty_rej] [int] NOT NULL DEFAULT 0,
		[id_type] [char](5) NOT NULL DEFAULT '',
		[picked] [bit] NOT NULL DEFAULT 0,
		[bar_code] [char](13) NOT NULL DEFAULT '',
		CONSTRAINT [PK_qrn_dtl] PRIMARY KEY CLUSTERED 
		(
			[qrn_dtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[qrn_dtl] ON;

	INSERT INTO [dbo].[qrn_dtl] ([qrn_dtlid],[qrnid],[cmpcasesid],[qty_rej],[id_type],[picked],[bar_code])
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

	SET IDENTITY_INSERT [dbo].[qrn_dtl] OFF;

	--SELECT * FROM [dbo].[qrn_dtl]

    COMMIT

    PRINT 'Table: dbo.qrn_dtl: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 009: qrnexcpt
-- =========================================================

-- Column changes:
--  - Set [qrnexcptid] as primary key
-- Maps:
--	- [qrnexcpt].[qrnid]	-- FK = [qrn].[qrnid]
--	- [qrnexcpt].[bom_no]	-- FK = [bom_hdr].[bom_no]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrnexcpt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnexcpt'))
		DROP TABLE [dbo].[qrnexcpt]
	
	CREATE TABLE [dbo].[qrnexcpt](
		[qrnexcptid] [int] IDENTITY(1,1) NOT NULL,
		[qrnid] [int] NOT NULL DEFAULT 0,				-- FK = [qrn].[qrnid]
		[extype] [char](1) NOT NULL DEFAULT '',
		[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		CONSTRAINT [PK_qrnexcpt] PRIMARY KEY CLUSTERED 
		(
			[qrnexcptid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[qrnexcpt] ON;

	INSERT INTO [dbo].[qrnexcpt] ([qrnexcptid],[qrnid],[extype],[bom_no])
	SELECT [rawUpsize_Contech].[dbo].[qrnexcpt].[qrnexcptid]
		  ,[rawUpsize_Contech].[dbo].[qrnexcpt].[qrnid]		-- FK = [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrnexcpt].[extype]
		  ,[rawUpsize_Contech].[dbo].[qrnexcpt].[bom_no]	-- FK = [bom_hdr].[bom_no]
	  FROM [rawUpsize_Contech].[dbo].[qrnexcpt]
  
	SET IDENTITY_INSERT [dbo].[qrnexcpt] OFF;

	--SELECT * FROM [dbo].[qrnexcpt]

    COMMIT

    PRINT 'Table: dbo.qrnexcpt: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 009: qrnissue
-- =========================================================

-- Column changes:
--  - Set [qrnissueid] as primary key
-- Maps:
--	- [qrnissue].[issuesid]		-- FK = [issues].[issuesid]
--	- [qrnmachn].[qrnid]		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
--	- [qrnissue].[issuesdtid]	-- FK = [issuesdt].[issuesdtid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrnissue: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnissue'))
		DROP TABLE [dbo].[qrnissue]
		
	CREATE TABLE [dbo].[qrnissue](
		[qrnissueid] [int] IDENTITY(1,1) NOT NULL,
		[issuesid] [int] NOT NULL DEFAULT 0,			-- FK = [issues].[issuesid]
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NOT NULL DEFAULT '',				-- FK = [qrn].[qrnid]
		[issuesdtid] [int] NOT NULL DEFAULT 0,			-- FK = [issuesdt].[issuesdtid]
		CONSTRAINT [PK_qrnissue] PRIMARY KEY CLUSTERED 
		(
			[qrnissueid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[qrnissue] ON;

	INSERT INTO [dbo].[qrnissue] ([qrnissueid],[issuesid],[qrnid],[issuesdtid])
	SELECT [rawUpsize_Contech].[dbo].[qrnissue].[qrnissueid]
		  ,[rawUpsize_Contech].[dbo].[qrnissue].[issuesid]
		  --,[rawUpsize_Contech].[dbo].[qrnmachn].[qrn_no]		-- FK = [qrn].[qrn_no]
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[qrnissue].[issuesdtid]
	  FROM [rawUpsize_Contech].[dbo].[qrnissue]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[qrnissue].[qrn_no] = qrn.[qrn_no]
  
	SET IDENTITY_INSERT [dbo].[qrnissue] OFF;

	--SELECT * FROM [dbo].[qrnissue]

    COMMIT

    PRINT 'Table: dbo.qrnissue: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 009: qrnmachn
-- =========================================================

-- Column changes:
--  - Set [qrnmachnid] as primary key
-- Maps:
--	- [qrnmachn].[qrnid]		-- FK = [qrn].[qrnid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrnmachn: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnmachn'))
		DROP TABLE [dbo].[qrnmachn]

	CREATE TABLE [dbo].[qrnmachn](
		[qrnmachnid] [int] IDENTITY(1,1) NOT NULL,
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NOT NULL DEFAULT '',				-- FK = [qrn].[qrnid]
		[machine] [char](10) NOT NULL DEFAULT '',
		CONSTRAINT [PK_qrnmachn] PRIMARY KEY CLUSTERED 
		(
			[qrnmachnid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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

    COMMIT

    PRINT 'Table: dbo.qrnmachn: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 009: qrnsource
-- =========================================================

-- Column changes:
--  - Added [qrnsourceid] as primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrnsource: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrnsource'))
		DROP TABLE [dbo].[qrnsource]
	
	CREATE TABLE [dbo].[qrnsource](
		[qrnsourceid] [int] identity(1,1) NOT NULL,
		[source] [char](2) NOT NULL DEFAULT '',
		[descript] [char](25) NOT NULL DEFAULT '',
		CONSTRAINT [PK_qrnsource] PRIMARY KEY CLUSTERED 
		(
			[qrnsourceid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[qrnsource] 
		SELECT * FROM [rawUpsize_Contech].[dbo].[qrnsource]
  
	--SELECT * FROM [dbo].[qrnsource]

    COMMIT

    PRINT 'Table: dbo.qrnsource: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 009: qrntable
-- =========================================================

-- Column changes:
--  - Set [qrntableid] as primary key
-- Maps:
--	- [qrnmachn].[qrnid]		-- FK = [qrn].[qrnid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.qrntable: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'qrntable'))
		DROP TABLE [dbo].[qrntable]
	
	CREATE TABLE [dbo].[qrntable](
		[qrntableid] [int] IDENTITY(1,1) NOT NULL,
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NOT NULL DEFAULT '',				-- FK = [qrn].[qrnid]
		[table] [char](10) NOT NULL DEFAULT '',
		[insertused] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_qrntable] PRIMARY KEY CLUSTERED 
		(
			[qrntableid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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

    COMMIT

    PRINT 'Table: dbo.qrntable: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section009_HR.sql'

-- =========================================================