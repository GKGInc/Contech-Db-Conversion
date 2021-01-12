-- ***************************************************
-- Section 010: complnts, cmpcases, rabox, ralabel
-- ***************************************************

-- column name changes:
--   invoice_no -> aropenid

-- removed columns:
--   invoice_no

-- table PK:
-- complntid: new identity col added

use Contech_Test
GO

begin tran


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
left outer join dbo.aropen aro on complnts.invoice_no = aro.invoice_no
GO

commit

