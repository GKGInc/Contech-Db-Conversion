
-- =========================================================
-- Section 035: issuetyp
-- =========================================================

-- Column changes:
--  - Added [issuetypid] to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'issuetyp'))
    DROP TABLE [dbo].[issuetyp]

CREATE TABLE [dbo].[issuetyp](
	[issuetypid] [int] IDENTITY(1,1) NOT NULL,
	[issue_type] [char](15) NOT NULL DEFAULT '',
	CONSTRAINT [PK_issuetyp] PRIMARY KEY CLUSTERED 
	(
		[issuetypid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [Contech_Test].[dbo].[issuetyp] ([issue_type])
SELECT [issue_type]
  FROM [rawUpsize_Contech].[dbo].[issuetyp]
  
--SELECT * FROM [Contech_Test].[dbo].[issuetyp]

-- =========================================================
-- Section 035: job_hist
-- =========================================================

-- *** NOT USED ***

-- Column changes:
--  - Set [job_histid] to be primary key
--  - Changed [notes] from text to varchar(2000)
--  - Changed [job_no] to [ordersid] to match updated standards
--  - Changed [userid] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [job_hist].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
--	- [job_hist].[userid]		-- FK = [users].[username] --> [users].[userid]

--USE Contech_Test

--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'job_hist'))
--    DROP TABLE [dbo].[job_hist]

--CREATE TABLE [dbo].[job_hist](
--	[job_histid] [int] IDENTITY(1,1) NOT NULL,
--	--[job_no] [int] NOT NULL DEFAULT 0,			
--	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
--	[notes] varchar(2000) NOT NULL DEFAULT '',
--	--[userid] [char](10) NOT NULL DEFAULT '',
--	[userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
--	[networkid] [char](30) NOT NULL DEFAULT '',
--	[note_dt] [datetime] NULL,
--	CONSTRAINT [PK_job_hist] PRIMARY KEY CLUSTERED 
--	(
--		[job_histid] ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] --TEXTIMAGE_ON [PRIMARY]
--GO

--SET IDENTITY_INSERT [Contech_Test].[dbo].[job_hist] ON;

--INSERT INTO [Contech_Test].[dbo].[job_hist] ([job_histid],[ordersid],[notes],[userid],[networkid],[note_dt])
--SELECT [rawUpsize_Contech].[dbo].[job_hist].[job_histid]
--      ,[rawUpsize_Contech].[dbo].[job_hist].[job_no]
--	  ,ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid] -- FK = [orders].[job_no] --> [orders].[ordersid] 
--      ,[rawUpsize_Contech].[dbo].[job_hist].[notes]
--      --,[rawUpsize_Contech].[dbo].[job_hist].[userid]
--	  ,ISNULL([Contech_Test].[dbo].[users].[userid] , 0) as [userid]	
--      ,[rawUpsize_Contech].[dbo].[job_hist].[networkid]
--      ,[rawUpsize_Contech].[dbo].[job_hist].[note_dt]
--  FROM [rawUpsize_Contech].[dbo].[job_hist]
--  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[job_hist].[job_no] = [Contech_Test].[dbo].[orders].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
--  LEFT JOIN [Contech_Test].[dbo].[users] ON [rawUpsize_Contech].[dbo].[job_hist].[userid] = [Contech_Test].[dbo].[users].[username]		-- FK = [users].[userid]

--SET IDENTITY_INSERT [Contech_Test].[dbo].[job_hist] OFF;

--SELECT * FROM [Contech_Test].[dbo].[job_hist]

-- =========================================================
-- Section 035: job_rels
-- =========================================================

-- *** NOT USED ***

-- Column changes:
--  - Set [job_relsid] to be primary key
--  - Changed [job_no] to [ordersid] to match updated standards
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [job_hist].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
--	- [job_hist].[add_user]		-- FK = [users].[username] --> [users].[userid]
--	- [job_hist].[mod_user]		-- FK = [users].[username] --> [users].[userid]

--USE Contech_Test

--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'job_rels'))
--    DROP TABLE [dbo].[job_rels]

