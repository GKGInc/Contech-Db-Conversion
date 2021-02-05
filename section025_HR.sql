-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section025_HR.sql'


BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 025: cashtype
-- =========================================================

-- Column changes:
--  - Added [cashtypeid] to be primary key

    PRINT 'Table: dbo.cashtype: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cashtype'))
		DROP TABLE [dbo].[cashtype]

	CREATE TABLE [dbo].[cashtype](
		[cashtypeid] [int] IDENTITY(1,1) NOT NULL,
		[code] [char](2) NOT NULL DEFAULT '',
		[desc] [char](20) NOT NULL DEFAULT '',
		[diff_sign] [int] NOT NULL DEFAULT '',
		CONSTRAINT [PK_cashtype] PRIMARY KEY CLUSTERED 
		(
			[cashtypeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[cashtype] ([code],[desc],[diff_sign])
	SELECT [code]
		  ,[desc]
		  ,[diff_sign]
	  FROM [rawUpsize_Contech].[dbo].[cashtype]
  
	--SELECT * FROM [dbo].[cashtype]

    PRINT 'Table: dbo.cashtype: end'

-- =========================================================
-- Section 025: changelog
-- =========================================================

-- Column changes:
--  - Added [changelogid] to be primary key
--  - Changed [username] [char](10) to [userid] [int] to reference users table
--  - Changed [oldvalue] from text to varchar(2000)
--  - Changed [newvalue] from text to varchar(2000)
--  - Changed [curprogram] from text to varchar(2000)
-- Maps:
--	- [changelog].[add_user]		-- FK = [users].[username] --> [users].[userid]


    PRINT 'Table: dbo.changelog: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'changelog'))
		DROP TABLE [dbo].[changelog]

	CREATE TABLE [dbo].[changelog](
		[changelogid] [int] IDENTITY(1,1) NOT NULL,
		[updatetype] [char](1) NOT NULL DEFAULT '',
		[trx_id] [char](10) NULL DEFAULT '',
		[netmachine] [char](30) NOT NULL DEFAULT '',
		--[username] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
		[userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
		[updatetime] [datetime] NULL,
		[tablename] [char](15) NOT NULL DEFAULT '',
		[recordid] [char](15) NOT NULL DEFAULT '',
		[fieldname] [char](15) NULL DEFAULT '',
		[oldvalue] varchar(2000) NULL DEFAULT '',
		[newvalue] varchar(2000) NULL DEFAULT '',
		[curprogram]  varchar(2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_changelog] PRIMARY KEY CLUSTERED 
		(
			[changelogid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[changelog] ([updatetype],[trx_id],[netmachine],[userid],[updatetime],[tablename],[recordid],[fieldname],[oldvalue],[newvalue],[curprogram])
	SELECT [rawUpsize_Contech].[dbo].[changelog].[updatetype]
		  ,[rawUpsize_Contech].[dbo].[changelog].[trx_id]
		  ,[rawUpsize_Contech].[dbo].[changelog].[netmachine]
		  --,[rawUpsize_Contech].[dbo].[changelog].[username]
		  ,ISNULL(users.[userid] , 0) as [userid]	-- FK = [users].[username] --> [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[changelog].[updatetime]
		  ,[rawUpsize_Contech].[dbo].[changelog].[tablename]
		  ,[rawUpsize_Contech].[dbo].[changelog].[recordid]
		  ,[rawUpsize_Contech].[dbo].[changelog].[fieldname]
		  ,[rawUpsize_Contech].[dbo].[changelog].[oldvalue]
		  ,[rawUpsize_Contech].[dbo].[changelog].[newvalue]
		  ,[rawUpsize_Contech].[dbo].[changelog].[curprogram]
	  FROM [rawUpsize_Contech].[dbo].[changelog]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[changelog].[username] = users.[username]	-- FK = [users].[userid]

	--SELECT * FROM [dbo].[changelog]

    PRINT 'Table: dbo.changelog: end'

-- =========================================================
-- table: car_empe
-- =========================================================

-- Column changes:
--  - Set car_empeid to be primary key
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [car_empe].[car_no]						-- FK = [corractn].[car_no]
--	- [car_empe].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.car_empe: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'car_empe'))
		DROP TABLE [dbo].[car_empe]

	CREATE TABLE [dbo].[car_empe](
		[car_empeid] [int] IDENTITY(1,1) NOT NULL,
		--[car_no] [char](8) NOT NULL DEFAULT '',		-- FK = [corractn].[car_no] 
		[corractnid] [int] NOT NULL DEFAULT 0,			-- FK = [corractn].[car_no] --> [corractn].[corractnid]
		--[empnumber] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber]
		[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_car_empe] PRIMARY KEY CLUSTERED 
		(
			[car_empeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[car_empe] ON;

	INSERT INTO [dbo].[car_empe] ([car_empeid],[corractnid],[employeeid])
	SELECT [rawUpsize_Contech].[dbo].[car_empe].[car_empeid]
		  --,[rawUpsize_Contech].[dbo].[car_empe].[car_no]
		  ,ISNULL(corractn.[corractnid] , 0) as [corractnid]	
		  --,[rawUpsize_Contech].[dbo].[car_empe].[empnumber]
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	
	  FROM [rawUpsize_Contech].[dbo].[car_empe]
	  LEFT JOIN [dbo].[corractn] corractn ON [rawUpsize_Contech].[dbo].[car_empe].[car_no] = corractn.[car_no]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[car_empe].[empnumber] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
    
	SET IDENTITY_INSERT [dbo].[car_empe] OFF;

	--SELECT * FROM [dbo].[car_empe]

    PRINT 'Table: dbo.car_empe: end'


    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section025_HR.sql'

-- =========================================================
