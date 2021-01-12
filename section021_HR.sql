
-- =========================================================
--Section 021: asstevnt
-- =========================================================

-- Column changes:
--  - Set asstevntid to be primary key
--  - Changed asset_no to int to reference assets table
--  - Changed empnumber to int to reference employee table
-- Maps:
--	- [asstevnt].[asstevntid]	-- FK = [assets].[asset_no] -> [assets].[assetsid]
--	- [asstevnt].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'asstevnt'))
    DROP TABLE [dbo].[asstevnt]

CREATE TABLE [dbo].[asstevnt](
	[asstevntid] [int] identity(1,1) NOT NULL,
	[asset_no] [int] NOT NULL,			-- FK = [assets].[asset_no] -> [assets].[assetsid]
	[evnt_type] [char](2) NOT NULL,
	[evnt_name] [char](30) NOT NULL,
	[interval] [char](2) NOT NULL,
	[intervalno] [int] NOT NULL,
	[rmndr_days] [int] NOT NULL,
	[evntperson] [char](10) NOT NULL,	-- FK = [employee].[empnumber] -> [employee].[employeeid]
	[document] [char](10) NOT NULL,
	[future_due] [datetime] NULL,
	[lastaction] [datetime] NULL,
	[rmndr_date] [datetime] NULL,
	[evntmpltid] [int] NOT NULL,
	[rev_rec] [int] NOT NULL,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL,
	CONSTRAINT [PK_asstevnt] PRIMARY KEY CLUSTERED 
	(
		[asstevntid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[asstevnt] ON;

INSERT INTO [Contech_Test].[dbo].[asstevnt] ([asstevntid],[asset_no],[evnt_type],[evnt_name],[interval],[intervalno],[rmndr_days],[evntperson],[document],[future_due],[lastaction],[rmndr_date],[evntmpltid],[rev_rec],[rev_dt],[rev_emp])
SELECT [rawUpsize_Contech].[dbo].[asstevnt].[asstevntid]
      --,[rawUpsize_Contech].[dbo].[asstevnt].[asset_no]
	  ,ISNULL([Contech_Test].[dbo].[assets].[assetsid], 0) AS [assetsid]		-- FK = [assets].[asset_no] -> [assets].[assetsid]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[evnt_type]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[evnt_name]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[interval]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[intervalno]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[rmndr_days]
      --,[rawUpsize_Contech].[dbo].[asstevnt].[evntperson]
	  ,ISNULL([Contech_Test].[dbo].[employee].[employeeid], 0) AS [employeeid]	-- [asstevnt].[evntperson]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[document]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[future_due]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[lastaction]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[rmndr_date]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[evntmpltid]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_rec]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_dt]
      ,[rawUpsize_Contech].[dbo].[asstevnt].[rev_emp]
  FROM [rawUpsize_Contech].[dbo].[asstevnt]
  LEFT JOIN [Contech_Test].[dbo].[assets] ON [rawUpsize_Contech].[dbo].[asstevnt].[asset_no] = [Contech_Test].[dbo].[assets].[asset_no]			-- FK = [assets].[asset_no] -> [assets].[assetsid]
  LEFT JOIN [Contech_Test].[dbo].[employee] ON [rawUpsize_Contech].[dbo].[asstevnt].[evntperson] = [Contech_Test].[dbo].[employee].[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

SET IDENTITY_INSERT [Contech_Test].[dbo].[asstevnt] OFF;

--SELECT * FROM [Contech_Test].[dbo].[asstevnt]

-- =========================================================