--CREATE TABLE [dbo].[job_rels](
--	[job_relsid] [int] IDENTITY(1,1) NOT NULL,
--	--[job_no] [int] NOT NULL DEFAULT 0,
--	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
--	[rel_date] [datetime] NULL,
--	[rel_ack] [datetime] NULL,
--	[rel_qty] [int] NOT NULL DEFAULT 0,
--	[add_dt] [datetime] NULL,
--	--[add_user] [char](10) NOT NULL DEFAULT '',
--	[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
--	[mod_dt] [datetime] NULL,
--	--[mod_user] [char](10) NOT NULL DEFAULT '',
--	[mod_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
--	[rel_type] [char](1) NOT NULL DEFAULT '',
--	CONSTRAINT [PK_job_rels] PRIMARY KEY CLUSTERED 
--	(
--		[job_relsid] ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--SET IDENTITY_INSERT [Contech_Test].[dbo].[job_rels] ON;

--INSERT INTO [Contech_Test].[dbo].[job_rels] ([job_relsid],[ordersid],[rel_date],[rel_ack],[rel_qty],[add_dt],[add_userid],[mod_dt],[mod_userid],[rel_type])
--SELECT [rawUpsize_Contech].[dbo].[job_rels].[job_relsid]
--      --,[rawUpsize_Contech].[dbo].[job_rels].[job_no]
--	  ,ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid] -- FK = [orders].[job_no] --> [orders].[ordersid] 
--      ,[rawUpsize_Contech].[dbo].[job_rels].[rel_date]
--      ,[rawUpsize_Contech].[dbo].[job_rels].[rel_ack]
--      ,[rawUpsize_Contech].[dbo].[job_rels].[rel_qty]
--      ,[rawUpsize_Contech].[dbo].[job_rels].[add_dt]
--      --,[rawUpsize_Contech].[dbo].[job_rels].[add_user]
--	  ,ISNULL(addUser.[userid] , 0) as [userid]			
--      ,[rawUpsize_Contech].[dbo].[job_rels].[mod_dt]
--      --,[rawUpsize_Contech].[dbo].[job_rels].[mod_user]
--	  ,ISNULL(modUser.[userid] , 0) as [userid]			
--      ,[rawUpsize_Contech].[dbo].[job_rels].[rel_type]
--  FROM [rawUpsize_Contech].[dbo].[job_rels]
--  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[job_rels].[job_no] = [Contech_Test].[dbo].[orders].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]
--  LEFT JOIN [Contech_Test].[dbo].[users] addUser ON [rawUpsize_Contech].[dbo].[job_rels].[add_user] = addUser.[username]	-- FK = [users].[userid]
--  LEFT JOIN [Contech_Test].[dbo].[users] modUser ON [rawUpsize_Contech].[dbo].[job_rels].[mod_user] = modUser.[username]	-- FK = [users].[userid]
    
--SET IDENTITY_INSERT [Contech_Test].[dbo].[job_rels] OFF;

--SELECT * FROM [Contech_Test].[dbo].[job_rels]

-- =========================================================
-- Section 035: joblabel
-- =========================================================

-- Column changes:
--  - Added [joblabelid] to be primary key
--  - Changed [job_no] to [ordersid] to match updated standards
-- Maps:
--	- [joblabel].[job_no] --> [ordersid]	-- FK = [orders].[job_no] --> [orders].[ordersid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'joblabel'))
    DROP TABLE [dbo].[joblabel]

CREATE TABLE [dbo].[joblabel](
	[joblabelid] [int] IDENTITY(1,1) NOT NULL,
	--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no]
	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
	[flag] [char](1) NOT NULL DEFAULT '',
	[lic] [char](4) NOT NULL DEFAULT '',
	[pcn] [char](13) NOT NULL DEFAULT '',
	[r] [char](2) NOT NULL DEFAULT '',
	[q] [char](1) NOT NULL DEFAULT '',
	[ct_lot] [char](13) NOT NULL DEFAULT '',
	[cust_lot] [char](13) NOT NULL DEFAULT '',
	[expyyyy] [char](4) NOT NULL DEFAULT '',
	[expyy] [char](2) NOT NULL DEFAULT '',
	[expmm] [char](2) NOT NULL DEFAULT '',
	[expdd] [char](2) NOT NULL DEFAULT '',
	[expjjj] [char](3) NOT NULL DEFAULT '',
	[created] [datetime] NULL,
	[modified] [datetime] NULL,
	[umid1] [char](1) NOT NULL DEFAULT '',
	[umid2] [char](1) NOT NULL DEFAULT '',
	[umid3] [char](1) NOT NULL DEFAULT '',
	[umid4] [char](1) NOT NULL DEFAULT '',
	[expcmonth] [char](3) NOT NULL DEFAULT '',
	CONSTRAINT [PK_joblabel] PRIMARY KEY CLUSTERED 
	(
		[joblabelid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [Contech_Test].[dbo].[joblabel] ([ordersid],[flag],[lic],[pcn],[r],[q],[ct_lot],[cust_lot],[expyyyy],[expyy],[expmm],[expdd],[expjjj],[created],[modified],[umid1],[umid2],[umid3],[umid4],[expcmonth])
SELECT --[rawUpsize_Contech].[dbo].[joblabel].[job_no]
	  ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid] -- FK = [orders].[job_no] --> [orders].[ordersid] 
      ,[rawUpsize_Contech].[dbo].[joblabel].[flag]
      ,[rawUpsize_Contech].[dbo].[joblabel].[lic]
      ,[rawUpsize_Contech].[dbo].[joblabel].[pcn]
      ,[rawUpsize_Contech].[dbo].[joblabel].[r]
      ,[rawUpsize_Contech].[dbo].[joblabel].[q]
      ,[rawUpsize_Contech].[dbo].[joblabel].[ct_lot]
      ,[rawUpsize_Contech].[dbo].[joblabel].[cust_lot]
      ,[rawUpsize_Contech].[dbo].[joblabel].[expyyyy]
      ,[rawUpsize_Contech].[dbo].[joblabel].[expyy]
      ,[rawUpsize_Contech].[dbo].[joblabel].[expmm]
      ,[rawUpsize_Contech].[dbo].[joblabel].[expdd]
      ,[rawUpsize_Contech].[dbo].[joblabel].[expjjj]
      ,[rawUpsize_Contech].[dbo].[joblabel].[created]
      ,[rawUpsize_Contech].[dbo].[joblabel].[modified]
      ,[rawUpsize_Contech].[dbo].[joblabel].[umid1]
      ,[rawUpsize_Contech].[dbo].[joblabel].[umid2]
      ,[rawUpsize_Contech].[dbo].[joblabel].[umid3]
      ,[rawUpsize_Contech].[dbo].[joblabel].[umid4]
      ,[rawUpsize_Contech].[dbo].[joblabel].[expcmonth]
  FROM [rawUpsize_Contech].[dbo].[joblabel]
  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[joblabel].[job_no] = [Contech_Test].[dbo].[orders].[job_no]		-- FK = [orders].[job_no] --> [orders].[ordersid]

--SELECT * FROM [Contech_Test].[dbo].[joblabel]

-- =========================================================
-- Section 035: joblabor
-- =========================================================

-- Column changes:
--  - Set [joblaborid] to be primary key
--  - Changed [job_no] to [ordersid] to match updated standards
--  - Changed [empnumber] [char](10) to [employeeid] [int] to reference [employee] table
--  - Changed [notes] from text to varchar(2000)
-- Maps:
--	- [joblabor].[job_no] --> [ordersid]		-- FK = [orders].[job_no] --> [orders].[ordersid]
--	- [joblabor].[mfgstageid]					-- FK = [mfgstage].[mfgstageid]
--	- [joblabor].[empnumber] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'joblabor'))
    DROP TABLE [dbo].[joblabor]

