-- =========================================================
-- Section 034: inspectionplanhdr
-- =========================================================

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'inspectionplanhdr'))
    DROP TABLE [inspectionplanhdr]

CREATE TABLE [inspectionplanhdr](
	[inspectionplanhdrid] [int] IDENTITY(1,1) NOT NULL,
	[inc] [char](8) NOT NULL DEFAULT '',		
	[plan] [char](2) NOT NULL DEFAULT '',		
	CONSTRAINT [PK_inspectionplanhdr] PRIMARY KEY CLUSTERED 
	(
		[inspectionplanhdrid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [inspectionplanhdr] ([inc],[plan])  
  SELECT DISTINCT * FROM
  (
  SELECT [inc], [plan] FROM [rawUpsize_Contech].[dbo].[inspstps]
  UNION
  SELECT [inc], [plan] FROM [rawUpsize_Contech].[dbo].[instpcmp]  
  )z
  ORDER BY [inc], [plan]
  
--SELECT * FROM [inspectionplanhdr]

-- =========================================================
-- Section 034: inspstps
-- =========================================================

-- Column changes:
--  - Set [inspstpsid] to be primary key
--  - Added [inspectionplanhdrid] [int] to reference [inspectionplanhdr] table via columns [inc] + [plan]
--  - Removed columns [inc] + [plan]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [inspstps].[inspectionplanhdrid]		-- FK = [inspectionplanhdr].[inspectionplanhdrid] = [inspectionplanhdr].[inc] + [inspectionplanhdr].[plan]
--	- [inspstps].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [inspstps].[rev_emp] --> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'inspstps'))
    DROP TABLE [inspstps]

CREATE TABLE [dbo].[inspstps](
	[inspstpsid] [int] IDENTITY(1,1) NOT NULL,
	--[inc] [char](8) NOT NULL DEFAULT '',			-- FK = [inspectionplanhdr].[inc]
	--[plan] [char](2) NOT NULL DEFAULT '',			-- FK = [inspectionplanhdr].[plan] 
	[inspectionplanhdrid] [int] NOT NULL DEFAULT 0, -- FK = [inspectionplanhdr].[inspectionplanhdrid] = [inspectionplanhdr].[inc] + [inspectionplanhdr].[plan]
	[clsficat] [int] NOT NULL DEFAULT 0,
	[step] [numeric](2, 0) NOT NULL DEFAULT 0,
	[descript] [char](70) NOT NULL DEFAULT '',
	--[comp] [char](5) NOT NULL DEFAULT '',			-- Empty -- FK = [componet].[comp] 
	[componetid] [int] NOT NULL,					-- FK = [componet].[comp] --> [componet].[componetid]
	[rev_rec] [int] NOT NULL DEFAULT 0,
	[rev_dt] [datetime] NULL,
	--[rev_emp] [char](10) NOT NULL DEFAULT '',		-- FK = [employee].[empnumber] 
	[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] --> [employee].[employeeid]
	CONSTRAINT [PK_inspstps] PRIMARY KEY CLUSTERED 
	(
		[inspstpsid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [inspstps] ON;

INSERT INTO [inspstps] ([inspstpsid],[inspectionplanhdrid],[clsficat],[step],[descript],[componetid],[rev_rec],[rev_dt],[employeeid])
SELECT [rawUpsize_Contech].[dbo].[inspstps].[inspstpsid]
      --,[rawUpsize_Contech].[dbo].[inspstps].[inc]			-- FK = [inspectionplanhdr].[inc] 
      --,[rawUpsize_Contech].[dbo].[inspstps].[plan]		-- FK = [inspectionplanhdr].[plan]
	  ,ISNULL(inspectionplanhdr.[inspectionplanhdrid], 0) AS [inspectionplanhdrid]		-- FK = [inspectionplanhdr].[inspectionplanhdrid] = [inspectionplanhdr].[inc] + [inspectionplanhdr].[plan]
      ,[rawUpsize_Contech].[dbo].[inspstps].[clsficat]
      ,[rawUpsize_Contech].[dbo].[inspstps].[step]
      ,[rawUpsize_Contech].[dbo].[inspstps].[descript]
      --,[rawUpsize_Contech].[dbo].[inspstps].[comp]
	  ,ISNULL(componet.[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[inspstps].[rev_rec]
      ,[rawUpsize_Contech].[dbo].[inspstps].[rev_dt]
      --,[rawUpsize_Contech].[dbo].[inspstps].[rev_emp]		-- FK = [employee].[empnumber] 
	  ,ISNULL(employee.[employeeid], 0) AS [employeeid]		-- FK = [employee].[empnumber] -> [employee].[employeeid]
  FROM [rawUpsize_Contech].[dbo].[inspstps]
  LEFT JOIN [inspectionplanhdr] inspectionplanhdr 
	ON [rawUpsize_Contech].[dbo].[inspstps].[inc] = inspectionplanhdr.[inc] 
		AND [rawUpsize_Contech].[dbo].[inspstps].[plan] = inspectionplanhdr.[plan]
  LEFT JOIN [componet] componet ON [rawUpsize_Contech].[dbo].[inspstps].[comp] = componet.[comp] 
  LEFT JOIN [employee] employee ON [rawUpsize_Contech].[dbo].[inspstps].[rev_emp] = employee.[empnumber]	
  
SET IDENTITY_INSERT [inspstps] OFF;

--SELECT * FROM [inspstps]

-- =========================================================
-- Section 034: instpcmp
-- =========================================================

-- Column changes:
--  - Set [instpcmpid] to be primary key
--  - Added [inspectionplanhdrid] [int] to reference [inspectionplanhdr] table via columns [inc] + [plan]
--  - Removed columns [inc] + [plan]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [instpcmp].[inspectionplanhdrid]		-- FK = [inspectionplanhdr].[inspectionplanhdrid] = [inspectionplanhdr].[inc] + [inspectionplanhdr].[plan]
--	- [instpcmp].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'instpcmp'))
    DROP TABLE [instpcmp]

CREATE TABLE [dbo].[instpcmp](
	[instpcmpid] [int] IDENTITY(1,1) NOT NULL,
	--[inc] [char](8) NOT NULL DEFAULT '',			-- FK = [inspectionplanhdr].[inc] 
	--[plan] [char](2) NOT NULL DEFAULT '',			-- FK = [inspectionplanhdr].[plan]
	[inspectionplanhdrid] [int] NOT NULL DEFAULT 0, -- FK = [inspectionplanhdr].[inspectionplanhdrid] = [inspectionplanhdr].[inc] + [inspectionplanhdr].[plan]
	--[comp] [char](5) NOT NULL DEFAULT '',			-- FK = [componet].[comp]
	[componetid] [int] NOT NULL,					-- FK = [componet].[comp] --> [componet].[componetid]
	CONSTRAINT [PK_instpcmp] PRIMARY KEY CLUSTERED 
	(
		[instpcmpid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [instpcmp] ON;

INSERT INTO [instpcmp] ([instpcmpid],[inspectionplanhdrid],[componetid])
SELECT [rawUpsize_Contech].[dbo].[instpcmp].[instpcmpid]		
      --,[rawUpsize_Contech].[dbo].[instpcmp].[inc]
      --,[rawUpsize_Contech].[dbo].[instpcmp].[plan]
	  ,ISNULL(inspectionplanhdr.[inspectionplanhdrid], 0) AS [inspectionplanhdrid]		
      --,[rawUpsize_Contech].[dbo].[instpcmp].[comp]
	  ,ISNULL(componet.[componetid], 0) AS [componetid] 
  FROM [rawUpsize_Contech].[dbo].[instpcmp]  
  LEFT JOIN [inspectionplanhdr] inspectionplanhdr							-- FK = [inspectionplanhdr].[inspectionplanhdrid] = [inspectionplanhdr].[inc] + [inspectionplanhdr].[plan]
	ON [rawUpsize_Contech].[dbo].[instpcmp].[inc] = inspectionplanhdr.[inc] 
		AND [rawUpsize_Contech].[dbo].[instpcmp].[plan] = inspectionplanhdr.[plan]
  LEFT JOIN [componet] componet ON [rawUpsize_Contech].[dbo].[instpcmp].[comp] = componet.[comp] 
  ORDER BY [rawUpsize_Contech].[dbo].[instpcmp].[instpcmpid]  
  
SET IDENTITY_INSERT [instpcmp] OFF;

--SELECT * FROM [instpcmp]

-- =========================================================
-- Section 034: inv_adj
-- =========================================================

-- Column changes:
--  - Set [inv_adjid] to be primary key
--  - Changed [reason] from [text] to [varchar](2000)
--  - Changed [userid] [char](10) to [userid] [int] to reference [users] table
--  - Added [matlinid] [int] to reference [matlin] table via columns [comp] + [ct_lot]
-- Maps:
--	- [inv_adj].[add_user]		-- FK = [users].[username] --> [users].[userid]
--	- [inv_adj].[matlinid]		-- FK = [matlin].[matlinid] = [matlin].[comp] + [matlin].[ct_lot] 

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'inv_adj'))
    DROP TABLE [inv_adj]

CREATE TABLE [dbo].[inv_adj](
	[inv_adjid] [int] IDENTITY(1,1) NOT NULL,
	--[comp] [char](5) NOT NULL DEFAULT '',			-- FK = [matlin].[comp]
	--[ct_lot] [char](4) NOT NULL DEFAULT '',		-- FK = [matlin].[ct_lot]
	[matlinid] [int] NOT NULL DEFAULT 0,			-- FK = [matlin].[matlinid] = [matlin].[comp] + [matlin].[ct_lot] 
	[adjustment] [int] NOT NULL DEFAULT 0,
	[reason] [varchar](2000) NOT NULL DEFAULT '',
	--[userid] [char](10) NOT NULL DEFAULT '',		-- FK = [users].[username]
	[userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	[add_dt] [datetime] NULL,
	CONSTRAINT [PK_inv_adj] PRIMARY KEY CLUSTERED 
	(
		[inv_adjid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [inv_adj] ON;

--Note: In case of duplicates, picked one 

INSERT INTO [inv_adj] ([inv_adjid],[matlinid],[adjustment],[reason],[userid],[add_dt])
SELECT inv_adj.[inv_adjid]
      --,inv_adj.[comp]
      --,inv_adj.[ct_lot]
	  ,ISNULL(matlin.[matlinid] , 0) as [matlinid]			
      ,inv_adj.[adjustment]
      ,inv_adj.[reason]
      --,[rawUpsize_Contech].[dbo].[inv_adj].[userid]
	  ,ISNULL(users.[userid] , 0) as [userid]			
      ,inv_adj.[add_dt]	
	FROM 
		(
			SELECT MAX([rawUpsize_Contech].[dbo].[inv_adj].[inv_adjid]) AS [inv_adjid] 
			  ,MAX([rawUpsize_Contech].[dbo].[inv_adj].[comp]) AS [comp] 
			  ,MAX([rawUpsize_Contech].[dbo].[inv_adj].[ct_lot]) AS [ct_lot] 
			  ,MAX(ISNULL(matlin.[matlinid] , 0)) AS [matlinid]			
			FROM [rawUpsize_Contech].[dbo].[inv_adj]
			LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[inv_adj].[userid] = users.[username]	-- FK = [users].[userid]
			LEFT JOIN [matlin] matlin ON [rawUpsize_Contech].[dbo].[inv_adj].[comp] = matlin.[comp] AND [rawUpsize_Contech].[dbo].[inv_adj].[ct_lot] = matlin.[ct_lot] -- FK = [matlin].[matlinid] = [matlin].[comp] + [matlin].[ct_lot] 
			GROUP BY 
				[rawUpsize_Contech].[dbo].[inv_adj].[inv_adjid]
				,[rawUpsize_Contech].[dbo].[inv_adj].[comp]
				,[rawUpsize_Contech].[dbo].[inv_adj].[ct_lot]
		  ) AS latest_inv_adj

	INNER JOIN [rawUpsize_Contech].[dbo].[inv_adj] inv_adj
		ON inv_adj.[inv_adjid] = latest_inv_adj.[inv_adjid] 
			AND inv_adj.[comp] = latest_inv_adj.[comp]
			AND inv_adj.[ct_lot] = latest_inv_adj.[ct_lot]
	LEFT JOIN [users] users ON inv_adj.[userid] = users.[username]	-- FK = [users].[userid]
	LEFT JOIN [matlin] matlin ON latest_inv_adj.[matlinid] = matlin.[matlinid]
	ORDER BY inv_adj.[inv_adjid]

SET IDENTITY_INSERT [inv_adj] OFF;

--SELECT * FROM [inv_adj]

-- =========================================================
-- Section 034: inv_sess
-- =========================================================

-- Column changes:
--  - Set [inv_sessid] to be primary key
--  - Changed [inv_sessid] [char](9) to [inv_sessid] [int]
-- Maps:
--	- [bom_hist].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'inv_sess'))
    DROP TABLE [inv_sess]

CREATE TABLE [dbo].[inv_sess](
	--[inv_sessid] [char](9) NOT NULL,
	[inv_sessid] [int] IDENTITY(1,1) NOT NULL,
	[inv_year] [char](4) NOT NULL DEFAULT '',
	[inv_month] [char](15) NOT NULL DEFAULT '',
	[created] [datetime] NULL,
	[comp] [bit] NOT NULL DEFAULT 0,
	[fp] [bit] NOT NULL DEFAULT 0,
	[mfg_locid] [int] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_inv_sess] PRIMARY KEY CLUSTERED 
	(
		[inv_sessid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [inv_sess] ON;

INSERT INTO [inv_sess] ([inv_sessid],[inv_year],[inv_month],[created],[comp],[fp],[mfg_locid])
SELECT [rawUpsize_Contech].[dbo].[inv_sess].[inv_sessid]
      ,[rawUpsize_Contech].[dbo].[inv_sess].[inv_year]
      ,[rawUpsize_Contech].[dbo].[inv_sess].[inv_month]
      ,[rawUpsize_Contech].[dbo].[inv_sess].[created]
      ,[rawUpsize_Contech].[dbo].[inv_sess].[comp]
      ,[rawUpsize_Contech].[dbo].[inv_sess].[fp]
      ,[rawUpsize_Contech].[dbo].[inv_sess].[mfg_locid]
  FROM [rawUpsize_Contech].[dbo].[inv_sess]
  
SET IDENTITY_INSERT [inv_sess] OFF;

--SELECT * FROM [inv_sess]

-- =========================================================