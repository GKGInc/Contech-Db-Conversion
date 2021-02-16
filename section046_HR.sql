-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section046_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 046: venship -- Moved to section005
-- =========================================================

-- Column changes:
--  - Added [venshipid] to be primary key
-- Maps:
--	- [venship].[mfg_locid]	-- FK = [mfg_loc].[mfg_locid]

 --   PRINT 'Table: dbo.venship: start'

	--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'venship'))
	--	DROP TABLE [dbo].[venship]

	--CREATE TABLE [dbo].[venship](
	--	[venshipid] [int] IDENTITY(1,1) NOT NULL,
	--	[company] [char](35) NOT NULL DEFAULT '',
	--	[shven_no] [char](5) NOT NULL DEFAULT '',
	--	[saddress] [char](35) NOT NULL DEFAULT '',
	--	[saddress2] [char](35) NOT NULL DEFAULT '',
	--	[city] [char](21) NOT NULL DEFAULT '',
	--	[state] [char](3) NOT NULL DEFAULT '',
	--	[zip] [char](11) NOT NULL DEFAULT '',
	--	[ship_via] [char](20) NOT NULL DEFAULT '',
	--	[fob_point] [char](15) NOT NULL DEFAULT '',
	--	[country] [char](10) NOT NULL DEFAULT '',
	--	[mfg_locid] [int] NOT NULL DEFAULT 0,		-- FK = [mfg_loc].[mfg_locid]
	--	CONSTRAINT [PK_venship] PRIMARY KEY CLUSTERED 
	--	(
	--		[venshipid] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	--) ON [PRIMARY]

	--INSERT INTO [dbo].[venship] ([company],[shven_no],[saddress],[saddress2],[city],[state],[zip],[ship_via],[fob_point],[country],[mfg_locid])
	--SELECT [rawUpsize_Contech].[dbo].[venship].[company]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[shven_no]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[saddress]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[saddress2]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[city]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[state]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[zip]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[ship_via]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[fob_point]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[country]
	--	  ,[rawUpsize_Contech].[dbo].[venship].[mfg_locid]
	--  FROM [rawUpsize_Contech].[dbo].[venship]
  
	----SELECT * FROM [dbo].[venship]

 --   PRINT 'Table: dbo.venship: end'

-- =========================================================
-- Section 046: wipshipd
-- =========================================================

-- Column changes:
--  - Set [wipshipdid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [wipshipd].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [wipshipd].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]
--	- [wipshipd].[mod_user] --> [mod_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.wipshipd: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'wipshipd'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('wipshipd')) > 0)
		BEGIN		
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('wipshipd')
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[wipshipd]
	END

	CREATE TABLE [dbo].[wipshipd](
		[wipshipdid] [int] IDENTITY(1,1) NOT NULL,
		--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no]
		[aropenid] [int] NULL,								-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		[ship_qty] [int] NOT NULL DEFAULT 0,
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',		
		[add_userid] [int] NULL,							-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL DEFAULT '',		
		[mod_userid] [int] NULL,							-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_wipshipd] PRIMARY KEY CLUSTERED 
		(
			[wipshipdid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[wipshipd] ON;

	INSERT INTO [dbo].[wipshipd] ([wipshipdid],[aropenid],[ship_qty],[add_dt],[add_userid],[mod_dt],[mod_userid])
	SELECT [rawUpsize_Contech].[dbo].[wipshipd].[wipshipdid]
		  --,[rawUpsize_Contech].[dbo].[wipshipd].[invoice_no]
		  ,ISNULL(aropen.[aropenid], NULL) AS [aropenid] 	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
		  ,[rawUpsize_Contech].[dbo].[wipshipd].[ship_qty]
		  ,[rawUpsize_Contech].[dbo].[wipshipd].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[wipshipd].[add_user]
		  ,ISNULL(add_user.[userid] , NULL) as [add_userid]			
		  ,[rawUpsize_Contech].[dbo].[wipshipd].[mod_dt]
		  --,[rawUpsize_Contech].[dbo].[wipshipd].[mod_user]
		  ,ISNULL(mod_user.[userid], NULL) as [mod_userid]			
	  FROM [rawUpsize_Contech].[dbo].[wipshipd]
	  LEFT JOIN [aropen] aropen ON [rawUpsize_Contech].[dbo].[wipshipd].[invoice_no] = aropen.[invoice_no]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	  LEFT JOIN [users] add_user ON [rawUpsize_Contech].[dbo].[wipshipd].[add_user] = add_user.[username]	-- FK = [users].[userid]
	  LEFT JOIN [users] mod_user ON [rawUpsize_Contech].[dbo].[wipshipd].[mod_user] = mod_user.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[wipshipd] OFF;

	--SELECT * FROM [dbo].[wipshipd]

    PRINT 'Table: dbo.wipshipd: end'
	
-- =========================================================
-- Section 046: wpbaghdr
-- =========================================================

-- Column changes:
--  - Set [wpbaghdrid] to be primary key
--  - Renamed [job_no] to [ordersid] to reference [orders] table
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [wpbagdtl].[cmpcasesid]				-- FK = [cmpcases].[cmpcasesid] 
--	- [wpbagdtl].[req_hdrid]				-- FK = [req_hdr].[req_hdrid]
--	- [wpbagdtl].[job_no] --> [orderid]		-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [wpbagdtl].[add_user]	--> [userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.wpbaghdr: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'wpbaghdr'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('wpbaghdr')) > 0)
		BEGIN		
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('wpbaghdr')
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[wpbaghdr]
	END

	CREATE TABLE [dbo].[wpbaghdr](
		[wpbaghdrid] [int] IDENTITY(1,1) NOT NULL,
		[cmpcaseid] [int] NULL,						-- FK = [cmpcases].[cmpcaseid] 
		[req_hdrid] [int] NULL,						-- FK = [req_hdr].[req_hdrid]
		--[job_no] [int] NOT NULL DEFAULT 0,		-- FK = [orders].[job_no] 
		[orderid] [int] NULL,						-- FK = [orders].[job_no] --> [orders].[orderid]
		[in_qty] [int] NOT NULL DEFAULT 0,
		[rem_qty] [int] NOT NULL DEFAULT 0,
		[in_dt] [datetime] NULL,
		[mod_dt] [datetime] NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_wpbaghdr] PRIMARY KEY CLUSTERED 
		(
			[wpbaghdrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_wpbaghdr_cmpcases FOREIGN KEY ([cmpcaseid]) REFERENCES [dbo].[cmpcases] ([cmpcaseid]) ON DELETE NO ACTION
		,CONSTRAINT FK_wpbaghdr_req_hdr FOREIGN KEY ([req_hdrid]) REFERENCES [dbo].[req_hdr] ([req_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_wpbaghdr_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_wpbaghdr_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[wpbaghdr] NOCHECK CONSTRAINT [FK_wpbaghdr_cmpcases];
	ALTER TABLE [dbo].[wpbaghdr] NOCHECK CONSTRAINT [FK_wpbaghdr_req_hdr];
	ALTER TABLE [dbo].[wpbaghdr] NOCHECK CONSTRAINT [FK_wpbaghdr_orders];
	ALTER TABLE [dbo].[wpbaghdr] NOCHECK CONSTRAINT [FK_wpbaghdr_users];

	SET IDENTITY_INSERT [dbo].[wpbaghdr] ON;

	INSERT INTO [dbo].[wpbaghdr] ([wpbaghdrid],[cmpcaseid],[req_hdrid],[orderid],[in_qty],[rem_qty],[in_dt],[mod_dt],[userid])
	SELECT [rawUpsize_Contech].[dbo].[wpbaghdr].[wpbaghdrid]
		  ,[rawUpsize_Contech].[dbo].[wpbaghdr].[cmpcasesid]
		  ,[rawUpsize_Contech].[dbo].[wpbaghdr].[req_hdrid]
		  --,[rawUpsize_Contech].[dbo].[wpbaghdr].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [orderid]		-- FK = [orders].[job_no] --> [orders].[orderid]     
		  ,[rawUpsize_Contech].[dbo].[wpbaghdr].[in_qty]
		  ,[rawUpsize_Contech].[dbo].[wpbaghdr].[rem_qty]
		  ,[rawUpsize_Contech].[dbo].[wpbaghdr].[in_dt]
		  ,[rawUpsize_Contech].[dbo].[wpbaghdr].[mod_dt]
		  --,[rawUpsize_Contech].[dbo].[wpbaghdr].[userid]
		  ,ISNULL(users.[userid], NULL) as [userid]			-- FK = [users].[username] --> [users].[userid]
	  FROM [rawUpsize_Contech].[dbo].[wpbaghdr]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[wpbaghdr].[job_no] = orders.[job_no]		
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[wpbaghdr].[userid] = users.[username]	
  
	SET IDENTITY_INSERT [dbo].[wpbaghdr] OFF;

	--SELECT * FROM [dbo].[wpbaghdr]

    PRINT 'Table: dbo.wpbaghdr: end'

-- =========================================================
-- Section 046: wpbagdtl
-- =========================================================

-- Column changes:
--  - Set [wpbagdtlid] to be primary key
-- Maps:
--	- [wpbagdtl].[wpbaghdrid]	-- FK = [wpbaghdr].[wpbaghdrid] 
--	- [wpbagdtl].[cmpcaseid]	-- FK = [cmpcases].[cmpcaseid] 

    PRINT 'Table: dbo.wpbagdtl: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'wpbagdtl'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('wpbagdtl')) > 0)
		BEGIN		
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('wpbagdtl')
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[wpbagdtl]
	END

	CREATE TABLE [dbo].[wpbagdtl](
		[wpbagdtlid] [int] IDENTITY(1,1) NOT NULL,
		[wpbaghdrid] [int] NOT NULL DEFAULT 0,		-- FK = [wpbaghdr].[wpbaghdrid] 
		[bar_code] [char](13) NOT NULL DEFAULT '',
		[init_qty] [int] NOT NULL DEFAULT 0,
		[qty] [int] NOT NULL DEFAULT 0,
		[restocked] [bit] NOT NULL DEFAULT 0,
		[restck_qty] [int] NOT NULL DEFAULT 0,
		[out_dt] [datetime] NULL,
		[cmpcaseid] [int] NULL,						-- FK = [cmpcases].[cmpcaseid] 
		CONSTRAINT [PK_wpbagdtl] PRIMARY KEY CLUSTERED 
		(
			[wpbagdtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_wpbagdtl_wpbaghdr FOREIGN KEY ([wpbaghdrid]) REFERENCES [dbo].[wpbaghdr] ([wpbaghdrid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_wpbagdtl_cmpcases FOREIGN KEY ([cmpcaseid]) REFERENCES [dbo].[cmpcases] ([cmpcaseid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[wpbagdtl] NOCHECK CONSTRAINT [FK_wpbagdtl_cmpcases];

	SET IDENTITY_INSERT [dbo].[wpbagdtl] ON;

	INSERT INTO [dbo].[wpbagdtl] ([wpbagdtlid],[wpbaghdrid],[bar_code],[init_qty],[qty],[restocked],[restck_qty],[out_dt],[cmpcaseid])
	SELECT [rawUpsize_Contech].[dbo].[wpbagdtl].[wpbagdtlid]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[wpbaghdrid]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[bar_code]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[init_qty]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[qty]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[restocked]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[restck_qty]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[out_dt]
		  ,[rawUpsize_Contech].[dbo].[wpbagdtl].[cmpcasesid]		
	  FROM [rawUpsize_Contech].[dbo].[wpbagdtl]
	  WHERE [wpbaghdrid] IN (SELECT [wpbaghdrid] FROM [wpbaghdr])

	SET IDENTITY_INSERT [dbo].[wpbagdtl] OFF;

	--SELECT * FROM [dbo].[wpbagdtl]

    PRINT 'Table: dbo.wpbagdtl: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section046_HR.sql'

-- =========================================================