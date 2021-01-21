
-- =========================================================
-- Section 029: corractn
-- =========================================================

-- Column changes:
--  - Set [corractnid] to be primary key
--  - Changed [remarks] from text to varchar(2000)
--  - Changed [ven_cause] from text to varchar(2000)
--  - Changed [ven_prevnt] from text to varchar(2000)
--  - Changed [evd_effect] from text to varchar(2000)
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
--  - Changed [qrn_no] [char](8) to [qrnid] [int] to reference [qrn] table
--  - Renamed [matlin_key] to [matlinid]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [users] table
--  - Renamed [complnt_no] to [complntid] [to reflect new standards
-- Maps:
--	- [corractn].[car_no]		-- FK = [cartrack].[car_no]
--	- [corractn].[qrn_no]		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
--	- [corractn].[matlinid]		-- FK = [matlin].[matlin_key] --> [matlin].[matlinid]
--	- [corractn].[comp]			-- FK = [componet].[comp] --> [componet].[componetid]
--	- [corractn].[complnt_no]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'corractn'))
    DROP TABLE [corractn]

CREATE TABLE [corractn](
	[corractnid] [int] identity(1,1) NOT NULL,
	[car_no] [char](8) NOT NULL DEFAULT '',	-- FK = [corractn].[car_no] 
	[car_date] [datetime] NULL,
	--[qrn_no] [char](8) NOT NULL,			-- FK = [qrn].[qrn_no] 
	[qrnid] [int] NOT NULL DEFAULT 0,		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
	--[matlin_key] [int] NOT NULL DEFAULT 0,-- FK = [matlin].[matlin_key]
	[matlinid] [int] NOT NULL DEFAULT 0,	-- FK = [matlin].[matlin_key] --> [matlin].[matlinid]
	[source] [char](2) NOT NULL DEFAULT '',
	--[comp] [char](5) NOT NULL,			-- FK = [componet].[comp] 
	[componetid] [int] NOT NULL,			-- FK = [componet].[comp] --> [componet].[componetid]
	[comp_desc] [char](75) NOT NULL DEFAULT '',
	[qty_rej] [int] NOT NULL DEFAULT '',
	[remarks] varchar(2000) NOT NULL DEFAULT '',
	[ven_cause] varchar(2000) NOT NULL DEFAULT '',
	[ven_prevnt] varchar(2000) NOT NULL DEFAULT '',
	[ven_sign] [char](50) NOT NULL DEFAULT '',
	[ven_title] [char](50) NOT NULL DEFAULT '',
	[ven_date] [datetime] NULL,
	[init_note] [datetime] NULL,
	[follow_up] [datetime] NULL,
	[final_note] [datetime] NULL,
	[revgrpmeet] [datetime] NULL,
	[issued_by] [char](50) NOT NULL DEFAULT '',
	[evd_effect] varchar(2000) NOT NULL DEFAULT '',
	[rspns_appr] [int] NOT NULL DEFAULT 0,
	[c_method] [bit] NOT NULL DEFAULT 0,
	[c_material] [bit] NOT NULL DEFAULT 0,
	[c_manpower] [bit] NOT NULL DEFAULT 0,
	[c_machinry] [bit] NOT NULL DEFAULT 0,
	[close_date] [datetime] NULL,
	[c_vendor] [bit] NOT NULL DEFAULT 0,
	[urgent] [bit] NOT NULL DEFAULT 0,
	[r_replcmnt] [bit] NOT NULL DEFAULT 0,
	[r_credit] [bit] NOT NULL DEFAULT 0,
	[corr_type] [char](1) NOT NULL DEFAULT '',
	[approve1] [char](50) NOT NULL DEFAULT '',
	[approve1dt] [datetime] NULL,
	[approve1ti] [char](50) NOT NULL DEFAULT '',
	[approve2] [char](50) NOT NULL DEFAULT '',
	[approve2ti] [char](50) NOT NULL DEFAULT '',
	[approve2dt] [datetime] NULL,
	[completeby] [char](50) NOT NULL DEFAULT '',
	[completeti] [char](50) NOT NULL DEFAULT '',
	[completedt] [datetime] NULL,
	[close_by] [char](50) NOT NULL DEFAULT '',
	[issued_to] [char](4) NOT NULL DEFAULT '',
	[expclosedt] [datetime] NULL,
	[ref_doc] [char](25) NOT NULL DEFAULT '',
	--[complnt_no] [int] NOT NULL DEFAULT 0,	-- FK = [complnts].[complnt_no]
	[complntid] [int] NOT NULL DEFAULT 0,		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]  
	[c_inconclu] [bit] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_corractn] PRIMARY KEY CLUSTERED 
	(
		[corractnid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [corractn] ON;

INSERT INTO [corractn] ([corractnid],[car_no],[car_date],[qrnid],[matlinid],[source],[componetid],[comp_desc],[qty_rej],[remarks],[ven_cause],[ven_prevnt],[ven_sign],[ven_title],[ven_date],[init_note],[follow_up],[final_note],[revgrpmeet],[issued_by],[evd_effect],[rspns_appr],[c_method],[c_material],[c_manpower],[c_machinry],[close_date],[c_vendor],[urgent],[r_replcmnt],[r_credit],[corr_type],[approve1],[approve1dt],[approve1ti],[approve2],[approve2ti],[approve2dt],[completeby],[completeti],[completedt],[close_by],[issued_to],[expclosedt],[ref_doc],[complntid],[c_inconclu])
SELECT [rawUpsize_Contech].[dbo].[corractn].[corractnid]
      ,[rawUpsize_Contech].[dbo].[corractn].[car_no]
      ,[rawUpsize_Contech].[dbo].[corractn].[car_date]
      --,[rawUpsize_Contech].[dbo].[corractn].[qrn_no]		-- FK = [qrn].[qrn_no] 
	  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
      ,[rawUpsize_Contech].[dbo].[corractn].[matlin_key]	-- FK = [matlin].[matlin_key] --> [matlin].[matlinid]		
      ,[rawUpsize_Contech].[dbo].[corractn].[source]
      --,[rawUpsize_Contech].[dbo].[corractn].[comp]		-- FK = [componet].[comp] 
	  ,ISNULL(componet.[componetid], 0) AS [componetid]		-- FK = [componet].[comp] --> [componet].[componetid]
      ,[rawUpsize_Contech].[dbo].[corractn].[comp_desc]
      ,[rawUpsize_Contech].[dbo].[corractn].[qty_rej]
      ,[rawUpsize_Contech].[dbo].[corractn].[remarks]
      ,[rawUpsize_Contech].[dbo].[corractn].[ven_cause]
      ,[rawUpsize_Contech].[dbo].[corractn].[ven_prevnt]
      ,[rawUpsize_Contech].[dbo].[corractn].[ven_sign]
      ,[rawUpsize_Contech].[dbo].[corractn].[ven_title]
      ,[rawUpsize_Contech].[dbo].[corractn].[ven_date]
      ,[rawUpsize_Contech].[dbo].[corractn].[init_note]
      ,[rawUpsize_Contech].[dbo].[corractn].[follow_up]
      ,[rawUpsize_Contech].[dbo].[corractn].[final_note]
      ,[rawUpsize_Contech].[dbo].[corractn].[revgrpmeet]
      ,[rawUpsize_Contech].[dbo].[corractn].[issued_by]
      ,[rawUpsize_Contech].[dbo].[corractn].[evd_effect]
      ,[rawUpsize_Contech].[dbo].[corractn].[rspns_appr]
      ,[rawUpsize_Contech].[dbo].[corractn].[c_method]
      ,[rawUpsize_Contech].[dbo].[corractn].[c_material]
      ,[rawUpsize_Contech].[dbo].[corractn].[c_manpower]
      ,[rawUpsize_Contech].[dbo].[corractn].[c_machinry]
      ,[rawUpsize_Contech].[dbo].[corractn].[close_date]
      ,[rawUpsize_Contech].[dbo].[corractn].[c_vendor]
      ,[rawUpsize_Contech].[dbo].[corractn].[urgent]
      ,[rawUpsize_Contech].[dbo].[corractn].[r_replcmnt]
      ,[rawUpsize_Contech].[dbo].[corractn].[r_credit]
      ,[rawUpsize_Contech].[dbo].[corractn].[corr_type]
      ,[rawUpsize_Contech].[dbo].[corractn].[approve1]
      ,[rawUpsize_Contech].[dbo].[corractn].[approve1dt]
      ,[rawUpsize_Contech].[dbo].[corractn].[approve1ti]
      ,[rawUpsize_Contech].[dbo].[corractn].[approve2]
      ,[rawUpsize_Contech].[dbo].[corractn].[approve2ti]
      ,[rawUpsize_Contech].[dbo].[corractn].[approve2dt]
      ,[rawUpsize_Contech].[dbo].[corractn].[completeby]
      ,[rawUpsize_Contech].[dbo].[corractn].[completeti]
      ,[rawUpsize_Contech].[dbo].[corractn].[completedt]
      ,[rawUpsize_Contech].[dbo].[corractn].[close_by]
      ,[rawUpsize_Contech].[dbo].[corractn].[issued_to]
      ,[rawUpsize_Contech].[dbo].[corractn].[expclosedt]
      ,[rawUpsize_Contech].[dbo].[corractn].[ref_doc]
      --,[rawUpsize_Contech].[dbo].[corractn].[complnt_no]	-- FK = [complnts].[complnt_no]  
	  ,ISNULL(complnts.[complntid], 0) AS [complntid]		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]  
      ,[rawUpsize_Contech].[dbo].[corractn].[c_inconclu]
  FROM [rawUpsize_Contech].[dbo].[corractn]
  LEFT JOIN [qrn] qrn ON [rawUpsize_Contech].[dbo].[corractn].[qrn_no] = qrn.[qrn_no] 
  LEFT JOIN [componet] componet ON [rawUpsize_Contech].[dbo].[corractn].[comp] = componet.[comp] 
  LEFT JOIN [complnts]  ON [rawUpsize_Contech].[dbo].[corractn].[complnt_no] = complnts.[complnt_no] 

SET IDENTITY_INSERT [corractn] OFF;

--SELECT * FROM [corractn]

-- =========================================================
-- Section 029: cractdtl
-- =========================================================

-- Column changes:
--  - Set [cractdtlid] to be primary key
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
-- Maps:
--	- [cractdtl].[car_no] --> [corractnid]		-- FK = [cartrack].[car_no]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cractdtl'))
    DROP TABLE [cractdtl]

CREATE TABLE [cractdtl](
	[cractdtlid] [int] identity(1,1) NOT NULL,
	--[car_no] [char](8) NOT NULL DEFAULT '',		-- FK = [corractn].[car_no] 
	[corractnid] [int] NOT NULL DEFAULT 0,			-- FK = [corractn].[car_no] --> [corractn].[corractnid]
	[requiremnt] [char](100) NOT NULL DEFAULT '',
	[actual] [char](100) NOT NULL DEFAULT '',
	[sampl_size] [int] NOT NULL DEFAULT 0,
	[defects] [int] NOT NULL DEFAULT 0,
	[coractnreq] [bit] NOT NULL DEFAULT 0,
	[use_as] [bit] NOT NULL DEFAULT 0,
	[return] [bit] NOT NULL DEFAULT 0,
	[scrap] [bit] NOT NULL DEFAULT 0,
	[rework] [bit] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_cractdtl] PRIMARY KEY CLUSTERED 
	(
		[cractdtlid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [cractdtl] ON;

INSERT INTO [cractdtl] ([cractdtlid],[corractnid],[requiremnt],[actual],[sampl_size],[defects],[coractnreq],[use_as],[return],[scrap],[rework])
SELECT [rawUpsize_Contech].[dbo].[cractdtl].[cractdtlid]
      --,[rawUpsize_Contech].[dbo].[cractdtl].[car_no]
	  ,ISNULL(corractn.[corractnid] , 0) as [corractnid]	
      ,[rawUpsize_Contech].[dbo].[cractdtl].[requiremnt]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[actual]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[sampl_size]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[defects]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[coractnreq]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[use_as]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[return]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[scrap]
      ,[rawUpsize_Contech].[dbo].[cractdtl].[rework]
  FROM [rawUpsize_Contech].[dbo].[cractdtl]
  LEFT JOIN [corractn] corractn ON [rawUpsize_Contech].[dbo].[cractdtl].[car_no] = corractn.[car_no]		-- FK = [corractn].[car_no] --> [corractn].[corractnid]
  
SET IDENTITY_INSERT [cractdtl] OFF;

--SELECT * FROM [cractdtl]

-- =========================================================
-- Section 029: cuslblft
-- =========================================================

-- Column changes:
--  - Set [cuslblftid] to be primary key
--  - Moved [cuslblftid] field to first column
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [rev_emp] [char](5) to [employeeid] [int] to reference [employee] table
-- Maps:
--	- [custctct].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [custctct].[rev_emp] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'cuslblft'))
    DROP TABLE [cuslblft]

CREATE TABLE [cuslblft](
	[cuslblftid] [int] identity(1,1) NOT NULL,
	--[cust_no] [char](5) NOT NULL DEFAULT '',	-- FK = [customer].[cust_no] 
	[customerid] int NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] -> [customer].[customerid]
	[flag] [char](1) NOT NULL DEFAULT '',
	[lic] [char](4) NOT NULL DEFAULT '',
	[r] [char](2) NOT NULL DEFAULT '',
	[q] [char](1) NOT NULL DEFAULT '',
	[umid1] [char](1) NOT NULL DEFAULT '',
	[umid2] [char](1) NOT NULL DEFAULT '',
	[umid3] [char](1) NOT NULL DEFAULT '',
	[umid4] [char](1) NOT NULL DEFAULT '',
	[rev_rec] [int] NOT NULL DEFAULT 0,
	[rev_dt] [datetime] NULL,
	--[rev_emp] [char](10) NOT NULL,			-- FK = [employee].[empnumber] -
	[employeeid] int NOT NULL,					-- FK = [employee].[empnumber] -> [employee].[employeeid]
	CONSTRAINT [PK_cuslblft] PRIMARY KEY CLUSTERED 
	(
		[cuslblftid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [cuslblft] ON;

INSERT INTO [cuslblft] ([cuslblftid],[customerid],[flag],[lic],[r],[q],[umid1],[umid2],[umid3],[umid4],[rev_rec],[rev_dt],[employeeid])
SELECT [rawUpsize_Contech].[dbo].[cuslblft].[cuslblftid]
      --,[rawUpsize_Contech].[dbo].[cuslblft].[cust_no]		-- FK = [customer].[cust_no]
	  ,ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] -> [customer].[customerid]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[flag]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[lic]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[r]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[q]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[umid1]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[umid2]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[umid3]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[umid4]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[rev_rec]
      ,[rawUpsize_Contech].[dbo].[cuslblft].[rev_dt]
      --,[rawUpsize_Contech].[dbo].[cuslblft].[rev_emp]		-- FK = [employee].[empnumber] 		
	  ,ISNULL(employee.[employeeid], 0) AS [employeeid]		-- FK = [employee].[empnumber] -> [employee].[employeeid]
  FROM [rawUpsize_Contech].[dbo].[cuslblft]
  LEFT JOIN [customer] customer ON [rawUpsize_Contech].[dbo].[cuslblft].[cust_no] = customer.[cust_no]		-- FK = [customer].[cust_no] -> [customer].[customerid]
  LEFT JOIN [employee] employee ON [rawUpsize_Contech].[dbo].[cuslblft].[rev_emp] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

SET IDENTITY_INSERT [cuslblft] OFF;

--SELECT * FROM [cuslblft]

-- =========================================================
-- Section 029: custctct
-- =========================================================

-- Column changes:
--  - Set [custctctid] to be primary key
--  - Moved [custctctid] field to first column
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
-- Maps:
--	- [custctct].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'custctct'))
    DROP TABLE [custctct]

