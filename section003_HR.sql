-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section003_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 003: class
-- =========================================================

-- Column changes:
--	- Moved [classid] to first column
--  - Changed [classid] to be primary key
--  - Changed [desc] from [text] to [varchar](2000)

    PRINT 'Table: dbo.class: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'class'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('class')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('class')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[class]
	END	
	
	CREATE TABLE [dbo].[class](
		classid [int] IDENTITY(1,1) NOT NULL,
		[class] [char](4) NOT NULL DEFAULT '',
		[desc] [varchar](2000) NOT NULL DEFAULT '',
		CONSTRAINT [PK_class] PRIMARY KEY CLUSTERED 
		(
			[classid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]


	INSERT INTO [dbo].[class]
		SELECT * FROM [rawUpsize_Contech].[dbo].[class] 

	--SELECT * FROM [dbo].[class]
	
    PRINT 'Table: dbo.class: end'

-- =========================================================
-- Section 003: doctypes -- Moved from section 031
-- =========================================================

-- Column changes:
--  - Added [doctypesid] to be primary key
--  - Changed [doctypesid] to [doctypeid]

	PRINT 'Table: dbo.doctypes: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'doctypes'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('doctypes')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('doctypes')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[doctypes]
	END	

	CREATE TABLE [dbo].[doctypes](
		[doctypeid] [int] IDENTITY(1,1) NOT NULL,
		[doctype] [char](4) NOT NULL DEFAULT '',
		[descript] [char](50) NOT NULL DEFAULT '',
		[order] [char](2) NOT NULL DEFAULT '',
		CONSTRAINT [PK_doctypes] PRIMARY KEY CLUSTERED 
		(
			[doctypeid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO [dbo].[doctypes] ([doctype],[descript],[order])
	SELECT [doctype]
		  ,[descript]
		  ,[order]
	  FROM [rawUpsize_Contech].[dbo].[doctypes]
  
	--SELECT * FROM [dbo].[doctypes]

    PRINT 'Table: dbo.doctypes: end'

-- =========================================================
-- Section 003: docs_hdr -- Moved from section 030
-- =========================================================

-- Column changes:
--  - Set [docs_hdrid] to be primary key
--  - Changed [doctype] [char](4) to [doctypeid] [int] to reference [docs_dtl] table
-- Maps:
--	- [docs_hdr].[doctype] --> [doctypeid]	-- FK = [doctypes].[doctype] --> [doctypes].[doctypeid]

    PRINT 'Table: dbo.docs_hdr: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'docs_hdr'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('docs_hdr')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('docs_hdr')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[docs_hdr]
	END	

	CREATE TABLE [dbo].[docs_hdr](
		[docs_hdrid] [int] IDENTITY(1,1) NOT NULL,
		--[doctype] [char](4) NOT NULL DEFAULT '',		-- FK = [doctypes].[doctype]
		[doctypeid] [int] NULL				,			-- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
		[series] [char](4) NOT NULL DEFAULT '',
		[descript] [char](75) NOT NULL DEFAULT '',
		CONSTRAINT [PK_docs_hdr] PRIMARY KEY CLUSTERED 
		(
			[docs_hdrid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	,CONSTRAINT FK_docs_hdr_doctype FOREIGN KEY ([doctypeid]) REFERENCES [dbo].[doctypes] ([doctypeid]) ON DELETE NO ACTION
	) ON [PRIMARY]
		
	ALTER TABLE [dbo].[docs_hdr] NOCHECK CONSTRAINT [FK_docs_hdr_doctype];

	SET IDENTITY_INSERT [dbo].[docs_hdr] ON;

	INSERT INTO [dbo].[docs_hdr] ([docs_hdrid],[doctypeid],[series],[descript])
	SELECT [rawUpsize_Contech].[dbo].[docs_hdr].[docs_hdrid]
		  --,[rawUpsize_Contech].[dbo].[docs_hdr].[doctype]
		  ,ISNULL(doctypes.[doctypeid], NULL) AS [docs_dtlid] -- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
		  ,[rawUpsize_Contech].[dbo].[docs_hdr].[series]
		  ,[rawUpsize_Contech].[dbo].[docs_hdr].[descript]
	  FROM [rawUpsize_Contech].[dbo].[docs_hdr]
	  LEFT JOIN [doctypes] doctypes ON [rawUpsize_Contech].[dbo].[docs_hdr].[doctype] = doctypes.[doctype]
  
	SET IDENTITY_INSERT [dbo].[docs_hdr] OFF;

	--SELECT * FROM [dbo].[docs_hdr]

    PRINT 'Table: dbo.docs_hdr: end'

-- =========================================================
-- Section 003: docs_dtl -- Moved from section 030
-- =========================================================

-- Column changes:
--  - Set [docs_dtlid] to be primary key
--  - Moved [docs_hdrid] to second column
--  - Changed [descript] from [text] to [varchar](2000)
--  - Changed [rev_emp] [char](10) to [rev_employeeid] [int] to reference [employee] table
-- Maps:
--	- [docs_dtl].[docs_hdrid]					-- FK = [docs_hdr].[docs_hdrid]
--	- [docs_dtl].[rev_emp] --> [rev_employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.docs_dtl: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'docs_dtl'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('docs_dtl')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('docs_dtl')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[docs_dtl]
	END	

	CREATE TABLE [dbo].[docs_dtl](
		[docs_dtlid] [int] IDENTITY(1,1) NOT NULL,
		[docs_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [docs_hdr].[docs_hdrid]
		[doctype] [char](4) NOT NULL DEFAULT '',
		[series] [char](4) NOT NULL DEFAULT '',
		[extension] [char](20) NOT NULL DEFAULT '',
		[document] [char](15) NOT NULL DEFAULT '',
		[descript] [varchar](2000) NOT NULL DEFAULT '',
		[rev] [char](4) NOT NULL DEFAULT '',
		[rev_date] [datetime] NULL,
		[move_date] [datetime] NULL,
		[docmod] [bit] NOT NULL DEFAULT 0,
		[cpmr_rev] [char](4) NOT NULL DEFAULT '',
		[cpmr_date] [datetime] NULL,
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		--[rev_emp] [char](10) NOT NULL DEFAULT '',
		[rev_employeeid] [int] NULL,		-- FK = [employee].[empnumber] -> [employee].[employeeid]
		CONSTRAINT [PK_docs_dtl] PRIMARY KEY CLUSTERED 
		(
			[docs_dtlid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_docs_dtl_docs_hdr FOREIGN KEY ([docs_hdrid]) REFERENCES [dbo].[docs_hdr] ([docs_hdrid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_docs_dtl_employee FOREIGN KEY ([rev_employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[docs_dtl] NOCHECK CONSTRAINT [FK_docs_dtl_employee];

	SET IDENTITY_INSERT [dbo].[docs_dtl] ON;

	INSERT INTO [dbo].[docs_dtl] ([docs_dtlid],[docs_hdrid],[doctype],[series],[extension],[document],[descript],[rev],[rev_date],[move_date],[docmod],[cpmr_rev],[cpmr_date],[rev_rec],[rev_dt],[rev_employeeid])
	SELECT [rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docs_hdrid]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[doctype]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[series]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[extension]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[document]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[descript]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[move_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docmod]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_rev]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp]
		  ,ISNULL(employee.[employeeid], NULL) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[docs_dtl]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp] = employee.[empnumber]	
	  WHERE [docs_hdrid] > 0
  
	SET IDENTITY_INSERT [dbo].[docs_dtl] OFF;

	--SELECT * FROM [dbo].[docs_dtl]

    PRINT 'Table: dbo.docs_dtl: end'
	
-- =========================================================
-- Section 003: colorant -- Moved from section 027
-- =========================================================

-- Column changes:
--  - Set [colorantid] to be primary key
--  - Changed [document] [char](15) to [document] [int] to reference [docs_dtl] table
-- Maps:
--	- [colorant].[document] --> [docs_dtlid]	-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]

    PRINT 'Table: dbo.colorant: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'colorant'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('colorant')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('colorant')
			PRINT (@SQL)	
			EXEC (@SQL)
		END
		
		DROP TABLE [dbo].[colorant]
	END	

	CREATE TABLE [dbo].[colorant](
		[colorantid] [int] IDENTITY(1,1) NOT NULL,
		[colorantno] [char](20) NOT NULL DEFAULT '',
		[color_desc] [char](50) NOT NULL DEFAULT '',
		--[document] [char](15) NOT NULL DEFAULT '',	-- FK = [docs_dtl].[document] 
		[docs_dtlid] [int] NULL,			-- FK = [docs_dtl].[document] -> [docs_dtl].[docs_dtlid]
		CONSTRAINT [PK_colorant] PRIMARY KEY CLUSTERED 
		(
			[colorantid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[colorant] ON;

	INSERT INTO [dbo].[colorant] ([colorantid],[colorantno],[color_desc],[docs_dtlid])
	SELECT [rawUpsize_Contech].[dbo].[colorant].[colorantid]
		  ,[rawUpsize_Contech].[dbo].[colorant].[colorantno]
		  ,[rawUpsize_Contech].[dbo].[colorant].[color_desc]
		  --,[rawUpsize_Contech].[dbo].[colorant].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid], NULL) AS [docs_dtlid] 
		  --,ISNULL([rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid], 0) AS [docs_dtlid] 
	  FROM [rawUpsize_Contech].[dbo].[colorant]
	  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[colorant].[document] = docs_dtl.[document]
	  --LEFT JOIN [rawUpsize_Contech].[dbo].[docs_dtl] ON [rawUpsize_Contech].[dbo].[colorant].[document] = [rawUpsize_Contech].[dbo].[docs_dtl].[document]
	  --ORDER BY [rawUpsize_Contech].[dbo].[colorant].[colorantid]
	  ORDER BY [rawUpsize_Contech].[dbo].[colorant].[colorantno]
    
	SET IDENTITY_INSERT [dbo].[colorant] OFF;

	--SELECT * FROM [dbo].[colorant]
	
    PRINT 'Table: dbo.colorant: end'

-- =========================================================
-- Section 003: componet
-- =========================================================

-- Column changes:
--  - Moved [componetid] to 1st column
--  - Changed [componetid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [ven_id] [char](6) to [vendorid] [int] to reference [vendor] table
--  - Changed [color_no] [char](20) to [colorantid] [int] to reference [colorant] table
--  - Changed [class] [char](4) to [classid] [int] to reference [class] in [class] table
--  - Changed [memo] from [text] to [varchar](2000)
-- Maps:
--	- [componet].[cust_no] --> [customerid]		-- FK = [customer].[cust_no] --> [customer].[customerid]
--	- [componet].[ven_id] --> [vendorid]		-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
--	- [componet].[color_no] --> [colorantid]	-- FK = [colorant].[color_no] --> [colorant].[colorantid]
--	- [componet].[class] --> [classid]			-- FK = [class].[class] -> [class].[classid]

	PRINT 'Table: dbo.componet: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'componet'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		--DECLARE @SQL varchar(4000)=''
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('componet')) > 0)
		BEGIN		
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('componet')
			PRINT (@SQL)	
			EXEC (@SQL)			
		END
		
		DROP TABLE [dbo].[componet]
	END	
	
	CREATE TABLE [dbo].[componet](
		[componetid] [int] IDENTITY(1,1) NOT NULL,
		[comp] [char](5) NOT NULL DEFAULT '',			
		[desc] [char](75) NOT NULL DEFAULT '',
		[desc2] [char](75) NOT NULL DEFAULT '',
		[memo1] [char](51) NOT NULL DEFAULT '',
		[insp] [char](2) NOT NULL DEFAULT '',
		--[cust_no] [char](5) NOT NULL DEFAULT '',		-- FK = [customer].[cust_no]
		[customerid] [int] NULL,						-- FK = [customer].[cust_no] --> [customer].[customerid]
		[cost] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[unit] [char](4) NOT NULL DEFAULT '',
		--[ven_id] [char](6) NOT NULL DEFAULT '',		-- FK = [vendor].[ven_id] 
		[vendorid] [int] NULL,							-- FK = [vendor].[ven_id] -> [vendor].[vendorid]
		[price] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[ctp_min] [numeric](10, 0) NOT NULL DEFAULT 0,
		[cmi_inv] [char](1) NOT NULL DEFAULT '',
		[cmi_min] [numeric](10, 0) NOT NULL DEFAULT 0,
		[cmi_price] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[material] [char](3) NOT NULL DEFAULT '',
		[cust_comp] [char](12) NOT NULL DEFAULT '',
		[cus_comp_r] [char](3) NOT NULL DEFAULT '',
		[cust_desc] [char](50) NOT NULL DEFAULT '',
		[memo] [varchar](2000) NOT NULL DEFAULT '',
		[inventory] [numeric](10, 0) NOT NULL DEFAULT 0,
		[drw] [char](8) NOT NULL DEFAULT '',
		[inc] [char](8) NOT NULL DEFAULT '',
		[price_ire] [numeric](9, 5) NOT NULL DEFAULT 0.0,
		[phys_inv] [numeric](10, 0) NOT NULL DEFAULT 0,
		[inv_card] [numeric](10, 0) NOT NULL DEFAULT 0,
		[quar] [numeric](10, 0) NOT NULL DEFAULT 0,
		[hold] [numeric](10, 0) NOT NULL DEFAULT 0,
		[reject] [numeric](10, 0) NOT NULL DEFAULT 0,
		--[class] [char](4) NOT NULL DEFAULT 0,				-- FK = [class].[class]
		[classid] [int] NULL,								-- FK = [class].[class] --> [class].[classid]
		[comp_rev] [char](2) NOT NULL DEFAULT '',
		[samp_plan] [char](2) NOT NULL DEFAULT '',
		[lbl] [char](8) NOT NULL DEFAULT '',
		[xinv] [bit] NOT NULL DEFAULT 0,
		[pickconv] [numeric](9, 2) NOT NULL DEFAULT 0.0,
		[back_dist] [bit] NOT NULL DEFAULT 0,
		[expire] [bit] NOT NULL DEFAULT 0,
		[comptype] [char](3) NOT NULL DEFAULT '',
		[color] [char](15) NOT NULL DEFAULT '',
		--[color_no] [char](20) NOT NULL DEFAULT '',		-- FK = [colorant].[color_no] 
		[colorantid] [int] NULL,							-- FK = [colorant].[color_no] --> [colorant].[colorantid]
		[pantone] [char](15) NOT NULL DEFAULT '',
		[fda_food] [int] NOT NULL DEFAULT 0,
		[fda_med] [int] NOT NULL DEFAULT 0,
		[coneg] [int] NOT NULL DEFAULT 0,
		[prop65] [int] NOT NULL DEFAULT 0,
		[rohs] [int] NOT NULL DEFAULT 0,
		[eu_94_62] [int] NOT NULL DEFAULT 0,
		[rev_rec] [int] NOT NULL DEFAULT 0,
		[rev_dt] [datetime] NULL,
		[rev_emp] [char](10) NOT NULL DEFAULT '',
		CONSTRAINT [PK_componet] PRIMARY KEY CLUSTERED 
		(
			[componetid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[componet] ON;

	INSERT INTO [dbo].[componet] ([componetid],[comp],[desc],[desc2],[memo1],[insp],[customerid],[cost],[unit],[vendorid],[price],[ctp_min],[cmi_inv],[cmi_min],[cmi_price],[material],[cust_comp],[cus_comp_r],
		[cust_desc],[memo],[inventory],[drw],[inc],[price_ire],[phys_inv],[inv_card],[quar],[hold],[reject],[classid],[comp_rev],[samp_plan],[lbl],[xinv],[pickconv],[back_dist],[expire],[comptype],[color],
		[colorantid],[pantone],[fda_food],[fda_med],[coneg],[prop65],[rohs],[eu_94_62],[rev_rec],[rev_dt],[rev_emp])

	SELECT [rawUpsize_Contech].[dbo].[componet].[componetid]
		,[rawUpsize_Contech].[dbo].[componet].[comp]
		,[rawUpsize_Contech].[dbo].[componet].[desc]
		,[rawUpsize_Contech].[dbo].[componet].[desc2]
		,[rawUpsize_Contech].[dbo].[componet].[memo1]
		,[rawUpsize_Contech].[dbo].[componet].[insp]
		--,[rawUpsize_Contech].[dbo].[componet].[cust_no]		
		,ISNULL(customer.[customerid], NULL) as [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
		,[rawUpsize_Contech].[dbo].[componet].[cost]
		,[rawUpsize_Contech].[dbo].[componet].[unit]
		--,[rawUpsize_Contech].[dbo].[componet].[ven_id]
		,ISNULL(vendor.[vendorid], NULL) AS [vendorid]			-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		,[rawUpsize_Contech].[dbo].[componet].[price]
		,[rawUpsize_Contech].[dbo].[componet].[ctp_min]
		,[rawUpsize_Contech].[dbo].[componet].[cmi_inv]
		,[rawUpsize_Contech].[dbo].[componet].[cmi_min]
		,[rawUpsize_Contech].[dbo].[componet].[cmi_price]
		,[rawUpsize_Contech].[dbo].[componet].[material]
		,[rawUpsize_Contech].[dbo].[componet].[cust_comp]
		,[rawUpsize_Contech].[dbo].[componet].[cus_comp_r]
		,[rawUpsize_Contech].[dbo].[componet].[cust_desc]
		,[rawUpsize_Contech].[dbo].[componet].[memo]
		,[rawUpsize_Contech].[dbo].[componet].[inventory]
		,[rawUpsize_Contech].[dbo].[componet].[drw]
		,[rawUpsize_Contech].[dbo].[componet].[inc]
		,[rawUpsize_Contech].[dbo].[componet].[price_ire]
		,[rawUpsize_Contech].[dbo].[componet].[phys_inv]
		,[rawUpsize_Contech].[dbo].[componet].[inv_card]
		,[rawUpsize_Contech].[dbo].[componet].[quar]
		,[rawUpsize_Contech].[dbo].[componet].[hold]
		,[rawUpsize_Contech].[dbo].[componet].[reject]
		--,[rawUpsize_Contech].[dbo].[componet].[class]
		,ISNULL(class.classid, NULL) AS [class]					-- FK = [class].[class] --> [class].[classid]
		,[rawUpsize_Contech].[dbo].[componet].[comp_rev]
		,[rawUpsize_Contech].[dbo].[componet].[samp_plan]
		,[rawUpsize_Contech].[dbo].[componet].[lbl]
		,[rawUpsize_Contech].[dbo].[componet].[xinv]
		,[rawUpsize_Contech].[dbo].[componet].[pickconv]
		,[rawUpsize_Contech].[dbo].[componet].[back_dist]
		,[rawUpsize_Contech].[dbo].[componet].[expire]
		,[rawUpsize_Contech].[dbo].[componet].[comptype]
		,[rawUpsize_Contech].[dbo].[componet].[color]
		--,[rawUpsize_Contech].[dbo].[componet].[color_no]
		,ISNULL(colorant.[colorantid], NULL) AS [colorantid]	-- FK = [colorant].[color_no] --> [colorant].[colorantid]
		,[rawUpsize_Contech].[dbo].[componet].[pantone]
		,[rawUpsize_Contech].[dbo].[componet].[fda_food]
		,[rawUpsize_Contech].[dbo].[componet].[fda_med]
		,[rawUpsize_Contech].[dbo].[componet].[coneg]
		,[rawUpsize_Contech].[dbo].[componet].[prop65]
		,[rawUpsize_Contech].[dbo].[componet].[rohs]
		,[rawUpsize_Contech].[dbo].[componet].[eu_94_62]
		,[rawUpsize_Contech].[dbo].[componet].[rev_rec]
		,[rawUpsize_Contech].[dbo].[componet].[rev_dt]
		,[rawUpsize_Contech].[dbo].[componet].[rev_emp]
	FROM [rawUpsize_Contech].[dbo].[componet] 
	LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[componet].[cust_no] = customer.[cust_no] 
	LEFT JOIN [dbo].[vendor] vendor ON [rawUpsize_Contech].[dbo].[componet].[ven_id] = vendor.[ven_id]
	LEFT JOIN [dbo].[colorant] colorant ON [rawUpsize_Contech].[dbo].[componet].[color_no] = colorant.[colorantno] 
	LEFT JOIN [dbo].[class] class ON [rawUpsize_Contech].[dbo].[componet].[class] = class.[class]

	SET IDENTITY_INSERT [dbo].[componet] OFF;

	--SELECT * FROM [dbo].[componet]

    PRINT 'Table: dbo.componet: end'
	
-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section003_HR.sql'

-- =========================================================