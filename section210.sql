-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section021_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 021: asstevnt
-- =========================================================

-- Column changes:
--  - Set [asstevntid] to be primary key
--  - Changed [asset_no] [char](10) to [assetid] [int] to reference [assets] table
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
--  - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table
-- Maps:
--	- [asstevnt].[asset_no] --> [asstevntid]	-- FK = [assets].[asset_no] --> [assets].[assetsid]
--	- [asstevnt].[evntperson] --> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
--	- [asstevnt].[document] --> [docs_dtlid]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]

    PRINT 'Table: dbo.asstevnt: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'asstevnt')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('asstevnt')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('asstevnt')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[asstevnt]
		PRINT 'Table [dbo].[asstevnt] dropped'
    END

	CREATE TABLE [dbo].[asstevnt](
		[asstevntid] [int] IDENTITY(1,1) NOT NULL,
		--[asset_no] [char](10) NOT NULL DEFAULT '',	-- FK = [assets].[asset_no]
		[assetid] [int] NULL,							-- FK = [assets].[asset_no] --> [assets].[assetid]
		[evnt_type] [char](2) NOT NULL DEFAULT '',
		[evnt_name] [char](30) NOT NULL DEFAULT '',
		[interval] [char](2) NOT NULL DEFAULT '',
		[intervalno] [int] NOT NULL DEFAULT 0,
		[rmndr_days] [int] NOT NULL DEFAULT 0,
		--[evntperson] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber] 
		[employeeid] [int] NULL,						-- FK = [employee].[empnumber] --> [employee].[employeeid]
		--[document] [char](10) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document] 
		[docs_dtlid] [int] NULL,						-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
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
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_asstevnt_assets FOREIGN KEY ([assetid]) REFERENCES [dbo].[assets] ([assetid]) ON DELETE NO ACTION
		,CONSTRAINT FK_asstevnt_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_asstevnt_docs_dtl FOREIGN KEY ([docs_dtlid]) REFERENCES [dbo].[docs_dtl] ([docs_dtlid]) ON DELETE NO ACTION
	) ON [PRIMARY] 
	
	ALTER TABLE [dbo].[asstevnt] NOCHECK CONSTRAINT [FK_asstevnt_assets];
	ALTER TABLE [dbo].[asstevnt] NOCHECK CONSTRAINT [FK_asstevnt_employee];
	ALTER TABLE [dbo].[asstevnt] NOCHECK CONSTRAINT [FK_asstevnt_docs_dtl];

	SET IDENTITY_INSERT [dbo].[asstevnt] ON;

	INSERT INTO [dbo].[asstevnt] ([asstevntid],[assetid],[evnt_type],[evnt_name],[interval],[intervalno],[rmndr_days],[employeeid],[docs_dtlid],[future_due],[lastaction],[rmndr_date],[evntmpltid],[rev_rec],[rev_dt],[rev_emp])
	SELECT [rawUpsize_Contech].[dbo].[asstevnt].[asstevntid]
		  --,[rawUpsize_Contech].[dbo].[asstevnt].[asset_no]
		  ,ISNULL(assets.[assetid], NULL) AS [assetid]			-- FK = [assets].[asset_no] --> [assets].[assetid]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[evnt_type]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[evnt_name]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[interval]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[intervalno]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rmndr_days]
		  --,[rawUpsize_Contech].[dbo].[asstevnt].[evntperson]
		  ,ISNULL(employee.[employeeid], NULL) AS [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
		  --,[rawUpsize_Contech].[dbo].[asstevnt].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid], NULL) AS [docs_dtlid]	-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[future_due]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[lastaction]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rmndr_date]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[evntmpltid]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_dt]
		  ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_emp]
	  FROM [rawUpsize_Contech].[dbo].[asstevnt]
	  LEFT JOIN [dbo].[assets] assets ON [rawUpsize_Contech].[dbo].[asstevnt].[asset_no] = assets.[asset_no]			-- FK = [assets].[asset_no] --> [assets].[assetid]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[asstevnt].[evntperson] = employee.[empnumber]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
	  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[asstevnt].[document] = docs_dtl.[document]		-- FK = [docs_dtl].[document] --> [docs_dtl].[docs_dtlid]

	SET IDENTITY_INSERT [dbo].[asstevnt] OFF;

	--SELECT * FROM [dbo].[asstevnt]
	
    PRINT 'Table: dbo.asstevnt: end'

-- =========================================================

    COMMIT
	
END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section021_HR.sql'

-- =========================================================