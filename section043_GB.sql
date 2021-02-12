-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section043_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 043: samplevl
-- =========================================================

-- Column changes:
--  - Set [samplevlid] to be primary key
-- Maps:
--	- [bom_hist].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.samplevl: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'samplevl')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('samplevl')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('samplevl')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[samplevl]
		PRINT 'Table [dbo].[samplevl] dropped'
    END

	CREATE TABLE [dbo].[samplevl](
		[samplevlid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](15) NOT NULL DEFAULT '',
		CONSTRAINT [PK_samplevl] PRIMARY KEY CLUSTERED 
		(
			[samplevlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[samplevl] ON;

	INSERT INTO [dbo].[samplevl] ([samplevlid],[descript])
	SELECT [rawUpsize_Contech].[dbo].[samplevl].[samplevlid]
		  ,[rawUpsize_Contech].[dbo].[samplevl].[descript]
	  FROM [rawUpsize_Contech].[dbo].[samplevl]
  
	SET IDENTITY_INSERT [dbo].[samplevl] OFF;

	--SELECT * FROM [dbo].[samplevl]

    PRINT 'Table: dbo.samplevl: end'

-- =========================================================
-- Section 043: shortcmp
-- =========================================================

-- Column changes:
--  - Set [shortcmpid] to be primary key
--  - Changed [comments] from [text] to [varchar](2000)
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [reasoncodeid] [char](1) to [reasoncodeid] [int] to reference [type] in [lookups] table
-- Maps:
--	- [shortcmp].[comp] --> [componetid]			-- FK = [componet].[comp] --> [componet].[componetid]
--	- [shortcmp].[add_user] --> [add_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [shortcmp].[reasoncode] --> [reasoncodeid]	-- FK = [lookups].[code] --> ([lookups].[lookupid])

    PRINT 'Table: dbo.shortcmp: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'shortcmp')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('shortcmp')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('shortcmp')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[shortcmp]
		PRINT 'Table [dbo].[shortcmp] dropped'
    END

	CREATE TABLE [dbo].[shortcmp](
		[shortcmpid] [int] IDENTITY(1,1) NOT NULL,
		[req_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [req_hdr].[req_hdrid]
		--[comp] [char](5) NOT NULL DEFAULT'',			-- FK = [componet].[comp]	
		[componetid] [int] NULL,						-- FK = [componet].[comp] --> [componet].[componetid]
		[required] [int] NOT NULL DEFAULT 0,
		[available] [int] NOT NULL DEFAULT 0,
		[comments] [varchar](2000) NOT NULL DEFAULT '',
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		--[reasoncode] [char](1) NOT NULL DEFAULT '',	-- FK = [lookups].[code]	--type = COMP SHORT CODES
		[reasoncodeid] [int] NULL,						-- FK = [lookups].[code]	--type = COMP SHORT CODES
		CONSTRAINT [PK_shortcmp] PRIMARY KEY CLUSTERED 
		(
			[shortcmpid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_shortcmp_req_hdr FOREIGN KEY ([req_hdrid]) REFERENCES [dbo].[req_hdr] ([req_hdrid]) ON DELETE NO ACTION
		,CONSTRAINT FK_shortcmp_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
		,CONSTRAINT FK_shortcmp_users FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_shortcmp_reasoncode FOREIGN KEY ([reasoncodeid]) REFERENCES [dbo].[lookups] ([lookupid]) ON DELETE NO ACTION

	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[shortcmp] NOCHECK CONSTRAINT [FK_shortcmp_req_hdr];
	ALTER TABLE [dbo].[shortcmp] NOCHECK CONSTRAINT [FK_shortcmp_componet];
	ALTER TABLE [dbo].[shortcmp] NOCHECK CONSTRAINT [FK_shortcmp_users];
	ALTER TABLE [dbo].[shortcmp] NOCHECK CONSTRAINT [FK_shortcmp_reasoncode];

	SET IDENTITY_INSERT [dbo].[shortcmp] ON;

	INSERT INTO [dbo].[shortcmp] ([shortcmpid],[req_hdrid],[componetid],[required],[available],[comments],[add_dt],[add_userid],[reasoncodeid])
	SELECT [rawUpsize_Contech].[dbo].[shortcmp].[shortcmpid]
		  ,[rawUpsize_Contech].[dbo].[shortcmp].[req_hdrid]
		  --,[rawUpsize_Contech].[dbo].[shortcmp].[comp]
		  ,ISNULL(componet.[componetid], NULL) AS [componetid] 
		  ,[rawUpsize_Contech].[dbo].[shortcmp].[required]
		  ,[rawUpsize_Contech].[dbo].[shortcmp].[available]
		  ,[rawUpsize_Contech].[dbo].[shortcmp].[comments]
		  ,[rawUpsize_Contech].[dbo].[shortcmp].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[shortcmp].[add_user]
		  ,ISNULL(users.[userid], NULL) as [userid]			
		  --,[rawUpsize_Contech].[dbo].[shortcmp].[reasoncode]
		  ,ISNULL(lookups.[lookupid], NULL) AS [reasoncodeid]
	  FROM [rawUpsize_Contech].[dbo].[shortcmp]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[shortcmp].[comp] = componet.[comp] 
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[shortcmp].[add_user] = users.[username]	-- FK = [users].[userid]
	  LEFT JOIN [dbo].[lookups] lookups ON [rawUpsize_Contech].[dbo].[shortcmp].[reasoncode] = lookups.[code] AND lookups.[type] = 'COMP SHORT CODES'
 
	SET IDENTITY_INSERT [dbo].[shortcmp] OFF;

	--SELECT * FROM [dbo].[shortcmp]

    PRINT 'Table: dbo.shortcmp: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section043_HR.sql'

-- =========================================================
