
-- =========================================================
-- Section 025: cartrack
-- =========================================================

-- Column changes:
--  - Set [cartrackid] to be primary key
--  - Changed [mod_reason] from text to varchar(2000)
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [rev_rel].[mod_user] --> [mod_userid]		-- FK = [users].[username] --> [users].[userid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cartrack'))
    DROP TABLE [dbo].[cartrack]

CREATE TABLE [dbo].[cartrack](
	[cartrackid] [int] IDENTITY(1,1) NOT NULL,
	[car_no] [char](8) NOT NULL DEFAULT '',
	[mod_reason] varchar(2000) NOT NULL DEFAULT '',
	--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
	[mod_userid] [int]  NOT NULL DEFAULT '',		-- FK = [users].[username] --> [users].[userid]
	[mod_dt] [datetime] NULL,
	CONSTRAINT [PK_cartrack] PRIMARY KEY CLUSTERED 
	(
		[cartrackid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] --TEXTIMAGE_ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[cartrack] ON;

INSERT INTO [Contech_Test].[dbo].[cartrack] ([cartrackid],[car_no],[mod_reason],[mod_userid],[mod_dt])
SELECT [rawUpsize_Contech].[dbo].[cartrack].[cartrackid]
      ,[rawUpsize_Contech].[dbo].[cartrack].[car_no]
      ,[rawUpsize_Contech].[dbo].[cartrack].[mod_reason]
      --,[rawUpsize_Contech].[dbo].[cartrack].[mod_user]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid]	 
      ,[rawUpsize_Contech].[dbo].[cartrack].[mod_dt]
  FROM [rawUpsize_Contech].[dbo].[cartrack]
    LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[cartrack].[mod_user] = [Contech_Test].[dbo].[users].[username]	-- FK = [users].[username] --> [users].[userid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[cartrack] OFF;

--SELECT * FROM [Contech_Test].[dbo].[cartrack]

-- =========================================================
-- Section 025: car_empe
-- =========================================================

-- Column changes:
--  - Set car_empeid to be primary key
--  - Changed [car_no] to int to reference [cartrack] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [car_empe].[car_no]						-- FK = [cartrack].[car_no]
--	- [car_empe].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'car_empe'))
    DROP TABLE [dbo].[car_empe]

CREATE TABLE [dbo].[car_empe](
	[car_empeid] [int] IDENTITY(1,1) NOT NULL,
	[car_no] [char](8) NOT NULL DEFAULT '',			-- FK = [cartrack].[car_no] 
	--[empnumber] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber]
	[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
	CONSTRAINT [PK_car_empe] PRIMARY KEY CLUSTERED 
	(
		[car_empeid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[car_empe] ON;

INSERT INTO [Contech_Test].[dbo].[car_empe] ([car_empeid],[car_no],[employeeid])
SELECT [rawUpsize_Contech].[dbo].[car_empe].[car_empeid]
      ,[rawUpsize_Contech].[dbo].[car_empe].[car_no]
      --,[rawUpsize_Contech].[dbo].[car_empe].[empnumber]
	  ,ISNULL([Contech_Test].[dbo].[employee].[employeeid], 0) AS [employeeid]	
  FROM [rawUpsize_Contech].[dbo].[car_empe]
  LEFT JOIN [Contech_Test].[dbo].[employee] ON [rawUpsize_Contech].[dbo].[car_empe].[empnumber] = [Contech_Test].[dbo].[employee].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[car_empe] OFF;

--SELECT * FROM [Contech_Test].[dbo].[car_empe]

-- =========================================================
-- Section 025: carcmpls
-- =========================================================

-- Column changes:
--  - Set [carcmplsid] to be primary key
--  - Changed [complnt_no] to [complntid] to reference [complnts] table
-- Maps:
--	- [prodctra].[car_no]		-- FK = [cartrack].[car_no]
--	- [prodctra].[complnt_no]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'carcmpls'))
    DROP TABLE [dbo].[carcmpls]

CREATE TABLE [dbo].[carcmpls](
	[carcmplsid] [int] IDENTITY(1,1) NOT NULL,
	[car_no] [char](8) NOT NULL DEFAULT '',		-- FK = [cartrack].[car_no]
	--[complnt_no] [int] NOT NULL DEFAULT 0,	-- FK = [complnts].[complnt_no] 
	[complntid] [int] NOT NULL DEFAULT 0,		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
	CONSTRAINT [PK_carcmpls] PRIMARY KEY CLUSTERED 
	(
		[carcmplsid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[carcmpls] ON;

INSERT INTO [Contech_Test].[dbo].[carcmpls] ([carcmplsid],[car_no],[complntid])
SELECT [rawUpsize_Contech].[dbo].[carcmpls].[carcmplsid]
      ,[rawUpsize_Contech].[dbo].[carcmpls].[car_no]
      --,[rawUpsize_Contech].[dbo].[carcmpls].[complnt_no]
	  ,ISNULL([Contech_Test].[dbo].[complnts].[complntid], 0) AS [complntid] 
  FROM [rawUpsize_Contech].[dbo].[carcmpls]
    LEFT JOIN [Contech_Test].[dbo].[complnts] ON [rawUpsize_Contech].[dbo].[carcmpls].[complnt_no] = [Contech_Test].[dbo].[complnts].[complnt_no] -- FK = [complnts].[complnt_no] --> [complnts].[complntid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[carcmpls] OFF;

--SELECT * FROM [Contech_Test].[dbo].[carcmpls]

-- =========================================================
-- Section 025: cashtype
-- =========================================================

-- Column changes:
--  - Added [cashtypeid] to be primary key

USE Contech_Test

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
GO

INSERT INTO [Contech_Test].[dbo].[cashtype] ([code],[desc],[diff_sign])
SELECT [code]
      ,[desc]
      ,[diff_sign]
  FROM [rawUpsize_Contech].[dbo].[cashtype]
  
--SELECT * FROM [Contech_Test].[dbo].[cashtype]

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

USE Contech_Test

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
GO

INSERT INTO [Contech_Test].[dbo].[changelog] ([updatetype],[trx_id],[netmachine],[userid],[updatetime],[tablename],[recordid],[fieldname],[oldvalue],[newvalue],[curprogram])
SELECT [rawUpsize_Contech].[dbo].[changelog].[updatetype]
      ,[rawUpsize_Contech].[dbo].[changelog].[trx_id]
      ,[rawUpsize_Contech].[dbo].[changelog].[netmachine]
      --,[rawUpsize_Contech].[dbo].[changelog].[username]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid]	-- FK = [users].[username] --> [users].[userid]
      ,[rawUpsize_Contech].[dbo].[changelog].[updatetime]
      ,[rawUpsize_Contech].[dbo].[changelog].[tablename]
      ,[rawUpsize_Contech].[dbo].[changelog].[recordid]
      ,[rawUpsize_Contech].[dbo].[changelog].[fieldname]
      ,[rawUpsize_Contech].[dbo].[changelog].[oldvalue]
      ,[rawUpsize_Contech].[dbo].[changelog].[newvalue]
      ,[rawUpsize_Contech].[dbo].[changelog].[curprogram]
  FROM [rawUpsize_Contech].[dbo].[changelog]
  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[changelog].[username] = [Contech_Test].[dbo].[users].[username]	-- FK = [users].[userid]

--SELECT * FROM [Contech_Test].[dbo].[changelog]

-- =========================================================