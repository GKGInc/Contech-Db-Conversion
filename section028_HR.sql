-- =========================================================
-- Section 028: comptype
-- =========================================================

-- Column changes:
--  - Added [comptypeid] to be primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'comptype'))
    DROP TABLE [comptype]

CREATE TABLE [dbo].[comptype](
	[comptypeid] [int] IDENTITY(1,1) NOT NULL,
	[comptype] [char](3) NOT NULL DEFAULT '',
	[descript] [char](50) NOT NULL DEFAULT '',
	CONSTRAINT [PK_comptype] PRIMARY KEY CLUSTERED 
	(
		[comptypeid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [comptype] ([comptype],[descript])
SELECT [comptype]
      ,[descript]
  FROM [rawUpsize_Contech].[dbo].[comptype]
  
--SELECT * FROM [comptype]

-- =========================================================
-- Section 028: compwhlocs
-- =========================================================

-- Column changes:
--	- Renamed [pk] to [compwhlocsid]
--  - Set [compwhlocsid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [compwhlocs].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'compwhlocs'))
    DROP TABLE [compwhlocs]

CREATE TABLE [dbo].[compwhlocs](
	--[pk] [int] NOT NULL,
	[compwhlocsid] [int] IDENTITY(1,1) NOT NULL,
	--[comp] [char](5) NOT NULL DEFAULT '',
	[componetid] [int] NOT NULL,		-- FK = [componet].[comp] --> [componet].[componetid]
	[wh_loc] [char](8) NOT NULL DEFAULT '',
	CONSTRAINT [PK_compwhlocs] PRIMARY KEY CLUSTERED 
	(
		[compwhlocsid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [compwhlocs] ON;

INSERT INTO [compwhlocs] ([compwhlocsid],[componetid],[wh_loc])
SELECT [rawUpsize_Contech].[dbo].[compwhlocs].[pk]
      --,[rawUpsize_Contech].[dbo].[compwhlocs].[comp]
	  ,ISNULL(componet.[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[compwhlocs].[wh_loc]
  FROM [rawUpsize_Contech].[dbo].[compwhlocs]
  LEFT JOIN [componet] componet ON [rawUpsize_Contech].[dbo].[compwhlocs].[comp] = componet.[comp] 
  
SET IDENTITY_INSERT [compwhlocs] OFF;

--SELECT * FROM [compwhlocs]

-- =========================================================
-- Section 028: consnpay
-- =========================================================

-- Column changes:
--  - Set [consnpayid] to be primary key
--  - Renamed [matlin_key] to [matlinid]
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
-- Maps:
--	- [consnpay].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'consnpay'))
    DROP TABLE [consnpay]

CREATE TABLE [dbo].[consnpay](
	[consnpayid] [int] IDENTITY(1,1) NOT NULL,
	--[matlin_key] [int] NOT NULL DEFAULT 0,
	[matlinid] [int] NOT NULL DEFAULT 0,
	[add_dt] [datetime] NULL,
	--[add_user] [char](10) NOT NULL DEFAULT '',
	[add_userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	CONSTRAINT [PK_consnpay] PRIMARY KEY CLUSTERED 
	(
		[consnpayid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [consnpay] ON;

INSERT INTO [consnpay] ([consnpayid],[matlinid],[add_dt],[add_userid])
SELECT [rawUpsize_Contech].[dbo].[consnpay].[consnpayid]
      ,[rawUpsize_Contech].[dbo].[consnpay].[matlin_key]
      ,[rawUpsize_Contech].[dbo].[consnpay].[add_dt]
      --,[rawUpsize_Contech].[dbo].[consnpay].[add_user]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [add_userid]			
  FROM [rawUpsize_Contech].[dbo].[consnpay]
  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[consnpay].[add_user] = [Contech_Test].[dbo].[users].[username]	-- FK = [users].[userid]
  
SET IDENTITY_INSERT [consnpay] OFF;

--SELECT * FROM [consnpay]

-- =========================================================
-- Section 028: convert
-- =========================================================

-- Column changes:
--  - Added [convertid] to be primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'convert'))
    DROP TABLE [convert]

CREATE TABLE [dbo].[convert](
	[convertid] [int] IDENTITY(1,1) NOT NULL,
	[f_country] [char](20) NOT NULL DEFAULT '',
	[t_country] [char](20) NOT NULL DEFAULT '',
	[units] [char](10) NOT NULL DEFAULT '',
	[rate] [numeric](9, 3) NOT NULL DEFAULT 0.0,
	CONSTRAINT [PK_convert] PRIMARY KEY CLUSTERED 
	(
		[convertid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [convert] ([f_country],[t_country],[units],[rate])
SELECT [f_country]
      ,[t_country]
      ,[units]
      ,[rate]
  FROM [rawUpsize_Contech].[dbo].[convert]
  
--SELECT * FROM [convert]

-- =========================================================
-- Section 028: coractfu
-- =========================================================

-- Column changes:
--  - Set [coractfuid] to be primary key
--  - Changed [fu_notes] from [text] to [varchar](2000)
-- Maps:
--	- [coractfu].[corractnid]	-- -- FK = [corractn].[corractnid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'coractfu'))
    DROP TABLE [coractfu]

CREATE TABLE [dbo].[coractfu](
	[coractfuid] [int] IDENTITY(1,1) NOT NULL,
	[corractnid] [int] NOT NULL DEFAULT 0,		-- FK = [corractn].[corractnid]
	[follow_up] [datetime] NULL,
	[fu_notes] [varchar](2000) NOT NULL DEFAULT '',
	CONSTRAINT [PK_coractfu] PRIMARY KEY CLUSTERED 
	(
		[coractfuid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [coractfu] ON;

INSERT INTO [coractfu] ([coractfuid],[corractnid],[follow_up],[fu_notes])
SELECT [coractfuid]
      ,[corractnid]
      ,[follow_up]
      ,[fu_notes]
  FROM [rawUpsize_Contech].[dbo].[coractfu]
  
SET IDENTITY_INSERT [coractfu] OFF;

--SELECT * FROM [coractfu]

-- =========================================================