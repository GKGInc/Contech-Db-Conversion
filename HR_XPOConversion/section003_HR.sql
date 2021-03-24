-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section003_HR.sql'
DECLARE @SQL varchar(4000)=''

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 003: class (renamed to classtype)
-- =========================================================

-- Column changes:
--	- Moved [classid] to first column
--  - Changed [classid] to be primary key
--  - Changed [desc] from [text] to [varchar](2000)

    PRINT 'Table: dbo.classtype: start'
	
	INSERT INTO [dbo].[classtype]([class],[desc])
		SELECT * FROM [rawUpsize_Contech].[dbo].[class] 

	--SELECT * FROM [dbo].[classtype]
	
    PRINT 'Table: dbo.class: classtype'

-- =========================================================
-- Section 003: doctypes -- Moved from section 031
-- =========================================================

-- Column changes:
--  - Added [doctypesid] to be primary key
--  - Changed [doctypesid] to [doctypeid]

	PRINT 'Table: dbo.doctypes: start'

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
	
	SET IDENTITY_INSERT [dbo].[docs_hdr] ON;

	INSERT INTO [dbo].[docs_hdr] ([docs_hdrid],[doctypeid],[series],[descript])
	SELECT [rawUpsize_Contech].[dbo].[docs_hdr].[docs_hdrid]
		  --,[rawUpsize_Contech].[dbo].[docs_hdr].[doctype]
		  ,ISNULL(doctypes.[doctypeid], NULL) AS [doctypeid] -- FK = [doctypes].[doctype] -> [doctypes].[doctypeid]
		  ,[rawUpsize_Contech].[dbo].[docs_hdr].[series]
		  ,[rawUpsize_Contech].[dbo].[docs_hdr].[descript]
	  FROM [rawUpsize_Contech].[dbo].[docs_hdr]
	  LEFT JOIN [doctypes] doctypes ON [rawUpsize_Contech].[dbo].[docs_hdr].[doctype] = doctypes.[doctype]
		ORDER BY [rawUpsize_Contech].[dbo].[docs_hdr].[docs_hdrid]

	SET IDENTITY_INSERT [dbo].[docs_hdr] OFF;

	--SELECT * FROM [dbo].[[docs_hdr]]

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
	
	SET IDENTITY_INSERT [dbo].[docs_dtl] ON;

	INSERT INTO [dbo].[docs_dtl] (
		[docs_dtlid]
      ,[docs_hdrid]
      ,[doctype]
      ,[series]
      ,[extension]
      ,[document]
      ,[descript]
      ,[rev]
      ,[rev_date]
      ,[move_date]
      ,[docmod]
      ,[cpmr_rev]
      ,[cpmr_date]
      ,[rev_rec]
      ,[rev_dt]
      ,[rev_employeeid]
			)
	SELECT [rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docs_hdrid]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[doctype]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[series]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[extension]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[document]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[descript]
		  ,TRIM([rawUpsize_Contech].[dbo].[docs_dtl].[rev])
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[move_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[docmod]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_rev]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[cpmr_date]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_rec]
		  ,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_dt]
		  --,[rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp]
		  ,ISNULL(employee.[EmployeeId], NULL) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	  FROM [rawUpsize_Contech].[dbo].[docs_dtl]
	  LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[docs_dtl].[rev_emp] = employee.[empnumber]	
	  WHERE [docs_hdrid] > 0
	  ORDER BY [rawUpsize_Contech].[dbo].[docs_dtl].[docs_dtlid]
  
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

	SET IDENTITY_INSERT [dbo].[colorant] ON;

	INSERT INTO [dbo].[colorant] ([colorantid],[colorantno],[color_desc],[docs_dtlid])
	SELECT [rawUpsize_Contech].[dbo].[colorant].[colorantid]
		  ,[rawUpsize_Contech].[dbo].[colorant].[colorantno]
		  ,[rawUpsize_Contech].[dbo].[colorant].[color_desc]
		  --,[rawUpsize_Contech].[dbo].[colorant].[document]
		  ,ISNULL(docs_dtl.[docs_dtlid], NULL) AS [docs_dtlid] 
	  FROM [rawUpsize_Contech].[dbo].[colorant]
	  LEFT JOIN [dbo].[docs_dtl] docs_dtl ON [rawUpsize_Contech].[dbo].[colorant].[document] = docs_dtl.[document]
	  ORDER BY [rawUpsize_Contech].[dbo].[colorant].[colorantno]
    
	SET IDENTITY_INSERT [dbo].[colorant] OFF;

	--SELECT * FROM [dbo].[colorant]
	
    PRINT 'Table: dbo.colorant: end'
		
