
-- =========================================================
-- Section 027: colorant
-- =========================================================

-- *** Note: FK [document] uses [docs_dtl][.document] which is in section 030

-- Column changes:
--  - Set [colorantid] to be primary key
--  - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table
-- Maps:
--	- [colorant].[document] --> [docs_dtlid]	-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'colorant'))
    DROP TABLE [dbo].[colorant]

CREATE TABLE [dbo].[colorant](
	[colorantid] [int] IDENTITY(1,1) NOT NULL,
	[colorantno] [char](20) NOT NULL DEFAULT '',
	[color_desc] [char](50) NOT NULL DEFAULT '',
	--[document] [char](15) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document] 
	[docs_dtlid] [int] NOT NULL DEFAULT 0,			-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]
	CONSTRAINT [PK_colorant] PRIMARY KEY CLUSTERED 
	(
		[colorantid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[colorant] ON;

INSERT INTO [Contech_Test].[dbo].[colorant] ([colorantid],[colorantno],[color_desc],[docs_dtlid])
SELECT [rawUpsize_Contech].[dbo].[colorant].[colorantid]
      ,[rawUpsize_Contech].[dbo].[colorant].[colorantno]
      ,[rawUpsize_Contech].[dbo].[colorant].[color_desc]
      --,[rawUpsize_Contech].[dbo].[colorant].[document]
	  --,ISNULL([Contech_Test].[dbo].[docs_dtl].[docs_dtlid], 0) AS [docs_dtlid] 
	  ,ISNULL([rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid], 0) AS [docs_dtlid] 
  FROM [rawUpsize_Contech].[dbo].[colorant]
  --LEFT JOIN [Contech_Test].[dbo].[docs_dtl] ON [rawUpsize_Contech].[dbo].[colorant].[document] = [Contech_Test].[dbo].[docs_dtl].[document]
  LEFT JOIN [rawUpsize_Contech].[dbo].[docs_dtl] ON [rawUpsize_Contech].[dbo].[colorant].[document] = [rawUpsize_Contech].[dbo].[docs_dtl].[document]
  ORDER BY [rawUpsize_Contech].[dbo].[colorant].[colorantid]
    
SET IDENTITY_INSERT [Contech_Test].[dbo].[colorant] OFF;

--SELECT * FROM [Contech_Test].[dbo].[colorant]

-- =========================================================
-- Section 027: comp_inv
-- =========================================================

-- Column changes:
--  - Added [comp_invid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [users] table
-- Maps:
--	- [compdocs].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'comp_inv'))
    DROP TABLE [dbo].[comp_inv]

CREATE TABLE [dbo].[comp_inv](
	[comp_invid] [int] IDENTITY(1,1) NOT NULL,
	--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp] 
	[componetid] [int] NOT NULL DEFAULT 0,		-- FK = [componet].[comp] --> [componet].[componetid]
	[on_hand] [int] NOT NULL DEFAULT 0,
	[phys_inv] [int] NOT NULL DEFAULT 0,
	[inv_card] [int] NOT NULL DEFAULT 0,
	[quar] [int] NOT NULL DEFAULT 0,
	[hold] [int] NOT NULL DEFAULT 0,
	[reject] [int] NOT NULL DEFAULT 0,
	[wip] [int] NOT NULL DEFAULT 0,
	[just_phys] [int] NOT NULL DEFAULT 0,
	[e_card] [int] NOT NULL DEFAULT 0,
	[cost] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[price_ire] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[phys_inv_c] [numeric](11, 2) NOT NULL DEFAULT 0.0,
	[quar_c] [numeric](11, 2) NOT NULL DEFAULT 0.0,
	[hold_c] [numeric](11, 2) NOT NULL DEFAULT 0.0,
	[reject_c] [numeric](11, 2) NOT NULL DEFAULT 0.0,
	[on_hand_c] [numeric](11, 2) NOT NULL DEFAULT 0.0,
	[ctpo] [bit] NOT NULL DEFAULT 0,
	[cust] [bit] NOT NULL DEFAULT 0,
	[physcust] [int] NOT NULL DEFAULT 0,
	[physcust_c] [numeric](11, 2) NOT NULL DEFAULT 0.0,
	[wipcust] [int] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_comp_inv] PRIMARY KEY CLUSTERED 
	(
		[comp_invid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [Contech_Test].[dbo].[comp_inv] ([componetid],[on_hand],[phys_inv],[inv_card],[quar],[hold],[reject],[wip],[just_phys],[e_card],[cost],[price_ire],[phys_inv_c],[quar_c],[hold_c],[reject_c],[on_hand_c],[ctpo],[cust],[physcust],[physcust_c],[wipcust])
SELECT --[rawUpsize_Contech].[dbo].[comp_inv].[comp]
	  ISNULL([Contech_Test].[dbo].[componet].[componetid], 0) AS [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[on_hand]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[phys_inv]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[inv_card]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[quar]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[hold]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[reject]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[wip]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[just_phys]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[e_card]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[cost]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[price_ire]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[phys_inv_c]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[quar_c]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[hold_c]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[reject_c]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[on_hand_c]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[ctpo]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[cust]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[physcust]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[physcust_c]
      ,[rawUpsize_Contech].[dbo].[comp_inv].[wipcust]
  FROM [rawUpsize_Contech].[dbo].[comp_inv]
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[comp_inv].[comp] = [Contech_Test].[dbo].[componet].[comp] 
  
--SELECT * FROM [Contech_Test].[dbo].[comp_inv]

-- =========================================================
-- Section 027: compdocs
-- =========================================================

-- Column changes:
--  - Set [compdocsid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference users table
-- Maps:
--	- [compdocs].[comp]			-- FK = [componet].[comp] --> [componet].[componetid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'compdocs'))
    DROP TABLE [dbo].[compdocs]

CREATE TABLE [dbo].[compdocs](
	[compdocsid] [int] IDENTITY(1,1) NOT NULL,
	[document] [char](15) NOT NULL DEFAULT '',
	--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp] 
	[componetid] [int] NOT NULL DEFAULT 0,		-- FK = [componet].[comp] --> [componet].[componetid]
	[po_print] [char](1) NOT NULL DEFAULT '',
	CONSTRAINT [PK_compdocs] PRIMARY KEY CLUSTERED 
	(
		[compdocsid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[compdocs] ON;

INSERT INTO [Contech_Test].[dbo].[compdocs] ([compdocsid],[document],[componetid],[po_print])
SELECT [rawUpsize_Contech].[dbo].[compdocs].[compdocsid]
      ,[rawUpsize_Contech].[dbo].[compdocs].[document]
      --,[rawUpsize_Contech].[dbo].[compdocs].[comp]
	  ,ISNULL([Contech_Test].[dbo].[componet].[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[compdocs].[po_print]
  FROM [rawUpsize_Contech].[dbo].[compdocs]
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[compdocs].[comp] = [Contech_Test].[dbo].[componet].[comp] 
  ORDER BY [rawUpsize_Contech].[dbo].[compdocs].[compdocsid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[compdocs] OFF;

--SELECT * FROM [Contech_Test].[dbo].[compdocs]

-- =========================================================
-- Section 027: complocs
-- =========================================================

-- Column changes:
--  - Set [complocsid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference users table
-- Maps:
--	- [complocs].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [complocs].[mfg_locid]				-- FK = [mfg_loc].[mfg_locid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'complocs'))
    DROP TABLE [dbo].[complocs]

CREATE TABLE [dbo].[complocs](
	[complocsid] [int] IDENTITY(1,1) NOT NULL,
	--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp] 
	[componetid] [int] NOT NULL DEFAULT 0,		-- FK = [componet].[comp] --> [componet].[componetid]
	[mfg_locid] [int] NOT NULL DEFAULT 0,		-- FK = [mfg_loc].[mfg_locid]
	[min_inv] [int] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_complocs] PRIMARY KEY CLUSTERED 
	(
		[complocsid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[complocs] ON;

INSERT INTO [Contech_Test].[dbo].[complocs] ([complocsid],[componetid],[mfg_locid],[min_inv])
SELECT [rawUpsize_Contech].[dbo].[complocs].[complocsid]
      --,[rawUpsize_Contech].[dbo].[complocs].[comp]
	  ,ISNULL([Contech_Test].[dbo].[componet].[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[complocs].[mfg_locid]
      ,[rawUpsize_Contech].[dbo].[complocs].[min_inv]
  FROM [rawUpsize_Contech].[dbo].[complocs]
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[complocs].[comp] = [Contech_Test].[dbo].[componet].[comp] 
  ORDER BY [rawUpsize_Contech].[dbo].[complocs].[complocsid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[complocs] OFF;

--SELECT * FROM [Contech_Test].[dbo].[complocs]

-- =========================================================