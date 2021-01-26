-- ***************************************************
-- Section 008: custpohd, custpodt, aropen
-- ***************************************************

begin tran

-- ***************************************************
-- custpohd

-- column name changes:
--   cust_no -> customerid
--   add_user -> add_userid
--   mod_user -> mod_userid

--  PK:
--   custpohdid: converted to identity

-- notes:


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'custpohd')
    BEGIN
        drop table dbo.custpohd
    END
GO

CREATE TABLE [dbo].[custpohd](
	[custpohdid] [int] identity (1, 1),
	[cust_po] [char](15) NOT NULL,
	-- [cust_no] [char](5) NOT NULL,
	customerid int NOT NULL,
	[einvoice] [bit] default (0) NOT NULL,
	[ship_to] [char](1) default '' NOT NULL,
	[add_dt] [datetime] NULL,
	-- [add_user] [char](15) default '' NOT NULL,
	add_userid int default 0 NOT NULL,
	[mod_dt] [datetime] NULL,
	-- [mod_user] [char](15) default '' NOT NULL,
	mod_userid int default 0 NOT NULL,
	[po_date] [datetime] NULL,
	[iskanban] [bit] default (0) NOT NULL,
	[kb_end] [datetime] NULL,
	[status] [char](1) default '' NOT NULL,
	[confirm_dt] [datetime] NULL,
	[confirm_user] [char](10) default '' NOT NULL,
	[confirm_no] [char](20) default '' NOT NULL,
	[confirm_contact] [char](50) default '' NOT NULL,
	[confirm_contactid] [int] default 0 NOT NULL,
    CONSTRAINT [PK_custpohd] PRIMARY KEY CLUSTERED
    (
        [custpohdid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.custpohd ON
GO

insert into dbo.custpohd
(custpohdid, cust_po, customerid, einvoice, ship_to, add_dt, add_userid, mod_dt, mod_userid, po_date, iskanban, kb_end, status, confirm_dt, confirm_user, confirm_no, confirm_contact, confirm_contactid)
select custpohd.custpohdid,
       custpohd.cust_po,
       -- custpohd.cust_no,
       ISNULL(c.customerid, 0),
       custpohd.einvoice,
       custpohd.ship_to,
       custpohd.add_dt,
       -- custpohd.add_user,
       ISNULL(addu.userid, 0),
       custpohd.mod_dt,
       -- custpohd.mod_user,
       ISNULL(modu.userid, 0),
       custpohd.po_date,
       custpohd.iskanban,
       custpohd.kb_end,
       custpohd.status,
       custpohd.confirm_dt,
       custpohd.confirm_user,
       custpohd.confirm_no,
       custpohd.confirm_contact,
       custpohd.confirm_contactid
from [rawUpsize_Contech].dbo.custpohd
    left outer join customer c on custpohd.cust_no = c.cust_no and rtrim(custpohd.cust_no) != ''
    left outer join users addu on custpohd.add_user = addu.username and rtrim(custpohd.add_user) != ''
    left outer join users modu on custpohd.mod_user = modu.username and rtrim(custpohd.mod_user) != ''
GO

set identity_insert dbo.custpohd OFF
GO

-- ***************************************************
-- custpodt

-- column name changes:
-- add_user -> add_userid
-- mod_user -> mod_userid

-- table PK:
-- custpodtid: converted to identity PK

-- notes:
-- (1)



IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'custpodt')
    BEGIN
        drop table dbo.custpodt
    END
GO

CREATE TABLE [dbo].[custpodt](
	[custpodtid] int identity (1, 1),
	[custpohdid] [int] NOT NULL,
	[line_no] [char](5) default '' NOT NULL,
	[uom] [char](5) default '' NOT NULL,
	[part_no] [char](15) NOT NULL,
	[order_qty] [int] NOT NULL,
	[need_by] [datetime] NULL,
	[price] [numeric](9, 2) default 0 NOT NULL,
	[add_dt] [datetime] NULL,
	-- [add_user] [char](15) NOT NULL,
	add_userid int default (0) NOT NULL,
	[mod_dt] [datetime] NULL,
	-- [mod_user] [char](15) NOT NULL,
	mod_userid int default (0) NOT NULL,
	[part_desc] [char](200) default '' NOT NULL,
	[release_qty] [int] default 0 NOT NULL,
	[min_releases] [int] default 0 NOT NULL,
	[lead_days] [int] default 0 NOT NULL,
    CONSTRAINT [PK_custpodt] PRIMARY KEY CLUSTERED
    (
        [custpodtid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.custpodt ON

insert into dbo.custpodt
(custpodtid, custpohdid, line_no, uom, part_no, order_qty, need_by, price, add_dt, add_userid, mod_dt, mod_userid, part_desc, release_qty, min_releases, lead_days)
select custpodtid,
       custpohdid,
       line_no,
       uom,
       part_no,
       order_qty,
       need_by,
       price,
       add_dt,
       -- add_user,
       ISNULL(addu.userid, 0),
       mod_dt,
       -- mod_user,
       ISNULL(modu.userid, 0),
       part_desc,
       release_qty,
       min_releases,
       lead_days
from [rawUpsize_Contech].dbo.custpodt
left outer join dbo.users addu on custpodt.add_user = addu.username
left outer join dbo.users modu on custpodt.mod_user = modu.username

set identity_insert dbo.custpodt OFF

-- ***************************************************
-- aropen

-- new columns:
-- aropenid

-- table PK:
-- aropenid: added


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'aropen')
    BEGIN
        drop table dbo.aropen
    END
GO

CREATE TABLE [dbo].[aropen](
    [aropenid] int identity(1, 1),
	[invoice_no] [numeric](9, 0) NOT NULL,
	[job_no] [int] NOT NULL,
	[total] [numeric](9, 2) NOT NULL,
	[cust_no] [char](5) default '' NOT NULL,
	[balancedue] [numeric](9, 2) NOT NULL,
	[codepd] [char](1) default '' NOT NULL,
	[cust_po] [char](15) default '' NOT NULL,
	[price] [numeric](9, 4) NOT NULL,
	[case_price] [numeric](9, 4) NOT NULL,
	[part_desc] [char](50) default '' NOT NULL,
	[part_no] [char](15) default '' NOT NULL,
	[ct_lot] [char](8) default '' NOT NULL,
	[cus_lot] [char](12) default '' NOT NULL,
	[memo] varchar(2000) default '' NOT NULL,
	[date_invoc] [datetime] NULL,
	[ship_via] [char](20) default '' NOT NULL,
	[terms] [char](10) default '' NOT NULL,
	[unit] [char](4) default '' NOT NULL,
	[freight] [numeric](6, 2) NOT NULL,
	[subc_cost] [numeric](10, 5) NOT NULL,
	[ship_to] [char](1) default '' NOT NULL,
	[entrdate] [datetime] NULL,
	[sh_qty] [numeric](7, 0) NOT NULL,
	[case_qty] [numeric](7, 2) NOT NULL,
	[charge_1] [numeric](8, 2) NOT NULL,
	[charge_2] [numeric](8, 2) NOT NULL,
	[code] [char](1) default '' NOT NULL,
	[dr_cr] [char](2) default '' NOT NULL,
	[code_po] [char](1) default '' NOT NULL,
	[mfg_cat] [char](2) default '' NOT NULL,
	[insurance] [numeric](9, 2) NOT NULL,
	[vat] [numeric](9, 2) NOT NULL,
	[vat_stat] [char](1) default '' NOT NULL,
	[part_rev] [char](15) default '' NOT NULL,
	[coc_lot_no] [char](10) default '' NOT NULL,
	[coc_exp_date] [datetime] NULL,
	[coc_memo] [text] default '' NOT NULL,
	[packing] [numeric](10, 0) NOT NULL,
	[discount] [numeric](7, 3) NOT NULL,
	[lading] [bit] NOT NULL,
	[nolading] [bit] NOT NULL,
	[cr_invoice] [numeric](9, 0) NOT NULL,
	[complnt_no] [int] NOT NULL,
	[cust_po_ln] [char](5) default '' NOT NULL,
	[cust_po_um] [char](5) default '' NOT NULL,
	[custpodtid] [int] NOT NULL,
	[fprice] [numeric](8, 2) NOT NULL,
	[fexchrate] [numeric](9, 5) NOT NULL,
	[currency] [char](3) default '' NOT NULL,
	[bill_to] [char](1) default '' NOT NULL,
    CONSTRAINT [PK_aropen] PRIMARY KEY CLUSTERED
    (
        [aropenid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

insert into dbo.aropen
select * from [rawUpsize_Contech].dbo.aropen
GO


commit