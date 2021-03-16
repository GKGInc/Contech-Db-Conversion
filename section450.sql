-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section045_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 045: userrmnd
-- =========================================================

-- Column changes:
--  - Set [userrmndid] to be primary key
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [rev_rel].[add_user]		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.userrmnd: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'userrmnd'))
		DROP TABLE [dbo].[userrmnd]

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'userrmnd')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('userrmnd')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('userrmnd')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[userrmnd]
		PRINT 'Table [dbo].[userrmnd] dropped'
    END

	CREATE TABLE [dbo].[userrmnd](
		[userrmndid] [int] IDENTITY(1,1) NOT NULL,
		--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[reminder] [char](30) NOT NULL DEFAULT '',
		CONSTRAINT [PK_userrmnd] PRIMARY KEY CLUSTERED 
		(
			[userrmndid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_userrmnd_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[userrmnd] NOCHECK CONSTRAINT [FK_userrmnd_users];

	--SET IDENTITY_INSERT [dbo].[userrmnd] ON;

	INSERT INTO [dbo].[userrmnd] ([userid],[reminder])
	SELECT --[rawUpsize_Contech].[dbo].[userrmnd].[userrmndid]
		  --,[rawUpsize_Contech].[dbo].[userrmnd].[userid]
		  ISNULL(users.[userid], NULL) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[userrmnd].[reminder]
	  FROM [rawUpsize_Contech].[dbo].[userrmnd]
	  LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[userrmnd].[userid] = users.[username]	-- FK = [users].[userid]

	--SET IDENTITY_INSERT [dbo].[userrmnd] OFF;

	--SELECT * FROM [dbo].[userrmnd]

    PRINT 'Table: dbo.userrmnd: end'

-- =========================================================
-- Section 045: val_locs
-- =========================================================

-- Column changes:
--  - Set [val_locsid] to be primary key

    PRINT 'Table: dbo.val_locs: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'val_locs')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('val_locs')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('val_locs')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[val_locs]
		PRINT 'Table [dbo].[val_locs] dropped'
    END

	CREATE TABLE [dbo].[val_locs](
		[val_locsid] [int] IDENTITY(1,1) NOT NULL,
		[loc_row] [int] NOT NULL DEFAULT 0,
		[loc_rack] [int] NOT NULL DEFAULT 0,
		[loc_level] [char](2) NOT NULL DEFAULT '',
		[last_inv] [datetime] NULL,
		CONSTRAINT [PK_val_locs] PRIMARY KEY CLUSTERED 
		(
			[val_locsid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[val_locs] ON;

	INSERT INTO [dbo].[val_locs] ([val_locsid],[loc_row],[loc_rack],[loc_level],[last_inv])
	SELECT [rawUpsize_Contech].[dbo].[val_locs].[val_locsid]
		  ,[rawUpsize_Contech].[dbo].[val_locs].[loc_row]
		  ,[rawUpsize_Contech].[dbo].[val_locs].[loc_rack]
		  ,[rawUpsize_Contech].[dbo].[val_locs].[loc_level]
		  ,[rawUpsize_Contech].[dbo].[val_locs].[last_inv]
	  FROM [rawUpsize_Contech].[dbo].[val_locs]
  
	SET IDENTITY_INSERT [dbo].[val_locs] OFF;

	--SELECT * FROM [dbo].[val_locs]

    PRINT 'Table: dbo.val_locs: end'

-- =========================================================
-- Section 045: vendcomp
-- =========================================================

-- Column changes:
--  - Set [vendcompid] to be primary key
--  - Moved [vendcompid] to be first column
--  - Changed [notes] from [text] to [varchar](2000)
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed [ven_id] [char](6) to [vendorid] [int] to reference [vendor] table
--  - Changed [po_no] [char](8) to [po_hdrid] [int] to reference [po_hdr] table
--  - Changed [samp_plan] [char](2)  to [samplanid] [int] to reference [samplans] table
-- Maps:
--	- [vendcomp].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [vendcomp].[ven_id] --> [vendorid]	-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
--	- [vendcomp].[po_no] --> [po_hdrid]		-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]

    PRINT 'Table: dbo.vendcomp: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'vendcomp')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('vendcomp')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('vendcomp')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[vendcomp]
		PRINT 'Table [dbo].[vendcomp] dropped'
    END

	CREATE TABLE [dbo].[vendcomp](
		[vendcompid] [int] IDENTITY(1,1) NOT NULL,
		--[comp] [char](5) NOT NULL DEFAULT '',		-- FK = [componet].[comp]
		[componetid] [int] NULL,					-- FK = [componet].[comp] --> [componet].[componetid]
		--[ven_id] [char](6) NOT NULL DEFAULT '',	-- FK = [vendor].[ven_id] 
		[vendorid] [int] NULL,						-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		[price] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[date] [datetime] NULL,
		--[po_no] [char](8) NOT NULL DEFAULT '',	-- FK = [po_hdr].[po_no]
		[po_hdrid] [int] NULL,						-- FK = [po_hdr].[po_no] --> [po_hdr].[po_hdrid]
		[concur] [bit] NOT NULL DEFAULT 0,
		[prim_sec] [char](1) NOT NULL DEFAULT '',
		[skiplot] [bit] NOT NULL DEFAULT 0,
		[mc] [bit] NOT NULL DEFAULT 0,
		[consign] [bit] NOT NULL DEFAULT 0,
		[leadtime] [char](20) NOT NULL DEFAULT '',
		[notes] [varchar](2000) NOT NULL DEFAULT '',
		[lead_wks] [int] NOT NULL DEFAULT 0,
		[moq] [int] NOT NULL DEFAULT 0,
		--[samp_plan] [char](2) NOT NULL DEFAULT '',	-- FK = [samplans].[code]
		[samplanid] [int] NULL,							-- FK = [samplans].[code] --> [samplans].[samplanid]
		CONSTRAINT [PK_vendcomp] PRIMARY KEY CLUSTERED 
		(
			[vendcompid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_vendcomp_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
		,CONSTRAINT FK_vendcomp_vendor FOREIGN KEY ([vendorid]) REFERENCES [dbo].[vendor] ([vendorid]) ON DELETE NO ACTION
		,CONSTRAINT FK_vendcomp_po_hdr FOREIGN KEY ([po_hdrid]) REFERENCES [dbo].[po_hdr] ([po_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_vendcomp_samplans FOREIGN KEY ([samplanid]) REFERENCES [dbo].[samplans] ([samplanid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[vendcomp] NOCHECK CONSTRAINT [FK_vendcomp_componet];
	ALTER TABLE [dbo].[vendcomp] NOCHECK CONSTRAINT [FK_vendcomp_vendor];
	ALTER TABLE [dbo].[vendcomp] NOCHECK CONSTRAINT [FK_vendcomp_po_hdr];
	ALTER TABLE [dbo].[vendcomp] NOCHECK CONSTRAINT [FK_vendcomp_samplans];

	SET IDENTITY_INSERT [dbo].[vendcomp] ON;

	INSERT INTO [dbo].[vendcomp] ([vendcompid],[componetid],[vendorid],[price],[date],[po_hdrid],[concur],[prim_sec],[skiplot],[mc],[consign],[leadtime],[notes],[lead_wks],[moq],[samplanid])
	SELECT [rawUpsize_Contech].[dbo].[vendcomp].[vendcompid]
		  --,[rawUpsize_Contech].[dbo].[vendcomp].[comp]
		  ,ISNULL(componet.[componetid], NULL) AS [componetid]	-- FK = [componet].[comp] --> [componet].[componetid] 
		  --,[rawUpsize_Contech].[dbo].[vendcomp].[ven_id]
		  ,ISNULL(vendor.[vendorid], NULL) AS [vendorid]		-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[price]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[date]
		  --,[rawUpsize_Contech].[dbo].[vendcomp].[po_no]
		  ,ISNULL(po_hdr.[po_hdrid], NULL) AS [po_hdrid]		-- FK = [po_hdr].[po_no] -> [po_hdr].[po_hdrid]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[concur]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[prim_sec]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[skiplot]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[mc]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[consign]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[leadtime]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[notes]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[lead_wks]
		  ,[rawUpsize_Contech].[dbo].[vendcomp].[moq]
		  --,[rawUpsize_Contech].[dbo].[vendcomp].[samp_plan]
		  ,ISNULL(samplans.[samplanid], NULL) AS [samplanid]	-- FK = [samplans].[code] --> [samplans].[samplanid]
	  FROM [rawUpsize_Contech].[dbo].[vendcomp]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[vendcomp].[comp] = componet.[comp] 
	  LEFT JOIN [dbo].[vendor] vendor ON [rawUpsize_Contech].[dbo].[vendcomp].[ven_id] = vendor.[ven_id]
	  LEFT JOIN [dbo].[po_hdr] po_hdr ON [rawUpsize_Contech].[dbo].[vendcomp].[po_no] = po_hdr.[po_no]
	  LEFT JOIN [dbo].[samplans] samplans ON [rawUpsize_Contech].[dbo].[vendcomp].[po_no] = samplans.[code]
	 ORDER BY [rawUpsize_Contech].[dbo].[vendcomp].[vendcompid]

	SET IDENTITY_INSERT [dbo].[vendcomp] OFF;

	--SELECT * FROM [dbo].[vendcomp]

    PRINT 'Table: dbo.vendcomp: end'
	
-- =========================================================
-- Section 045: vendctct
-- =========================================================

-- Column changes:
--  - Added [vendctctid] to be primary key

    PRINT 'Table: dbo.vendctct: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'vendctct')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('vendctct')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('vendctct')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[vendctct]
		PRINT 'Table [dbo].[vendctct] dropped'
    END

	CREATE TABLE [dbo].[vendctct](
		[vendctctid] [int] IDENTITY(1,1) NOT NULL,
		[ven_id] [char](6) NOT NULL DEFAULT '',
		[first_name] [char](15) NOT NULL DEFAULT '',
		[last_name] [char](25) NOT NULL DEFAULT '',
		[mi] [char](1) NOT NULL DEFAULT '',
		[department] [char](50) NOT NULL DEFAULT '',
		[email] [char](100) NOT NULL DEFAULT '',
		[ext] [char](4) NOT NULL DEFAULT '',
		[phone] [char](17) NOT NULL DEFAULT '',
		[fax] [char](17) NOT NULL DEFAULT '',
		[job_title] [char](50) NOT NULL DEFAULT '',
		CONSTRAINT [PK_vendctct] PRIMARY KEY CLUSTERED 
		(
			[vendctctid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[vendctct] ([ven_id],[first_name],[last_name],[mi],[department],[email],[ext],[phone],[fax],[job_title])
	SELECT [rawUpsize_Contech].[dbo].[vendctct].[ven_id]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[first_name]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[last_name]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[mi]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[department]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[email]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[ext]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[phone]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[fax]
		  ,[rawUpsize_Contech].[dbo].[vendctct].[job_title]
	  FROM [rawUpsize_Contech].[dbo].[vendctct]
  
	--SELECT * FROM [dbo].[vendctct]

    PRINT 'Table: dbo.vendctct: end'

-- =========================================================
-- Section 045: vendeval
-- =========================================================

-- Column changes:
--  - Set [vendevalid] to be primary key
--  - Changed [comments] from [text] to [varchar](2000)
--  - Changed [ven_id] [char](6) to [vendorid] [int] to reference [vendor] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
-- Maps:
--	- [vendeval].[ven_id] --> [vendorid]		-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
--	- [vendeval].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.vendeval: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'vendeval')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('vendeval')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('vendeval')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[vendeval]
		PRINT 'Table [dbo].[vendeval] dropped'
    END

	CREATE TABLE [dbo].[vendeval](
		[vendevalid] [int] IDENTITY(1,1) NOT NULL,
		--[ven_id] [char](6) NOT NULL DEFAULT '',		-- FK = [vendor].[ven_id] 
		[vendorid] [int] NULL,							-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		[eval_date] [datetime] NULL,
		[eval_code] [char](1) NOT NULL DEFAULT '',
		[poor_work] [bit] NOT NULL DEFAULT 0,
		[poor_service] [bit] NOT NULL DEFAULT 0,
		[fail_dates] [bit] NOT NULL DEFAULT 0,
		[fail_contract] [bit] NOT NULL DEFAULT 0,
		[other] [bit] NOT NULL DEFAULT 0,
		[comments] [varchar](2000) NOT NULL DEFAULT '',
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_vendeval] PRIMARY KEY CLUSTERED 
		(
			[vendevalid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_vendeval_vendor FOREIGN KEY ([vendorid]) REFERENCES [dbo].[vendor] ([vendorid]) ON DELETE NO ACTION
		,CONSTRAINT FK_vendeval_users FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[vendeval] NOCHECK CONSTRAINT [FK_vendeval_vendor];
	ALTER TABLE [dbo].[vendeval] NOCHECK CONSTRAINT [FK_vendeval_users];

	SET IDENTITY_INSERT [dbo].[vendeval] ON;

	INSERT INTO [dbo].[vendeval] ([vendevalid],[vendorid],[eval_date],[eval_code],[poor_work],[poor_service],[fail_dates],[fail_contract],[other],[comments],[add_userid],[add_dt])
	SELECT [rawUpsize_Contech].[dbo].[vendeval].[vendevalid]
		  --,[rawUpsize_Contech].[dbo].[vendeval].[ven_id]
		  ,ISNULL(vendor.[vendorid], NULL) AS [vendorid]		-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[eval_date]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[eval_code]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[poor_work]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[poor_service]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[fail_dates]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[fail_contract]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[other]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[comments]
		  --,[rawUpsize_Contech].[dbo].[vendeval].[add_user]
		  ,ISNULL(users.[userid], NULL) as [userid]				-- FK = [users].[username] --> [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[vendeval].[add_dt]
	  FROM [rawUpsize_Contech].[dbo].[vendeval]
	  LEFT JOIN [dbo].[vendor] vendor ON [rawUpsize_Contech].[dbo].[vendeval].[ven_id] = vendor.[ven_id]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[vendeval].[add_user] = users.[username]	-- FK = [users].[userid]

	SET IDENTITY_INSERT [dbo].[vendeval] OFF;

	--SELECT * FROM [dbo].[vendeval]

    PRINT 'Table: dbo.vendeval: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section045_HR.sql'

-- =========================================================