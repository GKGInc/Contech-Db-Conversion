-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section036_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 036: jobrabox
-- =========================================================

-- Column changes:
--  - Set [jobraboxid] to be primary key
--  - Renamed [job_no] to [orderid] to reference [orders] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [pick_user] [char](10) to [pick_userid] [int] to reference [users] table
-- Maps:
--	- [jobrabox].[raboxid]						-- FK = [rabox].[raboxid] 
--	- [jobrabox].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[ordersid]
--	- [jobrabox].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]
--	- [jobrabox].[pick_user] --> [pick_userid]	-- FK = [users].[username] --> [users].[userid]

	PRINT 'Table: dbo.jobrabox: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'jobrabox')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('jobrabox')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('jobrabox')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[jobrabox]
		PRINT 'Table [dbo].[jobrabox] dropped'
    END

	CREATE TABLE [dbo].[jobrabox](
		[jobraboxid] [int] IDENTITY(1,1) NOT NULL,
		--[job_no] [int] NOT NULL DEFAULT '',			-- FK = [orders].[job_no] 
		[orderid] [int] NULL,							-- FK = [orders].[job_no] --> [orders].[ordersid]  
		[raboxid] [int] NULL,							-- FK = [rabox].[raboxid]
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[qty] [int] NOT NULL DEFAULT 0,
		[pick_dt] [datetime] NULL,
		--[pick_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[pick_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_jobrabox] PRIMARY KEY CLUSTERED 
		(
			[jobraboxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_jobrabox_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_jobrabox_rabox FOREIGN KEY ([raboxid]) REFERENCES [dbo].[rabox] ([raboxid]) ON DELETE NO ACTION
		,CONSTRAINT FK_jobrabox_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_jobrabox_pick_user FOREIGN KEY ([pick_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[jobrabox] NOCHECK CONSTRAINT [FK_jobrabox_orders];
	ALTER TABLE [dbo].[jobrabox] NOCHECK CONSTRAINT [FK_jobrabox_rabox];
	ALTER TABLE [dbo].[jobrabox] NOCHECK CONSTRAINT [FK_jobrabox_add_user];
	ALTER TABLE [dbo].[jobrabox] NOCHECK CONSTRAINT [FK_jobrabox_pick_user];

	SET IDENTITY_INSERT [dbo].[jobrabox] ON;

	INSERT INTO [dbo].[jobrabox] ([jobraboxid],[orderid],[raboxid],[add_dt],[add_userid],[qty],[pick_dt],[pick_userid])
	SELECT [rawUpsize_Contech].[dbo].[jobrabox].[jobraboxid]
		  --,[rawUpsize_Contech].[dbo].[jobrabox].[job_no]
		  ,ISNULL(orders.[orderid], NULL) AS [ordersid]			-- FK = [orders].[job_no] --> [orders].[ordersid]     
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[raboxid]
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[jobrabox].[add_user]
		  ,ISNULL(add_user.[userid], NULL) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[qty]
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[pick_dt]
		  --,[rawUpsize_Contech].[dbo].[jobrabox].[pick_user]
		  ,ISNULL(pick_user.[userid], NULL) as [userid]			
	  FROM [rawUpsize_Contech].[dbo].[jobrabox]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[jobrabox].[job_no] = orders.[job_no]	
	  LEFT JOIN [dbo].[users] add_user ON [rawUpsize_Contech].[dbo].[jobrabox].[add_user] = add_user.[username]		-- FK = [users].[userid]
	  LEFT JOIN [dbo].[users] pick_user ON [rawUpsize_Contech].[dbo].[jobrabox].[pick_user] = pick_user.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[jobrabox] OFF;

	--SELECT * FROM [dbo].[jobrabox]

    PRINT 'Table: dbo.jobrabox: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section036_HR.sql'

-- =========================================================