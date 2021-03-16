-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section039_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 039: ord_pend
-- =========================================================

-- Column changes:
--  - Added [ord_pendid] to be primary key
--	- Added [orderid] [int]	to reference [orders] table 
--  - Removed columns [job_no] & [job_rev]
--	- Added [bom_hdrid] [int] to reference [bom_hdr] table
--  - Removed columns [bom_no] & [bom_rev]
-- Maps:
--	- [ord_pend].[ordersid]		-- FK = [orders].[job_no] + [orders].[job_rev] == [orders].[ordersid]
--	- [ord_pend].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

    PRINT 'Table: dbo.ord_pend: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ord_pend')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('ord_pend')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('ord_pend')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[ord_pend]
		PRINT 'Table [dbo].[ord_pend] dropped'
    END

	CREATE TABLE [dbo].[ord_pend](
		[ord_pendid] [int] IDENTITY(1,1) NOT NULL,
		[orderid] [int] NULL,							-- FK = [orders].[job_no] + [orders].[job_rev] == [orders].[orderid]
		--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no]
		--[job_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [orders].[job_rev]
		[status] [char](1) NOT NULL DEFAULT '',
		[date] [datetime] NULL,
		[bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
		[part_no] [char](15) NOT NULL DEFAULT '',
		[part_rev] [char](10) NOT NULL DEFAULT '',
		[cust_po] [char](15) NOT NULL DEFAULT '',
		[n_bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,
		CONSTRAINT [PK_ord_pend] PRIMARY KEY CLUSTERED 
		(
			[ord_pendid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_ord_pend_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_ord_pend_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[ord_pend] NOCHECK CONSTRAINT [FK_ord_pend_orders];
	ALTER TABLE [dbo].[ord_pend] NOCHECK CONSTRAINT [FK_ord_pend_bom_hdr];

	INSERT INTO [dbo].[ord_pend] ([orderid],[status],[date],[bom_hdrid],[part_no],[part_rev],[cust_po],[n_bom_rev])
	SELECT ISNULL(orders.[orderid], NULL) as [orderid]
		  -- [rawUpsize_Contech].[dbo].[ord_pend].[job_no]
		  --,[rawUpsize_Contech].[dbo].[ord_pend].[job_rev]
		  ,[rawUpsize_Contech].[dbo].[ord_pend].[status]
		  ,[rawUpsize_Contech].[dbo].[ord_pend].[date]
		  ,ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
		  --,[rawUpsize_Contech].[dbo].[ord_pend].[bom_no]
		  --,[rawUpsize_Contech].[dbo].[ord_pend].[bom_rev]
		  ,[rawUpsize_Contech].[dbo].[ord_pend].[part_no]
		  ,[rawUpsize_Contech].[dbo].[ord_pend].[part_rev]
		  ,[rawUpsize_Contech].[dbo].[ord_pend].[cust_po]
		  ,[rawUpsize_Contech].[dbo].[ord_pend].[n_bom_rev]
	  FROM [rawUpsize_Contech].[dbo].[ord_pend]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[ord_pend].[job_no] = orders.[job_no] AND [rawUpsize_Contech].[dbo].[ord_pend].[job_rev] = orders.[job_rev] 
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[ord_pend].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[ord_pend].[bom_rev] = bom_hdr.[bom_rev] 

	--SELECT * FROM [dbo].[ord_pend]

    PRINT 'Table: dbo.ord_pend: end'

-- =========================================================
-- Section 039: ordcstpo
-- =========================================================

-- Column changes:
--  - Added [ordcstpoid] to be primary key
--  - Renamed [job_no] to [orderid] to reference [orders] table
-- Maps:
--	- [ordcstpo].[job_no] --> [orderid]		-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [ordcstpo].[custpodtid]				-- FK = [custpodt].[custpodtid]

    PRINT 'Table: dbo.ordcstpo: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ordcstpo')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('ordcstpo')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('ordcstpo')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[ordcstpo]
		PRINT 'Table [dbo].[ordcstpo] dropped'
    END

	CREATE TABLE [dbo].[ordcstpo](
		[ordcstpoid] [int] IDENTITY(1,1) NOT NULL,
		--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] 
		[orderid] [int] NULL,							-- FK = [orders].[job_no] --> [orders].[orderid]     
		[custpodtid] [int] NULL,						-- FK = [custpodt].[custpodtid]
		CONSTRAINT [PK_ordcstpo] PRIMARY KEY CLUSTERED 
		(
			[ordcstpoid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_ordcstpo_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_ordcstpo_custpodt FOREIGN KEY ([custpodtid]) REFERENCES [dbo].[custpodt] ([custpodtid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[ordcstpo] NOCHECK CONSTRAINT [FK_ordcstpo_orders];
	ALTER TABLE [dbo].[ordcstpo] NOCHECK CONSTRAINT [FK_ordcstpo_custpodt];

	SET IDENTITY_INSERT [dbo].[ordcstpo] ON;

	INSERT INTO [dbo].[ordcstpo] ([ordcstpoid],[orderid],[custpodtid])
	SELECT [rawUpsize_Contech].[dbo].[ordcstpo].[ordcstpoid]
		  --,[rawUpsize_Contech].[dbo].[ordcstpo].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [orderid]		-- FK = [orders].[job_no] --> [orders].[orderid]     
		  ,[rawUpsize_Contech].[dbo].[ordcstpo].[custpodtid]
	  FROM [rawUpsize_Contech].[dbo].[ordcstpo]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[ordcstpo].[job_no] = orders.[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
  
	SET IDENTITY_INSERT [dbo].[ordcstpo] OFF;

	--SELECT * FROM [dbo].[ordcstpo]

    PRINT 'Table: dbo.ordcstpo: end'

-- =========================================================
-- Section 039: poconfrm
-- =========================================================

-- Column changes:
--  - Added [poconfrmid] to be primary key
--  - Changed [po_no] [char](8) to [po_hdrid] [int] to reference [po_hdr] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [confirm_user] [char](10) to [confirm_userid] [int] to reference [users] table
--  - Changed [unconfirm_user] [char](10) to [unconfirm_userid] [int] to reference [users] table
-- Maps:
--	- [poconfrm].[po_no] --> [po_hdrid]						-- FK = [po_hdr].[po_no] -> [po_hdr].[po_hdrid]
--	- [poconfrm].[add_user]	--> [add_userid]				-- FK = [users].[username] --> [users].[userid]
--	- [poconfrm].[confirm_user]	--> [confirm_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [poconfrm].[unconfirm_user] --> [unconfirm_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.poconfrm: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'poconfrm')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('poconfrm')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('poconfrm')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[poconfrm]
		PRINT 'Table [dbo].[poconfrm] dropped'
    END

	CREATE TABLE [dbo].[poconfrm](
		[poconfrmid] [int] IDENTITY(1,1) NOT NULL,
		--[po_no] [char](8) NOT NULL DEFAULT '',			-- FK = [po_hdr].[po_no] 
		[po_hdrid] [int] NULL,								-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',		-- FK = [users].[username]
		[add_userid] [int] NULL,							-- FK = [users].[username] --> [users].[userid]
		[confirm_dt] [datetime] NULL,
		--[confirm_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[confirm_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[lastremind] [datetime] NULL,
		[unconfirm_dt] [datetime] NULL,
		--[unconfirm_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[unconfirm_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_poconfrm] PRIMARY KEY CLUSTERED 
		(
			[poconfrmid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_poconfrm_po_hdr FOREIGN KEY ([po_hdrid]) REFERENCES [dbo].[po_hdr] ([po_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_poconfrm_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_poconfrm_confirm_user FOREIGN KEY ([confirm_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_poconfrm_unconfirm_user FOREIGN KEY ([unconfirm_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[poconfrm] NOCHECK CONSTRAINT [FK_poconfrm_po_hdr];
	ALTER TABLE [dbo].[poconfrm] NOCHECK CONSTRAINT [FK_poconfrm_add_user];
	ALTER TABLE [dbo].[poconfrm] NOCHECK CONSTRAINT [FK_poconfrm_confirm_user];
	ALTER TABLE [dbo].[poconfrm] NOCHECK CONSTRAINT [FK_poconfrm_unconfirm_user];

	SET IDENTITY_INSERT [dbo].[poconfrm] ON;

	INSERT INTO [dbo].[poconfrm] ([poconfrmid],[po_hdrid],[add_dt],[add_userid],[confirm_dt],[confirm_userid],[lastremind],[unconfirm_dt],[unconfirm_userid])
	SELECT DISTINCT
		  [rawUpsize_Contech].[dbo].[poconfrm].[poconfrmid]
		  --,[rawUpsize_Contech].[dbo].[poconfrm].[po_no]
		  ,ISNULL(po_hdr.[po_hdrid], NULL) AS [po_hdrid]		-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
		  ,[rawUpsize_Contech].[dbo].[poconfrm].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[poconfrm].[add_user]
		  ,ISNULL(add_user.[userid], NULL) as [add_userid]			
		  ,[rawUpsize_Contech].[dbo].[poconfrm].[confirm_dt]
		  --,[rawUpsize_Contech].[dbo].[poconfrm].[confirm_user]
		  ,ISNULL(confirm_user.[userid], NULL) as [confirm_userid]			
		  ,[rawUpsize_Contech].[dbo].[poconfrm].[lastremind]
		  ,[rawUpsize_Contech].[dbo].[poconfrm].[unconfirm_dt]
		  --,[rawUpsize_Contech].[dbo].[poconfrm].[unconfirm_user]
		  ,ISNULL(unconfirm_user.[userid], NULL) as [unconfirm_userid]			
	  FROM [rawUpsize_Contech].[dbo].[poconfrm]
	  LEFT JOIN [dbo].[po_hdr] po_hdr ON [rawUpsize_Contech].[dbo].[poconfrm].[po_no] = po_hdr.[po_no]							-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
	  LEFT JOIN [dbo].[users] add_user ON [rawUpsize_Contech].[dbo].[poconfrm].[add_user] = add_user.[username]					-- FK = [users].[username] --> [users].[userid]
	  LEFT JOIN [dbo].[users] confirm_user ON [rawUpsize_Contech].[dbo].[poconfrm].[confirm_user] = confirm_user.[username]		-- FK = [users].[username] --> [users].[userid]
	  LEFT JOIN [dbo].[users] unconfirm_user ON [rawUpsize_Contech].[dbo].[poconfrm].[unconfirm_user] = unconfirm_user.[username]	-- FK = [users].[username] --> [users].[userid]
	  ORDER BY [rawUpsize_Contech].[dbo].[poconfrm].[poconfrmid] 

	SET IDENTITY_INSERT [dbo].[poconfrm] OFF;

	--SELECT * FROM [dbo].[poconfrm]

    PRINT 'Table: dbo.poconfrm: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section039_HR.sql'

-- =========================================================