-- ***************************************************
-- Section 020:
-- ***************************************************

use Contech_Test
GO

begin tran

-- ***************************************************
-- table: fplabel

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1) Victor: req_hdrid needs to change to job_no -> orders.job_no


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fplabel')
        drop table dbo.fplabel
GO

CREATE TABLE [dbo].[fplabel](
	-- [fplabelid] [int] NOT NULL,
	[fplabelid] [int] identity (1, 1),
	-- [req_hdrid] [int] NOT NULL, -- see Note#1
	job_no int NOT NULL, -- see Note#1
	[labelno] [int] NOT NULL,
	[qty] [int] NOT NULL,
	-- [add_user] [char](10) NOT NULL,
	add_userid int default 0 not null,
	[add_dt] [datetime] NULL,
	-- [mod_user] [char](10) NOT NULL,
	mod_userid int default 0 not null,
	[mod_dt] [datetime] NULL,
	[ship_via] [char](20) default '' NOT NULL,
	[mfg_locid] [int] NOT NULL,
    CONSTRAINT [PK_fplabel] PRIMARY KEY CLUSTERED
    (
        [fplabelid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.fplabel ON

INSERT INTO dbo.fplabel
(fplabelid, job_no, labelno, qty, add_userid, add_dt, mod_userid, mod_dt, ship_via, mfg_locid)
select fplabelid,
       req_hdrid,
       labelno,
       qty,
       -- add_user,
       isnull(addu.userid, 0),
       add_dt,
       -- mod_user,
       isnull(modu.userid, 0),
       mod_dt,
       ship_via,
       fplabel.mfg_locid
from [rawUpsize_Contech].dbo.fplabel

left outer join dbo.users addu ON fplabel.add_user = addu.username
left outer join dbo.users modu ON fplabel.mod_user = modu.username

set identity_insert dbo.fplabel OFF


-- ***************************************************
-- table: fpbox

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fpbox')
        drop table dbo.fpbox
GO

CREATE TABLE [dbo].[fpbox](
	[fpboxid] [int] NOT NULL,
	[fplabelid] [int] NOT NULL,
	[qty] [int] NOT NULL,
	[add_user] [char](10) NOT NULL,
	[add_dt] [datetime] NULL
) ON [PRIMARY]
GO


-- ***************************************************
-- table: fplocatn

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fplocatn')
        drop table dbo.fplocatn
GO

CREATE TABLE [dbo].[fplocatn](
	[fplocatnid] [int] NOT NULL,
	[staging] [bit] NOT NULL,
	[location] [char](5) NOT NULL,
	[locfloor] [int] NOT NULL,
	[allowmix] [bit] NOT NULL
) ON [PRIMARY]
GO


-- ***************************************************
-- table: fppallet

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fppallet')
        drop table dbo.fppallet
GO

CREATE TABLE [dbo].[fppallet](
	[fppalletid] [int] NOT NULL,
	[fplocatnid] [int] NOT NULL,
	[add_user] [char](10) NOT NULL,
	[add_dt] [datetime] NULL,
	[mod_user] [char](10) NOT NULL,
	[mod_dt] [datetime] NULL,
	[ship_dt] [datetime] NULL,
	[ship_user] [char](10) NOT NULL,
	[allowmix] [bit] NOT NULL
) ON [PRIMARY]
GO



-- ***************************************************
-- table: fppltbox

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fppltbox')
        drop table dbo.fppltbox
GO


CREATE TABLE [dbo].[fppltbox](
	[fppltboxid] [int] NOT NULL,
	[fppalletid] [int] NOT NULL,
	[fplabelid] [int] NOT NULL,
	[add_user] [char](10) NOT NULL,
	[add_dt] [datetime] NULL
) ON [PRIMARY]
GO



-- ***************************************************
-- table: fpshpbox

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fpshpbox')
        drop table dbo.fpshpbox
GO

CREATE TABLE [dbo].[fppltbox](
	[fppltboxid] [int] NOT NULL,
	[fppalletid] [int] NOT NULL,
	[fplabelid] [int] NOT NULL,
	[add_user] [char](10) NOT NULL,
	[add_dt] [datetime] NULL
) ON [PRIMARY]
GO



-- ***************************************************
-- table: fptransfer

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fptransfer')
        drop table dbo.fptransfer
GO

CREATE TABLE [dbo].[fptransfer](
	[fptransferid] [int] NOT NULL,
	[job_no] [int] NOT NULL,
	[rel_qty] [int] NOT NULL,
	[jobstatus] [char](1) NOT NULL,
	[postatus] [char](1) NOT NULL,
	[price] [numeric](9, 4) NOT NULL,
	[add_dt] [datetime] NULL,
	[add_user] [char](10) NOT NULL,
	[mod_dt] [datetime] NULL,
	[mod_user] [char](10) NOT NULL,
	[ship_dt] [datetime] NULL,
	[lading] [bit] NOT NULL,
	[nolading] [bit] NOT NULL,
	[freight] [numeric](6, 2) NOT NULL,
	[sched_ship] [datetime] NULL,
	[rev_relid] [int] NOT NULL,
	[invoice_dt] [datetime] NULL
) ON [PRIMARY]
GO

-- ***************************************************
-- table: fptrnbox

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fptrnbox')
        drop table dbo.fptrnbox
GO

CREATE TABLE [dbo].[fptrnbox](
	[fptrnboxid] [int] NOT NULL,
	[fplabelid] [int] NOT NULL,
	[fplocatnid] [int] NOT NULL,
	[add_dt] [datetime] NULL
) ON [PRIMARY]
GO

-- ***************************************************
-- table: fpweight

-- re-mapped columns:
--

-- new columns:
--

-- table PK:
--

-- FK fields:
--

-- notes:
-- (1)


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'fpweight')
        drop table dbo.fpweight
GO

CREATE TABLE [dbo].[fpweight](
	[fpweightid] [int] NOT NULL,
	[part_no] [char](15) NOT NULL,
	[case_qty] [int] NOT NULL,
	[case_wt] [numeric](9, 2) NOT NULL
) ON [PRIMARY]
GO


commit
GO

-- rollback