CREATE TABLE [dbo].[joblabor](
	[joblaborid] [int] IDENTITY(1,1) NOT NULL,
	--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no]
	[ordersid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[ordersid]
	[mfgstageid] [int] NOT NULL DEFAULT 0,			-- FK = [mfgstage].[mfgstageid]
	--[empnumber] [char](10) NOT NULL DEFAULT '',	-- FK = [employee].[empnumber]
	[employeeid] [int] NOT NULL DEFAULT 0,			-- FK = [employee].[empnumber] -> [employee].[employeeid]
	[emp_rate] [numeric](5, 2) NOT NULL DEFAULT 0.0,
	[labor_date] [datetime] NULL,
	[timein] [char](6) NOT NULL DEFAULT '',
	[timeout] [char](6) NOT NULL DEFAULT '',
	[pcs] [numeric](10, 0) NOT NULL DEFAULT 0,
	[hrs] [numeric](4, 2) NOT NULL DEFAULT 0.0,
	[pcs_over_q] [numeric](10, 0) NOT NULL DEFAULT 0,
	[inc_pay] [numeric](6, 2) NOT NULL DEFAULT 0.0,
	[time_cost] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[lunch] [bit] NOT NULL DEFAULT 0,
	[quota] [numeric](6, 0) NOT NULL DEFAULT 0,
	[notes] varchar(2000) NOT NULL DEFAULT '',
	CONSTRAINT [PK_joblabor] PRIMARY KEY CLUSTERED 
	(
		[joblaborid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] --TEXTIMAGE_ON [PRIMARY]
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[joblabor] ON;

INSERT INTO [Contech_Test].[dbo].[joblabor] ([joblaborid],[ordersid],[mfgstageid],[employeeid],[emp_rate],[labor_date],[timein],[timeout],[pcs],[hrs],[pcs_over_q],[inc_pay],[time_cost],[lunch],[quota],[notes])
SELECT [rawUpsize_Contech].[dbo].[joblabor].[joblaborid]
      --,[rawUpsize_Contech].[dbo].[joblabor].[job_no]							-- FK = [orders].[job_no]
	  ,ISNULL([Contech_Test].[dbo].[orders].[ordersid], 0) AS [ordersid]		-- FK = [orders].[job_no] --> [orders].[ordersid] 
      ,[rawUpsize_Contech].[dbo].[joblabor].[mfgstageid]						-- FK = [mfgstage].[mfgstageid]
      --,[rawUpsize_Contech].[dbo].[joblabor].[empnumber]						-- FK = [employee].[empnumber] 
	  ,ISNULL([Contech_Test].[dbo].[employee].[employeeid], 0) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
      ,[rawUpsize_Contech].[dbo].[joblabor].[emp_rate]
      ,[rawUpsize_Contech].[dbo].[joblabor].[labor_date]
      ,[rawUpsize_Contech].[dbo].[joblabor].[timein]
      ,[rawUpsize_Contech].[dbo].[joblabor].[timeout]
      ,[rawUpsize_Contech].[dbo].[joblabor].[pcs]
      ,[rawUpsize_Contech].[dbo].[joblabor].[hrs]
      ,[rawUpsize_Contech].[dbo].[joblabor].[pcs_over_q]
      ,[rawUpsize_Contech].[dbo].[joblabor].[inc_pay]
      ,[rawUpsize_Contech].[dbo].[joblabor].[time_cost]
      ,[rawUpsize_Contech].[dbo].[joblabor].[lunch]
      ,[rawUpsize_Contech].[dbo].[joblabor].[quota]
      ,[rawUpsize_Contech].[dbo].[joblabor].[notes]
  FROM [rawUpsize_Contech].[dbo].[joblabor]
  LEFT JOIN [Contech_Test].[dbo].[orders] ON [rawUpsize_Contech].[dbo].[joblabor].[job_no] = [Contech_Test].[dbo].[orders].[job_no]				-- FK = [orders].[job_no] --> [orders].[ordersid]
  LEFT JOIN [Contech_Test].[dbo].[employee] ON [rawUpsize_Contech].[dbo].[joblabor].[empnumber] = [Contech_Test].[dbo].[employee].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[joblabor] OFF;

--SELECT * FROM [Contech_Test].[dbo].[joblabor]

-- =========================================================