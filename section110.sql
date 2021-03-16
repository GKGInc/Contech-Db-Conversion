-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section011_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 011: tbom_hdr
-- =========================================================

-- Column changes:
--  - Added [tbom_hdrid] as primary key
--  - Changed [unit] [char](4) to [unitid] [int] to reference [units] table
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [mfg_cat] [char](2) to [mfgcatid] [int] to reference [mfgcat] table
--  - Changed [notes] from [text] to [varchar](2000)
--  - Changed [price_note] from [text] to [varchar](2000)
-- Maps:
--	- [tbom_hdr].[unit] --> [unitid]		-- FK = [units].[unit] --> [units].[unitid]
--	- [tbom_hdr].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [tbom_hdr].[mfg_cat] --> [mfgcatid]	-- FK = [mfgcat].[mfg_cat] -> [mfgcat].[mfgcatid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.tbom_hdr: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'tbom_hdr')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('tbom_hdr')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('tbom_hdr')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[tbom_hdr]
		PRINT 'Table [dbo].[tbom_hdr] dropped'
    END

	CREATE TABLE [dbo].[tbom_hdr](
		[tbom_hdrid] [int] IDENTITY(1,1) NOT NULL,
		[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	
		[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	
		[part_no] [char](15) NOT NULL DEFAULT '',
		[part_rev] [char](10) NOT NULL DEFAULT '',
		[part_desc] [char](50) NOT NULL DEFAULT '',
		[price] [numeric](8, 4) NOT NULL DEFAULT 0.0,
		[price_ire] [numeric](8, 4) NOT NULL DEFAULT 0.0,
		[price_rev] [datetime] NULL,
		--[unit] [char](4) NOT NULL DEFAULT '',			-- FK = [units].[unit]
		[unitid] [int] NULL,							-- FK = [units].[unit] --> [units].[unitid]	
		[date_rev] [datetime] NULL,
		[sts] [char](1) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no] 	
		[customerid] [int] NULL,						-- FK = [customer].[cust_no] --> [customer].[customerid]	
		[date_ent] [datetime] NULL,
		[code_info] [numeric](1, 0) NOT NULL DEFAULT 0,
		[tube_lenth] [char](40) NOT NULL DEFAULT '',
		[tube_dim] [char](50) NOT NULL DEFAULT '',
		[assembly] [char](15) NOT NULL DEFAULT '',
		[scr_code] [char](1) NOT NULL DEFAULT '',
		[quota] [char](5) NOT NULL DEFAULT '',
		[notes] [varchar](2000) NOT NULL DEFAULT '',
		[mfg_no] [numeric](5, 0) NOT NULL DEFAULT 0,
		[spec_no] [char](5) NOT NULL DEFAULT '',
		[spec_rev] [char](2) NOT NULL DEFAULT '',
		[dspec_rev] [datetime] NULL,
		[doc_no] [char](5) NOT NULL DEFAULT '',
		[doc_rev] [char](2) NOT NULL DEFAULT '',
		[ddoc_rev] [datetime] NULL,
		[computer] [char](1) NOT NULL DEFAULT '',
		[waste] [char](10) NOT NULL DEFAULT '',
		[qty_case] [numeric](6, 0) NOT NULL DEFAULT 0,
		[price_note] [varchar](2000) NOT NULL DEFAULT '',
		--[mfg_cat] [char](2) NOT NULL DEFAULT 0,			-- FK = [mfgcat].[mfg_cat]
		[mfgcatid] [int] NULL,								-- FK = [mfgcat].[mfg_cat] -> [mfgcat].[mfgcatid]
		[rbom_no] [numeric](5, 0) NOT NULL DEFAULT 0,
		[sts_loc] [char](20) NOT NULL DEFAULT '',
		CONSTRAINT [PK_tbom_hdr] PRIMARY KEY CLUSTERED 
		(
			[tbom_hdrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_tbom_hdr_units FOREIGN KEY ([unitid]) REFERENCES [dbo].[units] ([unitid]) ON DELETE NO ACTION
		,CONSTRAINT FK_tbom_hdr_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_tbom_hdr_mfgcat FOREIGN KEY ([mfgcatid]) REFERENCES [dbo].[mfgcat] ([mfgcatid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[tbom_hdr] NOCHECK CONSTRAINT [FK_tbom_hdr_units];
	ALTER TABLE [dbo].[tbom_hdr] NOCHECK CONSTRAINT [FK_tbom_hdr_customer];
	ALTER TABLE [dbo].[tbom_hdr] NOCHECK CONSTRAINT [FK_tbom_hdr_mfgcat];

	INSERT INTO [dbo].[tbom_hdr] ([bom_no],[bom_rev],[part_no],[part_rev],[part_desc],[price],[price_ire],[price_rev],[unitid],[date_rev],[sts],[customerid],[date_ent],[code_info],[tube_lenth],[tube_dim],[assembly],
				[scr_code],[quota],[notes],[mfg_no],[spec_no],[spec_rev],[dspec_rev],[doc_no],[doc_rev],[ddoc_rev],[computer],[waste],[qty_case],[price_note],[mfgcatid],[rbom_no],[sts_loc])
	SELECT [rawUpsize_Contech].[dbo].[tbom_hdr].[bom_no]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[bom_rev]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[part_no]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[part_rev]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[part_desc]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price_ire]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[price_rev]
		  --,[rawUpsize_Contech].[dbo].[tbom_hdr].[unit]		
		  ,ISNULL(units.[unitid], NULL) as [unitid]				-- FK = [units].[unit] --> [units].[unitid]	
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[date_rev]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[sts]
		  --,[rawUpsize_Contech].[dbo].[tbom_hdr].[cust_no]		
		  ,ISNULL(customer.[customerid], NULL) as [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
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
		  --,[rawUpsize_Contech].[dbo].[tbom_hdr].[mfg_cat]		
		  ,ISNULL(mfgcat.[mfgcatid], NULL) AS [mfgcatid]		-- FK = [mfgcat].[mfg_cat] --> [mfgcat].[mfgcatid]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[rbom_no]
		  ,[rawUpsize_Contech].[dbo].[tbom_hdr].[sts_loc]
	  FROM [rawUpsize_Contech].[dbo].[tbom_hdr]
	  LEFT JOIN [dbo].[units] units ON [rawUpsize_Contech].[dbo].[tbom_hdr].[unit] = units.[unit] 
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[tbom_hdr].[cust_no] = customer.[cust_no] 
	  LEFT JOIN [dbo].[mfgcat] mfgcat ON [rawUpsize_Contech].[dbo].[tbom_hdr].[mfg_cat] = mfgcat.[mfg_cat] 

	--SELECT * FROM [tbom_hdr]

    COMMIT

    PRINT 'Table: dbo.tbom_hdr: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 011: tbom_dtl
-- =========================================================

-- Column changes:
--  - Added [tbom_dtlid] as primary key
--  - Added [tbom_hdrid] as foreign key to reference [tbom_hdr] table using [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [tbom_dtl].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.tbom_dtl: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'tbom_dtl')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('tbom_dtl')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('tbom_dtl')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[tbom_dtl]
		PRINT 'Table [dbo].[tbom_dtl] dropped'
    END

	CREATE TABLE [dbo].[tbom_dtl](
		[tbom_dtlid] [int] IDENTITY(1,1) NOT NULL,
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]  --> [tbom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev] --> [tbom_hdr].[bom_rev]
		[tbom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [tbom_hdr].[tbom_hdrid]
		[order] [numeric](2, 0) NOT NULL DEFAULT 0,
		--[comp] [char](5) NOT NULL DEFAULT '',			
		[componetid] [int] NULL,						-- FK = [componet].[comp] --> [componet].[componetid]
		[quan] [numeric](8, 6) NOT NULL DEFAULT 0.0,	
		[coc] [char](1) NOT NULL DEFAULT '',
		CONSTRAINT [PK_tbom_dtl] PRIMARY KEY CLUSTERED 
		(
			[tbom_dtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_tbom_dtl_tbom_hdr FOREIGN KEY ([tbom_hdrid]) REFERENCES [dbo].[tbom_hdr] ([tbom_hdrid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_tbom_dtl_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[tbom_dtl] NOCHECK CONSTRAINT [FK_tbom_dtl_componet];

	INSERT INTO [dbo].[tbom_dtl] 
	SELECT ISNULL(tbom_hdr.[tbom_hdrid], 0) AS [tbom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[tbom_dtl].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[tbom_dtl].[bom_rev]	
		  ,[rawUpsize_Contech].[dbo].[tbom_dtl].[order]
		  --,[rawUpsize_Contech].[dbo].[tbom_dtl].[comp]
		  ,ISNULL(componet.[componetid], NULL) AS [componetid] 
		  ,[rawUpsize_Contech].[dbo].[tbom_dtl].[quan]
		  ,[rawUpsize_Contech].[dbo].[tbom_dtl].[coc]  
	  FROM [rawUpsize_Contech].[dbo].[tbom_dtl] -- SELECT * FROM [rawUpsize_Contech].[dbo].[tbom_dtl]
	  LEFT JOIN [dbo].[tbom_hdr] tbom_hdr ON [rawUpsize_Contech].[dbo].[tbom_dtl].[bom_no] = tbom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[tbom_dtl].[bom_rev] = tbom_hdr.[bom_rev]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[tbom_dtl].[comp] = componet.[comp] 
	  WHERE tbom_hdr.[tbom_hdrid] > 0

	--SELECT * FROM [dbo].[tbom_dtl]

    COMMIT

    PRINT 'Table: dbo.tbom_dtl: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section011_HR.sql'

-- =========================================================