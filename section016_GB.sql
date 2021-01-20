-- ***************************************************
-- Section 016: accounts, asstcalib, assthist
-- ***************************************************

use Contech_Test
GO

begin tran

-- ***************************************************
-- table: accounts

-- table PK:
-- accountid: added new identity field

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'accounts')
        drop table dbo.accounts
GO

CREATE TABLE [dbo].[accounts](
    [accountid] int identity (1, 1), -- new
	[acct_code] [char](1) NOT NULL,
	[desc] [char](35) default '' NOT NULL,
    CONSTRAINT [PK_accounts] PRIMARY KEY CLUSTERED
    (
        [accountid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into dbo.accounts
select * FROM [rawUpsize_Contech].dbo.accounts

-- ***************************************************
-- table: asstcalib

-- re-mapped columns:
-- asset_no (char) -> assetsid (int)
-- add_empe (char) -> add_employeeid (int)
-- rev_emp (char)-> rev_employeeid (int)

-- new columns:
--

-- table PK:
-- asstcalibid: converted existing field to identity field

-- FK fields:
-- assetsid: assets.assetsid
-- add_employeeid: employee.employeeid
-- rev_employeeid: employee.employeeid

-- notes:
-- (1) changed criteria type from (text) to (varchar(2000)), query confirms longest values < 1000


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'asstcalib')
        drop table dbo.asstcalib
GO

CREATE TABLE [dbo].[asstcalib](
    -- [asstcalibid] [int] NOT NULL,
	[asstcalibid] [int] identity (1, 1),
	-- [asset_no] [char](10) NOT NULL,
	assetsid int not null,
	[criteria] varchar(2000) default '' NOT NULL,
	-- [add_empe] [char](10) NOT NULL,
	[add_employeeid] int default 0 NOT NULL,
	[add_dt] [datetime] NULL,
	[rev_rec] [int] default 0 NOT NULL,
	[rev_dt] [datetime] NULL,
	-- [rev_emp] [char](10) NOT NULL,
	rev_employeeid int default 0 NOT NULL,
    CONSTRAINT [PK_asstcalib] PRIMARY KEY CLUSTERED
    (
        [asstcalibid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.asstcalib ON

insert into dbo.asstcalib
(asstcalibid, assetsid, criteria, add_employeeid, add_dt, rev_rec, rev_dt, rev_employeeid)
select asstcalibid,
       -- asset_no,
       isnull(a.assetsid, 0),
       criteria,
       -- add_empe,
       ISNULL(adde.employeeid, 0),
       add_dt,
       asstcalib.rev_rec,
       asstcalib.rev_dt,
       -- rev_emp
        isnull(reve.employeeid, 0)
FROM [rawUpsize_Contech].dbo.asstcalib
inner join dbo.assets a ON asstcalib.asset_no = a.asset_no
left outer join dbo.employee adde ON asstcalib.add_empe = adde.empnumber
left outer join dbo.employee reve ON asstcalib.rev_emp = reve.empnumber
GO

set identity_insert dbo.asstcalib OFF


-- ***************************************************
-- table: assthist

-- re-mapped columns:
-- asset_no (char) -> assetsid (int)
-- empnumber (char) -> employeeid (int)
-- add_empe (char) -> add_employeeid (int)
-- rev_emp (char) - rev_employeeid (int)

-- table PK:
-- assthistid: converted existing col to identity PK

-- FK fields:
-- asset

-- notes:
-- (1) changed criteria type from (text) to (varchar(2000)), query confirms longest values < 1000

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'assthist')
        drop table dbo.assthist
GO


CREATE TABLE [dbo].[assthist](
	-- [assthistid] [int] NOT NULL,
	[assthistid] [int] identity (1, 1),
	-- [asset_no] [char](10) NOT NULL,
	[assetid] int not null,
	[asstevntid] [int] NOT NULL,
	[location] [char](3) default '' NOT NULL,
	[comments] varchar(2000) default '' NOT NULL,
	[inspect_by] [char](50) default '' NOT NULL,
	[evnt_date] [datetime] NULL,
	[evnt_type] [char](2) default '' NOT NULL,
	-- [empnumber] [char](10) NOT NULL,
	employeeid int default 0 NOT NULL,
	[add_dt] [datetime] NULL,
	-- [add_empe] [char](10) NOT NULL,
	add_employeeid int default 0 NOT NULL,
	[evntaction] [bit] default 0 NOT NULL,
	[evnt_name] [char](30) default '' NOT NULL,
	[rev_rec] [int] default 0 NOT NULL,
	[rev_dt] [datetime] NULL,
	-- [rev_emp] [char](10) NOT NULL
	rev_employeeid int default 0 NOT NULL,
    CONSTRAINT [PK_assthist] PRIMARY KEY CLUSTERED
    (
        [assthistid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.assthist ON

insert into dbo.assthist
(assthistid, assetid, asstevntid, location, comments, inspect_by, evnt_date, evnt_type, employeeid, add_dt, add_employeeid, evntaction, evnt_name, rev_rec, rev_dt, rev_employeeid)
select assthistid,
       -- asset_no,
       a.assetid,
       asstevntid,
       assthist.location,
       comments,
       inspect_by,
       evnt_date,
       evnt_type,
       -- empnumber,
       isnull(emp.employeeid, 0),
       add_dt,
       -- add_empe,
       isnull(adde.employeeid, 0),
       evntaction,
       evnt_name,
       assthist.rev_rec,
       assthist.rev_dt,
       -- rev_emp
       isnull(reve.employeeid, 0)
from [rawUpsize_Contech].dbo.assthist
inner join assets a ON assthist.asset_no = a.asset_no
left outer join employee emp ON assthist.empnumber = emp.empnumber
left outer join employee adde on assthist.add_empe = adde.empnumber
left outer join employee reve on assthist.rev_emp = reve.empnumber
GO

set identity_insert dbo.assthist OFF
GO

commit
GO

-- rollback
