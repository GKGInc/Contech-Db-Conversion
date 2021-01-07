
-- =========================================================
--Section 005: employee
-- =========================================================

-- Column changes:
--	- Changed empnumber int int
--  - Changed empnumber to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'employee'))
    DROP TABLE [dbo].[employee]
	
CREATE TABLE [dbo].[employee](
	[empnumber] [int] identity(1,1) NOT NULL,
	[emplastnam] [char](30) NOT NULL,
	[empfirstna] [char](20) NOT NULL,
	[empmidinit] [char](1) NOT NULL,
	[empstatus] [numeric](1, 0) NOT NULL,
	[emptmpfull] [numeric](1, 0) NOT NULL,
	[emp_rate] [numeric](5, 2) NOT NULL,
	[job_title] [char](30) NOT NULL,
	[empassword] [char](15) NOT NULL,
	[department] [char](4) NOT NULL,
	[manager_of] [char](4) NOT NULL,
	[last_rvw] [datetime] NULL,
	[barcode] [char](15) NOT NULL,
	[email] [char](100) NOT NULL,
	CONSTRAINT [PK_employee] PRIMARY KEY CLUSTERED 
	(
		[empnumber] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[employee] ON;

INSERT INTO [Contech_Test].[dbo].[employee] ([empnumber],[emplastnam],[empfirstna],[empmidinit],[empstatus],[emptmpfull],[emp_rate],[job_title],[empassword],[department],[manager_of],[last_rvw],[barcode],[email])
SELECT [empnumber],[emplastnam],[empfirstna],[empmidinit],[empstatus],[emptmpfull],[emp_rate],[job_title],[empassword],[department],[manager_of],[last_rvw],[barcode],[email] 
FROM [rawUpsize_Contech].[dbo].[employee] order by 1 
  
SET IDENTITY_INSERT [Contech_Test].[dbo].[employee] OFF;

--SELECT * FROM [Contech_Test].[dbo].[employee]

-- =========================================================
--Section 005: matlin
-- =========================================================

-- Column changes:
--  - Changed matlin_key to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'matlin'))
    DROP TABLE [dbo].[matlin]
	
CREATE TABLE [dbo].[matlin](
	[matlin_key] [int] identity(1,1) NOT NULL,
	[po_no] [char](8) NOT NULL,
	[date] [datetime] NULL,
	[amt_rec] [numeric](10, 0) NOT NULL,
	[amt_acc] [numeric](10, 0) NOT NULL,
	[amt_rej] [numeric](10, 0) NOT NULL,
	[ct_lot] [char](4) NOT NULL,
	[ven_lot] [char](35) NOT NULL,
	[ven_inv] [char](10) NOT NULL,
	[ven_id] [char](6) NOT NULL,
	[ven_frt] [numeric](9, 2) NOT NULL,
	[ven_cos_ea] [numeric](9, 5) NOT NULL,
	[ven_memo] [char](150) NOT NULL,
	[ct_control] [char](20) NOT NULL,
	[qrn_no] [char](8) NOT NULL,
	[comp] [char](5) NOT NULL,
	[cust_vendor] [char](25) NOT NULL,
	[cust_po] [char](15) NOT NULL,
	[rcvr_id] [char](40) NOT NULL,
	[rcvr_mod] [datetime] NULL,
	[upd_dt] [datetime] NULL,
	[inspector] [char](10) NOT NULL,
	[expires] [datetime] NULL,
	[scrap] [int] NOT NULL,
	[dlvrnotnum] [char](10) NOT NULL,
	[consign] [bit] NOT NULL,
	[po_price] [numeric](10, 5) NOT NULL,
	[vet_cert] [char](100) NOT NULL,
	[id_marks] [char](100) NOT NULL,
	[dscope_lot] [char](100) NOT NULL,
	[mfg_locid] [int] NOT NULL,
	CONSTRAINT [PK_matlin] PRIMARY KEY CLUSTERED 
	(
		[matlin_key] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

SET IDENTITY_INSERT [Contech_Test].[dbo].[matlin] ON;

INSERT INTO [Contech_Test].[dbo].[matlin] ([matlin_key],[po_no],[date],[amt_rec],[amt_acc],[amt_rej],[ct_lot],[ven_lot],[ven_inv],[ven_id],[ven_frt],[ven_cos_ea],[ven_memo],[ct_control],[qrn_no],[comp],[cust_vendor],[cust_po],[rcvr_id],[rcvr_mod],[upd_dt],[inspector],[expires],[scrap],[dlvrnotnum],[consign],[po_price],[vet_cert],[id_marks],[dscope_lot],[mfg_locid])
SELECT [matlin_key],[po_no],[date],[amt_rec],[amt_acc],[amt_rej],[ct_lot],[ven_lot],[ven_inv],[ven_id],[ven_frt],[ven_cos_ea],[ven_memo],[ct_control],[qrn_no],[comp],[cust_vendor],[cust_po],[rcvr_id],[rcvr_mod],[upd_dt],[inspector],[expires],[scrap],[dlvrnotnum],[consign],[po_price],[vet_cert],[id_marks],[dscope_lot],[mfg_locid]
FROM [rawUpsize_Contech].[dbo].[matlin] order by 1 
    
SET IDENTITY_INSERT [Contech_Test].[dbo].[matlin] OFF;

--SELECT * FROM [Contech_Test].[dbo].[matlin]

-- =========================================================
--Section 005: po_hdr
-- =========================================================

-- Column changes:
--  - Added po_hdrid to be primary key

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'po_hdr'))
    DROP TABLE [dbo].[po_hdr]
	
