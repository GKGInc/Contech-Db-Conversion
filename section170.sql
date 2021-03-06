-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section017_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 017: prdlinhd
-- =========================================================

-- Column changes:
--  - Set [prdlinhdid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [user_id] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [prdlinhd].[cust_no] -->[customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [prdlinhd].[user_id] -->[userid]		-- FK = [users].[username] --> [users].[userid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.prdlinhd: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlinhd'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prdlinhd')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prdlinhd')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[prdlinhd]
	END		

	CREATE TABLE [dbo].[prdlinhd](
		[prdlinhdid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](60) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT 0,	-- FK = [customer].[cust_no] 
		[customerid] [int] NULL,					-- FK = [customer].[cust_no] --> [customer].[customerid]
		--[user_id] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		CONSTRAINT [PK_prdlinhd] PRIMARY KEY CLUSTERED 
		(
			[prdlinhdid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prdlinhd_customer FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_prdlinhd_users FOREIGN KEY ([userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prdlinhd] NOCHECK CONSTRAINT [FK_prdlinhd_customer];
	ALTER TABLE [dbo].[prdlinhd] NOCHECK CONSTRAINT [FK_prdlinhd_users];

	SET IDENTITY_INSERT [dbo].[prdlinhd] ON;

	INSERT INTO [dbo].[prdlinhd] ([prdlinhdid],[descript],[customerid],[userid],[add_dt])
	SELECT [rawUpsize_Contech].[dbo].[prdlinhd].[prdlinhdid]
		  ,[rawUpsize_Contech].[dbo].[prdlinhd].[descript]
		  --,[rawUpsize_Contech].[dbo].[prdlinhd].[cust_no]
		  ,ISNULL(customer.[customerid], NULL) as [customerid]
		  --,[rawUpsize_Contech].[dbo].[prdlinhd].[user_id]
		  ,ISNULL(users.[userid] , NULL) as [userid] 
		  ,[rawUpsize_Contech].[dbo].[prdlinhd].[add_dt]
	  FROM [rawUpsize_Contech].[dbo].[prdlinhd]
	  LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[prdlinhd].[cust_no] = customer.[cust_no] 
	  LEFT JOIN [dbo].[users] users ON [rawUpsize_Contech].[dbo].[prdlinhd].[user_id] = users.[username] 
  
	SET IDENTITY_INSERT [dbo].[prdlinhd] OFF;

	--SELECT * FROM [dbo].[prdlinhd]

    COMMIT

    PRINT 'Table: dbo.prdlinhd: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 017: prdlindt
-- =========================================================

-- Column changes:
--  - Changed [prdlindtid] to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
-- Maps:
--	- [prdlindt].[prdlinhdid]				-- FK = [prdlinhd].[prdlinhdid] 
--	- [prdlindt].[comp]	--> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.prdlindt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'prdlindt'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('prdlindt')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('prdlindt')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[prdlindt]
	END

	CREATE TABLE [dbo].[prdlindt](
		[prdlindtid] [int] IDENTITY(1,1) NOT NULL,
		[prdlinhdid] [int] NOT NULL DEFAULT 0,		-- FK = [prdlinhd].[prdlinhdid] 
		--[comp] [char](5)  NOT NULL DEFAULT '',	-- FK = [componet].[comp] 
		[componetid] [int] NOT NULL,				-- FK = [componet].[comp] --> [componet].[componetid]
		[type] [char](3) NOT NULL DEFAULT '',
		[sort_order] [int] NOT NULL DEFAULT 0,
		[mod_dt] [datetime] NULL,
		[user_id] [char](10) NOT NULL DEFAULT '',
		[as_of_dt] [datetime] NULL,
		CONSTRAINT [PK_prdlindt] PRIMARY KEY CLUSTERED 
		(
			[prdlindtid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_prdlindt_prdlinhd FOREIGN KEY ([prdlinhdid]) REFERENCES [dbo].[prdlinhd] ([prdlinhdid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_prdlindt_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION

	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[prdlindt] NOCHECK CONSTRAINT [FK_prdlindt_componet];

	SET IDENTITY_INSERT [dbo].[prdlindt] ON;

	INSERT INTO [dbo].[prdlindt] ([prdlindtid],[prdlinhdid],[componetid],[type],[sort_order],[mod_dt],[user_id],[as_of_dt])
	SELECT [rawUpsize_Contech].[dbo].[prdlindt].[prdlindtid]
		  ,[rawUpsize_Contech].[dbo].[prdlindt].[prdlinhdid]
		  --,[rawUpsize_Contech].[dbo].[prdlindt].[comp]
		  ,ISNULL(componet.[componetid], 0) AS [componetid] 
		  ,[rawUpsize_Contech].[dbo].[prdlindt].[type]
		  ,[rawUpsize_Contech].[dbo].[prdlindt].[sort_order]
		  ,[rawUpsize_Contech].[dbo].[prdlindt].[mod_dt]
		  ,[rawUpsize_Contech].[dbo].[prdlindt].[user_id]
		  ,[rawUpsize_Contech].[dbo].[prdlindt].[as_of_dt]
	  FROM [rawUpsize_Contech].[dbo].[prdlindt]
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[prdlindt].[comp] = componet.[comp] -- FK = [componet].[comp] --> [componet].[componetid]
	WHERE [prdlinhdid] IN (SELECT [prdlinhdid] FROM [dbo].[prdlinhd])

	SET IDENTITY_INSERT [dbo].[prdlindt] OFF;

	--SELECT * FROM [dbo].[prdlindt]

    COMMIT

    PRINT 'Table: dbo.prdlindt: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 017: material -- Moved to section005
-- =========================================================

-- Column changes:
--  - Added [materialid] to be primary key
--  - Changed [description] from [text] to [varchar](2000)

--BEGIN TRAN;

--BEGIN TRY

--    PRINT 'Table: dbo.material: start'

--	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'material'))
--		DROP TABLE [dbo].[material]

--	CREATE TABLE [dbo].[material](
--		[materialid] [int] IDENTITY(1,1) NOT NULL,
--		[material] [char](3) NOT NULL DEFAULT '',
--		[description] [varchar](2000) NOT NULL DEFAULT '',
--		[type] [char](20) NOT NULL DEFAULT '',
--		CONSTRAINT [PK_material] PRIMARY KEY CLUSTERED 
--		(
--			[materialid] ASC
--		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--	) ON [PRIMARY] 

--	INSERT INTO [dbo].[material] SELECT * FROM [rawUpsize_Contech].[dbo].[material]
  
--	--SELECT * FROM [dbo].[material]

--    COMMIT

--    PRINT 'Table: dbo.material: end'

--END TRY
--BEGIN CATCH

--    ROLLBACK
--    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

--    RAISERROR ('Exiting script...', 20, -1)

--END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section017_HR.sql'

-- =========================================================