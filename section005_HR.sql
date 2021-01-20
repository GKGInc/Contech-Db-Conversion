
-- =========================================================
-- Section 005: employee
-- =========================================================

-- Column changes:
--	- Changed [employeeid] to be the primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'employee'))
    DROP TABLE [employee]
	
CREATE TABLE [employee](
	[employeeid] [int] IDENTITY(1,1) NOT NULL,
	[empnumber] [char](10) NOT NULL DEFAULT '',
	[emplastnam] [char](30) NOT NULL DEFAULT '',
	[empfirstna] [char](20) NOT NULL DEFAULT '',
	[empmidinit] [char](1) NOT NULL DEFAULT '',
	[empstatus] [numeric](1, 0) NOT NULL DEFAULT 0,
	[emptmpfull] [numeric](1, 0) NOT NULL DEFAULT 0,
	[emp_rate] [numeric](5, 2) NOT NULL DEFAULT 0.0,
	[job_title] [char](30) NOT NULL DEFAULT '',
	[empassword] [char](15) NOT NULL DEFAULT '',
	[department] [char](4) NOT NULL DEFAULT '',
	[manager_of] [char](4) NOT NULL DEFAULT '',
	[last_rvw] [datetime] NULL,
	[barcode] [char](15) NOT NULL DEFAULT '',
	[email] [char](100) NOT NULL DEFAULT '',
	CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
	(
		[employeeid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [employee]
	SELECT * FROM [rawUpsize_Contech].[dbo].[employee]

--SELECT * FROM [Contech_Test].[dbo].[employee]

-- =========================================================
-- Section 005: matlin
-- =========================================================

-- Column changes:
--  - Renamed [matlin_key] to [matlinid]
--  - Set [matlinid] to be primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matlin'))
    DROP TABLE [matlin]
	
CREATE TABLE [matlin](
	[matlinid] [int] IDENTITY(1,1) NOT NULL,
	[po_no] [char](8) NOT NULL DEFAULT '',
	[date] [datetime] NULL,
	[amt_rec] [numeric](10, 0) NOT NULL DEFAULT 0,
	[amt_acc] [numeric](10, 0) NOT NULL DEFAULT 0,
	[amt_rej] [numeric](10, 0) NOT NULL DEFAULT 0,
	[ct_lot] [char](4) NOT NULL DEFAULT '',
	[ven_lot] [char](35) NOT NULL DEFAULT '',
	[ven_inv] [char](10) NOT NULL DEFAULT '',
	[ven_id] [char](6) NOT NULL DEFAULT '',
	[ven_frt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[ven_cos_ea] [numeric](9, 5) NOT NULL DEFAULT 0.0,
	[ven_memo] [char](150) NOT NULL DEFAULT '',
	[ct_control] [char](20) NOT NULL DEFAULT '',
	[qrn_no] [char](8) NOT NULL DEFAULT '',
	[comp] [char](5) NOT NULL DEFAULT '',
	[cust_vendor] [char](25) NOT NULL DEFAULT '',
	[cust_po] [char](15) NOT NULL DEFAULT '',
	[rcvr_id] [char](40) NOT NULL DEFAULT '',
	[rcvr_mod] [datetime] NULL,
	[upd_dt] [datetime] NULL,
	[inspector] [char](10) NOT NULL DEFAULT '',
	[expires] [datetime] NULL,
	[scrap] [int] NOT NULL DEFAULT 0,
	[dlvrnotnum] [char](10) NOT NULL DEFAULT '',
	[consign] [bit] NOT NULL DEFAULT 0,
	[po_price] [numeric](10, 5) NOT NULL DEFAULT 0.0,
	[vet_cert] [char](100) NOT NULL DEFAULT '',
	[id_marks] [char](100) NOT NULL DEFAULT '',
	[dscope_lot] [char](100) NOT NULL DEFAULT '',
	[mfg_locid] [int] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_matlin] PRIMARY KEY CLUSTERED 
	(
		[matlinid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [matlin] ON;

INSERT INTO [matlin] ([matlinid],[po_no],[date],[amt_rec],[amt_acc],[amt_rej],[ct_lot],[ven_lot],[ven_inv],[ven_id],[ven_frt],[ven_cos_ea],[ven_memo],[ct_control],[qrn_no],[comp],[cust_vendor],[cust_po],[rcvr_id],[rcvr_mod],[upd_dt],[inspector],[expires],[scrap],[dlvrnotnum],[consign],[po_price],[vet_cert],[id_marks],[dscope_lot],[mfg_locid])
SELECT [matlin_key],[po_no],[date],[amt_rec],[amt_acc],[amt_rej],[ct_lot],[ven_lot],[ven_inv],[ven_id],[ven_frt],[ven_cos_ea],[ven_memo],[ct_control],[qrn_no],[comp],[cust_vendor],[cust_po],[rcvr_id],[rcvr_mod],[upd_dt],[inspector],[expires],[scrap],[dlvrnotnum],[consign],[po_price],[vet_cert],[id_marks],[dscope_lot],[mfg_locid]
FROM [rawUpsize_Contech].[dbo].[matlin] order by 1 
    
SET IDENTITY_INSERT [matlin] OFF;

--SELECT * FROM [matlin]

-- =========================================================
-- Section 005: po_hdr
-- =========================================================

-- Column changes:
--  - Added [po_hdrid] to be primary key
--  - Changed [memo] from [text] to [varchar](2000)
--  - Changed [cpmr] from [text] to [varchar](2000)

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'po_hdr'))
    DROP TABLE [po_hdr]
	
CREATE TABLE [po_hdr](
	[po_hdrid] [int] IDENTITY(1,1) NOT NULL,
	[po_no] [char](8) NOT NULL DEFAULT '',
	[status] [char](1) NOT NULL DEFAULT '',
	[po_rev] [numeric](2, 0) NOT NULL,
	[rev_date] [datetime] NULL,
	[bill_to] [char](5) NOT NULL DEFAULT '',
	[ship_to] [char](6) NOT NULL DEFAULT '',
	[date] [datetime] NULL,
	[buyer] [char](5) NOT NULL DEFAULT '',
	[ven_id] [char](6) NOT NULL DEFAULT '',
	[comp] [char](5) NOT NULL DEFAULT '',
	[total] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[charge1] [numeric](8, 2) NOT NULL DEFAULT 0.0,
	[charge1_desc] [char](40) NOT NULL DEFAULT '',
	[charge2] [numeric](6, 2) NOT NULL,
	[charge2_desc] [char](40) NOT NULL DEFAULT '',
	[sub_total] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[total_qty] [int] NOT NULL DEFAULT 0,
	[notes] [varchar](2000) NOT NULL DEFAULT '',
	[confirm] [char](20) NOT NULL DEFAULT '',
	[tax] [char](1) NOT NULL DEFAULT '',
	[tax_amt] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[conf_phone] [bit] NOT NULL DEFAULT 0,
	[cl_room] [bit] NOT NULL DEFAULT 0,
	[rush] [bit] NOT NULL DEFAULT 0,
	[dbl_bag] [bit] NOT NULL DEFAULT 0,
	[fl_cut] [bit] NOT NULL DEFAULT 0,
	[price] [numeric](10, 5) NOT NULL DEFAULT 0.0,
	[tot_bo] [int] NOT NULL DEFAULT 0,
	[tot_recd] [int] NOT NULL DEFAULT 0,
	[tot_recd_rej] [int] NOT NULL DEFAULT 0,
	[tot_recd_acc] [int] NOT NULL DEFAULT 0,
	[comp_rev] [char](2) NOT NULL DEFAULT '',
	[cusno] [char](5) NOT NULL DEFAULT '',
	[cus_po] [char](15) NOT NULL DEFAULT '',
	[ship_via] [char](20) NOT NULL DEFAULT '',
	[fob] [char](15) NOT NULL DEFAULT '',
	[shven_no] [char](5) NOT NULL DEFAULT '',
	[currency] [char](3) NOT NULL DEFAULT '',
	[comp_desc] [char](75) NOT NULL DEFAULT '',
	[comp_desc2] [char](75) NOT NULL DEFAULT '',
	[material] [char](3) NOT NULL DEFAULT '',
	[class] [char](4) NOT NULL DEFAULT '',
	[cpmr] [varchar](2000) NOT NULL DEFAULT '',
	[coc] [bit] NOT NULL DEFAULT 0,
	[conf_dlvry] [bit] NOT NULL DEFAULT 0,
	[category] [int] NOT NULL DEFAULT 0,
	[sop10073] [bit] NOT NULL DEFAULT 0,
	[initiator] [char](10) NOT NULL DEFAULT '',
	[kanban] [bit] NOT NULL DEFAULT 0,
	[kbrel_freq] [char](2) NOT NULL DEFAULT '',
	[kbstart_dt] [datetime] NULL,
	[kbrel_qty] [int] NOT NULL DEFAULT 0,
	[mfg_locid] [int] NOT NULL DEFAULT 0,
	[prepaid] [bit] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_po_hdr] PRIMARY KEY CLUSTERED 
	(
		[po_hdrid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [po_hdr] 
	SELECT [pohdr].* FROM 
		(SELECT [po_no]
			  ,MAX([po_rev]) AS [po_rev]
			  ,MAX([date]) AS [date]
			  ,MAX([tot_recd]) AS [tot_recd]
		  FROM [rawUpsize_Contech].[dbo].[po_hdr]
		  GROUP BY [po_no]) AS [latest_pohdr]
	INNER JOIN [rawUpsize_Contech].[dbo].[po_hdr] [pohdr]
		ON [pohdr].[po_no] = [latest_pohdr].[po_no] 
			AND [pohdr].[po_rev] = [latest_pohdr].[po_rev]
			AND [pohdr].[date] = [latest_pohdr].[date]
			AND [pohdr].[tot_recd] = [latest_pohdr].[tot_recd]
	ORDER BY [pohdr].[date],[pohdr].[po_no]	

--SELECT * FROM [po_hdr]
  
-- =========================================================
-- Section 005: po_dtl
-- =========================================================

-- Column changes:
--  - Added [po_dtlid] to be primary key
--  - Added [po_hdrid] as the FK to reference [po_hdr]
--  - Changed [exp] from [text] to [varchar](3000) | Note: raised amount because there was a truncation error

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'po_dtl'))
    DROP TABLE [po_dtl]
	
CREATE TABLE [po_dtl](
	[po_dtlid] [int] IDENTITY(1,1) NOT NULL,
	[po_hdrid] [int] NOT NULL DEFAULT 0,
	[po_no] [char](8) NOT NULL DEFAULT '',
	[ref_no] [numeric](2, 0) NOT NULL DEFAULT 0,
	[due_date] [datetime] NULL,
	[amt_due] [int] NOT NULL DEFAULT 0,
	[price] [numeric](9, 2) NOT NULL DEFAULT 0.0,
	[comment] [char](25) NOT NULL DEFAULT '',
	[exp] [varchar](3000) NOT NULL DEFAULT '',
	[kbfixed] [bit] NOT NULL DEFAULT 0,
	CONSTRAINT [PK_po_dtl] PRIMARY KEY CLUSTERED 
	(
		[po_dtlid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

INSERT INTO [po_dtl] (po_hdrid,[po_no],[ref_no],[due_date],[amt_due],[price],[comment],[exp],[kbfixed])
SELECT ISNULL(po_hdr.[po_hdrid], 0) AS [po_hdrid]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[po_no]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[ref_no]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[due_date]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[amt_due]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[price]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[comment]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[exp]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[kbfixed]
FROM [rawUpsize_Contech].[dbo].[po_dtl]
LEFT JOIN [po_hdr] po_hdr ON [rawUpsize_Contech].[dbo].[po_dtl].po_no = po_hdr.[po_no]

--SELECT * FROM [Contech_Test].[dbo].[po_dtl]

-- =========================================================