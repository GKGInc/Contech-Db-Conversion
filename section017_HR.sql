
-- =========================================================
--Section 017: prdlinhd
-- =========================================================

-- Column changes:
--  - Changed prdlinhdid to be primary key
--  - Changed cust_no to int to reference customer table
--  - Changed user_id to int to reference users table
-- Maps:
--	- [prdlinhd].[cust_no]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [prdlinhd].[user_id]	-- FK = [users].[userid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlinhd'))
    DROP TABLE [dbo].[prdlinhd]

CREATE TABLE [dbo].[prdlinhd](
	[prdlinhdid] [int] identity(1,1) NOT NULL,
	[descript] [char](60) NOT NULL,
	[cust_no] [int] NOT NULL,		-- FK = [customer].[cust_no] -> [customer].[customerid]
	[user_id] [int] NOT NULL,		-- FK = [users].[userid]
	[add_dt] [datetime] NULL,
	CONSTRAINT [PK_prdlinhd] PRIMARY KEY CLUSTERED 
	(
		[prdlinhdid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlinhd] ON;

INSERT INTO [Contech_Test].[dbo].[prdlinhd] ([prdlinhdid],[descript],[cust_no],[user_id],[add_dt])
SELECT [rawUpsize_Contech].[dbo].[prdlinhd].[prdlinhdid]
      ,[rawUpsize_Contech].[dbo].[prdlinhd].[descript]
      --,[rawUpsize_Contech].[dbo].[prdlinhd].[cust_no]
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) as [customerid]
      --,[rawUpsize_Contech].[dbo].[prdlinhd].[user_id]
	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid] -- Note: User BOBBY not found in users table
      ,[rawUpsize_Contech].[dbo].[prdlinhd].[add_dt]
  FROM [rawUpsize_Contech].[dbo].[prdlinhd]
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[prdlinhd].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no] 
  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[prdlinhd].[user_id] = [Contech_Test].[dbo].[users].[username] 
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlinhd] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prdlinhd]

-- =========================================================
--Section 017: prdlindt
-- =========================================================

-- Column changes:
--  - Changed prdlindtid to be primary key
--  - Changed [comp] to int to reference componet table
-- Maps:
--	- [prdlindt].[prdlinhdid]	-- FK = [prdlinhd].[prdlinhdid] 
--	- [prdlindt].[comp]			-- FK = [componet].[comp] --> [componet].[componetid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlindt'))
    DROP TABLE [dbo].[prdlindt]

CREATE TABLE [dbo].[prdlindt](
	[prdlindtid] [int] identity(1,1) NOT NULL,
	[prdlinhdid] [int] NOT NULL,		-- FK = [prdlinhd].[prdlinhdid] 
	[comp] [int] NOT NULL,			-- FK = [componet].[comp] --> [componet].[componetid] 
	[type] [char](3) NOT NULL,
	[sort_order] [int] NOT NULL,
	[mod_dt] [datetime] NULL,
	[user_id] [char](10) NOT NULL,
	[as_of_dt] [datetime] NULL,
	CONSTRAINT [PK_prdlindt] PRIMARY KEY CLUSTERED 
	(
		[prdlindtid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlindt] ON;

INSERT INTO [Contech_Test].[dbo].[prdlindt] ([prdlindtid],[prdlinhdid],[comp],[type],[sort_order],[mod_dt],[user_id],[as_of_dt])
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
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[prdlindt].[comp] = [Contech_Test].[dbo].[componet].[comp] 
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlindt] OFF;

--SELECT * FROM [Contech_Test].[dbo].[prdlindt]

-- =========================================================
--Section 017: material
-- =========================================================

-- Column changes:
--  - Added materialid to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'material'))
    DROP TABLE [dbo].[material]

CREATE TABLE [dbo].[material](
	[materialid] [int] identity(1,1) NOT NULL,
	[material] [char](3) NOT NULL,
	[description] [text] NOT NULL,
	[type] [char](20) NOT NULL,
	CONSTRAINT [PK_material] PRIMARY KEY CLUSTERED 
	(
		[materialid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[material] SELECT * FROM [rawUpsize_Contech].[dbo].[material]
  
--SELECT * FROM [Contech_Test].[dbo].[material]

-- =========================================================