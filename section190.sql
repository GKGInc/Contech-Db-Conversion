-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section019_HR.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 019: rev_rel
-- =========================================================

-- Column changes:
--  - Set [rev_relid] to be primary key
--  - Renamed [job_no] to [orderid] to reference [orders] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [rev_rel].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [rev_rel].[add_user] --> [add_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [rev_rel].[mod_user] --> [mod_userid]		-- FK = [users].[username] --> [users].[userid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.rev_rel: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'rev_rel')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('rev_rel')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('rev_rel')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[rev_rel]
		PRINT 'Table [dbo].[rev_rel] dropped'
    END

	CREATE TABLE [dbo].[rev_rel](
		[rev_relid] [int] IDENTITY(1,1) NOT NULL,
		--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] 
		[orderid] [int] NULL,							-- FK = [orders].[job_no] --> [orders].[orderid]
		[rel_qty] [int] NOT NULL DEFAULT 0,		
		[jobstatus] [char](1) NOT NULL DEFAULT '',
		[postatus] [char](1) NOT NULL DEFAULT '',
		[price] [numeric](9, 4) NOT NULL DEFAULT 0.0,
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[mod_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[ship_dt] [datetime] NULL,
		[lading] [bit] NOT NULL DEFAULT 0,
		[nolading] [bit] NOT NULL DEFAULT 0,
		[freight] [numeric](6, 2) NOT NULL DEFAULT 0.0,
		[sched_ship] [datetime] NULL,
		CONSTRAINT [PK_rev_rel] PRIMARY KEY CLUSTERED 
		(
			[rev_relid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_rev_rel_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_rev_rel_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_rev_rel_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[rev_rel] ON;

	INSERT INTO [dbo].[rev_rel] ([rev_relid],[orderid],[rel_qty],[jobstatus],[postatus],[price],[add_dt],[add_userid],[mod_dt],[mod_userid],[ship_dt],[lading],[nolading],[freight],[sched_ship])
	SELECT [rawUpsize_Contech].[dbo].[rev_rel].[rev_relid]
		  --,[rawUpsize_Contech].[dbo].[rev_rel].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [ordersid]		-- FK = [orders].[job_no] --> [orders].[orderid]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[rel_qty]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[jobstatus]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[postatus]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[price]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[rev_rel].[add_user] 
		  ,ISNULL(addUser.[userid], NULL) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[mod_dt]
		  --,[rawUpsize_Contech].[dbo].[rev_rel].[mod_user] 
		  ,ISNULL(modUser.[userid], NULL) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[ship_dt]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[lading]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[nolading]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[freight]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[sched_ship]
	  FROM [rawUpsize_Contech].[dbo].[rev_rel]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[rev_rel].[job_no] = orders.[job_no]			-- FK = [orders].[job_no] --> [orders].[orderid]
	  LEFT JOIN [dbo].[users] addUser ON [rawUpsize_Contech].[dbo].[rev_rel].[add_user] = addUser.[username]	-- FK = [users].[username] --> [users].[userid]
	  LEFT JOIN [dbo].[users] modUser ON [rawUpsize_Contech].[dbo].[rev_rel].[mod_user] = modUser.[username]	-- FK = [users].[username] --> [users].[userid]
    
	SET IDENTITY_INSERT [dbo].[rev_rel] OFF;

	--SELECT * FROM [dbo].[rev_rel]
	
    PRINT 'Table: dbo.rev_rel: end'

    COMMIT


END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section019_HR.sql'

-- =========================================================