CREATE TABLE [custctct](
	[custctctid] [int] identity(1,1) NOT NULL,
	--[cust_no] [char](5) NOT NULL,			-- FK = [customer].[cust_no] 
	[customerid] int NOT NULL DEFAULT 0,	-- FK = [customer].[cust_no] -> [customer].[customerid]
	[first_name] [char](15) NOT NULL DEFAULT '',
	[last_name] [char](25) NOT NULL DEFAULT '',
	[mi] [char](1) NOT NULL DEFAULT '',
	[department] [char](50) NOT NULL DEFAULT '',
	[email] [char](100) NOT NULL DEFAULT '',
	[ext] [char](4) NOT NULL DEFAULT '',
	[phone] [char](17) NOT NULL DEFAULT '',
	[fax] [char](17) NOT NULL DEFAULT '',
	[address] [char](35) NOT NULL DEFAULT '',
	[address2] [char](35) NOT NULL DEFAULT '',
	[city] [char](30) NOT NULL DEFAULT '',
	[state] [char](3) NOT NULL DEFAULT '',
	[zip] [char](11) NOT NULL DEFAULT '',
	[country] [char](15) NOT NULL DEFAULT '',
	[job_title] [char](50) NOT NULL DEFAULT '',
	CONSTRAINT [PK_custctct] PRIMARY KEY CLUSTERED 
	(
		[custctctid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [custctct] ON;

INSERT INTO [custctct] ([custctctid],[customerid],[first_name],[last_name],[mi],[department],[email],[ext],[phone],[fax],[address],[address2],[city],[state],[zip],[country],[job_title])
SELECT [rawUpsize_Contech].[dbo].[custctct].[custctctid]
      --,[rawUpsize_Contech].[dbo].[custctct].[cust_no]		
	  ,ISNULL(customer.[customerid], 0) as [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
      ,[rawUpsize_Contech].[dbo].[custctct].[first_name]
      ,[rawUpsize_Contech].[dbo].[custctct].[last_name]
      ,[rawUpsize_Contech].[dbo].[custctct].[mi]
      ,[rawUpsize_Contech].[dbo].[custctct].[department]
      ,[rawUpsize_Contech].[dbo].[custctct].[email]
      ,[rawUpsize_Contech].[dbo].[custctct].[ext]
      ,[rawUpsize_Contech].[dbo].[custctct].[phone]
      ,[rawUpsize_Contech].[dbo].[custctct].[fax]
      ,[rawUpsize_Contech].[dbo].[custctct].[address]
      ,[rawUpsize_Contech].[dbo].[custctct].[address2]
      ,[rawUpsize_Contech].[dbo].[custctct].[city]
      ,[rawUpsize_Contech].[dbo].[custctct].[state]
      ,[rawUpsize_Contech].[dbo].[custctct].[zip]
      ,[rawUpsize_Contech].[dbo].[custctct].[country]
      ,[rawUpsize_Contech].[dbo].[custctct].[job_title]
  FROM [rawUpsize_Contech].[dbo].[custctct]
  LEFT JOIN [customer] customer ON [rawUpsize_Contech].[dbo].[custctct].[cust_no] = customer.[cust_no] 
  
SET IDENTITY_INSERT [custctct] OFF;

--SELECT * FROM [custctct]

-- =========================================================
-- Section 029: custship
-- =========================================================

-- Column changes:
--  - Added [custshipid] to be primary key
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
-- Maps:
--	- [custship].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [custship].[fplocatnid]				-- FK = [fplocatn].[fplocatnid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'custship'))
    DROP TABLE [custship]

CREATE TABLE [custship](
	[custshipid] [int] identity(1,1) NOT NULL,
	--[cust_no] [char](5) NOT NULL,				-- FK = [customer].[cust_no] 
	[customerid] int NOT NULL DEFAULT 0,		-- FK = [customer].[cust_no] -> [customer].[customerid]
	[ship_to] [char](1) NOT NULL DEFAULT '',	
	[ship_via] [char](20) NOT NULL DEFAULT '',
	[name] [char](100) NOT NULL DEFAULT '',
	[address] [char](35) NOT NULL DEFAULT '',
	[address2] [char](35) NOT NULL DEFAULT '',
	[city] [char](30) NOT NULL DEFAULT '',
	[state] [char](3) NOT NULL DEFAULT '',
	[zip] [char](11) NOT NULL DEFAULT '',
	[country] [char](15) NOT NULL DEFAULT '',
	[acct_no] [char](15) NOT NULL DEFAULT '',
	[fob_point] [char](15) NOT NULL DEFAULT '',
	[phone] [char](17) NOT NULL DEFAULT '',
	[fax] [char](17) NOT NULL DEFAULT '',
	[fplocatnid] [int] NOT NULL DEFAULT 0,		-- FK = [fplocatn].[fplocatnid]
	CONSTRAINT [PK_custship] PRIMARY KEY CLUSTERED 
	(
		[custshipid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [custship] ([customerid],[ship_to],[ship_via],[name],[address],[address2],[city],[state],[zip],[country],[acct_no],[fob_point],[phone],[fax],[fplocatnid])
SELECT --[rawUpsize_Contech].[dbo].[custship].[cust_no]		-- FK = [customer].[cust_no] 
	  ISNULL(customer.[customerid], 0) as [customerid]		-- FK = [customer].[cust_no] -> [customer].[customerid]
      ,[rawUpsize_Contech].[dbo].[custship].[ship_to]
      ,[rawUpsize_Contech].[dbo].[custship].[ship_via]
      ,[rawUpsize_Contech].[dbo].[custship].[name]
      ,[rawUpsize_Contech].[dbo].[custship].[address]
      ,[rawUpsize_Contech].[dbo].[custship].[address2]
      ,[rawUpsize_Contech].[dbo].[custship].[city]
      ,[rawUpsize_Contech].[dbo].[custship].[state]
      ,[rawUpsize_Contech].[dbo].[custship].[zip]
      ,[rawUpsize_Contech].[dbo].[custship].[country]
      ,[rawUpsize_Contech].[dbo].[custship].[acct_no]
      ,[rawUpsize_Contech].[dbo].[custship].[fob_point]
      ,[rawUpsize_Contech].[dbo].[custship].[phone]
      ,[rawUpsize_Contech].[dbo].[custship].[fax]
      ,[rawUpsize_Contech].[dbo].[custship].[fplocatnid]	-- FK = [fplocatn].[fplocatnid]
  FROM [rawUpsize_Contech].[dbo].[custship]
  LEFT JOIN [customer] customer ON [rawUpsize_Contech].[dbo].[custship].[cust_no] = customer.[cust_no] 
  
--SELECT * FROM [custship]

-- =========================================================