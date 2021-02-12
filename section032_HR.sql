-- =========================================================

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section032_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 032: emp_edu
-- =========================================================

-- Column changes:
--  - Set [emp_eduid] to be primary key
--  - Changed [notes] from [text] to [varchar](2000)
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
--  - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table
--  - Changed [eff_user] [char](10) to [eff_userid] [int] to reference [users] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [rev_emp] [char](10) to [rev_employeeid] [int] to reference [employee] table
-- Maps:
--	- [emp_edu].[empnumber]	--> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
--	- [emp_edu].[document] --> [docs_dtlid]		-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]
--	- [emp_edu].[eff_user] --> [eff_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [emp_edu].[add_user] --> [add_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [emp_edu].[rev_emp] --> [rev_employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]

    PRINT 'Table: dbo.emp_edu: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'emp_edu')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('emp_edu')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('emp_edu')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[emp_edu]
		PRINT 'Table [dbo].[emp_edu] dropped'
    END

	CREATE TABLE [dbo].[emp_edu](
		[emp_eduid] [int] IDENTITY(1,1) NOT NULL,
		--[empnumber] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber]
		[employeeid] [int] NULL,						-- FK = [employee].[empnumber] -> [employee].[employeeid]
		--[document] [char](15) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document]
		[docs_dtlid] [int] NULL,						-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]
		[rev] [char](4) NOT NULL DEFAULT '',
		[edu_date] [datetime] NULL,
		[signature] [char](40) NOT NULL DEFAULT '',
		[notes] [varchar](2000) NOT NULL DEFAULT '',
		[notrain] [bit] NOT NULL DEFAULT 0,
		[follow_up] [datetime] NULL,
		[effective] [char](1) NOT NULL DEFAULT '',
		[eff_dt] [datetime] NULL,
		--[eff_user] [char](10) NOT NULL DEFAULT '',
		[eff_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',
		[add_userid] [int] NULL,						-- FK = [users].[username] --> [users].[userid]
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		--[rev_emp] [char](10) NOT NULL DEFAULT '',		-- FK = [employee].[empnumber]
		[rev_employeeid] [int] NULL,					-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_emp_edu] PRIMARY KEY CLUSTERED 
		(
			[emp_eduid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_emp_edu_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_emp_edu_docs_dtl FOREIGN KEY ([docs_dtlid]) REFERENCES [dbo].[docs_dtl] ([docs_dtlid]) ON DELETE NO ACTION
		,CONSTRAINT FK_emp_edu_eff_user FOREIGN KEY ([eff_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_emp_edu_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_emp_edu_rev_employee FOREIGN KEY ([rev_employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[emp_edu] NOCHECK CONSTRAINT [FK_emp_edu_employee];
	ALTER TABLE [dbo].[emp_edu] NOCHECK CONSTRAINT [FK_emp_edu_docs_dtl];
	ALTER TABLE [dbo].[emp_edu] NOCHECK CONSTRAINT [FK_emp_edu_eff_user];
	ALTER TABLE [dbo].[emp_edu] NOCHECK CONSTRAINT [FK_emp_edu_add_user];
	ALTER TABLE [dbo].[emp_edu] NOCHECK CONSTRAINT [FK_emp_edu_rev_employee];

	SET IDENTITY_INSERT [dbo].[emp_edu] ON;

	INSERT INTO [dbo].[emp_edu] ([emp_eduid],[employeeid],[docs_dtlid],[rev],[edu_date],[signature],[notes],[notrain],[follow_up],[effective],[eff_dt],[eff_userid],[add_dt],[add_userid],[rev_rec],[rev_dt],[rev_employeeid])
	SELECT [rawUpsize_Contech].[dbo].[emp_edu].[emp_eduid]
		  --,[rawUpsize_Contech].[dbo].[emp_edu].[empnumber]
		  ,ISNULL(employee.[employeeid], NULL) AS [employeeid]		-- FK = [employee].[empnumber] -> [employee].[employeeid]
		  --,[rawUpsize_Contech].[dbo].[emp_edu].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid], NULL) AS [docs_dtlid] 
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[rev]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[edu_date]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[signature]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[notes]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[notrain]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[follow_up]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[effective]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[eff_dt]
		  --,[rawUpsize_Contech].[dbo].[emp_edu].[eff_user]
		  ,ISNULL(eff_user.[userid], NULL) as [eff_user]			-- FK = [users].[userid]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[emp_edu].[add_user]		
		  ,ISNULL(add_user.[userid], NULL) as [add_user]			-- FK = [users].[userid]	
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[emp_edu].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[emp_edu].[rev_emp]
		  ,ISNULL(rev_employee.[employeeid], NULL) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[emp_edu]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[emp_edu].[empnumber] = employee.[empnumber]		-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  LEFT JOIN [dbo].[employee] rev_employee ON [rawUpsize_Contech].[dbo].[emp_edu].[rev_emp] = rev_employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]  
	  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[emp_edu].[document] = docs_dtl.[document]
	  --LEFT JOIN [rawUpsize_Contech].[dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[emp_edu].[document] = docs_dtl.[document]
	  LEFT JOIN [dbo].[users] eff_user ON [rawUpsize_Contech].[dbo].[emp_edu].[eff_user] = eff_user.[username]	-- FK = [users].[userid]
	  LEFT JOIN [dbo].[users] add_user ON [rawUpsize_Contech].[dbo].[emp_edu].[add_user] = add_user.[username]	-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[emp_edu] OFF;

	--SELECT * FROM [dbo].[emp_edu]

    PRINT 'Table: dbo.emp_edu: end'

-- =========================================================
-- Section 032: empstatrv
-- =========================================================

-- Column changes:
--  - Changed [pk] to [empstatrvid] 
--  - Set empstatrvid to be primary key
--  - Changed [stat_memo] from [text] to [varchar](2000)
--  - Changed [rvw_by] [char](10) to [rvw_byid] [int] to reference [users] table
--  - Changed [hr_rvw_by] [char](10) to [hr_rvw_byid] [int] to reference [users] table
-- Maps:
--	- [empstatrv].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] --> [employee].[employeeid]
--	- [empstatrv].[rvw_by] --> [rvw_byid]		-- FK = [users].[username] --> [users].[userid]
--	- [empstatrv].[hr_rvw_by] --> [hr_rvw_byid]	-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.empstatrv: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'empstatrv')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('empstatrv')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('empstatrv')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[empstatrv]
		PRINT 'Table [dbo].[empstatrv] dropped'
    END

	CREATE TABLE [dbo].[empstatrv](
		--[pk] [int] IDENTITY(1,1) NOT NULL,
		[empstatrvid] [int] IDENTITY(1,1) NOT NULL,
		--[empnumber] [char](10) NOT NULL DEFAULT '',
		[employeeid] [int] NULL,				-- FK = [employee].[empnumber] -> [employee].[employeeid]
		[empstatus] [int] NOT NULL DEFAULT 0,
		[rvw_date] [datetime] NULL,
		--[rvw_by] [char](10) NOT NULL DEFAULT '',
		[rvw_byid] [int] NULL,					-- FK = [users].[username] --> [users].[userid]
		[stat_memo] [varchar](2000) NOT NULL DEFAULT '',
		[hr_rvw_dt] [datetime] NULL,
		--[hr_rvw_by] [char](10) NOT NULL DEFAULT '',
		[hr_rvw_byid] [int] NULL,				-- FK = [users].[username] --> [users].[userid]
		CONSTRAINT [PK_empstatrv] PRIMARY KEY CLUSTERED 
		(
			empstatrvid ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_empstatrv_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_empstatrv_rvw_byid FOREIGN KEY ([rvw_byid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_empstatrv_hr_rvw_by FOREIGN KEY ([hr_rvw_byid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[empstatrv] NOCHECK CONSTRAINT [FK_empstatrv_employee];
	ALTER TABLE [dbo].[empstatrv] NOCHECK CONSTRAINT [FK_empstatrv_rvw_byid];
	ALTER TABLE [dbo].[empstatrv] NOCHECK CONSTRAINT [FK_empstatrv_hr_rvw_by];

	SET IDENTITY_INSERT [dbo].[empstatrv] ON;

	INSERT INTO [dbo].[empstatrv] ([empstatrvid],[employeeid],[empstatus],[rvw_date],[rvw_byid],[stat_memo],[hr_rvw_dt],[hr_rvw_byid])
	SELECT [rawUpsize_Contech].[dbo].[empstatrv].[pk]
		  --,[rawUpsize_Contech].[dbo].[empstatrv].[empnumber]
		  ,ISNULL([employee].[employeeid], NULL) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
		  ,[rawUpsize_Contech].[dbo].[empstatrv].[empstatus]
		  ,[rawUpsize_Contech].[dbo].[empstatrv].[rvw_date]
		  --,[rawUpsize_Contech].[dbo].[empstatrv].[rvw_by]
		  ,ISNULL(rvw_byid.[userid], NULL) as [rvw_byid]			
		  ,[rawUpsize_Contech].[dbo].[empstatrv].[stat_memo]
		  ,[rawUpsize_Contech].[dbo].[empstatrv].[hr_rvw_dt]
		  --,[rawUpsize_Contech].[dbo].[empstatrv].[hr_rvw_by]
		  ,ISNULL(hr_rvw_by.[userid], NULL) as [hr_rvw_byid]			
	  FROM [rawUpsize_Contech].[dbo].[empstatrv]
	  LEFT JOIN [employee] ON [rawUpsize_Contech].[dbo].[empstatrv].[empnumber] = [employee].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  LEFT JOIN [users] rvw_byid ON [rawUpsize_Contech].[dbo].[empstatrv].[rvw_by] = rvw_byid.[username]						-- FK = [users].[userid]
	  LEFT JOIN [users] hr_rvw_by ON [rawUpsize_Contech].[dbo].[empstatrv].[hr_rvw_by] = hr_rvw_by.[username]					-- FK = [users].[userid]
  
	SET IDENTITY_INSERT [dbo].[empstatrv] OFF;

	--SELECT * FROM [dbo].[empstatrv]

    PRINT 'Table: dbo.empstatrv: end'

-- =========================================================
-- Section 032: exchrate
-- =========================================================

-- Column changes:
--  - Set [exchrateid] to be primary key
-- Maps:
--	- [bom_hist].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.exchrate: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'exchrate')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('exchrate')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('exchrate')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[exchrate]
		PRINT 'Table [dbo].[exchrate] dropped'
    END

	CREATE TABLE [dbo].[exchrate](
		[exchrateid] [int] IDENTITY(1,1) NOT NULL,
		[currcode] [char](5) NOT NULL DEFAULT '',
		[multiplier] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		CONSTRAINT [PK_exchrate] PRIMARY KEY CLUSTERED 
		(
			[exchrateid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[exchrate] ON;

	INSERT INTO [exchrate] ([exchrateid],[currcode],[multiplier])
	SELECT [rawUpsize_Contech].[dbo].[exchrate].[exchrateid]
		  ,[rawUpsize_Contech].[dbo].[exchrate].[currcode]
		  ,[rawUpsize_Contech].[dbo].[exchrate].[multiplier]
	  FROM [rawUpsize_Contech].[dbo].[exchrate]
  
	SET IDENTITY_INSERT [dbo].[exchrate] OFF;

	--SELECT * FROM [dbo].[exchrate]

    PRINT 'Table: dbo.exchrate: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section032_HR.sql'

-- =========================================================