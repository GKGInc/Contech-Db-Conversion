-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section029HR.sql'

-- =========================================================
-- Section 029: cractdtl
-- =========================================================

-- Column changes:
--  - Set [cractdtlid] to be primary key
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
-- Maps:
--	- [cractdtl].[car_no] --> [corractnid]		-- FK = [cartrack].[car_no] --> [corractn].[corractnid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.cractdtl: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cractdtl'))
		DROP TABLE [dbo].[cractdtl]

	CREATE TABLE [dbo].[cractdtl](
		[cractdtlid] [int] identity(1,1) NOT NULL,
		--[car_no] [char](8) NOT NULL DEFAULT '',		-- FK = [corractn].[car_no] 
		[corractnid] [int] NOT NULL DEFAULT 0,			-- FK = [corractn].[car_no] --> [corractn].[corractnid]
		[requiremnt] [char](100) NOT NULL DEFAULT '',
		[actual] [char](100) NOT NULL DEFAULT '',
		[sampl_size] [int] NOT NULL DEFAULT 0,
		[defects] [int] NOT NULL DEFAULT 0,
		[coractnreq] [bit] NOT NULL DEFAULT 0,
		[use_as] [bit] NOT NULL DEFAULT 0,
		[return] [bit] NOT NULL DEFAULT 0,
		[scrap] [bit] NOT NULL DEFAULT 0,
		[rework] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_cractdtl] PRIMARY KEY CLUSTERED 
		(
			[cractdtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[cractdtl] ON;

	INSERT INTO [dbo].[cractdtl] ([cractdtlid],[corractnid],[requiremnt],[actual],[sampl_size],[defects],[coractnreq],[use_as],[return],[scrap],[rework])
	SELECT [rawUpsize_Contech].[dbo].[cractdtl].[cractdtlid]
		  --,[rawUpsize_Contech].[dbo].[cractdtl].[car_no]
		  ,ISNULL(corractn.[corractnid] , 0) as [corractnid]	
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[requiremnt]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[actual]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[sampl_size]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[defects]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[coractnreq]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[use_as]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[return]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[scrap]
		  ,[rawUpsize_Contech].[dbo].[cractdtl].[rework]
	  FROM [rawUpsize_Contech].[dbo].[cractdtl]
	  LEFT JOIN [dbo].[corractn] corractn ON [rawUpsize_Contech].[dbo].[cractdtl].[car_no] = corractn.[car_no]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
  
	SET IDENTITY_INSERT [dbo].[cractdtl] OFF;

	--SELECT * FROM [dbo].[cractdtl]

    PRINT 'Table: dbo.cractdtl: end'

-- =========================================================
-- Section 029: cuslblft
-- =========================================================

-- Column changes:
--  - Set [cuslblftid] to be primary key
--  - Moved [cuslblftid] field to first column
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [rev_emp] [char](5) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [custctct].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [custctct].[rev_emp] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]


    PRINT 'Table: dbo.cuslblft: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cuslblft'))
		DROP TABLE [dbo].[cuslblft]

	CREATE TABLE [dbo].[cuslblft](
		[cuslblftid] [int] identity(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL DEFAULT '',	-- FK = [customer].[cust_no] 
		[customerid] int NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] -> [customer].[customerid]
		[flag] [char](1) NOT NULL DEFAULT '',
		[lic] [char](4) NOT NULL DEFAULT '',
		[r] [char](2) NOT NULL DEFAULT '',
		[q] [char](1) NOT NULL DEFAULT '',
		[umid1] [char](1) NOT NULL DEFAULT '',
		[umid2] [char](1) NOT NULL DEFAULT '',
		[umid3] [char](1) NOT NULL DEFAULT '',
		[umid4] [char](1) NOT NULL DEFAULT '',
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		--[rev_emp] [char](10) NOT NULL,			-- FK = [employee].[empnumber] -
		[employeeid] int NOT NULL,					-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_cuslblft] PRIMARY KEY CLUSTERED 
		(
			[cuslblftid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[cuslblft] ON;

	INSERT INTO [dbo].[cuslblft] ([cuslblftid],[customerid],[flag],[lic],[r],[q],[umid1],[umid2],[umid3],[umid4],[rev_rec],[rev_dt],[employeeid])
	SELECT [rawUpsize_Contech].[dbo].[cuslblft].[cuslblftid]
		  --,[rawUpsize_Contech].[dbo].[cuslblft].[cust_no]		-- FK = [customer].[cust_no]
		  ,ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] -> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[flag]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[lic]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[r]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[q]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[umid1]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[umid2]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[umid3]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[umid4]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[cuslblft].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[cuslblft].[rev_emp]		-- FK = [employee].[empnumber] 		
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]		-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[cuslblft]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[cuslblft].[cust_no] = customer.[cust_no]		-- FK = [customer].[cust_no] -> [customer].[customerid]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[cuslblft].[rev_emp] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

	SET IDENTITY_INSERT [dbo].[cuslblft] OFF;

	--SELECT * FROM [dbo].[cuslblft]

    PRINT 'Table: dbo.cuslblft: end'

