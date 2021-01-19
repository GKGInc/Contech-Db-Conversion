
-- =========================================================
-- Section 019: rev_rel
-- =========================================================

-- Column changes:
--  - Set [rev_relid] to be primary key
--  - Renamed [job_no] to [ordersid] to reference [orders] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [rev_rel].[job_no] --> [ordersid]			-- FK = [orders].[job_no] --> [orders].[ordersid]
--	- [rev_rel].[add_user] --> [add_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [rev_rel].[mod_user] --> [mod_userid]		-- FK = [users].[username] --> [users].[userid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'rev_rel'))
    DROP TABLE [dbo].[rev_rel]

CREATE TABLE [dbo].[rev_rel](
	[rev_relid] [int] IDENTITY(1,1) NOT NULL,
	--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] 
	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
	[rel_qty] [int] NOT NULL DEFAULT 0,		
	[jobstatus] [char](1) NOT NULL DEFAULT '',
	[postatus] [char](1) NOT NULL DEFAULT '',
	[price] [numeric](9, 4) NOT NULL DEFAULT 0.0,
	[add_dt] [datetime] NULL,
	--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
	[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
	[mod_dt] [datetime] NULL,
	--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
	[mod_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
	[ship_dt] [datetime] NULL,
	[lading] [bit] NOT NULL DEFAULT 0,
	[nolading] [bit] NOT NULL DEFAULT 0,
	[freight] [numeric](6, 2) NOT NULL DEFAULT 0.0,
	[sched_ship] [datetime] NULL,
	CONSTRAINT [PK_rev_rel] PRIMARY KEY CLUSTERED 
	(
		[rev_relid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[rev_rel] ON;

INSERT INTO [Contech_Test].[dbo].[rev_rel] ([rev_relid],[ordersid],[rel_qty],[jobstatus],[postatus],[price],[add_dt],[add_userid],[mod_dt],[mod_userid],[ship_dt],[lading],[nolading],[freight],[sched_ship])
SELECT [rawUpsize_Contech].[dbo].[rev_rel].[rev_relid]
      --,[rawUpsize_Contech].[dbo].[rev_rel].[job_no]
	  ,ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid] -- FK = [orders].[job_no] --> [orders].[ordersid]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[rel_qty]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[jobstatus]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[postatus]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[price]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[add_dt]
      --,[rawUpsize_Contech].[dbo].[rev_rel].[add_user] 
	  ,ISNULL(addUser.[userid] , 0) as [userid]			
      ,[rawUpsize_Contech].[dbo].[rev_rel].[mod_dt]
      --,[rawUpsize_Contech].[dbo].[rev_rel].[mod_user] 
	  ,ISNULL(modUser.[userid] , 0) as [userid]			
      ,[rawUpsize_Contech].[dbo].[rev_rel].[ship_dt]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[lading]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[nolading]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[freight]
      ,[rawUpsize_Contech].[dbo].[rev_rel].[sched_ship]
  FROM [rawUpsize_Contech].[dbo].[rev_rel]
  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[rev_rel].[job_no] = [Contech_Test].[dbo].[orders].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
  LEFT JOIN [Contech_Test].[dbo].[users] addUser ON [rawUpsize_Contech].[dbo].[rev_rel].[add_user] = addUser.[username]					-- FK = [users].[username] --> [users].[userid]
  LEFT JOIN [Contech_Test].[dbo].[users] modUser ON [rawUpsize_Contech].[dbo].[rev_rel].[mod_user] = modUser.[username]					-- FK = [users].[username] --> [users].[userid]
    
SET IDENTITY_INSERT [Contech_Test].[dbo].[prdlindt] OFF;

--SELECT * FROM [Contech_Test].[dbo].[rev_rel]

-- =========================================================