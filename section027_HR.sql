-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section027_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 027: colorant -- Moved to Section 003
-- =========================================================

-- Column changes:
--  - Set [colorantid] to be primary key
--  - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table
-- Maps:
--	- [colorant].[document] --> [docs_dtlid]	-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]

 --   PRINT 'Table: dbo.colorant: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'colorant'))
	--	DROP TABLE [dbo].[colorant]

	--CREATE TABLE [dbo].[colorant](
	--	[colorantid] [int] IDENTITY(1,1) NOT NULL,
	--	[colorantno] [char](20) NOT NULL DEFAULT '',
	--	[color_desc] [char](50) NOT NULL DEFAULT '',
	--	--[document] [char](15) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document] 
	--	[docs_dtlid] [int] NOT NULL DEFAULT 0,			-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]
	--	CONSTRAINT [PK_colorant] PRIMARY KEY CLUSTERED 
	--	(
	--		[colorantid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	--) ON [PRIMARY]

	--SET IDENTITY_INSERT [dbo].[colorant] ON;

	--INSERT INTO [dbo].[colorant] ([colorantid],[colorantno],[color_desc],[docs_dtlid])
	--SELECT [rawUpsize_Contech].[dbo].[colorant].[colorantid]
	--	  ,[rawUpsize_Contech].[dbo].[colorant].[colorantno]
	--	  ,[rawUpsize_Contech].[dbo].[colorant].[color_desc]
	--	  --,[rawUpsize_Contech].[dbo].[colorant].[document]
	--	  ,ISNULL(docs_dtl.[docs_dtlid], 0) AS [docs_dtlid] 
	--	  --,ISNULL([rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid], 0) AS [docs_dtlid] 
	--  FROM [rawUpsize_Contech].[dbo].[colorant]
	--  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[colorant].[document] = docs_dtl.[document]
	--  --LEFT JOIN [rawUpsize_Contech].[dbo].[docs_dtl] ON [rawUpsize_Contech].[dbo].[colorant].[document] = [rawUpsize_Contech].[dbo].[docs_dtl].[document]
	--  ORDER BY [rawUpsize_Contech].[dbo].[colorant].[colorantid]
    
	--SET IDENTITY_INSERT [dbo].[colorant] OFF;

	----SELECT * FROM [dbo].[colorant]
	
 --   PRINT 'Table: dbo.colorant: end'

-- =========================================================
-- Section 027: comp_inv
-- =========================================================

-- Column changes:
--  - Added [comp_invid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [users] table
-- Maps:
--	- [compdocs].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.comp_inv: start'

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
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[comp_inv] ([componetid],[on_hand],[phys_inv],[inv_card],[quar],[hold],[reject],[wip],[just_phys],[e_card],[cost],[price_ire],[phys_inv_c],[quar_c],[hold_c],[reject_c],[on_hand_c],[ctpo],[cust],[physcust],[physcust_c],[wipcust])
	SELECT --[rawUpsize_Contech].[dbo].[comp_inv].[comp]
		  ISNULL(componet.[componetid], 0) AS [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
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
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[comp_inv].[comp] = componet.[comp] 
  
	--SELECT * FROM [dbo].[comp_inv]
	
    PRINT 'Table: dbo.comp_inv: end'

-- =========================================================
-- Section 027: compdocs
-- =========================================================

-- Column changes:
--  - Set [compdocsid] to be primary key
--  - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table
--  - Changed [compdocsid] to [compdocid]
--  - Changed [comp] [char](5) to [componetid] [int] to reference users table
-- Maps:
--	- [compdocs].[document] --> [docs_dtlid]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
--	- [compdocs].[comp]	--> [componetid]		-- FK = [componet].[comp] --> [componet].[componetid]
-- Notes:
--	- Multiple documents not found in [docs_dtl] table

    PRINT 'Table: dbo.compdocs: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'compdocs'))
		DROP TABLE [dbo].[compdocs]

	CREATE TABLE [dbo].[compdocs](
		[compdocid] [int] IDENTITY(1,1) NOT NULL,
		--[document] [char](15) NOT NULL DEFAULT '',-- FK = [docs_dtl].[document]
		[docs_dtlid] [int] NOT NULL DEFAULT 0,		-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
		--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp] 
		[componetid] [int] NOT NULL DEFAULT 0,		-- FK = [componet].[comp] --> [componet].[componetid]
		[po_print] [char](1) NOT NULL DEFAULT '',
		CONSTRAINT [PK_compdocs] PRIMARY KEY CLUSTERED 
		(
			[compdocid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[compdocs] ON;

	INSERT INTO [dbo].[compdocs] ([compdocid],[docs_dtlid],[componetid],[po_print])
	SELECT [rawUpsize_Contech].[dbo].[compdocs].[compdocsid]
		  --,[rawUpsize_Contech].[dbo].[compdocs].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid], 0) AS [docs_dtlid] 	
		  --,[rawUpsize_Contech].[dbo].[compdocs].[comp]
		  ,ISNULL(componet.[componetid], 0) AS [componetid] 
		  ,[rawUpsize_Contech].[dbo].[compdocs].[po_print]
	  FROM [rawUpsize_Contech].[dbo].[compdocs]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[compdocs].[comp] = componet.[comp]				
	  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[compdocs].[document] = docs_dtl.[document]	
	  ORDER BY [rawUpsize_Contech].[dbo].[compdocs].[compdocsid]

	SET IDENTITY_INSERT [dbo].[compdocs] OFF;

	--SELECT * FROM [dbo].[compdocs]
	
    PRINT 'Table: dbo.compdocs: end'

-- =========================================================
-- Section 027: complocs
-- =========================================================

-- Column changes:
--  - Set [complocsid] to be primary key
--  - Changed [complocsid] to [complocid]
--  - Changed [comp] [char](5) to [componetid] [int] to reference users table
-- Maps:
--	- [complocs].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [complocs].[mfg_locid]				-- FK = [mfg_loc].[mfg_locid]

    PRINT 'Table: dbo.complocs: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'complocs'))
		DROP TABLE [dbo].[complocs]

	CREATE TABLE [dbo].[complocs](
		[complocid] [int] IDENTITY(1,1) NOT NULL,
		--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp] 
		[componetid] [int] NOT NULL DEFAULT 0,		-- FK = [componet].[comp] --> [componet].[componetid]
		[mfg_locid] [int] NOT NULL DEFAULT 0,		-- FK = [mfg_loc].[mfg_locid]
		[min_inv] [int] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_complocs] PRIMARY KEY CLUSTERED 
		(
			[complocid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[complocs] ON;

	INSERT INTO [dbo].[complocs] ([complocid],[componetid],[mfg_locid],[min_inv])
	SELECT [rawUpsize_Contech].[dbo].[complocs].[complocsid]
		  --,[rawUpsize_Contech].[dbo].[complocs].[comp]
		  ,ISNULL(componet.[componetid], 0) AS [componetid] 
		  ,[rawUpsize_Contech].[dbo].[complocs].[mfg_locid]
		  ,[rawUpsize_Contech].[dbo].[complocs].[min_inv]
	  FROM [rawUpsize_Contech].[dbo].[complocs]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[complocs].[comp] = componet.[comp] 
	  ORDER BY [rawUpsize_Contech].[dbo].[complocs].[complocsid]

	SET IDENTITY_INSERT [dbo].[complocs] OFF;

	--SELECT * FROM [dbo].[complocs]

    PRINT 'Table: dbo.complocs: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section027_HR.sql'

-- =========================================================