-- =========================================================

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section007_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 007: matlin -- Moved from Section 005
-- =========================================================

-- Column changes:
--  - Renamed [matlin_key] to [matlinid]
--  - Set [matlinid] to be primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.matlin: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matlin'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('matlin')) > 0)
		BEGIN
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('matlin')
			PRINT (@SQL)	
			EXEC (@SQL)
		END

		DROP TABLE [dbo].[matlin]
		PRINT 'Table [dbo].[matlin] dropped'
	END

	CREATE TABLE [dbo].[matlin](
		[matlinid] [int] IDENTITY(1,1) NOT NULL,
		[po_no] [char](8) NOT NULL DEFAULT '',
		[date] [datetime] NULL,
		[amt_rec] [numeric](10, 0) NOT NULL DEFAULT 0,
		[amt_acc] [numeric](10, 0) NOT NULL DEFAULT 0,
		[amt_rej] [numeric](10, 0) NOT NULL DEFAULT 0,
		[ct_lot] [char](4) NOT NULL DEFAULT '',
		[ven_lot] [char](35) NOT NULL DEFAULT '',
		[ven_inv] [char](10) NOT NULL DEFAULT '',
		[ven_id] [char](6) NOT NULL DEFAULT '',
		[ven_frt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[ven_cos_ea] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[ven_memo] [char](150) NOT NULL DEFAULT '',
		[ct_control] [char](20) NOT NULL DEFAULT '',
		[qrn_no] [char](8) NOT NULL DEFAULT '',
		[comp] [char](5) NOT NULL DEFAULT '',
		[cust_vendor] [char](25) NOT NULL DEFAULT '',
		[cust_po] [char](15) NOT NULL DEFAULT '',
		[rcvr_id] [char](40) NOT NULL DEFAULT '',
		[rcvr_mod] [datetime] NULL,
		[upd_dt] [datetime] NULL,
		[inspector] [char](10) NOT NULL DEFAULT '',
		[expires] [datetime] NULL,
		[scrap] [int] NOT NULL DEFAULT 0,
		[dlvrnotnum] [char](10) NOT NULL DEFAULT '',
		[consign] [bit] NOT NULL DEFAULT 0,
		[po_price] [numeric](10, 5) NOT NULL DEFAULT 0.0,
		[vet_cert] [char](100) NOT NULL DEFAULT '',
		[id_marks] [char](100) NOT NULL DEFAULT '',
		[dscope_lot] [char](100) NOT NULL DEFAULT '',
		[mfg_locid] [int] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_matlin] PRIMARY KEY CLUSTERED 
		(
			[matlinid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [matlin] ON;

	INSERT INTO [dbo].[matlin] ([matlinid],[po_no],[date],[amt_rec],[amt_acc],[amt_rej],[ct_lot],[ven_lot],[ven_inv],[ven_id],[ven_frt],[ven_cos_ea],[ven_memo],[ct_control],[qrn_no],[comp],[cust_vendor],[cust_po],[rcvr_id],[rcvr_mod],[upd_dt],[inspector],[expires],[scrap],[dlvrnotnum],[consign],[po_price],[vet_cert],[id_marks],[dscope_lot],[mfg_locid])
	SELECT [matlin_key],[po_no],[date],[amt_rec],[amt_acc],[amt_rej],[ct_lot],[ven_lot],[ven_inv],[ven_id],[ven_frt],[ven_cos_ea],[ven_memo],[ct_control],[qrn_no],[comp],[cust_vendor],[cust_po],[rcvr_id],[rcvr_mod],[upd_dt],[inspector],[expires],[scrap],[dlvrnotnum],[consign],[po_price],[vet_cert],[id_marks],[dscope_lot],[mfg_locid]
	FROM [rawUpsize_Contech].[dbo].[matlin] order by 1 
    
	SET IDENTITY_INSERT [dbo].[matlin] OFF;

	--SELECT * FROM [matlin]

    PRINT 'Table: dbo.matlin: end'

-- =========================================================
-- Section 007: po_hdr -- Moved from Section 005
-- =========================================================

-- Column changes:
--  - Added [po_hdrid] to be primary key
--  - Changed [memo] from [text] to [varchar](2000)
--  - Changed [cpmr] from [text] to [varchar](2000)
--  - Changed [bill_to] [char](5) to [billto_custid] [int] to reference [customer] table
--  - Changed [buyer] [char](5) to [buyerid] [int] to reference [buyer] table
--  - Changed [ven_id] [char](6) to [vendorid] [int] to reference [vendor] table
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed [cusno] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [shven_no] [char](5) to [customerid] [int] to reference [venship] table
--  - Changed [material] [char](3) to [materialid] [int] to reference [material] table
--  - Changed [class] [char](4) to [classid] [int] to reference [class] table
--  - Removed [ship_to] column
-- Maps:
--	- [po_hdr].[bill_to] --> [billto_custid] -- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [po_hdr].[buyer] --> [buyerid]		-- FK = [buyer].[buyer] --> [buyer].[buyerid]
--	- [po_hdr].[ven_id] --> [vendorid]		-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
--	- [po_hdr].[comp] --> [componetid]		-- FK = [componet].[comp] --> [componet].[componetid]
--	- [po_hdr].[cusno] --> [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [po_hdr].[shven_no] --> [customerid]	-- FK = [venship].[shven_no] --> [venship].[venshipid]
--	- [po_hdr].[material] --> [materialid]	-- FK = [material].[material] --> [material].[materialid]
--	- [po_hdr].[class] --> [classid]		-- FK = [class].[class] --> [class].[classid]

    PRINT 'Table: dbo.po_hdr: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'po_hdr'))
	BEGIN
		----	Drop FOREIGN KEY constraint tables first -- Without it you get error: "Could not drop object 'dbo.bom_hdr' because it is referenced by a FOREIGN KEY constraint."
		--IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'po_dtl')
		--BEGIN
		--	PRINT 'Table [dbo].[po_dtl] dropped'
		--	DROP TABLE [dbo].[po_dtl]
		--END

		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('po_hdr')) > 0)
		BEGIN
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('po_hdr')
			PRINT (@SQL)	
			EXEC (@SQL)
		END

		DROP TABLE [dbo].[po_hdr]

		PRINT 'Table [dbo].[po_hdr] dropped'		
	END

	CREATE TABLE [dbo].[po_hdr](
		[po_hdrid] [int] IDENTITY(1,1) NOT NULL,
		[po_no] [char](8) NOT NULL DEFAULT '',
		[status] [char](1) NOT NULL DEFAULT '',
		[po_rev] [numeric](2, 0) NOT NULL,
		[rev_date] [datetime] NULL,
		--[bill_to] [char](5) NOT NULL DEFAULT '',		
		[billto_custid] [int] NULL,				-- FK = [customer].[bill_to] --> [customer].[customerid]
		--[ship_to] [char](6) NOT NULL DEFAULT '',
		[date] [datetime] NULL,
		--[buyer] [char](5) NOT NULL DEFAULT '',		
		[buyerid] [int] NULL,					-- FK = [buyer].[buyer] --> [buyer].[buyerid]
		--[ven_id] [char](6) NOT NULL DEFAULT '',
		[vendorid] [int] NULL,					-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		--[comp] [char](5) NOT NULL DEFAULT '',
		[componetid] [int] NULL,				-- FK = [componet].[comp] --> [componet].[componetid]
		[total] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[charge1] [numeric](8, 2) NOT NULL DEFAULT 0.0,
		[charge1_desc] [char](40) NOT NULL DEFAULT '',
		[charge2] [numeric](6, 2) NOT NULL,
		[charge2_desc] [char](40) NOT NULL DEFAULT '',
		[sub_total] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[total_qty] [int] NOT NULL DEFAULT 0,
		[notes] [varchar](2000) NOT NULL DEFAULT '',
		[confirm] [char](20) NOT NULL DEFAULT '',
		[tax] [char](1) NOT NULL DEFAULT '',
		[tax_amt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[conf_phone] [bit] NOT NULL DEFAULT 0,
		[cl_room] [bit] NOT NULL DEFAULT 0,
		[rush] [bit] NOT NULL DEFAULT 0,
		[dbl_bag] [bit] NOT NULL DEFAULT 0,
		[fl_cut] [bit] NOT NULL DEFAULT 0,
		[price] [numeric](10, 5) NOT NULL DEFAULT 0.0,
		[tot_bo] [int] NOT NULL DEFAULT 0,
		[tot_recd] [int] NOT NULL DEFAULT 0,
		[tot_recd_rej] [int] NOT NULL DEFAULT 0,
		[tot_recd_acc] [int] NOT NULL DEFAULT 0,
		[comp_rev] [char](2) NOT NULL DEFAULT '',
		--[cusno] [char](5) NOT NULL DEFAULT '',
		[customerid] [int] NULL,					-- FK = [customer].[cust_no] --> [customer].[customerid]
		[cus_po] [char](15) NOT NULL DEFAULT '',
		[ship_via] [char](20) NOT NULL DEFAULT '',
		[fob] [char](15) NOT NULL DEFAULT '',
		--[shven_no] [char](5) NOT NULL DEFAULT '',	
		[venshipid] [int] NULL,						-- FK = [venship].[shven_no] --> [venship].[venshipid]
		[currency] [char](3) NOT NULL DEFAULT '',
		[comp_desc] [char](75) NOT NULL DEFAULT '',
		[comp_desc2] [char](75) NOT NULL DEFAULT '',
		--[material] [char](3) NOT NULL DEFAULT '',	
		[materialid] [int] NULL,					-- FK = [material].[material] --> [material].[materialid]
		--[class] [char](4) NOT NULL DEFAULT '',		
		[classid] [int] NULL,						-- FK = [class].[class] --> [class].[classid]
		[cpmr] [varchar](2000) NOT NULL DEFAULT '',
		[coc] [bit] NOT NULL DEFAULT 0,
		[conf_dlvry] [bit] NOT NULL DEFAULT 0,
		[category] [int] NOT NULL DEFAULT 0,
		[sop10073] [bit] NOT NULL DEFAULT 0,
		[initiator] [char](10) NOT NULL DEFAULT '',
		[kanban] [bit] NOT NULL DEFAULT 0,
		[kbrel_freq] [char](2) NOT NULL DEFAULT '',
		[kbstart_dt] [datetime] NULL,
		[kbrel_qty] [int] NOT NULL DEFAULT 0,
		[mfg_locid] [int] NULL,						-- FK = [mfg_loc].[mfg_locid]
		[prepaid] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_po_hdr] PRIMARY KEY CLUSTERED 
		(
			[po_hdrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT [FK_po_hdrbillto_cust] FOREIGN KEY ([billto_custid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrbuyer] FOREIGN KEY ([buyerid]) REFERENCES [dbo].[buyer] ([buyerid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrvendor] FOREIGN KEY ([vendorid]) REFERENCES [dbo].[vendor] ([vendorid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrcomponet] FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrcustomer] FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrvenship] FOREIGN KEY ([venshipid]) REFERENCES [dbo].[venship] ([venshipid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrmaterial] FOREIGN KEY ([materialid]) REFERENCES [dbo].[material] ([materialid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrclass] FOREIGN KEY ([classid]) REFERENCES [dbo].[class] ([classid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_po_hdrmfg_loc] FOREIGN KEY ([mfg_locid]) REFERENCES [dbo].[mfg_loc] ([mfg_locid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrbillto_cust];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrbuyer];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrvendor];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrcomponet];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrcustomer];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrvenship];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrmaterial];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrclass];
	ALTER TABLE [dbo].[po_hdr] NOCHECK CONSTRAINT [FK_po_hdrmfg_loc];

	CREATE INDEX [idx_po_hdr_po_no] ON [dbo].[po_hdr] ([po_no]);
	
	INSERT INTO [dbo].[po_hdr] 
		SELECT --pohdr.* 
			pohdr.[po_no]
			,pohdr.[status]
			,pohdr.[po_rev]
			,pohdr.[rev_date]
			--,pohdr.[bill_to]
			,ISNULL(billto.[customerid], NULL) as [billto_custid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
			--,pohdr.[ship_to]
			,pohdr.[date]
			--,pohdr.[buyer]
			,ISNULL(buyer.[buyerid], NULL) AS [buyerid]				-- FK = [buyer].[buyer] --> [buyer].[buyerid]
			--,pohdr.[ven_id]
			,ISNULL(vendor.[vendorid], NULL) AS [vendorid]			-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
			--,pohdr.[comp]
			,ISNULL(componet.[componetid], NULL) AS [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
			,pohdr.[total]
			,pohdr.[charge1]
			,pohdr.[charge1_desc]
			,pohdr.[charge2]
			,pohdr.[charge2_desc]
			,pohdr.[sub_total]
			,pohdr.[total_qty]
			,pohdr.[notes]
			,pohdr.[confirm]
			,pohdr.[tax]
			,pohdr.[tax_amt]
			,pohdr.[conf_phone]
			,pohdr.[cl_room]
			,pohdr.[rush]
			,pohdr.[dbl_bag]
			,pohdr.[fl_cut]
			,pohdr.[price]
			,pohdr.[tot_bo]
			,pohdr.[tot_recd]
			,pohdr.[tot_recd_rej]
			,pohdr.[tot_recd_acc]
			,pohdr.[comp_rev]
			--,pohdr.[cusno]	
			,ISNULL(customer.[customerid], NULL) as [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
			,pohdr.[cus_po]
			,pohdr.[ship_via]
			,pohdr.[fob]
			--,pohdr.[shven_no]	
			,ISNULL(venship.[venshipid], NULL) as [venshipid]		-- FK = [venship].[shven_no] --> [venship].[venshipid]
			,pohdr.[currency]
			,pohdr.[comp_desc]
			,pohdr.[comp_desc2]
			--,pohdr.[material]
			,ISNULL(material.[materialid], NULL) as [materialid]	-- FK = [material].[material] --> [material].[materialid]
			--,pohdr.[class]
			,ISNULL(class.[classid], NULL) as [classid]				-- FK = [class].[class] --> [class].[classid]
			,pohdr.[cpmr]
			,pohdr.[coc]
			,pohdr.[conf_dlvry]
			,pohdr.[category]
			,pohdr.[sop10073]
			,pohdr.[initiator]
			,pohdr.[kanban]
			,pohdr.[kbrel_freq]
			,pohdr.[kbstart_dt]
			,pohdr.[kbrel_qty]
			,pohdr.[mfg_locid]
			,pohdr.[prepaid]		
		FROM 
			(SELECT [po_no]
				  ,MAX([po_rev]) AS [po_rev]
				  ,MAX([date]) AS [date]
				  ,MAX([tot_recd]) AS [tot_recd]
			  FROM [rawUpsize_Contech].[dbo].[po_hdr]
			  GROUP BY [po_no]) AS latest_pohdr
		INNER JOIN [rawUpsize_Contech].[dbo].[po_hdr] pohdr
			ON pohdr.[po_no] = latest_pohdr.[po_no] 
				AND pohdr.[po_rev] = latest_pohdr.[po_rev]
				AND pohdr.[date] = latest_pohdr.[date]
				AND pohdr.[tot_recd] = latest_pohdr.[tot_recd]
		LEFT JOIN [dbo].[customer] billto
			ON pohdr.[bill_to] = billto.[cust_no] 
		LEFT JOIN [dbo].[buyer] buyer 
			ON pohdr.[buyer] = buyer.[buyer]
		LEFT JOIN [dbo].[vendor] vendor 
			ON pohdr.[ven_id] = vendor.[ven_id]
		LEFT JOIN [dbo].[componet] componet
			ON pohdr.[comp] = componet.[comp] 
		LEFT JOIN [dbo].[customer] customer
			ON pohdr.[cusno] = customer.[cust_no] 
		LEFT JOIN [dbo].[venship] venship
			ON pohdr.[shven_no] = venship.[shven_no] 
		LEFT JOIN [dbo].[material] material
			ON pohdr.[material] = material.[material] 
		LEFT JOIN [dbo].[class] class
			ON pohdr.[class] = class.[class] 
		ORDER BY pohdr.[date],pohdr.[po_no]	

	--SELECT * FROM [dbo].[po_hdr]
  
    PRINT 'Table: dbo.po_hdr: end'

-- =========================================================
-- Section 007: po_dtl -- Moved from Section 005
-- =========================================================

-- Column changes:
--  - Added [po_dtlid] to be primary key
--  - Added [po_hdrid] as the FK to reference [po_hdr]
--  - Removed [po_no] [char](8) column. That data can be found in [po_hdr] table referenced by [po_hdrid] column
--  - Changed [exp] from [text] to [varchar](3000) | Note: raised amount because there was a truncation error

    PRINT 'Table: dbo.po_dtl: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'po_dtl'))
	BEGIN	
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('po_dtl')) > 0)
		BEGIN
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('po_dtl')
			PRINT (@SQL)	
			EXEC (@SQL)		
		END

		DROP TABLE [dbo].[po_dtl]
		PRINT 'Table [dbo].[po_dtl] dropped'
	END

	CREATE TABLE [dbo].[po_dtl](
		[po_dtlid] [int] IDENTITY(1,1) NOT NULL,
		[po_hdrid] [int] NOT NULL,			-- FK = [po_hdr].[po_hdrid]
		--[po_no] [char](8) NOT NULL DEFAULT '',
		[ref_no] [numeric](2, 0) NOT NULL DEFAULT 0,
		[due_date] [datetime] NULL,
		[amt_due] [int] NOT NULL DEFAULT 0,
		[price] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[comment] [char](25) NOT NULL DEFAULT '',
		[exp] [varchar](3000) NOT NULL DEFAULT '',
		[kbfixed] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_po_dtl] PRIMARY KEY CLUSTERED 
		(
			[po_dtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_po_hdrpo_dtl FOREIGN KEY ([po_hdrid]) REFERENCES [dbo].[po_hdr] (po_hdrid) ON DELETE CASCADE NOT FOR REPLICATION
	) ON [PRIMARY] 

	INSERT INTO [dbo].[po_dtl] (po_hdrid,[ref_no],[due_date],[amt_due],[price],[comment],[exp],[kbfixed])
	SELECT ISNULL(po_hdr.[po_hdrid], 0) AS [po_hdrid]
		  --,[rawUpsize_Contech].[dbo].[po_dtl].[po_no]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[ref_no]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[due_date]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[amt_due]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[price]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[comment]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[exp]
		  ,[rawUpsize_Contech].[dbo].[po_dtl].[kbfixed]
	FROM [rawUpsize_Contech].[dbo].[po_dtl]
	LEFT JOIN [dbo].[po_hdr] po_hdr ON [rawUpsize_Contech].[dbo].[po_dtl].po_no = po_hdr.[po_no]
	WHERE po_hdr.[po_hdrid] IS NOT NULL
	ORDER BY 1

    PRINT 'Table: dbo.po_dtl: end'
	
	--sp_help '[dbo].[po_hdr]'
	--SELECT * FROM [dbo].[po_hdr]
	--SELECT * FROM [dbo].[po_dtl]	
	
-- =========================================================
-- Section 007: issues -- Moved from section015
-- =========================================================

-- Column changes:
--  - Changed [issuesid] to be primary key
--  - Changed [issuesid] to [issueid]

    PRINT 'Table: dbo.issues: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issues')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('issues')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('issues')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[issues]
		PRINT 'Table [dbo].[issues] dropped'
    END

	CREATE TABLE [dbo].[issues](
		[issueid] [int] IDENTITY(1,1) NOT NULL,
		[issue_type] [char](15) NOT NULL DEFAULT '',
		[issue_desc] [char](35) NOT NULL DEFAULT '',
		CONSTRAINT [PK_issues] PRIMARY KEY CLUSTERED 
		(
			[issueid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[issues] ON;

	INSERT INTO [dbo].[issues] ([issueid],[issue_type],[issue_desc])
	SELECT [issuesid]
		  ,[issue_type]
		  ,[issue_desc]
	  FROM [rawUpsize_Contech].[dbo].[issues]
  
	SET IDENTITY_INSERT [dbo].[issues] OFF;

	--SELECT * FROM [dbo].[issues]
	
    PRINT 'Table: dbo.issues: end'
	
-- =========================================================
-- Section 007: issuesdt -- Moved from section015
-- =========================================================

-- Column changes:
--  - Changed [issuesdtid] to be primary key
-- Maps:
--	- [issuesdtid].[issueid]	-- FK = [issues].[issueid] 

    PRINT 'Table: dbo.issuesdt: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issuesdt')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('issuesdt')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('issuesdt')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[issuesdt]
		PRINT 'Table [dbo].[issuesdt] dropped'
    END

	CREATE TABLE [dbo].[issuesdt](
		[issuesdtid] [int] IDENTITY(1,1) NOT NULL,
		[issuesid] [int] NOT NULL DEFAULT 0,			-- FK = [issues].[issueid] 
		[dtl_code] [char](2) NOT NULL DEFAULT '',
		[issue_dtl] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_issuesdt] PRIMARY KEY CLUSTERED 
		(
			[issuesdtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_issues_issuesdt FOREIGN KEY ([issuesid]) REFERENCES [dbo].[issues] ([issueid]) ON DELETE CASCADE NOT FOR REPLICATION 
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[issuesdt] ON;

	INSERT INTO [dbo].[issuesdt] ([issuesdtid],[issuesid],[dtl_code],[issue_dtl])
	SELECT [issuesdtid]		-- FK = [issues].[issueid] 
		  ,[issuesid]
		  ,[dtl_code]
		  ,[issue_dtl]
	  FROM [rawUpsize_Contech].[dbo].[issuesdt]
  
	SET IDENTITY_INSERT [dbo].[issuesdt] OFF;

	--SELECT * FROM [dbo].[issuesdt]

    PRINT 'Table: dbo.issuesdt: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section007_HR.sql'

-- =========================================================
