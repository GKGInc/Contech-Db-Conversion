-- =========================================================
--Section 011: tbom_hdr
-- =========================================================

-- Column changes:
--  - Added tbom_hdrid as primary key
--  - Changed cust_no to int to reference customer table
--  - Changed mfg_cat to int to reference mfgcat table
-- Maps:
--	- [tbom_hdr].[cust_no]	-- FK = [customer].[cust_no] -> [vendor].[customerid]
--	- [tbom_hdr].[mfg_cat]	-- FK = [mfgcat].[mfg_cat] -> [mfgcat].[mfgcatid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'tbom_hdr'))
    DROP TABLE [dbo].[tbom_hdr]

CREATE TABLE [dbo].[tbom_hdr](
	[tbom_hdrid] [int] identity(1,1) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL,
	[bom_rev] [numeric](2, 0) NOT NULL,
	[part_no] [char](15) NOT NULL,
	[part_rev] [char](10) NOT NULL,
	[part_desc] [char](50) NOT NULL,
	[price] [numeric](8, 4) NOT NULL,
	[price_ire] [numeric](8, 4) NOT NULL,
	[price_rev] [datetime] NULL,
	[unit] [char](4) NOT NULL,
	[date_rev] [datetime] NULL,
	[sts] [char](1) NOT NULL,
	[cust_no] [int] NOT NULL,			-- customer.cust_no
	[date_ent] [datetime] NULL,
	[code_info] [numeric](1, 0) NOT NULL,
	[tube_lenth] [char](40) NOT NULL,
	[tube_dim] [char](50) NOT NULL,
	[assembly] [char](15) NOT NULL,
	[scr_code] [char](1) NOT NULL,
	[quota] [char](5) NOT NULL,
	[notes] [text] NOT NULL,
	[mfg_no] [numeric](5, 0) NOT NULL,
	[spec_no] [char](5) NOT NULL,
	[spec_rev] [char](2) NOT NULL,
	[dspec_rev] [datetime] NULL,
	[doc_no] [char](5) NOT NULL,
	[doc_rev] [char](2) NOT NULL,
	[ddoc_rev] [datetime] NULL,
	[computer] [char](1) NOT NULL,
	[waste] [char](10) NOT NULL,
	[qty_case] [numeric](6, 0) NOT NULL,
	[price_note] [text] NOT NULL,
	[mfg_cat] [int] NOT NULL,		-- mfgcat.mfg_cat
	[rbom_no] [numeric](5, 0) NOT NULL,
	[sts_loc] [char](20) NOT NULL,
	CONSTRAINT [PK_tbom_hdr] PRIMARY KEY CLUSTERED 
	(
		[tbom_hdrid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[tbom_hdr] 
SELECT [rawUpsize_Contech].[dbo].[tbom_hdr].[bom_no]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[bom_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[part_no]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[part_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[part_desc]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price_ire]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[unit]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[date_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[sts]
      --,[rawUpsize_Contech].[dbo].[tbom_hdr].[cust_no]		-- customer.cust_no
	  ,ISNULL([Contech_Test].[dbo].[customer].[customerid], 0) as [customerid]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[date_ent]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[code_info]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[tube_lenth]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[tube_dim]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[assembly]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[scr_code]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[quota]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[notes]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[mfg_no]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[spec_no]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[spec_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[dspec_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[doc_no]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[doc_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[ddoc_rev]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[computer]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[waste]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[qty_case]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price_note]
      --,[rawUpsize_Contech].[dbo].[tbom_hdr].[mfg_cat]		-- mfgcat.mfg_cat
	  ,ISNULL([Contech_Test].[dbo].[mfgcat].[mfgcatid], 0) AS [mfgcatid] -- Note: mfg_cat 40 is not found in [mfgcat] table
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[rbom_no]
      ,[rawUpsize_Contech].[dbo].[tbom_hdr].[sts_loc]
  FROM [rawUpsize_Contech].[dbo].[tbom_hdr]
  LEFT JOIN [Contech_Test].[dbo].[customer] ON [rawUpsize_Contech].[dbo].[tbom_hdr].[cust_no] = [Contech_Test].[dbo].[customer].[cust_no] 
  LEFT JOIN [Contech_Test].[dbo].[mfgcat] ON [rawUpsize_Contech].[dbo].[tbom_hdr].[mfg_cat] = [Contech_Test].[dbo].[mfgcat].[mfg_cat] 

--SELECT * FROM [Contech_Test].[dbo].[tbom_hdr]

-- =========================================================
--Section 011: tbom_dtl
-- =========================================================

-- Column changes:
--  - Added tbom_dtlid as primary key
--  - Added tbom_hdrid as foreign key to reference tbom_hdr table
--  - Changed comp to int to reference componet table
-- Maps:
--	- [tbom_dtl].[comp]		-- FK = [componet].[comp] -> [componet].[componetid]
--	- [tbom_dtl].[bom_no]	-- FK = [bom_hdr].[bom_no] 
--	- [tbom_dtl].[bom_rev]	-- FK = [bom_hdr].[bom_rev] 

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'tbom_dtl'))
    DROP TABLE [dbo].[tbom_dtl]

CREATE TABLE [dbo].[tbom_dtl](
	[tbom_dtlid] [int] identity(1,1) NOT NULL,
	[tbom_hdrid] [int] NOT NULL,		-- FK = [tbom_hdr].[tbom_hdrid]
	[order] [numeric](2, 0) NOT NULL,
	[comp] [char](5) NOT NULL,			-- componet.comp
	[quan] [numeric](8, 6) NOT NULL,	
	[coc] [char](1) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL,	-- tbom_hdr.bom_no --> link to tbom_hdr
	[bom_rev] [numeric](2, 0) NOT NULL, -- tbom_hdr.bom_rev --> link to tbom_hdr
	CONSTRAINT [PK_tbom_dtl] PRIMARY KEY CLUSTERED 
	(
		[tbom_dtlid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[tbom_dtl] 
SELECT ISNULL([Contech_Test].[dbo].[tbom_hdr].[tbom_hdrid], 0) AS [tbom_hdrid]
      ,[rawUpsize_Contech].[dbo].[tbom_dtl].[order]
      --,[rawUpsize_Contech].[dbo].[tbom_dtl].[comp]
	  ,ISNULL([Contech_Test].[dbo].[componet].[componetid], 0) AS [componetid] 
      ,[rawUpsize_Contech].[dbo].[tbom_dtl].[quan]
      ,[rawUpsize_Contech].[dbo].[tbom_dtl].[coc]
      ,[rawUpsize_Contech].[dbo].[tbom_dtl].[bom_no]
      ,[rawUpsize_Contech].[dbo].[tbom_dtl].[bom_rev]	  
  FROM [rawUpsize_Contech].[dbo].[tbom_dtl]
  LEFT JOIN [Contech_Test].[dbo].[componet] ON [rawUpsize_Contech].[dbo].[tbom_dtl].[comp] = [Contech_Test].[dbo].[componet].[comp] 
  LEFT JOIN [Contech_Test].[dbo].[tbom_hdr] ON [rawUpsize_Contech].[dbo].[tbom_dtl].[bom_no] = [Contech_Test].[dbo].[tbom_hdr].[bom_no] AND [rawUpsize_Contech].[dbo].[tbom_dtl].[bom_rev] = [Contech_Test].[dbo].[tbom_hdr].[bom_rev]
  
--SELECT * FROM [Contech_Test].[dbo].[tbom_dtl]

-- =========================================================