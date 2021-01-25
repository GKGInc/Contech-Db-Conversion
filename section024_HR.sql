-- ***************************************************
-- Section 024: bomdocs, bompriclog, bomstage, bomtable, buyer
-- ***************************************************

use Contech_Test
GO

begin tran

-- ***************************************************
-- table: bomdocs

-- re-mapped columns:
-- bom_no   ___ bom_hdrid
-- bom_rev  _/

-- new columns:
-- bom_hdrid: replaces bom_no & bom_rev

-- table PK:
-- bomdocsid: add identity PK

-- FK fields:
-- bom_hdrid: bom_hdr.bom_hdrid


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bomdocs')
        drop table dbo.bomdocs
GO

CREATE TABLE [dbo].[bomdocs](
    bomdocsid int identity (1, 1), -- new column
	[document] [char](15) NOT NULL,
	-- [bom_no] [numeric](5, 0) NOT NULL,
	-- [bom_rev] [numeric](2, 0) NOT NULL,
	bom_hdrid int NOT NULL,
	[coc] [char](1) default '' NOT NULL,
    CONSTRAINT [PK_bomdocs] PRIMARY KEY CLUSTERED
    (
        [bomdocsid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into dbo.bomdocs
select document,
       -- bom_no,
       -- bom_rev,
        isnull(bom.bom_hdrid, 0),
       coc
from [rawUpsize_Contech].dbo.bomdocs
left outer join dbo.bom_hdr bom on bomdocs.bom_no = bom.bom_no and bomdocs.bom_rev = bom.bom_rev
GO


-- ***************************************************
-- table: bompriclog

-- re-mapped columns:
-- id (int) -> bompriclogid
-- job_no -> orderid
-- add_user -> add_userid

-- table PK:
-- bompriclogid: converted existing col to identity PK, also changed the name

-- FK fields:
-- orderid -> orders.orderid on job_no = orders.job_no
-- add_userid -> users.userid on add_user = users.username

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bompriclog')
        drop table dbo.bompriclog
GO

CREATE TABLE [dbo].[bompriclog](
	-- [id] [int] NOT NULL,
	bompriclogid int identity (1, 1),
	[bom_no] [numeric](5, 0) NOT NULL,
	[qty_from] [int] default 0 NOT NULL,
	[qty_to] [int] default 0 NOT NULL,
	[price] [numeric](8, 4) default 0 NOT NULL,
	-- [job_no] [int] NOT NULL,
	[orderid] [int] not null,
	-- [add_user] [char](10) NOT NULL,
	add_userid int default 0 NOT NULL,
	[add_dt] [datetime] NULL,
    CONSTRAINT [PK_bompriclog] PRIMARY KEY CLUSTERED
    (
        [bompriclogid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.bompriclog ON

insert into dbo.bompriclog
(bompriclogid, bom_no, qty_from, qty_to, price, orderid, add_userid, add_dt)
select id,
       bom_no,
       qty_from,
       qty_to,
       bompriclog.price,
       -- job_no,
       isnull(ord.orderid, 0),
       -- add_user,
       isnull(addu.userid, 0),
       bompriclog.add_dt
from [rawUpsize_Contech].dbo.bompriclog
inner join dbo.orders ord ON bompriclog.job_no = ord.job_no
left outer join dbo.users addu ON bompriclog.add_user = addu.username

set identity_insert dbo.bompriclog OFF



-- ***************************************************
-- table:  bomstage

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


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bomstage')
        drop table dbo.bomstage
GO

CREATE TABLE [dbo].[bomstage](
	-- [bomstageid] [int] NOT NULL,
	[bomstageid] int identity (1, 1),
	[bom_no] [numeric](5, 0) NOT NULL,
	[mfgstageid] [int] NOT NULL,
	[sort_order] [int] NOT NULL,
	[mfg_no] [numeric](5, 0) NOT NULL,
    CONSTRAINT [PK_bomstage] PRIMARY KEY CLUSTERED
    (
        [bomstageid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




-- ***************************************************
-- table: bomtable

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


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bomtable')
        drop table dbo.bomtable
GO

CREATE TABLE [dbo].[bomtable](
    [bomtableid] int identity (1, 1), -- new column
	[bom_no] [numeric](5, 0) NOT NULL,
	[table] [char](10) NOT NULL,
	[bom_rev] [numeric](2, 0) NOT NULL,
    CONSTRAINT [PK_bomtable] PRIMARY KEY CLUSTERED
    (
        [bomtableid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- ***************************************************
-- table: buyer

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


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'buyer')
        drop table dbo.buyer
GO

CREATE TABLE [dbo].[buyer](
    [buyerid] int identity (1, 1), -- new column
	[buyer] [char](5) NOT NULL,
	[first_name] [char](15) NOT NULL,
	[mi] [char](1) NOT NULL,
	[last_name] [char](25) NOT NULL,
    CONSTRAINT [PK_buyer] PRIMARY KEY CLUSTERED
    (
        [buyerid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




commit
GO

-- rollback
