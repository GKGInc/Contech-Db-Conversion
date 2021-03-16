-- ***************************************************
-- Section 024: bomdocs, bompriclog, bomstage, bomtable, buyer
-- ***************************************************

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section024_HR.sql'
DECLARE @SQL varchar(4000)=''

-- ***************************************************
-- table: bomdocs
-- ***************************************************

-- Re-mapped columns:
-- - bom_no   ___ bom_hdrid
-- - bom_rev  _/
-- - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table

-- New columns:
-- - bom_hdrid: replaces bom_no & bom_rev
-- - docs_dtlid

-- Table PK:
-- - bomdocsid: add identity PK

-- FK fields:
-- - bom_hdrid: bom_hdr.bom_hdrid
-- - docs_dtlid: docs_dtl.docs_dtlid

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.bomdocs: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bomdocs')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bomdocs')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bomdocs')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[bomdocs]
		PRINT 'Table [dbo].[bomdocs] dropped'
    END

	CREATE TABLE [dbo].[bomdocs](
		bomdocsid int identity (1, 1),			-- PK = new column
		--[document] [char](15) NOT NULL,
		[docs_dtlid] [int] NULL,				-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
		-- [bom_no] [numeric](5, 0) NOT NULL,
		-- [bom_rev] [numeric](2, 0) NOT NULL,
		[bom_hdrid] [int] NULL,
		[coc] [char](1) default '' NOT NULL,
		CONSTRAINT [PK_bomdocs] PRIMARY KEY CLUSTERED
		(
			[bomdocsid] ASC
		) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_bomdocs_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION --ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_bomdocs_docs_dtl FOREIGN KEY ([docs_dtlid]) REFERENCES [dbo].[docs_dtl] ([docs_dtlid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[bomdocs] NOCHECK CONSTRAINT [FK_bomdocs_bom_hdr];
	ALTER TABLE [dbo].[bomdocs] NOCHECK CONSTRAINT [FK_bomdocs_docs_dtl];

	insert into dbo.bomdocs
	select --document,	
		  ISNULL(docs_dtl.[docs_dtlid], NULL) AS [docs_dtlid], 	
		   -- bom_no,
		   -- bom_rev,
			isnull(bom.bom_hdrid, NULL),
		   coc
	from [rawUpsize_Contech].dbo.bomdocs
	left outer join dbo.bom_hdr bom on bomdocs.bom_no = bom.bom_no and bomdocs.bom_rev = bom.bom_rev
	LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[bomdocs].[document] = docs_dtl.[document]
	
	--SELECT * FROM [bomdocs]

    COMMIT

    PRINT 'Table: dbo.bomdocs: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- ***************************************************
-- table: bompriclog
-- ***************************************************

-- Re-mapped columns:
-- - id (int) -> bompriclogid
-- - job_no -> orderid
-- - add_user -> add_userid

-- Table PK:
-- - bompriclogid: converted existing col to identity PK, also changed the name

-- FK fields:
-- - orderid -> orders.orderid on job_no = orders.job_no
-- - add_userid -> users.userid on add_user = users.username

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.bompriclog: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bompriclog')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bompriclog')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bompriclog')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[bompriclog]
		PRINT 'Table [dbo].[bompriclog] dropped'
    END

	CREATE TABLE [dbo].[bompriclog](
		-- [id] [int] NOT NULL,
		bompriclogid int identity (1, 1),
		[bom_no] [numeric](5, 0) NOT NULL,
		[qty_from] [int] default 0 NOT NULL,
		[qty_to] [int] default 0 NOT NULL,
		[price] [numeric](8, 4) default 0 NOT NULL,
		-- [job_no] [int] NOT NULL,
		[orderid] [int] NULL,
		-- [add_user] [char](10) NOT NULL,
		[add_userid] [int] NULL,
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_bompriclog] PRIMARY KEY CLUSTERED
		(
			[bompriclogid] ASC
		) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_bompriclog_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_bompriclog_users FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[bompriclog] NOCHECK CONSTRAINT [FK_bompriclog_orders];
	ALTER TABLE [dbo].[bompriclog] NOCHECK CONSTRAINT [FK_bompriclog_users];

	set identity_insert dbo.bompriclog ON

	insert into dbo.bompriclog
	(bompriclogid, bom_no, qty_from, qty_to, price, orderid, add_userid, add_dt)
	select id,
		   bom_no,
		   qty_from,
		   qty_to,
		   bompriclog.price,
		   -- job_no,
		   isnull(ord.orderid, NULL),
		   -- add_user,
		   isnull(addu.userid, NULL),
		   bompriclog.add_dt
	from [rawUpsize_Contech].dbo.bompriclog
	inner join dbo.orders ord ON bompriclog.job_no = ord.job_no
	left outer join dbo.users addu ON bompriclog.add_user = addu.username

	set identity_insert dbo.bompriclog OFF

	--SELECT * FROM [bompriclog]

    COMMIT

    PRINT 'Table: dbo.bompriclog: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- ***************************************************
-- Table: bomstage
-- ***************************************************

-- Column changes:
--  - Set [bomstageid] to be primary key
--  - Removed [bom_no] column. It is not being used.
-- Maps:
--	- [bomstage].[bom_no]		-- FK = [bom_hdr].[bom_no] 
--	- [bomstage].[mfgstageid]	-- FK = [mfgstage].[mfgstageid] 
-- Notes:
--  - Could not link [bomstage].[bom_no] to [bom_hdr].[bom_no]. Multiple [bom_rev] entries for [bom_no] values

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.bomstage: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bomstage')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bomstage')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bomstage')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[bomstage]
		PRINT 'Table [dbo].[bomstage] dropped'
    END

	CREATE TABLE [dbo].[bomstage](
		[bomstageid] [int] IDENTITY(1,1) NOT NULL,
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no] 
		[mfgstageid] [int] NULL,						-- FK = [mfgstage].[mfgstageid] 
		[sort_order] [int] NOT NULL DEFAULT 0,
		[mfg_no] [numeric](5, 0) NOT NULL DEFAULT 0,
		CONSTRAINT [PK_bomstage] PRIMARY KEY CLUSTERED
		(
			[bomstageid] ASC
		) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_bomstage_mfgstage FOREIGN KEY ([mfgstageid]) REFERENCES [dbo].[mfgstage] ([mfgstageid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[bomstage] NOCHECK CONSTRAINT [FK_bomstage_mfgstage];

	SET IDENTITY_INSERT [dbo].[bomstage] ON;

	INSERT INTO [dbo].[bomstage] ([bomstageid],[mfgstageid],[sort_order],[mfg_no])
	SELECT [rawUpsize_Contech].[dbo].[bomstage].[bomstageid]
		  --,[rawUpsize_Contech].[dbo].[bomstage].[bom_no]
		  ,[rawUpsize_Contech].[dbo].[bomstage].[mfgstageid]
		  ,[rawUpsize_Contech].[dbo].[bomstage].[sort_order]
		  ,[rawUpsize_Contech].[dbo].[bomstage].[mfg_no]
	  FROM [rawUpsize_Contech].[dbo].[bomstage]
	  ORDER BY [rawUpsize_Contech].[dbo].[bomstage].[bomstageid]

	SET IDENTITY_INSERT [dbo].[bomstage] OFF;

	--SELECT * FROM [dbo].[bomstage]
	
    COMMIT

    PRINT 'Table: dbo.bomstage: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- ***************************************************
-- Table: bomtable
-- ***************************************************

-- Column changes:
--  - Added [bomtableid] to be primary key
--  - Added [bom_hdrid] [int] to reference [bom_hdr] table using [bom_no] and [bom_rev] columns
--  - Removed columns [bom_no] and [bom_rev] 
-- Maps:
--	- [bomtable].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.bomtable: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bomtable')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bomtable')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bomtable')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[bomtable]
		PRINT 'Table [dbo].[bomtable] dropped'
    END

	CREATE TABLE [dbo].[bomtable](
		[bomtableid] [int] IDENTITY(1,1) NOT NULL,		-- new column
		[table] [char](10) NOT NULL DEFAULT '',
		--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,
		--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,
		[bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
		CONSTRAINT [PK_bomtable] PRIMARY KEY CLUSTERED
		(
			[bomtableid] ASC
		) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_bomtable_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION --ON DELETE CASCADE NOT FOR REPLICATION 
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[bomtable] NOCHECK CONSTRAINT [FK_bomtable_bom_hdr];

	INSERT INTO [dbo].[bomtable] ([table],[bom_hdrid])
	SELECT [rawUpsize_Contech].[dbo].[bomtable].[table]
		  --,[rawUpsize_Contech].[dbo].[bomtable].[bom_no]
	   --   ,[rawUpsize_Contech].[dbo].[bomtable].[bom_rev]
		  ,ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
	  FROM [rawUpsize_Contech].[dbo].[bomtable]
	  LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[bomtable].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[bomtable].[bom_rev] = bom_hdr.[bom_rev] 
	WHERE bom_hdr.[bom_hdrid] > 0

	--SELECT * FROM [dbo].[bomtable]
	
    COMMIT

    PRINT 'Table: dbo.bomtable: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- ***************************************************
-- Table: buyer -- Moved to section002
-- ***************************************************

-- Column changes:
--  - Added [buyerid] to be primary key

--BEGIN TRAN;

--BEGIN TRY

--    PRINT 'Table: dbo.buyer: start'

--	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'buyer'))
--		DROP TABLE [dbo].[buyer]

--	CREATE TABLE [dbo].[buyer](
--		[buyerid] int identity (1, 1),	-- new column 
--		[buyer] [char](5) NOT NULL DEFAULT '',
--		[first_name] [char](15) NOT NULL DEFAULT '',
--		[mi] [char](1) NOT NULL DEFAULT '',
--		[last_name] [char](25) NOT NULL DEFAULT '',
--		CONSTRAINT [PK_buyer] PRIMARY KEY CLUSTERED
--		(
--			[buyerid] ASC
--		) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--	) ON [PRIMARY]

--	INSERT INTO [dbo].[buyer] ([buyer],[first_name],[mi],[last_name])

--	SELECT [buyer]
--		  ,[first_name]
--		  ,[mi]
--		  ,[last_name]
--	  FROM [rawUpsize_Contech].[dbo].[buyer]

--	--SELECT * FROM [dbo].[buyer]
	
--    COMMIT

--    PRINT 'Table: dbo.buyer: end'

--END TRY
--BEGIN CATCH

--    ROLLBACK
--    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

--    RAISERROR ('Exiting script...', 20, -1)

--END CATCH;

-- ***************************************************

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section024_HR.sql'

-- ***************************************************