-- =========================================================
-- Section 029: custctct
-- =========================================================

-- Column changes:
--  - Set [custctctid] to be primary key
--  - Moved [custctctid] field to first column
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
-- Maps:
--	- [custctct].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]

    PRINT 'Table: dbo.custctct: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'custctct'))
		DROP TABLE [dbo].[custctct]

	CREATE TABLE [dbo].[custctct](
		[custctctid] [int] identity(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL,			-- FK = [customer].[cust_no] 
		[customerid] int NOT NULL DEFAULT 0,	-- FK = [customer].[cust_no] -> [customer].[customerid]
		[first_name] [char](15) NOT NULL DEFAULT '',
		[last_name] [char](25) NOT NULL DEFAULT '',
		[mi] [char](1) NOT NULL DEFAULT '',
		[department] [char](50) NOT NULL DEFAULT '',
		[email] [char](100) NOT NULL DEFAULT '',
		[ext] [char](4) NOT NULL DEFAULT '',
		[phone] [char](17) NOT NULL DEFAULT '',
		[fax] [char](17) NOT NULL DEFAULT '',
		[address] [char](35) NOT NULL DEFAULT '',
		[address2] [char](35) NOT NULL DEFAULT '',
		[city] [char](30) NOT NULL DEFAULT '',
		[state] [char](3) NOT NULL DEFAULT '',
		[zip] [char](11) NOT NULL DEFAULT '',
		[country] [char](15) NOT NULL DEFAULT '',
		[job_title] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_custctct] PRIMARY KEY CLUSTERED 
		(
			[custctctid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [custctct] ON;

	INSERT INTO [custctct] ([custctctid],[customerid],[first_name],[last_name],[mi],[department],[email],[ext],[phone],[fax],[address],[address2],[city],[state],[zip],[country],[job_title])
	SELECT [rawUpsize_Contech].[dbo].[custctct].[custctctid]
		  --,[rawUpsize_Contech].[dbo].[custctct].[cust_no]		
		  ,ISNULL(customer.[customerid], 0) as [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[custctct].[first_name]
		  ,[rawUpsize_Contech].[dbo].[custctct].[last_name]
		  ,[rawUpsize_Contech].[dbo].[custctct].[mi]
		  ,[rawUpsize_Contech].[dbo].[custctct].[department]
		  ,[rawUpsize_Contech].[dbo].[custctct].[email]
		  ,[rawUpsize_Contech].[dbo].[custctct].[ext]
		  ,[rawUpsize_Contech].[dbo].[custctct].[phone]
		  ,[rawUpsize_Contech].[dbo].[custctct].[fax]
		  ,[rawUpsize_Contech].[dbo].[custctct].[address]
		  ,[rawUpsize_Contech].[dbo].[custctct].[address2]
		  ,[rawUpsize_Contech].[dbo].[custctct].[city]
		  ,[rawUpsize_Contech].[dbo].[custctct].[state]
		  ,[rawUpsize_Contech].[dbo].[custctct].[zip]
		  ,[rawUpsize_Contech].[dbo].[custctct].[country]
		  ,[rawUpsize_Contech].[dbo].[custctct].[job_title]
	  FROM [rawUpsize_Contech].[dbo].[custctct]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[custctct].[cust_no] = customer.[cust_no] 
  
	SET IDENTITY_INSERT [dbo].[custctct] OFF;

	--SELECT * FROM [dbo].[custctct]

    PRINT 'Table: dbo.custctct: end'


-- =========================================================
-- Section 029: custship
-- =========================================================

-- Column changes:
--  - Added [custshipid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
-- Maps:
--	- [custship].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [custship].[fplocatnid]				-- FK = [fplocatn].[fplocatnid]

    PRINT 'Table: dbo.custship: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'custship'))
		DROP TABLE [dbo].[custship]

	CREATE TABLE [dbo].[custship](
		[custshipid] [int] identity(1,1) NOT NULL,
		--[cust_no] [char](5) NOT NULL,				-- FK = [customer].[cust_no] 
		[customerid] int NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] -> [customer].[customerid]
		[ship_to] [char](1) NOT NULL DEFAULT '',	
		[ship_via] [char](20) NOT NULL DEFAULT '',
		[name] [char](100) NOT NULL DEFAULT '',
		[address] [char](35) NOT NULL DEFAULT '',
		[address2] [char](35) NOT NULL DEFAULT '',
		[city] [char](30) NOT NULL DEFAULT '',
		[state] [char](3) NOT NULL DEFAULT '',
		[zip] [char](11) NOT NULL DEFAULT '',
		[country] [char](15) NOT NULL DEFAULT '',
		[acct_no] [char](15) NOT NULL DEFAULT '',
		[fob_point] [char](15) NOT NULL DEFAULT '',
		[phone] [char](17) NOT NULL DEFAULT '',
		[fax] [char](17) NOT NULL DEFAULT '',
		[fplocatnid] [int] NOT NULL DEFAULT 0,		-- FK = [fplocatn].[fplocatnid]
		CONSTRAINT [PK_custship] PRIMARY KEY CLUSTERED 
		(
			[custshipid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[custship] ([customerid],[ship_to],[ship_via],[name],[address],[address2],[city],[state],[zip],[country],[acct_no],[fob_point],[phone],[fax],[fplocatnid])
	SELECT --[rawUpsize_Contech].[dbo].[custship].[cust_no]		-- FK = [customer].[cust_no] 
		  ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] -> [customer].[customerid]
		  ,[rawUpsize_Contech].[dbo].[custship].[ship_to]
		  ,[rawUpsize_Contech].[dbo].[custship].[ship_via]
		  ,[rawUpsize_Contech].[dbo].[custship].[name]
		  ,[rawUpsize_Contech].[dbo].[custship].[address]
		  ,[rawUpsize_Contech].[dbo].[custship].[address2]
		  ,[rawUpsize_Contech].[dbo].[custship].[city]
		  ,[rawUpsize_Contech].[dbo].[custship].[state]
		  ,[rawUpsize_Contech].[dbo].[custship].[zip]
		  ,[rawUpsize_Contech].[dbo].[custship].[country]
		  ,[rawUpsize_Contech].[dbo].[custship].[acct_no]
		  ,[rawUpsize_Contech].[dbo].[custship].[fob_point]
		  ,[rawUpsize_Contech].[dbo].[custship].[phone]
		  ,[rawUpsize_Contech].[dbo].[custship].[fax]
		  ,[rawUpsize_Contech].[dbo].[custship].[fplocatnid]	-- FK = [fplocatn].[fplocatnid]
	  FROM [rawUpsize_Contech].[dbo].[custship]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[custship].[cust_no] = customer.[cust_no] 
  
	--SELECT * FROM [dbo].[custship]

    PRINT 'Table: dbo.custship: end'

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section029_HR.sql'

-- =========================================================