CREATE TABLE [dbo].[po_hdr](
	[po_hdrid] [int] identity(1,1) NOT NULL,
	[po_no] [char](8) NOT NULL,
	[status] [char](1) NOT NULL,
	[po_rev] [numeric](2, 0) NOT NULL,
	[rev_date] [datetime] NULL,
	[bill_to] [char](5) NOT NULL,
	[ship_to] [char](6) NOT NULL,
	[date] [datetime] NULL,
	[buyer] [char](5) NOT NULL,
	[ven_id] [char](6) NOT NULL,
	[comp] [char](5) NOT NULL,
	[total] [numeric](9, 2) NOT NULL,
	[charge1] [numeric](8, 2) NOT NULL,
	[charge1_desc] [char](40) NOT NULL,
	[charge2] [numeric](6, 2) NOT NULL,
	[charge2_desc] [char](40) NOT NULL,
	[sub_total] [numeric](9, 2) NOT NULL,
	[total_qty] [int] NOT NULL,
	[notes] [text] NOT NULL,
	[confirm] [char](20) NOT NULL,
	[tax] [char](1) NOT NULL,
	[tax_amt] [numeric](9, 2) NOT NULL,
	[conf_phone] [bit] NOT NULL,
	[cl_room] [bit] NOT NULL,
	[rush] [bit] NOT NULL,
	[dbl_bag] [bit] NOT NULL,
	[fl_cut] [bit] NOT NULL,
	[price] [numeric](10, 5) NOT NULL,
	[tot_bo] [int] NOT NULL,
	[tot_recd] [int] NOT NULL,
	[tot_recd_rej] [int] NOT NULL,
	[tot_recd_acc] [int] NOT NULL,
	[comp_rev] [char](2) NOT NULL,
	[cusno] [char](5) NOT NULL,
	[cus_po] [char](15) NOT NULL,
	[ship_via] [char](20) NOT NULL,
	[fob] [char](15) NOT NULL,
	[shven_no] [char](5) NOT NULL,
	[currency] [char](3) NOT NULL,
	[comp_desc] [char](75) NOT NULL,
	[comp_desc2] [char](75) NOT NULL,
	[material] [char](3) NOT NULL,
	[class] [char](4) NOT NULL,
	[cpmr] [text] NOT NULL,
	[coc] [bit] NOT NULL,
	[conf_dlvry] [bit] NOT NULL,
	[category] [int] NOT NULL,
	[sop10073] [bit] NOT NULL,
	[initiator] [char](10) NOT NULL,
	[kanban] [bit] NOT NULL,
	[kbrel_freq] [char](2) NOT NULL,
	[kbstart_dt] [datetime] NULL,
	[kbrel_qty] [int] NOT NULL,
	[mfg_locid] [int] NOT NULL,
	[prepaid] [bit] NOT NULL,
	CONSTRAINT [PK_po_hdr] PRIMARY KEY CLUSTERED 
	(
		[po_hdrid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[po_hdr] SELECT * FROM [rawUpsize_Contech].[dbo].[po_hdr]

SELECT * FROM [Contech_Test].[dbo].[po_hdr]
  
-- =========================================================
--Section 005: po_dtl
-- =========================================================

-- Column changes:
--  - Added po_dtlid to be primary key
--  - Added po_hdrid as the FK to reference po_hdr

USE Contech_Test

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'po_dtl'))
    DROP TABLE [dbo].[po_dtl]
	
CREATE TABLE [dbo].[po_dtl](
	[po_dtlid] [int] identity(1,1) NOT NULL,
	[po_hdrid] [int] NOT NULL,
	[po_no] [char](8) NOT NULL,
	[ref_no] [numeric](2, 0) NOT NULL,
	[due_date] [datetime] NULL,
	[amt_due] [int] NOT NULL,
	[price] [numeric](9, 2) NOT NULL,
	[comment] [char](25) NOT NULL,
	[exp] [text] NOT NULL,
	[kbfixed] [bit] NOT NULL
,
	CONSTRAINT [PK_po_dtl] PRIMARY KEY CLUSTERED 
	(
		[po_dtlid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

INSERT INTO [Contech_Test].[dbo].[po_dtl] (po_hdrid,[po_no],[ref_no],[due_date],[amt_due],[price],[comment],[exp],[kbfixed])
SELECT 
      ISNULL([Contech_Test].[dbo].[po_hdr].[po_hdrid], 0) AS [po_hdrid]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[po_no]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[ref_no]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[due_date]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[amt_due]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[price]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[comment]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[exp]
      ,[rawUpsize_Contech].[dbo].[po_dtl].[kbfixed]
FROM [rawUpsize_Contech].[dbo].[po_dtl]
LEFT JOIN [Contech_Test].[dbo].[po_hdr] ON [rawUpsize_Contech].[dbo].[po_dtl].po_no = [Contech_Test].[dbo].[po_hdr].po_no

--SELECT * FROM [Contech_Test].[dbo].[po_dtl]

-- =========================================================