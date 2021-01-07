
-- =========================================================
--Section 3: class
-- =========================================================

-- Column changes:
--	- pk to first column

--USE Contech_Test

--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'class'))
--    DROP TABLE [dbo].[class]
	
--CREATE TABLE [dbo].[class](
--	pk int identity(1,1) not null,
--	[class] [char](4) NOT NULL,
--	[desc] [text] NOT NULL
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO


--INSERT INTO [Contech_Test].[dbo].[class]	SELECT * FROM [rawUpsize_Contech].[dbo].[class] 

--SELECT * FROM [Contech_Test].[dbo].[class]

-- =========================================================
--Section 3: componet
-- =========================================================

-- Column changes:
--	- 

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'componet'))
    DROP TABLE [dbo].[componet]
	

CREATE TABLE [dbo].[componet](
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
	[class] [char](4) NOT NULL,
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
	[componetid] [int] NOT NULL,
	[rev_rec] [int] NOT NULL,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-- =========================================================