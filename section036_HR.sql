-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section036_HR.sql'

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

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'jobrabox'))
		DROP TABLE [dbo].[jobrabox]

	CREATE TABLE [dbo].[jobrabox](
		[jobraboxid] [int] IDENTITY(1,1) NOT NULL,
		--[job_no] [int] NOT NULL DEFAULT '',			-- FK = [orders].[job_no] 
		[orderid] [int] NOT NULL DEFAULT 0,				-- FK = [orders].[job_no] --> [orders].[ordersid]  
		[raboxid] [int] NOT NULL DEFAULT 0,				-- FK = [rabox].[raboxid]
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[qty] [int] NOT NULL DEFAULT 0,
		[pick_dt] [datetime] NULL,
		--[pick_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[pick_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_jobrabox] PRIMARY KEY CLUSTERED 
		(
			[jobraboxid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[jobrabox] ON;

	INSERT INTO [dbo].[jobrabox] ([jobraboxid],[orderid],[raboxid],[add_dt],[add_userid],[qty],[pick_dt],[pick_userid])
	SELECT [rawUpsize_Contech].[dbo].[jobrabox].[jobraboxid]
		  --,[rawUpsize_Contech].[dbo].[jobrabox].[job_no]
		  ,ISNULL(orders.[orderid], 0) AS [ordersid]			-- FK = [orders].[job_no] --> [orders].[ordersid]     
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[raboxid]
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[jobrabox].[add_user]
		  ,ISNULL(add_user.[userid] , 0) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[qty]
		  ,[rawUpsize_Contech].[dbo].[jobrabox].[pick_dt]
		  --,[rawUpsize_Contech].[dbo].[jobrabox].[pick_user]
		  ,ISNULL(pick_user.[userid] , 0) as [userid]			
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