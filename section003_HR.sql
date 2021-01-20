-- =========================================================
-- Section 003: class
-- =========================================================

-- Column changes:
--	- Moved [classid] to first column
--  - Changed [classid] to be primary key
--  - Changed [desc] from [text] to [varchar](2000)

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'class'))
    DROP TABLE [class]
	
CREATE TABLE [class](
	classid [int] IDENTITY(1,1) NOT NULL,
	[class] [char](4) NOT NULL DEFAULT '',
	[desc] [varchar](2000) NOT NULL DEFAULT '',
	CONSTRAINT [PK_class] PRIMARY KEY CLUSTERED 
	(
		[classid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [class]
	SELECT * FROM [rawUpsize_Contech].[dbo].[class] 

--SELECT * FROM [class]

-- =========================================================
-- Section 003: componet
-- =========================================================

-- Column changes:
--  - Moved [componetid] to 1st column
--  - Changed [componetid] to be primary key
--  - Changed [class] [char](4) to [classid] [int] to reference [class] in [class] table
--  - Changed [memo] from [text] to [varchar](2000)
-- Maps:
--	- [componet].[class] --> [classid]		-- FK = [class].[class] -> [class].[classid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'componet'))
    DROP TABLE [dbo].[componet]
	
CREATE TABLE [dbo].[componet](
	[componetid] [int] IDENTITY(1,1) NOT NULL,
	[comp] [char](5) NOT NULL DEFAULT '',			
	[desc] [char](75) NOT NULL DEFAULT '',
	[desc2] [char](75) NOT NULL DEFAULT '',
	[memo1] [char](51) NOT NULL DEFAULT '',
	[insp] [char](2) NOT NULL DEFAULT '',
	[cust_no] [char](5) NOT NULL DEFAULT '',
	[cost] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[unit] [char](4) NOT NULL DEFAULT '',
	[ven_id] [char](6) NOT NULL DEFAULT '',
	[price] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[ctp_min] [numeric](10, 0) NOT NULL DEFAULT 0,
	[cmi_inv] [char](1) NOT NULL DEFAULT '',
	[cmi_min] [numeric](10, 0) NOT NULL DEFAULT 0,
	[cmi_price] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[material] [char](3) NOT NULL DEFAULT '',
	[cust_comp] [char](12) NOT NULL DEFAULT '',
	[cus_comp_r] [char](3) NOT NULL DEFAULT '',
	[cust_desc] [char](50) NOT NULL DEFAULT '',
	[memo] [varchar](2000) NOT NULL DEFAULT '',
	[inventory] [numeric](10, 0) NOT NULL DEFAULT 0,
	[drw] [char](8) NOT NULL DEFAULT '',
	[inc] [char](8) NOT NULL DEFAULT '',
	[price_ire] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[phys_inv] [numeric](10, 0) NOT NULL DEFAULT 0,
	[inv_card] [numeric](10, 0) NOT NULL DEFAULT 0,
	[quar] [numeric](10, 0) NOT NULL DEFAULT 0,
	[hold] [numeric](10, 0) NOT NULL DEFAULT 0,
	[reject] [numeric](10, 0) NOT NULL DEFAULT 0,
	--[class] [char](4) NOT NULL DEFAULT 0,
	[classid] [int] NOT NULL DEFAULT 0,					-- FK = [class].[class] -> [class].[classid]
	[comp_rev] [char](2) NOT NULL DEFAULT '',
	[samp_plan] [char](2) NOT NULL DEFAULT '',
	[lbl] [char](8) NOT NULL DEFAULT '',
	[xinv] [bit] NOT NULL DEFAULT 0,
	[pickconv] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[back_dist] [bit] NOT NULL DEFAULT 0,
	[expire] [bit] NOT NULL DEFAULT 0,
	[comptype] [char](3) NOT NULL DEFAULT '',
	[color] [char](15) NOT NULL DEFAULT '',
	[color_no] [char](20) NOT NULL DEFAULT '',
	[pantone] [char](15) NOT NULL DEFAULT '',
	[fda_food] [int] NOT NULL DEFAULT 0,
	[fda_med] [int] NOT NULL DEFAULT 0,
	[coneg] [int] NOT NULL DEFAULT 0,
	[prop65] [int] NOT NULL DEFAULT 0,
	[rohs] [int] NOT NULL DEFAULT 0,
	[eu_94_62] [int] NOT NULL DEFAULT 0,
	[rev_rec] [int] NOT NULL DEFAULT 0,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL DEFAULT '',
	CONSTRAINT [PK_componet] PRIMARY KEY CLUSTERED 
	(
		[componetid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [componet] ON;

INSERT INTO [componet] ([componetid],[comp],[desc],[desc2],[memo1],[insp],[cust_no],[cost],[unit],[ven_id],[price],[ctp_min],[cmi_inv],[cmi_min],[cmi_price],[material],[cust_comp],[cus_comp_r],[cust_desc],[memo],[inventory],[drw],[inc],[price_ire],[phys_inv],[inv_card],[quar],[hold],[reject],[classid],[comp_rev],[samp_plan],[lbl],[xinv],[pickconv],[back_dist],[expire],[comptype],[color],[color_no],[pantone],[fda_food],[fda_med],[coneg],[prop65],[rohs],[eu_94_62],[rev_rec],[rev_dt],[rev_emp])
SELECT 
	[rawUpsize_Contech].[dbo].[componet].[componetid]
	,[rawUpsize_Contech].[dbo].[componet].[comp]
	,[rawUpsize_Contech].[dbo].[componet].[desc]
	,[rawUpsize_Contech].[dbo].[componet].[desc2]
	,[rawUpsize_Contech].[dbo].[componet].[memo1]
	,[rawUpsize_Contech].[dbo].[componet].[insp]
	,[rawUpsize_Contech].[dbo].[componet].[cust_no]
	,[rawUpsize_Contech].[dbo].[componet].[cost]
	,[rawUpsize_Contech].[dbo].[componet].[unit]
	,[rawUpsize_Contech].[dbo].[componet].[ven_id]
	,[rawUpsize_Contech].[dbo].[componet].[price]
	,[rawUpsize_Contech].[dbo].[componet].[ctp_min]
	,[rawUpsize_Contech].[dbo].[componet].[cmi_inv]
	,[rawUpsize_Contech].[dbo].[componet].[cmi_min]
	,[rawUpsize_Contech].[dbo].[componet].[cmi_price]
	,[rawUpsize_Contech].[dbo].[componet].[material]
	,[rawUpsize_Contech].[dbo].[componet].[cust_comp]
	,[rawUpsize_Contech].[dbo].[componet].[cus_comp_r]
	,[rawUpsize_Contech].[dbo].[componet].[cust_desc]
	,[rawUpsize_Contech].[dbo].[componet].[memo]
	,[rawUpsize_Contech].[dbo].[componet].[inventory]
	,[rawUpsize_Contech].[dbo].[componet].[drw]
	,[rawUpsize_Contech].[dbo].[componet].[inc]
	,[rawUpsize_Contech].[dbo].[componet].[price_ire]
	,[rawUpsize_Contech].[dbo].[componet].[phys_inv]
	,[rawUpsize_Contech].[dbo].[componet].[inv_card]
	,[rawUpsize_Contech].[dbo].[componet].[quar]
	,[rawUpsize_Contech].[dbo].[componet].[hold]
	,[rawUpsize_Contech].[dbo].[componet].[reject]
	--,[rawUpsize_Contech].[dbo].[componet].[class]
	,ISNULL(class.classid, 0) AS [class]
	,[rawUpsize_Contech].[dbo].[componet].[comp_rev]
	,[rawUpsize_Contech].[dbo].[componet].[samp_plan]
	,[rawUpsize_Contech].[dbo].[componet].[lbl]
	,[rawUpsize_Contech].[dbo].[componet].[xinv]
	,[rawUpsize_Contech].[dbo].[componet].[pickconv]
	,[rawUpsize_Contech].[dbo].[componet].[back_dist]
	,[rawUpsize_Contech].[dbo].[componet].[expire]
	,[rawUpsize_Contech].[dbo].[componet].[comptype]
	,[rawUpsize_Contech].[dbo].[componet].[color]
	,[rawUpsize_Contech].[dbo].[componet].[color_no]
	,[rawUpsize_Contech].[dbo].[componet].[pantone]
	,[rawUpsize_Contech].[dbo].[componet].[fda_food]
	,[rawUpsize_Contech].[dbo].[componet].[fda_med]
	,[rawUpsize_Contech].[dbo].[componet].[coneg]
	,[rawUpsize_Contech].[dbo].[componet].[prop65]
	,[rawUpsize_Contech].[dbo].[componet].[rohs]
	,[rawUpsize_Contech].[dbo].[componet].[eu_94_62]
	,[rawUpsize_Contech].[dbo].[componet].[rev_rec]
	,[rawUpsize_Contech].[dbo].[componet].[rev_dt]
	,[rawUpsize_Contech].[dbo].[componet].[rev_emp]
FROM [rawUpsize_Contech].[dbo].[componet] 
LEFT JOIN [class] class ON [rawUpsize_Contech].[dbo].[componet].[class] = class.[class]

SET IDENTITY_INSERT [componet] OFF;

--SELECT * FROM [componet]

-- =========================================================