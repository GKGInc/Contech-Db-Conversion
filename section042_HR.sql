-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section042_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 042: rev_rel_inv
-- =========================================================

-- Column changes:
--  - Changed [pk] to [rev_rel_invid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
-- Maps:
--	- [rev_rel_inv].[rev_relid]						-- FK = [rev_rel].[rev_relid]
--	- [rev_rel_inv].[invoice_no] --> [aropenid]		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [rev_rel_inv].[add_user] --> [add_userid]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.rev_rel_inv: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'rev_rel_inv'))
		DROP TABLE [dbo].[rev_rel_inv]

	CREATE TABLE [dbo].[rev_rel_inv](
		--[pk] [int] IDENTITY(1,1) NOT NULL,
		[rev_rel_invid] [int] IDENTITY(1,1) NOT NULL,
		[rev_relid] [int] NOT NULL DEFAULT 0,			-- FK = [rev_rel].[rev_relid]
		--[invoice_no] [int] NOT NULL DEFAULT 0,		-- FK = [aropen].[invoice_no]
		[aropenid] [int] NOT NULL DEFAULT 0,			-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_rev_rel_inv] PRIMARY KEY CLUSTERED 
		(
			[rev_rel_invid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[rev_rel_inv] ON;

	INSERT INTO [dbo].[rev_rel_inv] ([rev_rel_invid],[rev_relid],[aropenid],[add_dt],[add_userid])
	SELECT [rawUpsize_Contech].[dbo].[rev_rel_inv].[pk]
		  ,[rawUpsize_Contech].[dbo].[rev_rel_inv].[rev_relid]	
		  --,[rawUpsize_Contech].[dbo].[rev_rel_inv].[invoice_no]
		  ,ISNULL(aropen.[aropenid], 0) AS [aropenid] 		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[rev_rel_inv].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[rev_rel_inv].[add_user]
		  ,ISNULL(users.[userid] , 0) as [userid]			-- FK = [users].[username] --> [users].[userid]
	  FROM [rawUpsize_Contech].[dbo].[rev_rel_inv]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[rev_rel_inv].[invoice_no] = aropen.[invoice_no]	
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[rev_rel_inv].[add_user] = users.[username]	
  
	SET IDENTITY_INSERT [dbo].[rev_rel_inv] OFF;

	--SELECT * FROM [dbo].[rev_rel_inv]

    PRINT 'Table: dbo.rev_rel_inv: end'

-- =========================================================
-- Section 042: revrelbx
-- =========================================================

-- Column changes:
--  - Set [revrelbxid] to be primary key
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [revrelbx].[rev_relid]				-- FK = [rev_rel].[rev_relid]
--	- [revrelbx].[fppalletid]				-- FK = [fppallet].[fppalletid]
--	- [revrelbx].[fplabelid]				-- FK = [fplabel].[fplabelid]
--	- [rev_rel].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.revrelbx: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'revrelbx'))
		DROP TABLE [dbo].[revrelbx]

	CREATE TABLE [dbo].[revrelbx](
		[revrelbxid] [int] IDENTITY(1,1) NOT NULL,
		[rev_relid] [int] NOT NULL DEFAULT 0,		-- FK = [rev_rel].[rev_relid]
		[fppalletid] [int] NOT NULL DEFAULT 0,		-- FK = [fppallet].[fppalletid]
		[fplabelid] [int] NOT NULL DEFAULT 0,		-- FK = [fplabel].[fplabelid]
		--[add_user] [char](10) NOT NULL DEFAULT '',-- FK = [users].[username]
		[add_userid] [int] NOT NULL DEFAULT 0,		-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_revrelbx] PRIMARY KEY CLUSTERED 
		(
			[revrelbxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[revrelbx] ON;

	INSERT INTO [dbo].[revrelbx] ([revrelbxid],[rev_relid],[fppalletid],[fplabelid],[add_userid],[add_dt])
	SELECT [rawUpsize_Contech].[dbo].[revrelbx].[revrelbxid]
		  ,[rawUpsize_Contech].[dbo].[revrelbx].[rev_relid]
		  ,[rawUpsize_Contech].[dbo].[revrelbx].[fppalletid]
		  ,[rawUpsize_Contech].[dbo].[revrelbx].[fplabelid]
		  --,[rawUpsize_Contech].[dbo].[revrelbx].[add_user]
		  ,ISNULL(users.[userid] , 0) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[revrelbx].[add_dt]
	  FROM [rawUpsize_Contech].[dbo].[revrelbx]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[revrelbx].[add_user] = users.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[revrelbx] OFF;

	--SELECT * FROM [dbo].[revrelbx]

    PRINT 'Table: dbo.revrelbx: end'

-- =========================================================
-- Section 042: sampaql
-- =========================================================

-- Column changes:
--  - Set [sampaqlid] to be primary key
-- Maps:
--	- [bom_hist].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.sampaql: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'sampaql'))
		DROP TABLE [dbo].[sampaql]

	CREATE TABLE [dbo].[sampaql](
		[sampaqlid] [int] IDENTITY(1,1) NOT NULL,
		[aql] [numeric](5, 3) NOT NULL DEFAULT 0.0,
		CONSTRAINT [PK_sampaql] PRIMARY KEY CLUSTERED 
		(
			[sampaqlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[sampaql] ON;

	INSERT INTO [dbo].[sampaql] ([sampaqlid],[aql])
	SELECT [rawUpsize_Contech].[dbo].[sampaql].[sampaqlid]
		  ,[rawUpsize_Contech].[dbo].[sampaql].[aql]
	  FROM [rawUpsize_Contech].[dbo].[sampaql]
  
	SET IDENTITY_INSERT [dbo].[sampaql] OFF;

	--SELECT * FROM [dbo].[sampaql]

    PRINT 'Table: dbo.sampaql: end'

-- =========================================================
-- Section 042: sampchrt
-- =========================================================

-- Column changes:
--  - Set [sampchrtid] to be primary key
-- Maps:
--	- [bom_hist].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.sampchrt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'sampchrt'))
		DROP TABLE [dbo].[sampchrt]

	CREATE TABLE [dbo].[sampchrt](
		[sampchrtid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](30) NOT NULL DEFAULT '',
		CONSTRAINT [PK_sampchrt] PRIMARY KEY CLUSTERED 
		(
			[sampchrtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[sampchrt] ON;

	INSERT INTO [dbo].[sampchrt] ([sampchrtid],[descript])
	SELECT [rawUpsize_Contech].[dbo].[sampchrt].[sampchrtid]
		  ,[rawUpsize_Contech].[dbo].[sampchrt].[descript]
	  FROM [rawUpsize_Contech].[dbo].[sampchrt]
  
	SET IDENTITY_INSERT [dbo].[sampchrt] OFF;

	--SELECT * FROM [dbo].[sampchrt]

    PRINT 'Table: dbo.sampchrt: end'

-- =========================================================
-- Section 042: sampdtl
-- =========================================================

-- Column changes:
--  - Set [sampdtlid] to be primary key
--  - Changed [plan] [char](2) to [samplansid] [int] to reference [samplans] table
-- Maps:
--	- [sampdtl].[plan] --> [samplanid]	-- FK = [samplans].[code] --> [samplans].[samplanid]
--	- [sampdtl].[class]					-- FK = [clsficat].[clsficatid]
--	- [sampdtl].[chart]					-- FK = [sampchrt].[sampchrtid]
--	- [sampdtl].[insp_lev]				-- FK = [samplevl].[samplevlid]
--	- [sampdtl].[aql]					-- FK = [samplacql].[sampaqlid]

    PRINT 'Table: dbo.sampdtl: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'sampdtl'))
		DROP TABLE [dbo].[sampdtl]

	CREATE TABLE [dbo].[sampdtl](
		[sampdtlid] [int] IDENTITY(1,1) NOT NULL,
		--[plan] [char](2) NOT NULL DEFAULT '',		-- FK = [samplans].[code] 
		[samplanid] [int] NOT NULL DEFAULT '',		-- FK = [samplans].[code] --> [samplans].[samplanid]
		[order] [numeric](2, 0) NOT NULL DEFAULT 0,
		[class] [int] NOT NULL DEFAULT 0,			-- FK = [clsficat].[clsficatid]
		[chart] [int] NOT NULL DEFAULT 0,			-- FK = [sampchrt].[sampchrtid]
		[insp_lev] [int] NOT NULL DEFAULT 0,		-- FK = [samplevl].[samplevlid]
		[aql] [int] NOT NULL DEFAULT 0,				-- FK = [samplacql].[sampaqlid]
		[measure] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_sampdtl] PRIMARY KEY CLUSTERED 
		(
			[sampdtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[sampdtl] ON;

	INSERT INTO [dbo].[sampdtl] ([sampdtlid],[samplanid],[order],[class],[chart],[insp_lev],[aql],[measure])
	SELECT [rawUpsize_Contech].[dbo].[sampdtl].[sampdtlid]
		  --,[rawUpsize_Contech].[dbo].[sampdtl].[plan]
		  ,ISNULL(samplans.[samplanid] , 0) as [samplanid]	-- FK = [samplans].[code] --> [samplans].[samplanid]		
		  ,[rawUpsize_Contech].[dbo].[sampdtl].[order]
		  ,[rawUpsize_Contech].[dbo].[sampdtl].[class]
		  ,[rawUpsize_Contech].[dbo].[sampdtl].[chart]
		  ,[rawUpsize_Contech].[dbo].[sampdtl].[insp_lev]
		  ,[rawUpsize_Contech].[dbo].[sampdtl].[aql]
		  ,[rawUpsize_Contech].[dbo].[sampdtl].[measure]
	  FROM [rawUpsize_Contech].[dbo].[sampdtl]
	  LEFT JOIN [dbo].[samplans] samplans ON [rawUpsize_Contech].[dbo].[sampdtl].[plan] = samplans.[code]	
  
	SET IDENTITY_INSERT [dbo].[sampdtl] OFF;

	--SELECT * FROM [dbo].[sampdtl]

    PRINT 'Table: dbo.sampdtl: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section042_HR.sql'

-- =========================================================