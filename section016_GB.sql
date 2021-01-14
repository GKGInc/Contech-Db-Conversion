-- ***************************************************
-- Section 016: accounts, asstcalib, assthist
-- ***************************************************

use Contech_Test
GO

begin tran

-- ***************************************************
-- table:

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


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'accounts')
        drop table dbo.accounts
GO

CREATE TABLE [dbo].[accounts](
	[acct_code] [char](1) NOT NULL,
	[desc] [char](35) NOT NULL
) ON [PRIMARY]
GO



-- ***************************************************
-- table:

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


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'asstcalib')
        drop table dbo.asstcalib
GO

CREATE TABLE [dbo].[asstcalib](
	[asstcalibid] [int] NOT NULL,
	[asset_no] [char](10) NOT NULL,
	[criteria] [text] NOT NULL,
	[add_empe] [char](10) NOT NULL,
	[add_dt] [datetime] NULL,
	[rev_rec] [int] NOT NULL,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-- ***************************************************
-- table:

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


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'assthist')
        drop table dbo.assthist
GO


CREATE TABLE [dbo].[assthist](
	[assthistid] [int] NOT NULL,
	[asset_no] [char](10) NOT NULL,
	[asstevntid] [int] NOT NULL,
	[location] [char](3) NOT NULL,
	[comments] [text] NOT NULL,
	[inspect_by] [char](50) NOT NULL,
	[evnt_date] [datetime] NULL,
	[evnt_type] [char](2) NOT NULL,
	[empnumber] [char](10) NOT NULL,
	[add_dt] [datetime] NULL,
	[add_empe] [char](10) NOT NULL,
	[evntaction] [bit] NOT NULL,
	[evnt_name] [char](30) NOT NULL,
	[rev_rec] [int] NOT NULL,
	[rev_dt] [datetime] NULL,
	[rev_emp] [char](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



commit
GO

-- rollback
