
-- =========================================================
-- Section 046: venship
-- =========================================================

-- Column changes:
--  - Added [venshipid] to be primary key
-- Maps:
--	- [venship].[mfg_locid]	-- FK = [mfg_loc].[mfg_locid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'venship'))
    DROP TABLE [venship]

CREATE TABLE [dbo].[venship](
	[venshipid] [int] IDENTITY(1,1) NOT NULL,
	[company] [char](35) NOT NULL DEFAULT '',
	[shven_no] [char](5) NOT NULL DEFAULT '',
	[saddress] [char](35) NOT NULL DEFAULT '',
	[saddress2] [char](35) NOT NULL DEFAULT '',
	[city] [char](21) NOT NULL DEFAULT '',
	[state] [char](3) NOT NULL DEFAULT '',
	[zip] [char](11) NOT NULL DEFAULT '',
	[ship_via] [char](20) NOT NULL DEFAULT '',
	[fob_point] [char](15) NOT NULL DEFAULT '',
	[country] [char](10) NOT NULL DEFAULT '',
	[mfg_locid] [int] NOT NULL DEFAULT 0,		-- FK = [mfg_loc].[mfg_locid]
	CONSTRAINT [PK_venship] PRIMARY KEY CLUSTERED 
	(
		[venshipid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [venship] ([company],[shven_no],[saddress],[saddress2],[city],[state],[zip],[ship_via],[fob_point],[country],[mfg_locid])
SELECT [rawUpsize_Contech].[dbo].[venship].[company]
      ,[rawUpsize_Contech].[dbo].[venship].[shven_no]
      ,[rawUpsize_Contech].[dbo].[venship].[saddress]
      ,[rawUpsize_Contech].[dbo].[venship].[saddress2]
      ,[rawUpsize_Contech].[dbo].[venship].[city]
      ,[rawUpsize_Contech].[dbo].[venship].[state]
      ,[rawUpsize_Contech].[dbo].[venship].[zip]
      ,[rawUpsize_Contech].[dbo].[venship].[ship_via]
      ,[rawUpsize_Contech].[dbo].[venship].[fob_point]
      ,[rawUpsize_Contech].[dbo].[venship].[country]
      ,[rawUpsize_Contech].[dbo].[venship].[mfg_locid]
  FROM [rawUpsize_Contech].[dbo].[venship]
  
--SELECT * FROM [venship]

-- =========================================================
-- Section 046: wipshipd
-- =========================================================

-- Column changes:
--  - Set [wipshipdid] to be primary key
--  - Changed [invoice_no] [numeric](9, 0) to [aropenid] [int] to reference [aropen] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [wipshipd].[invoice_no] --> [aropenid]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
--	- [wipshipd].[add_user] --> [add_userid]	-- FK = [users].[username] --> [users].[userid]
--	- [wipshipd].[mod_user] --> [mod_userid]	-- FK = [users].[username] --> [users].[userid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'wipshipd'))
    DROP TABLE [wipshipd]

CREATE TABLE [dbo].[wipshipd](
	[wipshipdid] [int] IDENTITY(1,1) NOT NULL,
	--[invoice_no] [numeric](9, 0) NOT NULL DEFAULT 0,	-- FK = [aropen].[invoice_no]
	[aropenid] [int] NOT NULL DEFAULT 0,				-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
	[ship_qty] [int] NOT NULL DEFAULT 0,
	[add_dt] [datetime] NULL,
	--[add_user] [char](10) NOT NULL DEFAULT '',		
	[add_userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	[mod_dt] [datetime] NULL,
	--[mod_user] [char](10) NOT NULL DEFAULT '',		
	[mod_userid] [int] NOT NULL DEFAULT 0,				-- FK = [users].[username] --> [users].[userid]
	CONSTRAINT [PK_wipshipd] PRIMARY KEY CLUSTERED 
	(
		[wipshipdid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [wipshipd] ON;

INSERT INTO [wipshipd] ([wipshipdid],[aropenid],[ship_qty],[add_dt],[add_userid],[mod_dt],[mod_userid])
SELECT [rawUpsize_Contech].[dbo].[wipshipd].[wipshipdid]
      --,[rawUpsize_Contech].[dbo].[wipshipd].[invoice_no]
	  ,ISNULL(aropen.[aropenid], 0) AS [aropenid] 	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
      ,[rawUpsize_Contech].[dbo].[wipshipd].[ship_qty]
      ,[rawUpsize_Contech].[dbo].[wipshipd].[add_dt]
      --,[rawUpsize_Contech].[dbo].[wipshipd].[add_user]
	  ,ISNULL(add_user.[userid] , 0) as [add_userid]			
      ,[rawUpsize_Contech].[dbo].[wipshipd].[mod_dt]
      --,[rawUpsize_Contech].[dbo].[wipshipd].[mod_user]
	  ,ISNULL(mod_user.[userid] , 0) as [mod_userid]			
  FROM [rawUpsize_Contech].[dbo].[wipshipd]
  LEFT JOIN [aropen] aropen ON [rawUpsize_Contech].[dbo].[wipshipd].[invoice_no] = aropen.[invoice_no]	-- FK = [aropen].[invoice_no] --> [aropen].[aropenid]
  LEFT JOIN [users] add_user ON [rawUpsize_Contech].[dbo].[wipshipd].[add_user] = add_user.[username]	-- FK = [users].[userid]
  LEFT JOIN [users] mod_user ON [rawUpsize_Contech].[dbo].[wipshipd].[mod_user] = mod_user.[username]	-- FK = [users].[userid]
  
SET IDENTITY_INSERT [wipshipd] OFF;

--SELECT * FROM [wipshipd]

-- =========================================================
-- Section 046: wpbagdtl
-- =========================================================

-- Column changes:
--  - Set [wpbagdtlid] to be primary key
-- Maps:
--	- [wpbagdtl].[wpbaghdrid]	-- FK = [wpbaghdr].[wpbaghdrid] 
--	- [wpbagdtl].[cmpcasesid]	-- FK = [cmpcases].[cmpcasesid] 

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'wpbagdtl'))
    DROP TABLE [wpbagdtl]

CREATE TABLE [dbo].[wpbagdtl](
	[wpbagdtlid] [int] IDENTITY(1,1) NOT NULL,
	[wpbaghdrid] [int] NOT NULL DEFAULT 0,		-- FK = [wpbaghdr].[wpbaghdrid] 
	[bar_code] [char](13) NOT NULL DEFAULT '',
	[init_qty] [int] NOT NULL DEFAULT 0,
	[qty] [int] NOT NULL DEFAULT 0,
	[restocked] [bit] NOT NULL DEFAULT 0,
	[restck_qty] [int] NOT NULL DEFAULT 0,
	[out_dt] [datetime] NULL,
	[cmpcasesid] [int] NOT NULL DEFAULT 0,		-- FK = [cmpcases].[cmpcasesid] 
	CONSTRAINT [PK_wpbagdtl] PRIMARY KEY CLUSTERED 
	(
		[wpbagdtlid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [wpbagdtl] ON;

INSERT INTO [wpbagdtl] ([wpbagdtlid],[wpbaghdrid],[bar_code],[init_qty],[qty],[restocked],[restck_qty],[out_dt],[cmpcasesid])
SELECT [rawUpsize_Contech].[dbo].[wpbagdtl].[wpbagdtlid]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[wpbaghdrid]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[bar_code]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[init_qty]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[qty]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[restocked]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[restck_qty]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[out_dt]
      ,[rawUpsize_Contech].[dbo].[wpbagdtl].[cmpcasesid]		
  FROM [rawUpsize_Contech].[dbo].[wpbagdtl]
  
SET IDENTITY_INSERT [wpbagdtl] OFF;

--SELECT * FROM [wpbagdtl]

-- =========================================================
-- Section 046: wpbaghdr
-- =========================================================

-- Column changes:
--  - Set [wpbaghdrid] to be primary key
--  - Renamed [job_no] to [ordersid] to reference [orders] table
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [wpbagdtl].[cmpcasesid]				-- FK = [cmpcases].[cmpcasesid] 
--	- [wpbagdtl].[req_hdrid]				-- FK = [req_hdr].[req_hdrid]
--	- [wpbagdtl].[job_no] --> [orderid]		-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [wpbagdtl].[add_user]	--> [userid]	-- FK = [users].[username] --> [users].[userid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'wpbaghdr'))
    DROP TABLE [wpbaghdr]

CREATE TABLE [dbo].[wpbaghdr](
	[wpbaghdrid] [int] IDENTITY(1,1) NOT NULL,
	[cmpcasesid] [int] NOT NULL DEFAULT 0,		-- FK = [cmpcases].[cmpcasesid] 
	[req_hdrid] [int] NOT NULL DEFAULT 0,		-- FK = [req_hdr].[req_hdrid]
	--[job_no] [int] NOT NULL DEFAULT 0,		-- FK = [orders].[job_no] 
	[orderid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[orderid]
	[in_qty] [int] NOT NULL DEFAULT 0,
	[rem_qty] [int] NOT NULL DEFAULT 0,
	[in_dt] [datetime] NULL,
	[mod_dt] [datetime] NULL,
	--[userid] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
	[userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
	CONSTRAINT [PK_wpbaghdr] PRIMARY KEY CLUSTERED 
	(
		[wpbaghdrid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [wpbaghdr] ON;

INSERT INTO [wpbaghdr] ([wpbaghdrid],[cmpcasesid],[req_hdrid],[orderid],[in_qty],[rem_qty],[in_dt],[mod_dt],[userid])
SELECT [rawUpsize_Contech].[dbo].[wpbaghdr].[wpbaghdrid]
      ,[rawUpsize_Contech].[dbo].[wpbaghdr].[cmpcasesid]
      ,[rawUpsize_Contech].[dbo].[wpbaghdr].[req_hdrid]
      --,[rawUpsize_Contech].[dbo].[wpbaghdr].[job_no]
	  ,ISNULL(orders.[orderid], 0) AS [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]     
      ,[rawUpsize_Contech].[dbo].[wpbaghdr].[in_qty]
      ,[rawUpsize_Contech].[dbo].[wpbaghdr].[rem_qty]
      ,[rawUpsize_Contech].[dbo].[wpbaghdr].[in_dt]
      ,[rawUpsize_Contech].[dbo].[wpbaghdr].[mod_dt]
      --,[rawUpsize_Contech].[dbo].[wpbaghdr].[userid]
	  ,ISNULL(users.[userid] , 0) as [userid]			-- FK = [users].[username] --> [users].[userid]
  FROM [rawUpsize_Contech].[dbo].[wpbaghdr]
  LEFT JOIN [orders] orders ON [rawUpsize_Contech].[dbo].[wpbaghdr].[job_no] = orders.[job_no]		
  LEFT JOIN [users] users ON [rawUpsize_Contech].[dbo].[wpbaghdr].[userid] = users.[username]	
  
SET IDENTITY_INSERT [wpbaghdr] OFF;

--SELECT * FROM [wpbaghdr]

-- =========================================================