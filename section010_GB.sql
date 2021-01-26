-- ***************************************************
-- Section 010: complnts, cmpcases, ralabel, rabox
-- ***************************************************

begin tran

-- ***************************************************
-- table: complnts

-- column name changes:
--   invoice_no -> aropenid, converting ref# to FK id

-- table PK:
-- complntid: new identity col added

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'complnts')
        drop table dbo.complnts
GO


CREATE TABLE [dbo].[complnts](
    complntid int identity (1, 1),
	[complnt_no] [int] NOT NULL,
	[custcompln] [char](25) default '' NOT NULL,
	-- [invoice_no] [numeric](9, 0) NOT NULL,
	aropenid int NOT NULL,
	[complntqty] [int] default 0 NOT NULL,
	[samples] [bit] default 0 NOT NULL,
	[complaint] varchar(2000) default '' NOT NULL,
	[qa_sign] [char](50) default '' NOT NULL,
	[qasign_dt] [datetime] NULL,
	[dsposition] varchar(2000) default '' NOT NULL,
	[sign1] [char](50) default '' NOT NULL,
	[date1] [datetime] NULL,
	[sign2] [char](50) default '' NOT NULL,
	[date2] [datetime] NULL,
	[cnfrm_code] [char](2) default '' NOT NULL,
	[car_no] [char](8) default '' NOT NULL,
	[complnt_dt] [datetime] NULL,
	[complainer] [int] default 0 NOT NULL,
	[complnttyp] [char](3) default '' NOT NULL,
	[status] [char](1) default '' NOT NULL,
	[complanant] [char](50) default '' NOT NULL,
	[issuesid] [int] default 0 NOT NULL,
	[issuesdtid] [int] default 0 NOT NULL,
	[ct_lot] [char](8) default '' NOT NULL,
    CONSTRAINT [PK_complnts] PRIMARY KEY CLUSTERED
    (
        [complntid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into dbo.complnts
select complnts.complnt_no,
       custcompln,
       ISNULL(aro.aropenid, 0),
       complntqty,
       samples,
       complaint,
       qa_sign,
       qasign_dt,
       dsposition,
       sign1,
       date1,
       sign2,
       date2,
       cnfrm_code,
       car_no,
       complnt_dt,
       complainer,
       complnttyp,
       status,
       complanant,
       issuesid,
       issuesdtid,
       complnts.ct_lot
from [rawUpsize_Contech].dbo.complnts
left outer join dbo.aropen aro on complnts.invoice_no = aro.invoice_no and aro.invoice_no != 0
GO

-- ***************************************************
-- table: cmpcases

-- column name changes:
--  cmpcasesid -> cmpcaseid  (PK)
--  matlin_key -> matlinid,  (FK to matlin)
--  comp -> componetid  (FK to componet)
--  userid (char) -> userid (int)  (FK to user)

-- table PK:
-- cmpcaseid: converted to identity pk

-- notes:
-- (1)

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'cmpcases')
        drop table dbo.cmpcases
GO

CREATE TABLE [dbo].[cmpcases](
	[cmpcaseid] [int] identity (1, 1),
	[bar_code] [char](9) default '' NOT NULL,
	[case_no] [int] default 0 NOT NULL,
	-- [matlin_key] [int] default 0 NOT NULL,
	[matlinid] int default 0 NOT NULL,
	-- [comp] [char](5) default '' NOT NULL,
	[componetid] int default 0 NOT NULL,
	[ct_lot] [char](4) default '' NOT NULL,
	[loc_row] [int] default 0 NOT NULL,
	[loc_rack] [int] default 0 NOT NULL,
	[loc_level] [char](2) default '' NOT NULL,
	[qty] [int] default 0 NOT NULL,
	[aloc_qty] [int] default 0 NOT NULL,
	[restock] [bit] default 0 NOT NULL,
	[last_mod] [datetime] NULL,
	-- [userid] [char](10) default '' NOT NULL,
	[userid] int default 0 NOT NULL,
	[insp_date] [datetime] NULL,
	[consign] [bit] default 0 NOT NULL,
	[mfg_locid] [int] default 0 NOT NULL,
    CONSTRAINT [PK_cmpcases] PRIMARY KEY CLUSTERED
    (
        [cmpcaseid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert dbo.cmpcases ON

insert into dbo.cmpcases
(cmpcaseid, bar_code, case_no, matlinid, componetid, ct_lot, loc_row, loc_rack, loc_level, qty, aloc_qty, restock, last_mod, userid, insp_date, consign, mfg_locid)
select cmpcasesid,
       bar_code,
       case_no,
       matlin_key,
       isnull(cmp.componetid, 0),
       ct_lot,
       loc_row,
       loc_rack,
       loc_level,
       qty,
       aloc_qty,
       restock,
       last_mod,
       isnull(u.userid, 0),
       insp_date,
       consign,
       cmpcases.mfg_locid
from [rawUpsize_Contech].dbo.cmpcases
left outer join dbo.componet cmp ON cmpcases.comp = cmp.comp and (cmpcases.comp is not null AND cmpcases.comp != '')
left outer join dbo.users u on cmpcases.userid = u.username and RTRIM(cmpcases.userid) != ''

set identity_insert dbo.cmpcases OFF

-- ***************************************************
-- table: ralabel

-- column name changes:
--  add_user -> add_userid
--  mod_user -> mod_userid

-- table PK:
-- ralabelid: converted to identity pk

-- FK fields:
--  prodctraid -> direct ref to prodctra.prodctraid
--  add_userid -> converted username ref to userid
--  mod_userid -> converted username ref to userid
--  fplocatnid -> direct ref to fplocatn.fplocatnid

-- notes:
-- (1)

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'ralabel')
        drop table dbo.ralabel
GO

CREATE TABLE [dbo].[ralabel](
	[ralabelid] [int] identity (1, 1),
	[prodctraid] [int] default 0 NOT NULL,
	[labelno] [int] default 0 NOT NULL,
	[qty] [int] default 0 NOT NULL,
	-- [add_user] [char](10) NOT NULL,
	add_userid [int] default 0 NOT NULL,
	[add_dt] [datetime] NULL,
	-- [mod_user] [char](10) NOT NULL,
	mod_userid [int] default 0 NOT NULL,
	[mod_dt] [datetime] NULL,
	[fplocatnid] [int] default 0 NOT NULL,
	[orig_qty] [int] default 0 NOT NULL,
    CONSTRAINT [PK_ralabel] PRIMARY KEY CLUSTERED
    (
        [ralabelid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


set identity_insert [dbo].[ralabel] ON

insert into dbo.ralabel
(ralabelid, prodctraid, labelno, qty, add_userid, add_dt, mod_userid, mod_dt, fplocatnid, orig_qty)
select ralabelid,
       prodctraid,
       labelno,
       qty,
       -- add_user,
       isnull(addu.userid, 0),
       add_dt,
       -- mod_user,
       isnull(modu.userid, 0),
       mod_dt,
       fplocatnid,
       orig_qty
from [rawUpsize_Contech].dbo.ralabel
left outer join dbo.users addu on ralabel.add_user = addu.username and rtrim(ralabel.add_user) != ''
left outer join dbo.users modu on ralabel.add_user = modu.username and rtrim(ralabel.mod_user) != ''

set identity_insert [dbo].[ralabel] OFF

-- ***************************************************
-- table: rabox

-- column name changes:
-- add_user -> add_userid
-- mod_user -> mod_userid

-- table PK:
-- raboxid: converted to identity PK

-- FK fields:
--  ralabelid -> direct ref to ralabel.ralabelid
--  add_userid -> converted username ref to userid
--  mod_userid -> converted username ref to userid
--  fplocatnid -> direct ref to fplocatn.fplocatnid

-- notes:
-- (1)

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'rabox')
        drop table dbo.rabox
GO

CREATE TABLE [dbo].[rabox](
	[raboxid] int identity (1, 1),
	[ralabelid] [int] default 0 NOT NULL,
	[labelno] [int] default 0 NOT NULL,
	[qty] [int] default 0 NOT NULL,
	-- [add_user] [char](10) NOT NULL,
	[add_userid] int default 0 NOT NULL,
	[add_dt] [datetime] NULL,
	-- [mod_user] [char](10) NOT NULL,
	[mod_userid] [int] default 0 NOT NULL,
	[mod_dt] [datetime] NULL,
	[fplocatnid] [int] default 0 NOT NULL,
	[orig_qty] [int] default 0 NOT NULL,
    CONSTRAINT [PK_rabox] PRIMARY KEY CLUSTERED
    (
        [raboxid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert [dbo].[rabox] ON

insert into dbo.rabox
(raboxid, ralabelid, labelno, qty, add_userid, add_dt, mod_userid, mod_dt, fplocatnid, orig_qty)
select raboxid,
       ralabelid,
       labelno,
       qty,
       -- add_user,
       isnull(addu.userid, 0),
       add_dt,
       -- mod_user,
      isnull(addu.userid, 0),
       mod_dt,
       fplocatnid,
       orig_qty
FROM [rawUpsize_Contech].dbo.rabox
left outer join dbo.users addu on rabox.add_user = addu.username and rtrim(rabox.add_user) != ''
left outer join dbo.users modu on rabox.add_user = modu.username and rtrim(rabox.mod_user) != ''

set identity_insert [dbo].[rabox] OFF
GO

commit
GO

