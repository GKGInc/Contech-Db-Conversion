-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section028_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 028: comptype -- Moved to section003
-- =========================================================

---- Column changes:
----  - Added [comptypeid] to be primary key

--    PRINT 'Table: dbo.comptype: start'
	
--    --DECLARE @SQL varchar(4000)=''
--    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'comptype')
--    BEGIN
--		-- Check for Foreign Key Contraints and remove them
--		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('comptype')) > 0)
--		BEGIN				
--			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('comptype')
--			EXEC (@SQL)
--			PRINT (@SQL)
--		END
            
--		DROP TABLE [dbo].[comptype]
--		PRINT 'Table [dbo].[comptype] dropped'
--    END

--	CREATE TABLE [dbo].[comptype](
--		[comptypeid] [int] IDENTITY(1,1) NOT NULL,
--		[comptype] [char](3) NOT NULL DEFAULT '',
--		[descript] [char](50) NOT NULL DEFAULT '',
--		CONSTRAINT [PK_comptype] PRIMARY KEY CLUSTERED 
--		(
--			[comptypeid] ASC
--		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--	) ON [PRIMARY]

--	INSERT INTO [dbo].[comptype] ([comptype],[descript])
--	SELECT [comptype]
--		  ,[descript]
--	  FROM [rawUpsize_Contech].[dbo].[comptype]
  
--	--SELECT * FROM [dbo].[comptype]

--    PRINT 'Table: dbo.comptype: end'

-- =========================================================
-- Section 028: compwhlocs
-- =========================================================

-- Column changes:
--	- Renamed [pk] to [compwhlocsid]
--  - Set [compwhlocsid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [compwhlocs].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.compwhlocs: start'
	
    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'compwhlocs')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('compwhlocs')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('compwhlocs')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[compwhlocs]
		PRINT 'Table [dbo].[compwhlocs] dropped'
    END

	CREATE TABLE [dbo].[compwhlocs](
		--[pk] [int] NOT NULL,
		[compwhlocsid] [int] IDENTITY(1,1) NOT NULL,
		--[comp] [char](5) NOT NULL DEFAULT '',
		[componetid] [int] NULL,		-- FK = [componet].[comp] --> [componet].[componetid]
		[wh_loc] [char](8) NOT NULL DEFAULT '',
		CONSTRAINT [PK_compwhlocs] PRIMARY KEY CLUSTERED 
		(
			[compwhlocsid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_compwhlocs_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION

	) ON [PRIMARY]

	ALTER TABLE [dbo].[compwhlocs] NOCHECK CONSTRAINT [FK_compwhlocs_componet];

	SET IDENTITY_INSERT [dbo].[compwhlocs] ON;

	INSERT INTO [dbo].[compwhlocs] ([compwhlocsid],[componetid],[wh_loc])
	SELECT [rawUpsize_Contech].[dbo].[compwhlocs].[pk]
		  --,[rawUpsize_Contech].[dbo].[compwhlocs].[comp]
		  ,ISNULL(componet.[componetid], NULL) AS [componetid] 
		  ,[rawUpsize_Contech].[dbo].[compwhlocs].[wh_loc]
	  FROM [rawUpsize_Contech].[dbo].[compwhlocs]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[compwhlocs].[comp] = componet.[comp] 
  
	SET IDENTITY_INSERT [dbo].[compwhlocs] OFF;

	--SELECT * FROM [dbo].[compwhlocs]

    PRINT 'Table: dbo.compwhlocs: end'

-- =========================================================
-- Section 028: consnpay
-- =========================================================

-- Column changes:
--  - Set [consnpayid] to be primary key
--  - Renamed [matlin_key] to [matlinid]
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
-- Maps:
--	- [consnpay].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.consnpay: start'
	
    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'consnpay')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('consnpay')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('consnpay')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[consnpay]
		PRINT 'Table [dbo].[consnpay] dropped'
    END

	CREATE TABLE [dbo].[consnpay](
		[consnpayid] [int] IDENTITY(1,1) NOT NULL,
		--[matlin_key] [int] NOT NULL DEFAULT 0,
		[matlinid] [int] NOT NULL DEFAULT 0,
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',
		[add_userid] [int] NULL,				-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_consnpay] PRIMARY KEY CLUSTERED 
		(
			[consnpayid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_consnpay_matlin FOREIGN KEY ([matlinid]) REFERENCES [dbo].[matlin] ([matlinid]) ON DELETE NO ACTION
		,CONSTRAINT FK_consnpay_users FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[consnpay] NOCHECK CONSTRAINT [FK_consnpay_matlin];
	ALTER TABLE [dbo].[consnpay] NOCHECK CONSTRAINT [FK_consnpay_users];

	SET IDENTITY_INSERT [dbo].[consnpay] ON;

	INSERT INTO [dbo].[consnpay] ([consnpayid],[matlinid],[add_dt],[add_userid])
	SELECT [rawUpsize_Contech].[dbo].[consnpay].[consnpayid]
		  ,[rawUpsize_Contech].[dbo].[consnpay].[matlin_key]
		  ,[rawUpsize_Contech].[dbo].[consnpay].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[consnpay].[add_user]
		  ,ISNULL(users.[userid] , NULL) as [add_userid]			
	  FROM [rawUpsize_Contech].[dbo].[consnpay]
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[consnpay].[add_user] = users.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[consnpay] OFF;

	--SELECT * FROM [dbo].[consnpay]

    PRINT 'Table: dbo.consnpay: end'

-- =========================================================
-- Section 028: convert
-- =========================================================

-- Column changes:
--  - Added [convertid] to be primary key

    PRINT 'Table: dbo.convert: start'
	
    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'convert')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('convert')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('convert')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[convert]
		PRINT 'Table [dbo].[convert] dropped'
    END

	CREATE TABLE [dbo].[convert](
		[convertid] [int] IDENTITY(1,1) NOT NULL,
		[f_country] [char](20) NOT NULL DEFAULT '',
		[t_country] [char](20) NOT NULL DEFAULT '',
		[units] [char](10) NOT NULL DEFAULT '',
		[rate] [numeric](9, 3) NOT NULL DEFAULT 0.0,
		CONSTRAINT [PK_convert] PRIMARY KEY CLUSTERED 
		(
			[convertid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[convert] ([f_country],[t_country],[units],[rate])
	SELECT [f_country]
		  ,[t_country]
		  ,[units]
		  ,[rate]
	  FROM [rawUpsize_Contech].[dbo].[convert]
  
	--SELECT * FROM [dbo].[convert]

    PRINT 'Table: dbo.convert: end'

-- =========================================================
-- Section 028: coractfu
-- =========================================================

-- Column changes:
--  - Set [coractfuid] to be primary key
--  - Changed [fu_notes] from [text] to [varchar](2000)
-- Maps:
--	- [coractfu].[corractnid]	-- -- FK = [corractn].[corractnid]

    PRINT 'Table: dbo.coractfu: start'
	
    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'coractfu')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('coractfu')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('coractfu')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[coractfu]
		PRINT 'Table [dbo].[coractfu] dropped'
    END

	CREATE TABLE [dbo].[coractfu](
		[coractfuid] [int] IDENTITY(1,1) NOT NULL,
		[corractnid] [int] NOT NULL DEFAULT 0,		-- FK = [corractn].[corractnid]
		[follow_up] [datetime] NULL,
		[fu_notes] [varchar](2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_coractfu] PRIMARY KEY CLUSTERED 
		(
			[coractfuid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_coractfu_corractn FOREIGN KEY ([corractnid]) REFERENCES [dbo].[corractn] ([corractnid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[coractfu] NOCHECK CONSTRAINT [FK_coractfu_corractn];

	SET IDENTITY_INSERT [dbo].[coractfu] ON;

	INSERT INTO [dbo].[coractfu] ([coractfuid],[corractnid],[follow_up],[fu_notes])
	SELECT [coractfuid]
		  ,[corractnid]
		  ,[follow_up]
		  ,[fu_notes]
	  FROM [rawUpsize_Contech].[dbo].[coractfu]
  
	SET IDENTITY_INSERT [dbo].[coractfu] OFF;

	--SELECT * FROM [dbo].[coractfu]

    PRINT 'Table: dbo.coractfu: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section028_HR.sql'

-- =========================================================