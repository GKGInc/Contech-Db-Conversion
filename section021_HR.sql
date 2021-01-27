-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section021_HR.sql'

-- =========================================================
-- Section 021: asstevnt
-- =========================================================

-- Column changes:
--  - Set [asstevntid] to be primary key
--  - Changed [asset_no] [char](10) to [assetid] [int] to reference [assets] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [asstevnt].[asset_no] --> [asstevntid]	-- FK = [assets].[asset_no] -> [assets].[assetsid]
--	- [asstevnt].[evntperson] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.asstevnt: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'asstevnt'))
		DROP TABLE [dbo].[asstevnt]

	CREATE TABLE [dbo].[asstevnt](
		[asstevntid] [int] IDENTITY(1,1) NOT NULL,
		--[asset_no] [char](10) NOT NULL DEFAULT '',	-- FK = [assets].[asset_no]
		[assetid] [int] NOT NULL DEFAULT 0,				-- FK = [assets].[asset_no] -> [assets].[assetid]
		[evnt_type] [char](2) NOT NULL DEFAULT '',
		[evnt_name] [char](30) NOT NULL DEFAULT '',
		[interval] [char](2) NOT NULL DEFAULT '',
		[intervalno] [int] NOT NULL DEFAULT 0,
		[rmndr_days] [int] NOT NULL DEFAULT 0,
		--[evntperson] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber] 
		[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
		[document] [char](10) NOT NULL DEFAULT '',
		[future_due] [datetime] NULL,
		[lastaction] [datetime] NULL,
		[rmndr_date] [datetime] NULL,
		[evntmpltid] [int] NOT NULL DEFAULT 0,
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		[rev_emp] [char](10) NOT NULL DEFAULT '',
		CONSTRAINT [PK_asstevnt] PRIMARY KEY CLUSTERED 
		(
			[asstevntid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[asstevnt] ON;

	INSERT INTO [dbo].[asstevnt] ([asstevntid],[assetid],[evnt_type],[evnt_name],[interval],[intervalno],[rmndr_days],[employeeid],[document],[future_due],[lastaction],[rmndr_date],[evntmpltid],[rev_rec],[rev_dt],[rev_emp])
	SELECT [rawUpsize_Contech].[dbo].[asstevnt].[asstevntid]
		  --,[rawUpsize_Contech].[dbo].[asstevnt].[asset_no]
		  ,ISNULL(assets.[assetid], 0) AS [assetid]			-- FK = [assets].[asset_no] -> [assets].[assetid]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[evnt_type]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[evnt_name]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[interval]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[intervalno]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rmndr_days]
		  --,[rawUpsize_Contech].[dbo].[asstevnt].[evntperson]
		  ,ISNULL(employee.[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[document]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[future_due]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[lastaction]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rmndr_date]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[evntmpltid]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_dt]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_emp]
	  FROM [rawUpsize_Contech].[dbo].[asstevnt]
	  LEFT JOIN [dbo].[assets] assets ON [rawUpsize_Contech].[dbo].[asstevnt].[asset_no] = assets.[asset_no]			-- FK = [assets].[asset_no] -> [assets].[assetid]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[asstevnt].[evntperson] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

	SET IDENTITY_INSERT [dbo].[asstevnt] OFF;

	--SELECT * FROM [dbo].[asstevnt]

    COMMIT

    PRINT 'Table: dbo.asstevnt: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section021_HR.sql'

-- =========================================================