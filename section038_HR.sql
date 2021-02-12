-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section038_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 038: lottranx
-- =========================================================

-- Column changes:
--  - Set [lottranxid] to be primary key
--  - Removed [comp] [char](5). cmpcases has this info
--  - Removed [ct_lot] [char](4). cmpcases has this info
--  - Changed [userid] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [lottranx].[cmpcasesid]	-- FK = [cmpcases].[cmpcasesid]
--	- [rev_rel].[userid]		-- FK = [users].[username] --> [users].[userid]
--	- [lottranx].[mfg_locid]	-- FK = [mfg_loc].[mfg_locid]

    PRINT 'Table: dbo.lottranx: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lottranx')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('lottranx')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('lottranx')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[lottranx]
		PRINT 'Table [dbo].[lottranx] dropped'
    END

	CREATE TABLE [dbo].[lottranx](
		[lottranxid] [int] IDENTITY(1,1) NOT NULL,
		[cmpcaseid] [int]NULL,						-- FK = [cmpcases].[cmpcaseid]
		[old_caseid] [int] NOT NULL DEFAULT 0,
		--[comp] [char](5) NOT NULL DEFAULT '',		-- Note: comp + lot can be removed, cmpcases has this info
		--[ct_lot] [char](4) NOT NULL DEFAULT '',	-- Note: comp + lot can be removed, cmpcases has this info
		[trx_qty] [int] NOT NULL DEFAULT 0,
		[trx_from] [char](10) NOT NULL DEFAULT '',
		[trx_to] [char](10) NOT NULL DEFAULT '',
		[trx_when] [datetime] NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]	
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[mfg_locid] [int] NULL,						-- FK = [mfg_loc].[mfg_locid]
		CONSTRAINT [PK_lottranx] PRIMARY KEY CLUSTERED 
		(
			[lottranxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_lottranx_cmpcases FOREIGN KEY ([cmpcaseid]) REFERENCES [dbo].[cmpcases] ([cmpcaseid]) ON DELETE NO ACTION
		,CONSTRAINT FK_lottranx_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_lottranx_mfg_loc FOREIGN KEY ([mfg_locid]) REFERENCES [dbo].[mfg_loc] ([mfg_locid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[lottranx] NOCHECK CONSTRAINT [FK_lottranx_cmpcases];
	ALTER TABLE [dbo].[lottranx] NOCHECK CONSTRAINT [FK_lottranx_users];
	ALTER TABLE [dbo].[lottranx] NOCHECK CONSTRAINT [FK_lottranx_mfg_loc];

	SET IDENTITY_INSERT [dbo].[lottranx] ON;

	INSERT INTO [dbo].[lottranx] ([lottranxid],[cmpcaseid],[old_caseid],[trx_qty],[trx_from],[trx_to],[trx_when],[userid],[mfg_locid])
	SELECT [rawUpsize_Contech].[dbo].[lottranx].[lottranxid]
		  ,[rawUpsize_Contech].[dbo].[lottranx].[cmpcasesid]
		  ,[rawUpsize_Contech].[dbo].[lottranx].[old_caseid]
		  --,[rawUpsize_Contech].[dbo].[lottranx].[comp]		-- Note: comp + lot can be removed, cmpcases has this info
		  --,[rawUpsize_Contech].[dbo].[lottranx].[ct_lot]		-- Note: comp + lot can be removed, cmpcases has this info
		  ,[rawUpsize_Contech].[dbo].[lottranx].[trx_qty]
		  ,[rawUpsize_Contech].[dbo].[lottranx].[trx_from]
		  ,[rawUpsize_Contech].[dbo].[lottranx].[trx_to]
		  ,[rawUpsize_Contech].[dbo].[lottranx].[trx_when]
		  --,[rawUpsize_Contech].[dbo].[lottranx].[userid]
		  ,ISNULL(users.[userid], NULL) as [userid]				-- FK = [users].[username] --> [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[lottranx].[mfg_locid]
	  FROM [rawUpsize_Contech].[dbo].[lottranx]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[lottranx].[userid] = users.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[lottranx] OFF;

	--SELECT * FROM [dbo].[lottranx]

    PRINT 'Table: dbo.lottranx: end'

-- =========================================================
-- Section 038: matlincr
-- =========================================================

-- Column changes:
--  - Changed [matcr_key] to [matlincrid] to be primary key
--  - Changed [po_no] [char](8) to [po_hdrid] [int] to reference [po_hdr] table
--  - Changed [qrn_no] [char](8) to [qrnid] [int] to reference [qrn] table
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Removed [qrn_key] [char](14). date_ret indicates old values. 
-- Maps:
--	- [matlincr].[po_no] --> [po_hdrid]		-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
--	- [matlincr].[qrn_no] --> [qrnid]		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
--	- [matlincr].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.matlincr: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matlincr')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('matlincr')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('matlincr')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[matlincr]
		PRINT 'Table [dbo].[matlincr] dropped'
    END

	CREATE TABLE [dbo].[matlincr](
		--[matcr_key] [int] IDENTITY(1,1) NOT NULL,
		[matlincrid] [int] IDENTITY(1,1) NOT NULL,
		--[po_no] [char](8) NOT NULL DEFAULT '',		-- FK = [po_hdr].[po_no]
		[po_hdrid] [int] NULL,							-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
		[ven_inv] [char](10) NOT NULL DEFAULT '',
		[ven_cr_inv] [char](10) NOT NULL DEFAULT '',
		[cr_amt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[amt_rec] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[tot_amt] [numeric](10, 0) NOT NULL DEFAULT 0,
		[date] [datetime] NULL,
		[date_ret] [datetime] NULL,
		[ct_cr_no] [char](6) NOT NULL DEFAULT '',
		[memo] [char](60) NOT NULL DEFAULT '',
		[status] [char](1) NOT NULL DEFAULT '',
		[ship] [char](10) NOT NULL DEFAULT '',
		[retur_auth] [char](10) NOT NULL DEFAULT '',
		[dispos] [char](10) NOT NULL DEFAULT '',
		[ct_lot] [char](4) NOT NULL DEFAULT '',
		--[qrn_key] [char](14) NOT NULL DEFAULT '',		-- Note: date_ret indicates old values. REMOVE COL
		--[qrn_no] [char](8) NOT NULL DEFAULT '',		-- FK = [qrn].[qrn_no]
		[qrnid] [int] NULL,								-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		[ven_lot] [char](15) NOT NULL DEFAULT '',
		[incoming] [bit] NOT NULL DEFAULT 0,
		--[comp] [char](5) NOT NULL DEFAULT '',			-- FK = [componet].[comp]
		[componetid] [int] NULL,						-- FK = [componet].[comp] --> [componet].[componetid]
		CONSTRAINT [PK_matlincr] PRIMARY KEY CLUSTERED 
		(
			[matlincrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_matlincr_po_hdr FOREIGN KEY ([po_hdrid]) REFERENCES [dbo].[po_hdr] ([po_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_matlincr_qrn FOREIGN KEY ([qrnid]) REFERENCES [dbo].[qrn] ([qrnid]) ON DELETE NO ACTION
		,CONSTRAINT FK_matlincr_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[matlincr] NOCHECK CONSTRAINT [FK_matlincr_po_hdr];
	ALTER TABLE [dbo].[matlincr] NOCHECK CONSTRAINT [FK_matlincr_qrn];
	ALTER TABLE [dbo].[matlincr] NOCHECK CONSTRAINT [FK_matlincr_componet];

	SET IDENTITY_INSERT [dbo].[matlincr] ON;

	INSERT INTO [dbo].[matlincr] ([matlincrid],[po_hdrid],[ven_inv],[ven_cr_inv],[cr_amt],[amt_rec],[tot_amt],[date],[date_ret],[ct_cr_no],[memo],[status],[ship],[retur_auth],[dispos],[ct_lot],[qrnid],[ven_lot],[incoming],[componetid])
	SELECT [rawUpsize_Contech].[dbo].[matlincr].[matcr_key]
		  --,[rawUpsize_Contech].[dbo].[matlincr].[po_no]
		  ,ISNULL(po_hdr.[po_hdrid], NULL) AS [po_hdrid]		-- FK = [po_hdr].[po_no] -> [po_hdr].[po_hdrid]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ven_inv]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ven_cr_inv]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[cr_amt]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[amt_rec]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[tot_amt]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[date]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[date_ret]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ct_cr_no]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[memo]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[status]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ship]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[retur_auth]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[dispos]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ct_lot]
		  --,[rawUpsize_Contech].[dbo].[matlincr].[qrn_key]		-- Note: date_ret indicates old values. REMOVE COL
		  --,[rawUpsize_Contech].[dbo].[matlincr].[qrn_no]
		  ,ISNULL(qrn.[qrnid], NULL) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ven_lot]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[incoming]
		  --,[rawUpsize_Contech].[dbo].[matlincr].[comp]
		  ,ISNULL(componet.[componetid], NULL) AS [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
	  FROM [rawUpsize_Contech].[dbo].[matlincr]
	  LEFT JOIN [dbo].[po_hdr] po_hdr ON [rawUpsize_Contech].[dbo].[matlincr].[po_no] = po_hdr.[po_no]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[matlincr].[qrn_no] = qrn.[qrn_no] 
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[matlincr].[comp] = componet.[comp] 
  
	SET IDENTITY_INSERT [dbo].[matlincr] OFF;

	--SELECT * FROM [dbo].[matlincr]

    PRINT 'Table: dbo.matlincr: end'

-- =========================================================
-- Section 038: matrldoc
-- =========================================================

-- Column changes:
--  - Set [matrldocid] to be primary key
--  - Changed [material] [char](3) to [materialid] [int] to reference [material] table
--  - Changed [document] [char](15) to [docs_dtlid] [int] to reference [docs_dtl] table
-- Maps:
--	- [matrldoc].[material] --> [materialid]	-- FK = [material].[material] --> [material].[materialid]
--	- [matrldoc].[document] --> [docs_dtlid]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]

    PRINT 'Table: dbo.matrldoc: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matrldoc')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('matrldoc')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('matrldoc')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[matrldoc]
		PRINT 'Table [dbo].[matrldoc] dropped'
    END

	CREATE TABLE [dbo].[matrldoc](
		[matrldocid] [int] IDENTITY(1,1) NOT NULL,
		--[material] [char](3) NOT NULL DEFAULT '',		-- FK = [material].[material] 
		[materialid] [int] NULL,						-- FK = [material].[material] --> [material].[materialid]
		--[document] [char](15) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document] 
		[docs_dtlid] [int] NULL,						-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
		CONSTRAINT [PK_matrldoc] PRIMARY KEY CLUSTERED 
		(
			[matrldocid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_matrldoc_material FOREIGN KEY ([materialid]) REFERENCES [dbo].[material] ([materialid]) ON DELETE NO ACTION
		,CONSTRAINT FK_matrldoc_docs_dtl FOREIGN KEY ([docs_dtlid]) REFERENCES [dbo].[docs_dtl] ([docs_dtlid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[matrldoc] NOCHECK CONSTRAINT [FK_matrldoc_material];
	ALTER TABLE [dbo].[matrldoc] NOCHECK CONSTRAINT [FK_matrldoc_docs_dtl];

	SET IDENTITY_INSERT [matrldoc] ON;

	INSERT INTO [matrldoc] ([matrldocid],[materialid],[docs_dtlid])
	SELECT [rawUpsize_Contech].[dbo].[matrldoc].[matrldocid]
		  --,[rawUpsize_Contech].[dbo].[matrldoc].[material]
		  ,ISNULL(material.[materialid], NULL) as [materialid]	-- FK = [material].[material] --> [material].[materialid]
		  --,[rawUpsize_Contech].[dbo].[matrldoc].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid], NULL) as [docs_dtlid]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
	  FROM [rawUpsize_Contech].[dbo].[matrldoc]
	  LEFT JOIN [dbo].[material] material ON [rawUpsize_Contech].[dbo].[matrldoc].[material] = material.[material]	-- FK = [material].[material] --> [material].[materialid]
	  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[matrldoc].[document] = docs_dtl.[document]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
	  --LEFT JOIN [rawUpsize_Contech].[dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[matrldoc].[document] = docs_dtl.[document]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
  
	SET IDENTITY_INSERT [dbo].[matrldoc] OFF;

	--SELECT * FROM [dbo].[matrldoc]

    PRINT 'Table: dbo.matrldoc: end'

-- =========================================================
-- Section 038: newdocnotice
-- =========================================================

-- Column changes:
--  - Changed [pk] to [newdocnoticeid] to be primary key
--  - Changed [userid] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [newdocnotice].[userid]		-- FK = [users].[username] --> [users].[userid]
--	- [newdocnotice].[docs_dtlid]	-- FK = [docs_dtl].[docs_dtlid]

    PRINT 'Table: dbo.newdocnotice: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'newdocnotice')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('newdocnotice')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('newdocnotice')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[newdocnotice]
		PRINT 'Table [dbo].[newdocnotice] dropped'
    END

	CREATE TABLE [dbo].[newdocnotice](
		[newdocnoticeid] [int] IDENTITY(1,1) NOT NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]	
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[docs_dtlid] [int] NULL,					-- FK = [docs_dtl].[docs_dtlid]
		[add_dt] [datetime] NULL,
		[dismiss_dt] [datetime] NULL,
		CONSTRAINT [PK_newdocnotice] PRIMARY KEY CLUSTERED 
		(
			[newdocnoticeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_newdocnotice_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_newdocnotice_docs_dtl FOREIGN KEY ([docs_dtlid]) REFERENCES [dbo].[docs_dtl] ([docs_dtlid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[newdocnotice] NOCHECK CONSTRAINT [FK_newdocnotice_users];
	ALTER TABLE [dbo].[newdocnotice] NOCHECK CONSTRAINT [FK_newdocnotice_docs_dtl];

	SET IDENTITY_INSERT [dbo].[newdocnotice] ON;

	INSERT INTO [dbo].[newdocnotice] ([newdocnoticeid],[userid],[docs_dtlid],[add_dt],[dismiss_dt])
	SELECT [rawUpsize_Contech].[dbo].[newdocnotice].[pk]
		  --,[rawUpsize_Contech].[dbo].[newdocnotice].[userid]
		  ,ISNULL(users.[userid], NULL) as [userid]					-- FK = [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[newdocnotice].[docs_dtlid]	-- FK = [docs_dtl].[docs_dtlid]
		  ,[rawUpsize_Contech].[dbo].[newdocnotice].[add_dt]
		  ,[rawUpsize_Contech].[dbo].[newdocnotice].[dismiss_dt]
	  FROM [rawUpsize_Contech].[dbo].[newdocnotice]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[newdocnotice].[userid] = users.[username]	-- FK = [users].[userid]

	SET IDENTITY_INSERT [dbo].[newdocnotice] OFF;

	--SELECT * FROM [dbo].[newdocnotice]

    PRINT 'Table: dbo.newdocnotice: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section038_HR.sql'

-- =========================================================