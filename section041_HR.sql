-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section041_HR.sql'

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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'quotas'))
		DROP TABLE [dbo].[quotas]

	CREATE TABLE [dbo].[quotas](
		[quotasid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		[quota] [numeric](6, 0) NOT NULL DEFAULT 0,
		[type] [char](15) NOT NULL DEFAULT '',
		[mfgstageid] [int] NOT NULL DEFAULT 0,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[mod_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		CONSTRAINT [PK_quotas] PRIMARY KEY CLUSTERED 
		(
			[quotasid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[quotas] ([bom_hdrid],[quota],[type],[mfgstageid],[add_userid],[add_dt],[mod_userid],[mod_dt])
	SELECT ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[quotas].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[quotas].[bom_rev]
		  ,[rawUpsize_Contech].[dbo].[quotas].[quota]
		  ,[rawUpsize_Contech].[dbo].[quotas].[type]
		  ,[rawUpsize_Contech].[dbo].[quotas].[mfgstageid]
		  --,[rawUpsize_Contech].[dbo].[quotas].[add_user]
		  ,ISNULL(add_user.[userid], 0) as [add_userid]			
		  ,[rawUpsize_Contech].[dbo].[quotas].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[quotas].[mod_user]
		  ,ISNULL(mod_user.[userid], 0) as [mod_userid]			
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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'quotashx'))
		DROP TABLE [dbo].[quotashx]

	CREATE TABLE [dbo].[quotashx](
		[quotashxid] [int] IDENTITY(1,1) NOT NULL,
		[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		--[mod_user] [char](10) NOT NULL DEFAULT '',
		[mod_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		[mod_notes] [varchar](2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_quotashx] PRIMARY KEY CLUSTERED 
		(
			[quotashxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[quotashx] ON;

	INSERT INTO [dbo].[quotashx] ([quotashxid],[bom_hdrid],[mod_userid],[mod_dt],[mod_notes])
	SELECT [rawUpsize_Contech].[dbo].[quotashx].[quotashxid]
		  ,ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[quotashx].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[quotashx].[bom_rev]
		  --,[rawUpsize_Contech].[dbo].[quotashx].[mod_user]
		  ,ISNULL(mod_user.[userid], 0) as [mod_userid]		
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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'receipts'))
		DROP TABLE [dbo].[receipts]

	CREATE TABLE [dbo].[receipts](
		[receiptid] [int] IDENTITY(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL DEFAULT '',			-- FK = [customer].[cust_no]
		[customerid] [int] NOT NULL DEFAULT 0,				-- FK = [customer].[cust_no] --> [customer].[customerid]
		[cashtype] [char](2) NOT NULL DEFAULT '',
		--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no]
		[aropenid] [int] NOT NULL DEFAULT 0,				-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
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
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[receipts] ([customerid],[cashtype],[aropenid],[check_no],[check_amt],[check_date],[apply_amt],[comment],[fr_ins],[vat],[acct],[write_off],[discount],[misc_inc],[date_time])
	SELECT --[rawUpsize_Contech].[dbo].[receipts].[cust_no]		
		  ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[receipts].[cashtype]
		  --,[rawUpsize_Contech].[dbo].[receipts].[invoice_no]
		  ,ISNULL(aropen.[aropenid], 0) AS [aropenid] 			-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'reminder'))
		DROP TABLE [dbo].[reminder]

	CREATE TABLE [dbo].[reminder](
		[reminderid] [int] IDENTITY(1,1) NOT NULL,
		[reminder] [char](30) NOT NULL DEFAULT '',
		[descript] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_reminder] PRIMARY KEY CLUSTERED 
		(
			[reminderid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
--	- [req_case].[cmpcasesid]	-- FK = [cmpcases].[cmpcasesid]
--	- [req_case].[userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.req_case: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'req_case'))
		DROP TABLE [dbo].[req_case]

	CREATE TABLE [dbo].[req_case](
		[req_caseid] [int] IDENTITY(1,1) NOT NULL,
		[req_dtlid] [int] NOT NULL DEFAULT 0,			-- FK = [req_dtl].[req_dtlid]
		[req_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [req_hdr].[req_hdrid]
		[cmpcasesid] [int] NOT NULL DEFAULT 0,			-- FK = [cmpcases].[cmpcasesid]
		[qty] [int] NOT NULL DEFAULT 0,			
		[picked] [bit] NOT NULL DEFAULT 0,
		[qty_picked] [int] NOT NULL DEFAULT 0,
		[picked_dt] [datetime] NULL,
		[picked_by] [char](10) NOT NULL DEFAULT '',
		[mod_date] [datetime] NULL,
		[add_dt] [datetime] NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',
		[userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_req_case] PRIMARY KEY CLUSTERED 
		(
			[req_caseid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[req_case] ON;

	INSERT INTO [dbo].[req_case] ([req_caseid],[req_dtlid],[req_hdrid],[cmpcasesid],[qty],[picked],[qty_picked],[picked_dt],[picked_by],[mod_date],[add_dt],[userid])
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
		  ,ISNULL(users.[userid] , 0) as [userid]			
	  FROM [rawUpsize_Contech].[dbo].[req_case]
	  LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[req_case].[userid] = users.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[req_case] OFF;

	--SELECT * FROM [dbo].[req_case]

    PRINT 'Table: dbo.req_case: end'

-- =========================================================

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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'samplans'))
		DROP TABLE [dbo].[samplans]

	CREATE TABLE [dbo].[samplans](
		[samplanid] [int] IDENTITY(1,1) NOT NULL,
		[code] [char](2) NOT NULL DEFAULT '',
		[desc] [char](60) NOT NULL DEFAULT '',
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		--[rev_emp] [char](10) NOT NULL DEFAULT '',		-- FK = [employee].[empnumber]
		[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_samplans] PRIMARY KEY CLUSTERED
		(
			[samplanid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[samplans] ON;

	INSERT INTO [dbo].[samplans] ([samplanid],[code],[desc],[rev_rec],[rev_dt],[employeeid])
	SELECT [rawUpsize_Contech].[dbo].[samplans].[samplansid]
		  ,[rawUpsize_Contech].[dbo].[samplans].[code]
		  ,[rawUpsize_Contech].[dbo].[samplans].[desc]
		  ,[rawUpsize_Contech].[dbo].[samplans].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[samplans].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[samplans].[rev_emp]
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- [asstevnt].[evntperson]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[samplans]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[samplans].[rev_emp]	 = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

	SET IDENTITY_INSERT [dbo].[samplans] OFF;

	--SELECT * FROM [dbo].[samplans]

    PRINT 'Table: dbo.samplans: end'

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section041_HR.sql'

-- =========================================================