-- =========================================================
-- Section 003: material -- Moved from section017
-- =========================================================

-- Column changes:
--  - Added [materialid] to be primary key
--  - Changed [description] from [text] to [varchar](2000)

    PRINT 'Table: dbo.material: start'
	
	INSERT INTO [dbo].[material] ([material],[description],[type])
	 SELECT * FROM [rawUpsize_Contech].[dbo].[material]
  
	--SELECT * FROM [dbo].[material]
	
    PRINT 'Table: dbo.material: end'

	-- =========================================================
-- Section 028: comptype -- Moved to section003
-- =========================================================

-- Column changes:
--  - Added [comptypeid] to be primary key

    PRINT 'Table: dbo.comptype: start'
	
	INSERT INTO [dbo].[comptype] ([comptype],[descript])
	SELECT [comptype]
		  ,[descript]
	  FROM [rawUpsize_Contech].[dbo].[comptype]
  
	--SELECT * FROM [dbo].[comptype]

    PRINT 'Table: dbo.comptype: end'

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
--	- [componet].[rev_emp] --> [rev_employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
--	- [componet].[material] --> [materialid]	-- FK = [material].[material] --> [material].[materialid]
--	- [componet].[comptype] --> [comptypeid]	-- FK = [comptype].[comptype] --> [comptype].[comptypeid]

	PRINT 'Table: dbo.componet: start'

	SET IDENTITY_INSERT [dbo].[componet] ON;

	INSERT INTO [dbo].[componet] ([componetid]
      ,[comp]
      ,[desc]
      ,[des2]
      ,[memo1]
      ,[insp]
      ,[customerid]
      ,[cost]
      ,[unit]
      ,[vendorid]
      ,[price]
      ,[ctp_min]
      ,[cmi_inv]
      ,[cmi_min]
      ,[cmi_price]
      ,[materialid]
      ,[cust_comp]
      ,[cus_comp_r]
      ,[cust_desc]
      ,[memo]
      ,[inventory]
      ,[drw]
      ,[inc]
      ,[price_ire]
      ,[phys_inv]
      ,[inv_card]
      ,[quar]
      ,[hold]
      ,[reject]
      ,[classtypeid]
      ,[comp_rev]
      ,[samp_plan]
      ,[LBL]
      ,[xinv]
      ,[pickconv]
      ,[back_dist]
      ,[expire]
      ,[comptypeid]
      ,[color]
      ,[colorantid]
      ,[pantone]
      ,[fda_food]
      ,[fda_med]
      ,[coneg]
      ,[prop65]
      ,[rohs]
      ,[eu_94_62]
      ,[rev_rec]
      ,[rev_dt]
      ,[rev_emp]) 

	SELECT [rawUpsize_Contech].[dbo].[componet].[componetid]  --49
		,[rawUpsize_Contech].[dbo].[componet].[comp]
		,[rawUpsize_Contech].[dbo].[componet].[desc]
		,[rawUpsize_Contech].[dbo].[componet].[desc2]
		,[rawUpsize_Contech].[dbo].[componet].[memo1]
		,[rawUpsize_Contech].[dbo].[componet].[insp]
		--,[rawUpsize_Contech].[dbo].[componet].[cust_no]		
		,ISNULL(customer.[CustomerId], NULL) as [customerid]	-- FK = [customer].[cust_no] --> [customer].[customerid]
		,[rawUpsize_Contech].[dbo].[componet].[cost]
		,[rawUpsize_Contech].[dbo].[componet].[unit]
		--,[rawUpsize_Contech].[dbo].[componet].[ven_id]
		,ISNULL(vendor.[VendorId], NULL) AS [vendorid]			-- FK = [vendor].[ven_id] --> [vendor].[vendorid]
		,[rawUpsize_Contech].[dbo].[componet].[price]
		,[rawUpsize_Contech].[dbo].[componet].[ctp_min]
		,[rawUpsize_Contech].[dbo].[componet].[cmi_inv]
		,[rawUpsize_Contech].[dbo].[componet].[cmi_min]
		,[rawUpsize_Contech].[dbo].[componet].[cmi_price]
		--,[rawUpsize_Contech].[dbo].[componet].[material]
		,ISNULL(material.[materialid], NULL) AS [materialid]	-- FK = [material].[material] --> [material].[materialid]
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
		,ISNULL(class.ClassId, NULL) AS [class]					-- FK = [class].[class] --> [class].[classid]
		,[rawUpsize_Contech].[dbo].[componet].[comp_rev]
		,[rawUpsize_Contech].[dbo].[componet].[samp_plan]
		,[rawUpsize_Contech].[dbo].[componet].[lbl]
		,[rawUpsize_Contech].[dbo].[componet].[xinv]
		,[rawUpsize_Contech].[dbo].[componet].[pickconv]
		,[rawUpsize_Contech].[dbo].[componet].[back_dist]
		,[rawUpsize_Contech].[dbo].[componet].[expire]
		--,[rawUpsize_Contech].[dbo].[componet].[comptype]
		,ISNULL(comptype.[comptypeid], NULL) AS [comptypeid]	-- FK = [comptype].[comptype] --> [comptype].[comptypeid]
		,[rawUpsize_Contech].[dbo].[componet].[color]
		--,[rawUpsize_Contech].[dbo].[componet].[color_no]
		,ISNULL(colorant.[colorantId], NULL) AS [colorantid]	-- FK = [colorant].[color_no] --> [colorant].[colorantid]
		,[rawUpsize_Contech].[dbo].[componet].[pantone]
		,[rawUpsize_Contech].[dbo].[componet].[fda_food]
		,[rawUpsize_Contech].[dbo].[componet].[fda_med]
		,[rawUpsize_Contech].[dbo].[componet].[coneg]
		,[rawUpsize_Contech].[dbo].[componet].[prop65]
		,[rawUpsize_Contech].[dbo].[componet].[rohs]
		,[rawUpsize_Contech].[dbo].[componet].[eu_94_62]
		,[rawUpsize_Contech].[dbo].[componet].[rev_rec]
		,[rawUpsize_Contech].[dbo].[componet].[rev_dt]
		--,[rawUpsize_Contech].[dbo].[componet].[rev_emp]		-- FK = Employee.EmployeeNumber
		,ISNULL(employee.[EmployeeId], NULL) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	FROM [rawUpsize_Contech].[dbo].[componet] 
	LEFT JOIN [dbo].[customer] customer ON [rawUpsize_Contech].[dbo].[componet].[cust_no] = customer.[cust_no] 
	LEFT JOIN [dbo].[vendor] vendor ON [rawUpsize_Contech].[dbo].[componet].[ven_id] = vendor.[ven_id]
	LEFT JOIN [dbo].[material] material ON [rawUpsize_Contech].[dbo].[componet].[Material] = material.[material] 
	LEFT JOIN [dbo].[comptype] comptype ON [rawUpsize_Contech].[dbo].[componet].[comptype] = comptype.[comptype] 
	LEFT JOIN [dbo].[colorant] colorant ON [rawUpsize_Contech].[dbo].[componet].[color_no] = colorant.[colorantno] 
	LEFT JOIN [dbo].[classtype] class ON [rawUpsize_Contech].[dbo].[componet].[class] = class.[class]
	LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[componet].[rev_emp] = employee.[empnumber]	

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