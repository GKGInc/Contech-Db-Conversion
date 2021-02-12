-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section013_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 013: fplocatn
-- =========================================================

-- Column changes:
--  - Change [fplocatnid] to be primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.fplocatn: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fplocatn')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fplocatn')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fplocatn')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fplocatn]
		PRINT 'Table [dbo].[fplocatn] dropped'
    END

	CREATE TABLE [dbo].[fplocatn](
		[fplocatnid] [int] IDENTITY(1,1) NOT NULL,
		[staging] [bit] NOT NULL DEFAULT 0,
		[location] [char](5) NOT NULL DEFAULT '',
		[locfloor] [int] NOT NULL DEFAULT 0,
		[allowmix] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_fplocatn] PRIMARY KEY CLUSTERED 
		(
			[fplocatnid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[fplocatn] ON;

	INSERT INTO [dbo].[fplocatn] ([fplocatnid],[staging],[location],[locfloor],[allowmix])
	SELECT [fplocatnid]
		  ,[staging]
		  ,[location]
		  ,[locfloor]
		  ,[allowmix]
	  FROM [rawUpsize_Contech].[dbo].[fplocatn]
  
	SET IDENTITY_INSERT [dbo].[fplocatn] OFF;

	--SELECT * FROM [dbo].[fplocatn]

    COMMIT

    PRINT 'Table: dbo.fplocatn: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 013: prodctra
-- =========================================================

-- Column changes:
--  - Moved [prodctraid] to first column
--  - Changed [prodctraid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Renamed [complnt_no] to [complntid] to reference [complnts] table
--  - Renamed [job_no] to [orderid] to reference [orders] table

--  - Changed [inspection] from [text] to [varchar](2000)
--  - Changed [mrc_disp] from [text] to [varchar](2000)
--  - Changed [cust_issue] from [text] to [varchar](2000)
-- Maps:
--	- [prodctra].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [prodctra].[complnt_no] --> [complntid]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
--	- [prodctra].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.prodctra: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prodctra')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prodctra')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prodctra')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prodctra]
		PRINT 'Table [dbo].[prodctra] dropped'
    END

	CREATE TABLE [dbo].[prodctra](
		[prodctraid] [int] IDENTITY(1,1) NOT NULL,
		[ra_no] [char](9) NOT NULL DEFAULT '',
		[ra_dt] [datetime] NULL,
		--[invoice_no] [numeric](9, 0) NOT NULL,		-- FK = [aropen].[invoice_no] 
		[aropenid] [int] NULL,							-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[ra_qty] [int] NOT NULL DEFAULT 0,
		--[complnt_no] [int] NOT NULL DEFAULT 0,		-- FK = [complnts].[complnt_no] 
		[complntid] [int] NULL,							-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
		[contact] [char](3) NOT NULL DEFAULT '',
		[ship_via] [char](30) NOT NULL DEFAULT '',
		[rcvd_dt] [datetime] NULL,
		[rcvd_qty] [int] NOT NULL DEFAULT 0,
		[rcvr_init] [char](3) NOT NULL DEFAULT '',
		[rcvd_cond] [char](90) NOT NULL DEFAULT '',
		[inspection] [varchar](2000) NOT NULL DEFAULT '',
		[qasign] [char](50) NOT NULL DEFAULT '',
		[qasign_dt] [datetime] NULL,
		[mrc_disp] [varchar](2000) NOT NULL DEFAULT '',
		[sign2] [char](50) NOT NULL DEFAULT '',
		[sign2_dt] [datetime] NULL,
		[sign1] [char](50) NOT NULL DEFAULT '',
		[sign1_dt] [datetime] NULL,
		[cr_invoice] [numeric](9, 0) NOT NULL DEFAULT 0,
		[officeinit] [char](3) NOT NULL DEFAULT '',
		[credit] [numeric](1, 0) NOT NULL DEFAULT 0,
		[freight] [numeric](1, 0) NOT NULL DEFAULT 0,
		[cust_issue] [varchar](2000) NOT NULL DEFAULT '',
		--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] 
		[orderid] [int] NULL,							-- FK = [orders].[job_no] --> [orders].[orderid]
		[rework_no] [char](10) NOT NULL DEFAULT '',
		[viapay] [char](1) NOT NULL DEFAULT '',
		[shpcustvia] [char](30) NOT NULL DEFAULT '',
		[materltobe] [char](1) NOT NULL DEFAULT '',
		[special] [char](50) NOT NULL DEFAULT '',
		[jobstatus] [char](1) NOT NULL DEFAULT '',
		[disposition] [int] NOT NULL DEFAULT 0,
		[disp_doc] [char](10) NOT NULL DEFAULT '',
		[inspresult] [char](1) NOT NULL DEFAULT '',
		CONSTRAINT [PK_prodctra] PRIMARY KEY CLUSTERED 
		(
			[prodctraid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prodctra_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
		,CONSTRAINT FK_prodctra_complnt FOREIGN KEY ([complntid]) REFERENCES [dbo].[complnts] ([complntid]) ON DELETE NO ACTION
		,CONSTRAINT FK_prodctra_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prodctra] NOCHECK CONSTRAINT [FK_prodctra_aropen];
	ALTER TABLE [dbo].[prodctra] NOCHECK CONSTRAINT [FK_prodctra_complnt];
	ALTER TABLE [dbo].[prodctra] NOCHECK CONSTRAINT [FK_prodctra_orders];

	SET IDENTITY_INSERT [dbo].[prodctra] ON;

	INSERT INTO [dbo].[prodctra] ([prodctraid],[ra_no],[ra_dt],[aropenid],[ra_qty],[complntid],[contact],[ship_via],[rcvd_dt],[rcvd_qty],[rcvr_init],[rcvd_cond],[inspection],[qasign],[qasign_dt],[mrc_disp],[sign2],[sign2_dt],[sign1],[sign1_dt],[cr_invoice],[officeinit],[credit],[freight],[cust_issue],[orderid],[rework_no],[viapay],[shpcustvia],[materltobe],[special],[jobstatus],[disposition],[disp_doc],[inspresult])
	SELECT [rawUpsize_Contech].[dbo].[prodctra].[prodctraid]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[ra_no]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[ra_dt]
		  --,[rawUpsize_Contech].[dbo].[prodctra].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) AS [aropenid]			-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[ra_qty]
		  --,[rawUpsize_Contech].[dbo].[prodctra].[complnt_no]
		  ,ISNULL(complnts.[complntid], NULL) AS [complntid]		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[contact]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[ship_via]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[rcvd_dt]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[rcvd_qty]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[rcvr_init]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[rcvd_cond]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[inspection]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[qasign]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[qasign_dt]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[mrc_disp]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[sign2]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[sign2_dt]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[sign1]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[sign1_dt]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[cr_invoice]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[officeinit]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[credit]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[freight]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[cust_issue]
		  --,[rawUpsize_Contech].[dbo].[prodctra].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [ordersid]				-- FK = [orders].[job_no] --> [orders].[orderid]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[rework_no]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[viapay]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[shpcustvia]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[materltobe]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[special]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[jobstatus]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[disposition]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[disp_doc]
		  ,[rawUpsize_Contech].[dbo].[prodctra].[inspresult]
	  FROM [rawUpsize_Contech].[dbo].[prodctra]
	  LEFT JOIN [dbo].[aropen] aropen ON [rawUpsize_Contech].[dbo].[prodctra].[invoice_no] = aropen.[invoice_no]		-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	  LEFT JOIN [dbo].[complnts] complnts ON [rawUpsize_Contech].[dbo].[prodctra].[complnt_no] = complnts.[complnt_no]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[prodctra].[job_no] = orders.[job_no]				-- FK = [orders].[job_no] --> [orders].[orderid]
  
	SET IDENTITY_INSERT [dbo].[prodctra] OFF;

	--SELECT * FROM [dbo].[prodctra]

    COMMIT

    PRINT 'Table: dbo.prodctra: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 013: prodschd
-- =========================================================

-- Column changes:
--  - Changed prodschdid to be primary key
--  - Changed empnumber to int to reference employee table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
--  - Renamed [job_no] to [orderid] to reference [orders] table
--  - Changed [comments] from [text] to [varchar](2000)
-- Maps:
--	- [prodschd].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid] 
--	- [prodschd].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.prodschd: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prodschd')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prodschd')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prodschd')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prodschd]
		PRINT 'Table [dbo].[prodschd] dropped'
    END

	CREATE TABLE [dbo].[prodschd](
		[prodschdid] [int] IDENTITY(1,1) NOT NULL,
		--[empnumber] [char](10) NOT NULL DEFAULT '', -- FK = [employee].[empnumber] 
		[employeeid] [int] NULL,					-- FK = [employee].[empnumber] --> [employee].[employeeid] 
		--[job_no] [int] NOT NULL DEFAULT 0,		-- FK = [orders].[job_no] 
		[orderid] [int] NULL,						-- FK = [orders].[job_no] --> [orders].[orderid]
		[start_date] [datetime] NULL,
		[end_date] [datetime] NULL,
		[qty_comp] [numeric](7, 0) NOT NULL DEFAULT 0,
		[comments] varchar(2000) NOT NULL DEFAULT '',
		[totemps] [int] NOT NULL DEFAULT 0,
		[calcdstart] [datetime] NULL,
		CONSTRAINT [PK_prodschd] PRIMARY KEY CLUSTERED 
		(
			[prodschdid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prodschd_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_prodschd_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[prodschd] NOCHECK CONSTRAINT [FK_prodschd_employee];
	ALTER TABLE [dbo].[prodschd] NOCHECK CONSTRAINT [FK_prodschd_orders];

	SET IDENTITY_INSERT [dbo].[prodschd] ON;

	INSERT INTO [dbo].[prodschd] ([prodschdid],[employeeid],[orderid],[start_date],[end_date],[qty_comp],[comments],[totemps],[calcdstart])
	SELECT [rawUpsize_Contech].[dbo].[prodschd].[prodschdid]
		  --,[rawUpsize_Contech].[dbo].[prodschd].[empnumber]
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid] 
		  --,[rawUpsize_Contech].[dbo].[prodschd].[job_no]
		  ,ISNULL(orders.[orderid], 0) AS [ordersid]		-- FK = [orders].[job_no] --> [orders].[ordersid]
		  ,[rawUpsize_Contech].[dbo].[prodschd].[start_date]
		  ,[rawUpsize_Contech].[dbo].[prodschd].[end_date]
		  ,[rawUpsize_Contech].[dbo].[prodschd].[qty_comp]
		  ,[rawUpsize_Contech].[dbo].[prodschd].[comments]
		  ,[rawUpsize_Contech].[dbo].[prodschd].[totemps]
		  ,[rawUpsize_Contech].[dbo].[prodschd].[calcdstart]
	  FROM [rawUpsize_Contech].[dbo].[prodschd]  
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[prodschd].[empnumber] = employee.[empnumber]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[prodschd].[job_no] = orders.[job_no]
	  
	SET IDENTITY_INSERT [dbo].[prodschd] OFF;

	--SELECT * FROM [dbo].[prodschd]

    COMMIT

    PRINT 'Table: dbo.prodschd: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 013: prodtabl
-- =========================================================

-- Column changes:
--  - Changed [prodtablid] to be primary key
-- Maps:
--	- [prodtabl].[prodschdid]	-- FK = [prodschd].[prodschdid] 

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.prodtabl: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prodtabl')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prodtabl')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prodtabl')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[prodtabl]
		PRINT 'Table [dbo].[prodtabl] dropped'
    END

	CREATE TABLE [dbo].[prodtabl](
		[prodtablid] [int] IDENTITY(1,1) NOT NULL,
		[prodschdid] [int] NOT NULL DEFAULT 0,	-- FK = [prodschd].[prodschdid]
		[table] [char](10) NOT NULL DEFAULT '',
		CONSTRAINT [PK_prodtabl] PRIMARY KEY CLUSTERED 
		(
			[prodtablid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prodtabl_prodschd FOREIGN KEY ([prodschdid]) REFERENCES [dbo].[prodschd] ([prodschdid]) ON DELETE CASCADE NOT FOR REPLICATION 
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prodtabl] NOCHECK CONSTRAINT [FK_prodtabl_prodschd];

	SET IDENTITY_INSERT [dbo].[prodtabl] ON;

	INSERT INTO [dbo].[prodtabl] ([prodtablid],[prodschdid],[table])
	SELECT [prodtablid]
		  ,[prodschdid]
		  ,[table]
	  FROM [rawUpsize_Contech].[dbo].[prodtabl]
  
	SET IDENTITY_INSERT [dbo].[prodtabl] OFF;

	--SELECT * FROM [dbo].[prodtabl]

    COMMIT

    PRINT 'Table: dbo.prodtabl: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section044_HR.sql'

-- =========================================================