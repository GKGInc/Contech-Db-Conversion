-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section038_HR.sql'

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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'lottranx'))
		DROP TABLE [dbo].[lottranx]

	CREATE TABLE [dbo].[lottranx](
		[lottranxid] [int] IDENTITY(1,1) NOT NULL,
		[cmpcasesid] [int] NOT NULL DEFAULT 0,		-- FK = [cmpcases].[cmpcasesid]
		[old_caseid] [int] NOT NULL DEFAULT 0,
		--[comp] [char](5) NOT NULL DEFAULT '',		-- Note: comp + lot can be removed, cmpcases has this info
		--[ct_lot] [char](4) NOT NULL DEFAULT '',	-- Note: comp + lot can be removed, cmpcases has this info
		[trx_qty] [int] NOT NULL DEFAULT 0,
		[trx_from] [char](10) NOT NULL DEFAULT '',
		[trx_to] [char](10) NOT NULL DEFAULT '',
		[trx_when] [datetime] NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]	
		[userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[mfg_locid] [int] NOT NULL DEFAULT 0,		-- FK = [mfg_loc].[mfg_locid]
		CONSTRAINT [PK_lottranx] PRIMARY KEY CLUSTERED 
		(
			[lottranxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[lottranx] ON;

	INSERT INTO [dbo].[lottranx] ([lottranxid],[cmpcasesid],[old_caseid],[trx_qty],[trx_from],[trx_to],[trx_when],[userid],[mfg_locid])
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
		  ,ISNULL(users.[userid] , 0) as [userid]				-- FK = [users].[username] --> [users].[userid]
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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matlincr'))
		DROP TABLE [dbo].[matlincr]

	CREATE TABLE [dbo].[matlincr](
		--[matcr_key] [int] IDENTITY(1,1) NOT NULL,
		[matlincrid] [int] IDENTITY(1,1) NOT NULL,
		--[po_no] [char](8) NOT NULL DEFAULT '',		-- FK = [po_hdr].[po_no]
		[po_hdrid] [int] DEFAULT 0,						-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
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
		[qrnid] [int] NOT NULL DEFAULT 0,				-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		[ven_lot] [char](15) NOT NULL DEFAULT '',
		[incoming] [bit] NOT NULL DEFAULT 0,
		--[comp] [char](5) NOT NULL DEFAULT '',			-- FK = [componet].[comp]
		[componetid] [int] NOT NULL DEFAULT 0,			-- FK = [componet].[comp] --> [componet].[componetid]
		CONSTRAINT [PK_matlincr] PRIMARY KEY CLUSTERED 
		(
			[matlincrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[matlincr] ON;

	INSERT INTO [dbo].[matlincr] ([matlincrid],[po_hdrid],[ven_inv],[ven_cr_inv],[cr_amt],[amt_rec],[tot_amt],[date],[date_ret],[ct_cr_no],[memo],[status],[ship],[retur_auth],[dispos],[ct_lot],[qrnid],[ven_lot],[incoming],[componetid])
	SELECT [rawUpsize_Contech].[dbo].[matlincr].[matcr_key]
		  --,[rawUpsize_Contech].[dbo].[matlincr].[po_no]
		  ,ISNULL(po_hdr.[po_hdrid], 0) AS [po_hdrid]			-- FK = [po_hdr].[po_no] -> [po_hdr].[po_hdrid]
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
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[ven_lot]
		  ,[rawUpsize_Contech].[dbo].[matlincr].[incoming]
		  --,[rawUpsize_Contech].[dbo].[matlincr].[comp]
		  ,ISNULL(componet.[componetid], 0) AS [componetid]		-- FK = [componet].[comp] --> [componet].[componetid]
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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matrldoc'))
		DROP TABLE [dbo].[matrldoc]

	CREATE TABLE [dbo].[matrldoc](
		[matrldocid] [int] IDENTITY(1,1) NOT NULL,
		--[material] [char](3) NOT NULL DEFAULT '',		-- FK = [material].[material] 
		[materialid] [int] NOT NULL DEFAULT 0,			-- FK = [material].[material] --> [material].[materialid]
		--[document] [char](15) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document] 
		[docs_dtlid] [int] NOT NULL DEFAULT 0,			-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
		CONSTRAINT [PK_matrldoc] PRIMARY KEY CLUSTERED 
		(
			[matrldocid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [matrldoc] ON;

	INSERT INTO [matrldoc] ([matrldocid],[materialid],[docs_dtlid])
	SELECT [rawUpsize_Contech].[dbo].[matrldoc].[matrldocid]
		  --,[rawUpsize_Contech].[dbo].[matrldoc].[material]
		  ,ISNULL(material.[materialid] , 0) as [materialid]	-- FK = [material].[material] --> [material].[materialid]
		  --,[rawUpsize_Contech].[dbo].[matrldoc].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid] , 0) as [docs_dtlid]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'newdocnotice'))
		DROP TABLE [dbo].[newdocnotice]

	CREATE TABLE [dbo].[newdocnotice](
		[newdocnoticeid] [int] IDENTITY(1,1) NOT NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]	
		[userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[docs_dtlid] [int] NOT NULL DEFAULT 0,		-- FK = [docs_dtl].[docs_dtlid]
		[add_dt] [datetime] NULL,
		[dismiss_dt] [datetime] NULL,
		CONSTRAINT [PK_newdocnotice] PRIMARY KEY CLUSTERED 
		(
			[newdocnoticeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[newdocnotice] ON;

	INSERT INTO [dbo].[newdocnotice] ([newdocnoticeid],[userid],[docs_dtlid],[add_dt],[dismiss_dt])
	SELECT [rawUpsize_Contech].[dbo].[newdocnotice].[pk]
		  --,[rawUpsize_Contech].[dbo].[newdocnotice].[userid]
		  ,ISNULL(users.[userid] , 0) as [userid]					-- FK = [users].[userid]
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