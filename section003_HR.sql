-- =========================================================
--Section 003: class
-- =========================================================

-- Column changes:
--	- Moved classid to first column
--  - Changed classid to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'class'))
    DROP TABLE [dbo].[class]
	
CREATE TABLE [dbo].[class](
	classid int identity(1,1) not null,
	[class] [char](4) NOT NULL,
	[desc] [text] NOT NULL,
	CONSTRAINT [PK_class] PRIMARY KEY CLUSTERED 
	(
		[classid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[class]	SELECT * FROM [rawUpsize_Contech].[dbo].[class] 

--SELECT * FROM [Contech_Test].[dbo].[class]

-- =========================================================
--Section 003: componet
-- =========================================================

-- Column changes:
--  - Moved componetid to 1st column
--  - Changed componetid to be primary key
--  - Changed class to int to reference type in class table
-- Maps:
--	- [componet].[lass]		-- FK = [class].[class] -> [class].[classid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'componet'))
    DROP TABLE [dbo].[componet]
	
CREATE TABLE [dbo].[componet](
	[componetid] int identity(1,1) not null,
	[comp] [char](5) NOT NULL,
	[desc] [char](75) NOT NULL,
	[desc2] [char](75) NOT NULL,
	[memo1] [char](51) NOT NULL,
	[insp] [char](2) NOT NULL,
	[cust_no] [char](5) NOT NULL,
	[cost] [numeric](9, 5) NOT NULL,
	[unit] [char](4) NOT NULL,
	[ven_id] [char](6) NOT NULL,
	[price] [numeric](9, 5) NOT NULL,
	[ctp_min] [numeric](10, 0) NOT NULL,
	[cmi_inv] [char](1) NOT NULL,
	[cmi_min] [numeric](10, 0) NOT NULL,
	[cmi_price] [numeric](9, 5) NOT NULL,
	[material] [char](3) NOT NULL,
	[cust_comp] [char](12) NOT NULL,
	[cus_comp_r] [char](3) NOT NULL,
	[cust_desc] [char](50) NOT NULL,
	[memo] [text] NOT NULL,
	[inventory] [numeric](10, 0) NOT NULL,
	[drw] [char](8) NOT NULL,
	[inc] [char](8) NOT NULL,
	[price_ire] [numeric](9, 5) NOT NULL,
	[phys_inv] [numeric](10, 0) NOT NULL,
	[inv_card] [numeric](10, 0) NOT NULL,
	[quar] [numeric](10, 0) NOT NULL,
	[hold] [numeric](10, 0) NOT NULL,
	[reject] [numeric](10, 0) NOT NULL,
	[class] [int] NOT NULL,
	[comp_rev] [char](2) NOT NULL,
	[samp_plan] [char](2) NOT NULL,
	[lbl] [char](8) NOT NULL,
	[xinv] [bit] NOT NULL,
	[pickconv] [numeric](9, 2) NOT NULL,
	[back_dist] [bit] NOT NULL,
	[expire] [bit] NOT NULL,
	[comptype] [char](3) NOT NULL,
	[color] [char](15) NOT NULL,
	[color_no] [char](20) NOT NULL,
	[pantone] [char](15) NOT NULL,
	[fda_food] [int] NOT NULL,
	[fda_med] [int] NOT NULL,
	[coneg] [int] NOT NULL,
	[prop65] [int] NOT NULL,
	[rohs] [int] NOT NULL,
	[eu_94_62] [int] NOT NULL,
	[rev_rec] [int] NOT NULL,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL,
	CONSTRAINT [PK_componet] PRIMARY KEY CLUSTERED 
	(
		[componetid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[componet] ON;

INSERT INTO [Contech_Test].[dbo].[componet] ([componetid],[comp],[desc],[desc2],[memo1],[insp],[cust_no],[cost],[unit],[ven_id],[price],[ctp_min],[cmi_inv],[cmi_min],[cmi_price],[material],[cust_comp],[cus_comp_r],[cust_desc],[memo],[inventory],[drw],[inc],[price_ire],[phys_inv],[inv_card],[quar],[hold],[reject],[class],[comp_rev],[samp_plan],[lbl],[xinv],[pickconv],[back_dist],[expire],[comptype],[color],[color_no],[pantone],[fda_food],[fda_med],[coneg],[prop65],[rohs],[eu_94_62],[rev_rec],[rev_dt],[rev_emp])
SELECT 
[componetid]
,[comp]
,[rawUpsize_Contech].[dbo].[componet].[desc]
,[desc2]
,[memo1]
,[insp]
,[cust_no]
,[cost]
,[unit]
,[ven_id]
,[price]
,[ctp_min]
,[cmi_inv]
,[cmi_min]
,[cmi_price]
,[material]
,[cust_comp]
,[cus_comp_r]
,[cust_desc]
,[memo]
,[inventory]
,[drw]
,[inc]
,[price_ire]
,[phys_inv]
,[inv_card]
,[quar]
,[hold]
,[reject]
--,[rawUpsize_Contech].[dbo].[componet].[class]
,ISNULL([Contech_Test].[dbo].[class].classid, 0) AS [class]
,[comp_rev]
,[samp_plan]
,[lbl]
,[xinv]
,[pickconv]
,[back_dist]
,[expire]
,[comptype]
,[color]
,[color_no]
,[pantone]
,[fda_food]
,[fda_med]
,[coneg]
,[prop65]
,[rohs]
,[eu_94_62]
,[rev_rec]
,[rev_dt]
,[rev_emp]
FROM [rawUpsize_Contech].[dbo].[componet] 
LEFT JOIN [Contech_Test].[dbo].[class] ON [rawUpsize_Contech].[dbo].[componet].[class] = [Contech_Test].[dbo].[class].class

SET IDENTITY_INSERT [Contech_Test].[dbo].[componet] OFF;

--SELECT * FROM [Contech_Test].[dbo].[componet]

-- =========================================================