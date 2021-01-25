-- ***************************************************
-- Section 024: bomdocs, bompriclog, bomstage, bomtable, buyer
-- ***************************************************

use Contech_Test
GO

begin tran

-- ***************************************************
-- table: bomdocs
-- ***************************************************

-- Re-mapped columns:
-- - bom_no   ___ bom_hdrid
-- - bom_rev  _/

-- New columns:
-- - bom_hdrid: replaces bom_no & bom_rev

-- Table PK:
-- - bomdocsid: add identity PK

-- FK fields:
-- - bom_hdrid: bom_hdr.bom_hdrid

USE [Contech_Test]

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

--SELECT * FROM [bomdocs]

-- ***************************************************
-- table: bompriclog
-- ***************************************************

-- Re-mapped columns:
-- - id (int) -> bompriclogid
-- - job_no -> orderid
-- - add_user -> add_userid

-- Table PK:
-- - bompriclogid: converted existing col to identity PK, also changed the name

-- FK fields:
-- - orderid -> orders.orderid on job_no = orders.job_no
-- - add_userid -> users.userid on add_user = users.username

USE [Contech_Test]

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

--SELECT * FROM [bompriclog]

-- ***************************************************
-- Table: bomstage
-- ***************************************************

-- Column changes:
--  - Set [bomstageid] to be primary key
-- Maps:
--	- [bomstage].[bom_no]		-- FK = [bom_hdr].[bom_no] 
--	- [bomstage].[mfgstageid]	-- FK = [mfgstage].[mfgstageid] 
-- Notes:
--  - Could not link [bomstage].[bom_no] to [bom_hdr].[bom_no]. Multiple [bom_rev] entries for [bom_no] values

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bomstage'))
    DROP TABLE [bomstage]
GO

CREATE TABLE [dbo].[bomstage](
	[bomstageid] [int] IDENTITY(1,1) NOT NULL,
	[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no] 
	[mfgstageid] [int] NOT NULL DEFAULT 0,			-- FK = [mfgstage].[mfgstageid] 
	[sort_order] [int] NOT NULL DEFAULT 0,
	[mfg_no] [numeric](5, 0) NOT NULL DEFAULT 0,
    CONSTRAINT [PK_bomstage] PRIMARY KEY CLUSTERED
    (
        [bomstageid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [bomstage] ON;

INSERT INTO [bomstage] ([bomstageid],[bom_no],[mfgstageid],[sort_order],[mfg_no])
SELECT [rawUpsize_Contech].[dbo].[bomstage].[bomstageid]
      ,[rawUpsize_Contech].[dbo].[bomstage].[bom_no]
      ,[rawUpsize_Contech].[dbo].[bomstage].[mfgstageid]
      ,[rawUpsize_Contech].[dbo].[bomstage].[sort_order]
      ,[rawUpsize_Contech].[dbo].[bomstage].[mfg_no]
  FROM [rawUpsize_Contech].[dbo].[bomstage]
  ORDER BY [rawUpsize_Contech].[dbo].[bomstage].[bomstageid]

SET IDENTITY_INSERT [bomstage] OFF;

--SELECT * FROM [bomstage]

-- ***************************************************
-- Table: bomtable
-- ***************************************************

-- Column changes:
--  - Added [bomtableid] to be primary key
--  - Added [bom_hdrid] [int] to reference [bom_hdr] table using [bom_no] and [bom_rev] columns
--  - Removed columns [bom_no] and [bom_rev] 
-- Maps:
--	- [bomtable].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bomtable'))
    DROP TABLE [bomtable]
GO

CREATE TABLE [dbo].[bomtable](
    [bomtableid] [int] IDENTITY(1,1) NOT NULL,		-- new column
	[table] [char](10) NOT NULL DEFAULT '',
	--[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,
	--[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,
	[bom_hdrid] [int] NOT NULL DEFAULT 0,			-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
    CONSTRAINT [PK_bomtable] PRIMARY KEY CLUSTERED
    (
        [bomtableid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [bomtable] ([table],[bom_hdrid])
SELECT [rawUpsize_Contech].[dbo].[bomtable].[table]
	  --,[rawUpsize_Contech].[dbo].[bomtable].[bom_no]
   --   ,[rawUpsize_Contech].[dbo].[bomtable].[bom_rev]
	  ,ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
  FROM [rawUpsize_Contech].[dbo].[bomtable]
  LEFT JOIN [bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[bomtable].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[bomtable].[bom_rev] = bom_hdr.[bom_rev] 
  
--SELECT * FROM [bomtable]

-- ***************************************************
-- Table: buyer
-- ***************************************************

-- Column changes:
--  - Added [buyerid] to be primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'buyer'))
    DROP TABLE [buyer]
GO

CREATE TABLE [dbo].[buyer](
    [buyerid] int identity (1, 1),	-- new column 
	[buyer] [char](5) NOT NULL DEFAULT '',
	[first_name] [char](15) NOT NULL DEFAULT '',
	[mi] [char](1) NOT NULL DEFAULT '',
	[last_name] [char](25) NOT NULL DEFAULT '',
    CONSTRAINT [PK_buyer] PRIMARY KEY CLUSTERED
    (
        [buyerid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [buyer] ([buyer],[first_name],[mi],[last_name])

SELECT [buyer]
      ,[first_name]
      ,[mi]
      ,[last_name]
  FROM [rawUpsize_Contech].[dbo].[buyer]

--SELECT * FROM [buyer]

-- ***************************************************

commit
GO

-- rollback
