-- ***************************************************
-- Section 022: autoinvoice, bdocpend
-- ***************************************************

use Contech_Test
GO

begin tran

-- ***************************************************
-- table: autoinvoice

-- re-mapped columns:
-- invoice_no  -> aropenid

-- table PK:
-- autoinvoiceid: added identity PK col

-- FK fields:
-- aropenid: aropen.aropenid
-- add_userid: users.userid


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'autoinvoice')
        drop table dbo.autoinvoice
GO

CREATE TABLE [dbo].[autoinvoice](
    autoinvoiceid int identity (1, 1), -- new PK field
	-- [invoice_no] [int] NOT NULL,
	aropenid int NOT NULL,
	-- [add_user] [char](10) NOT NULL,
	[add_userid] int default 0 NOT NULL,
	[add_dt] [datetime] NULL,
	[usersess] [char](10) default '' NOT NULL,
	[action] [char](10) default '' NOT NULL,
    CONSTRAINT [PK_autoinvoice] PRIMARY KEY CLUSTERED
    (
        [autoinvoiceid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into dbo.autoinvoice
(aropenid, add_userid, add_dt, usersess, action)
select -- invoice_no,
       isnull(inv.aropenid, 0),
       -- add_user,
       isnull(addu.userid, 0),
       add_dt,
       usersess,
       action
from [rawUpsize_Contech].dbo.autoinvoice
left outer join dbo.aropen inv ON autoinvoice.invoice_no = inv.invoice_no
left outer join dbo.users addu ON autoinvoice.add_user = addu.username
order by autoinvoice.add_dt
GO


-- ***************************************************
-- table: bdocpend

-- re-mapped columns:
-- bom_no   ___ bom_hdr.bom_hdrid
-- bom_rev  _/

-- new columns:
-- bom_hdrid: replaces the bom_no/bom_rev columns as ref to bom_hdr

-- table PK:
-- bdocpendid: new identity PK

-- FK fields:
-- bom_hdrid: bom_hdr.bom_hdrid


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bdocpend')
        drop table dbo.bdocpend
GO

CREATE TABLE [dbo].[bdocpend](
    bdocpendid int identity (1, 1), -- new col
	-- [bom_no] [numeric](5, 0) NOT NULL,
	-- [bom_rev] [numeric](2, 0) NOT NULL,
	bom_hdrid int NOT NULL, -- new col
	[doc_no] [char](5) default '' NOT NULL,
	[doc_rev] [char](2) default '' NOT NULL,
	[ndoc_no] [char](5) default '' NOT NULL,
	[ndoc_rev] [char](2) default '' NOT NULL,
	[add_date] [datetime] NULL,
	[status] [char](1) default '' NOT NULL,
    CONSTRAINT [PK_bdocpend] PRIMARY KEY CLUSTERED
    (
        [bdocpendid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into dbo.bdocpend
(bom_hdrid, doc_no, doc_rev, ndoc_no, ndoc_rev, add_date, status)
select -- bom_no,
       -- bom_rev,
       bom.bom_hdrid,
       bdocpend.doc_no,
       bdocpend.doc_rev,
       ndoc_no,
       ndoc_rev,
       add_date,
       status
from [rawUpsize_Contech].dbo.bdocpend
inner join dbo.bom_hdr bom ON bdocpend.bom_no = bom.bom_no and bdocpend.bom_rev = bom.bom_rev
GO

commit
GO

-- rollback
