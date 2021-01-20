
-- =========================================================
-- Section 025: car_empe
-- =========================================================

-- Column changes:
--  - Set car_empeid to be primary key
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [car_empe].[car_no]						-- FK = [corractn].[car_no]
--	- [car_empe].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'car_empe'))
    DROP TABLE [car_empe]

CREATE TABLE [car_empe](
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
GO

SET IDENTITY_INSERT [car_empe] ON;

INSERT INTO [car_empe] ([car_empeid],[corractnid],[employeeid])
SELECT [rawUpsize_Contech].[dbo].[car_empe].[car_empeid]
      --,[rawUpsize_Contech].[dbo].[car_empe].[car_no]
	  ,ISNULL(corractn.[corractnid] , 0) as [corractnid]	
      --,[rawUpsize_Contech].[dbo].[car_empe].[empnumber]
	  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	
  FROM [rawUpsize_Contech].[dbo].[car_empe]
  LEFT JOIN [corractn] corractn ON [rawUpsize_Contech].[dbo].[car_empe].[car_no] = corractn.[car_no]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
  LEFT JOIN [employee] employee ON [rawUpsize_Contech].[dbo].[car_empe].[empnumber] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
    
SET IDENTITY_INSERT [car_empe] OFF;

--SELECT * FROM [car_empe]

-- =========================================================
-- Section 025: cartrack
-- =========================================================

-- Column changes:
--  - Set [cartrackid] to be primary key
--  - Changed [mod_reason] from text to varchar(2000)
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [cartrack].[car_no] --> [car_empeid]		-- FK = [car_empe].[car_no] --> [car_empe].[car_empeid]
--	- [cartrack].[mod_user] --> [mod_userid]	-- FK = [users].[username] --> [users].[userid]

--USE [Contech_Test]

--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cartrack'))
--    DROP TABLE [cartrack]

--CREATE TABLE [cartrack](
--	[cartrackid] [int] IDENTITY(1,1) NOT NULL,
--	--[car_no] [char](8) NOT NULL DEFAULT '',		-- FK = [car_empe].[car_no] 
--	[corractnid] [int] NOT NULL DEFAULT 0,			-- FK = [corractn].[car_no] --> [corractn].[corractnid]
--	[mod_reason] varchar(2000) NOT NULL DEFAULT '',
--	--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username] 
--	[mod_userid] [int]  NOT NULL DEFAULT '',		-- FK = [users].[username] --> [users].[userid]
--	[mod_dt] [datetime] NULL,
--	CONSTRAINT [PK_cartrack] PRIMARY KEY CLUSTERED 
--	(
--		[cartrackid] ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--SET IDENTITY_INSERT [cartrack] ON;

--INSERT INTO [cartrack] ([cartrackid],[corractnid],[mod_reason],[mod_userid],[mod_dt])
--SELECT [rawUpsize_Contech].[dbo].[cartrack].[cartrackid]
--      --,[rawUpsize_Contech].[dbo].[cartrack].[car_no]
--	  ,ISNULL(corractn.[corractnid] , 0) as [corractnid]	
--      ,[rawUpsize_Contech].[dbo].[cartrack].[mod_reason]
--      --,[rawUpsize_Contech].[dbo].[cartrack].[mod_user]
--	  ,ISNULL(users.[userid] , 0) as [userid]	 
--      ,[rawUpsize_Contech].[dbo].[cartrack].[mod_dt]
--  FROM [rawUpsize_Contech].[dbo].[cartrack]
--  LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[cartrack].[mod_user] = users.[username]				-- FK = [users].[username] --> [users].[userid]
--  LEFT JOIN [corractn] corractn ON [rawUpsize_Contech].[dbo].[cartrack].[car_no] = corractn.[car_no]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
--  ORDER BY [rawUpsize_Contech].[dbo].[cartrack].[cartrackid]

--SET IDENTITY_INSERT [cartrack] OFF;

--SELECT * FROM [cartrack]

-- =========================================================
-- Section 025: carcmpls
-- =========================================================

-- Column changes:
--  - Set [carcmplsid] to be primary key
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
--  - Changed [complnt_no] to [complntid] to reference [complnts] table
-- Maps:
--	- [carcmpls].[car_no] --> [car_empeid]		-- FK = [car_empe].[car_no] --> [car_empe].[car_empeid]
--	- [carcmpls].[complnt_no]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]

--USE [Contech_Test]

--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'carcmpls'))
--    DROP TABLE [carcmpls]

--CREATE TABLE [carcmpls](
--	[carcmplsid] [int] IDENTITY(1,1) NOT NULL,
--	--[car_no] [char](8) NOT NULL DEFAULT '',	-- FK = [car_empe].[car_no] 
--	[corractnid] [int] NOT NULL DEFAULT 0,		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
--	--[complnt_no] [int] NOT NULL DEFAULT 0,	-- FK = [complnts].[complnt_no] 
--	[complntid] [int] NOT NULL DEFAULT 0,		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
--	CONSTRAINT [PK_carcmpls] PRIMARY KEY CLUSTERED 
--	(
--		[carcmplsid] ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] 
--GO

--SET IDENTITY_INSERT [carcmpls] ON;

--INSERT INTO [carcmpls] ([carcmplsid],[corractnid],[complntid])
--SELECT [rawUpsize_Contech].[dbo].[carcmpls].[carcmplsid]
--      --,[rawUpsize_Contech].[dbo].[carcmpls].[car_no]
--	  ,ISNULL(corractn.[corractnid] , 0) as [corractnid]	
--      --,[rawUpsize_Contech].[dbo].[carcmpls].[complnt_no]
--	  ,ISNULL(complnts.[complntid], 0) AS [complntid] 
--  FROM [rawUpsize_Contech].[dbo].[carcmpls]
--  LEFT JOIN [corractn] corractn ON [rawUpsize_Contech].[dbo].[carcmpls].[car_no] = corractn.[car_no]			-- FK = [corractn].[car_no] --> [corractn].[corractnid]
--  LEFT JOIN [complnts] complnts ON [rawUpsize_Contech].[dbo].[carcmpls].[complnt_no] = complnts.[complnt_no]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]

--SET IDENTITY_INSERT [carcmpls] OFF;

--SELECT * FROM [carcmpls]

-- =========================================================
-- Section 025: cashtype
-- =========================================================

-- Column changes:
--  - Added [cashtypeid] to be primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cashtype'))
    DROP TABLE [cashtype]

CREATE TABLE [cashtype](
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

INSERT INTO [cashtype] ([code],[desc],[diff_sign])
SELECT [code]
      ,[desc]
      ,[diff_sign]
  FROM [rawUpsize_Contech].[dbo].[cashtype]
  
--SELECT * FROM [cashtype]

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

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'changelog'))
    DROP TABLE [changelog]

CREATE TABLE [changelog](
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

INSERT INTO [changelog] ([updatetype],[trx_id],[netmachine],[userid],[updatetime],[tablename],[recordid],[fieldname],[oldvalue],[newvalue],[curprogram])
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
  LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[changelog].[username] = users.[username]	-- FK = [users].[userid]

--SELECT * FROM [changelog]

-- =========================================================