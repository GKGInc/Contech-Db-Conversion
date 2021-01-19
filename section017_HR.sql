
-- =========================================================
-- Section 017: prdlinhd
-- =========================================================

-- Column changes:
--  - Set [prdlinhdid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [user_id] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [prdlinhd].[cust_no] -->[customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [prdlinhd].[user_id] -->[userid]		-- FK = [users].[username] --> [users].[userid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlinhd'))
    DROP TABLE [dbo].[prdlinhd]

CREATE TABLE [dbo].[prdlinhd](
	[prdlinhdid] [int] IDENTITY(1,1) NOT NULL,
	[descript] [char](60) NOT NULL DEFAULT '',
	--[cust_no] [char](5) NOT NULL DEFAULT 0,	-- FK = [customer].[cust_no] 
	[customerid] [int] NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] --> [customer].[customerid]
	--[user_id] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
	[userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
	[add_dt] [datetime] NULL,
	CONSTRAINT [PK_prdlinhd] PRIMARY KEY CLUSTERED 
	(
		[prdlinhdid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlinhd] ON;

INSERT INTO [Contech_Test].[dbo].[prdlinhd] ([prdlinhdid],[descript],[customerid],[userid],[add_dt])
SELECT [rawUpsize_Contech].[dbo].[prdlinhd].[prdlinhdid]
      ,[rawUpsize_Contech].[dbo].[prdlinhd].[descript]
      --,[rawUpsize_Contech].[dbo].[prdlinhd].[cust_no]
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) as [customerid]
      --,[rawUpsize_Contech].[dbo].[prdlinhd].[user_id]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid] 
      ,[rawUpsize_Contech].[dbo].[prdlinhd].[add_dt]
  FROM [rawUpsize_Contech].[dbo].[prdlinhd]
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[prdlinhd].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no] 
  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[prdlinhd].[user_id] = [Contech_Test].[dbo].[users].[username] 
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlinhd] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prdlinhd]

-- =========================================================
-- Section 017: prdlindt
-- =========================================================

-- Column changes:
--  - Changed [prdlindtid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [prdlindt].[prdlinhdid]				-- FK = [prdlinhd].[prdlinhdid] 
--	- [prdlindt].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlindt'))
    DROP TABLE [dbo].[prdlindt]

CREATE TABLE [dbo].[prdlindt](
	[prdlindtid] [int] IDENTITY(1,1) NOT NULL,
	[prdlinhdid] [int] NOT NULL DEFAULT 0,		-- FK = [prdlinhd].[prdlinhdid] 
	--[comp] [char](5)  NOT NULL DEFAULT '',	-- FK = [componet].[comp] 
	[componetid] [int] NOT NULL,				-- FK = [componet].[comp] --> [componet].[componetid]
	[type] [char](3) NOT NULL DEFAULT '',
	[sort_order] [int] NOT NULL DEFAULT 0,
	[mod_dt] [datetime] NULL,
	[user_id] [char](10) NOT NULL DEFAULT '',
	[as_of_dt] [datetime] NULL,
	CONSTRAINT [PK_prdlindt] PRIMARY KEY CLUSTERED 
	(
		[prdlindtid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlindt] ON;

INSERT INTO [Contech_Test].[dbo].[prdlindt] ([prdlindtid],[prdlinhdid],[componetid],[type],[sort_order],[mod_dt],[user_id],[as_of_dt])
SELECT [rawUpsize_Contech].[dbo].[prdlindt].[prdlindtid]
      ,[rawUpsize_Contech].[dbo].[prdlindt].[prdlinhdid]
      --,[rawUpsize_Contech].[dbo].[prdlindt].[comp]
	  ,ISNULL([Contech_Test].[dbo].[componet].[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[prdlindt].[type]
      ,[rawUpsize_Contech].[dbo].[prdlindt].[sort_order]
      ,[rawUpsize_Contech].[dbo].[prdlindt].[mod_dt]
      ,[rawUpsize_Contech].[dbo].[prdlindt].[user_id]
      ,[rawUpsize_Contech].[dbo].[prdlindt].[as_of_dt]
  FROM [rawUpsize_Contech].[dbo].[prdlindt]
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[prdlindt].[comp] = [Contech_Test].[dbo].[componet].[comp] -- FK = [componet].[comp] --> [componet].[componetid]
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlindt] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prdlindt]

-- =========================================================
-- Section 017: material
-- =========================================================

-- Column changes:
--  - Added [materialid] to be primary key
--  - Changed [description] from [text] to [varchar](2000)

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'material'))
    DROP TABLE [dbo].[material]

CREATE TABLE [dbo].[material](
	[materialid] [int] IDENTITY(1,1) NOT NULL,
	[material] [char](3) NOT NULL DEFAULT '',
	[description] [varchar](2000) NOT NULL DEFAULT '',
	[type] [char](20) NOT NULL DEFAULT '',
	CONSTRAINT [PK_material] PRIMARY KEY CLUSTERED 
	(
		[materialid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [Contech_Test].[dbo].[material] SELECT * FROM [rawUpsize_Contech].[dbo].[material]
  
--SELECT * FROM [Contech_Test].[dbo].[material]

-- =========================================================