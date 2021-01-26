-- ***************************************************
-- Section 006: bom_hdr, bom_dtl
-- ***************************************************
-- column name changes:
--      bom_dtl.bom_dtlid -> bom_dtlref
-- removed columns:
--      bom_dtl.bom_no
--      bom_dtl.bom_ref

-- bom_hdr PK:
--      bom_dtl.bom_hdrid (new)
-- bom_dtl PK:
--      bom_dtlid (already existed); converted to primary key

-- notes:
-- (1)
--      bom_hdr had duplicate records (2):
--      bom_no	bom_rev
--      53622	4
--      50398	15
--      The script only imports the first instance of these bom_dtl records.


begin tran

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bom_hdr')
    BEGIN
        drop table dbo.bom_hdr
    END

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bom_dtl')
    BEGIN
        drop table dbo.bom_dtl
    END

CREATE TABLE [dbo].[bom_hdr](
    bom_hdrid int identity(1, 1),
	[bom_no] [numeric](5, 0) NOT NULL,
	[bom_rev] [numeric](2, 0) NOT NULL,
	[part_no] [char](15) NOT NULL,
	[part_rev] [char](10) default '' NOT NULL,
	[part_desc] [char](50) default '' NOT NULL,
	[price] [numeric](8, 4) default 0 NOT NULL,
	[price_ire] [numeric](8, 4) default 0 NOT NULL,
	[price_rev] [datetime] NULL,
	[unit] [char](4) default '' NOT NULL,
	[date_rev] [datetime] NULL,
	[sts] [char](1) default '' NOT NULL,
	[cust_no] [char](5) default '' NOT NULL,
	[date_ent] [datetime] NULL,
	[code_info] [numeric](1, 0) default 0 NOT NULL,
	[tube_lenth] [char](40) default '' NOT NULL,
	[tube_dim] [char](50) default '' NOT NULL,
	[assembly] [char](15) default '' NOT NULL,
	[scr_code] [char](1) default '' NOT NULL,
	[quota] [char](5) default '' NOT NULL,
	[notes] varchar(2000) default '' NOT NULL,
	[mfg_no] [numeric](5, 0) default 0 NOT NULL,
	[spec_no] [char](5) default '' NOT NULL,
	[spec_rev] [char](2) default '' NOT NULL,
	[dspec_rev] [datetime] NULL,
	[doc_no] [char](5) default '' NOT NULL,
	[doc_rev] [char](2) default '' NOT NULL,
	[ddoc_rev] [datetime] NULL,
	[computer] [char](1) default '' NOT NULL,
	[waste] [char](10) default '' NOT NULL,
	[qty_case] [numeric](6, 0) default 0 NOT NULL,
	[price_note] varchar(2000) default '' NOT NULL,
	[mfg_cat] [char](2) default '' NOT NULL,
	[expfactor] [int] default 0 NOT NULL,
	[sts_loc] [char](20) default '' NOT NULL,
	[expunit] [char](1) default '' NOT NULL,
    CONSTRAINT [PK_bom_hdr] PRIMARY KEY CLUSTERED
    (
        [bom_hdrid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into [dbo].[bom_hdr]
select * FROM [rawUpsize_Contech].dbo.bom_hdr
GO

CREATE TABLE [dbo].[bom_dtl](
    bom_dtlid int identity(1, 1),
    bom_hdrid int NOT NULL,
	[order] [numeric](2, 0) default 0 NOT NULL,
	[comp] [char](5) default '' NOT NULL,
	[quan] [numeric](8, 6) default 0 NOT NULL,
	[coc] [char](1) default '' NOT NULL,
	bom_dtlref int default 0 not null,
    CONSTRAINT [PK_bom_dtl] PRIMARY KEY CLUSTERED
    (
        [bom_dtlid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO dbo.bom_dtl
SELECT bom_hdr.[bom_hdrid]
    ,[order]
    ,[comp]
    ,[quan]
    ,[coc]
    ,[bom_dtlid]
FROM [rawUpsize_Contech].dbo.bom_dtl
INNER JOIN (select bom_no, bom_rev, min(bom_hdrid) as bom_hdrid
            from dbo.bom_hdr group by bom_no, bom_rev) bom_hdr
    ON bom_dtl.bom_no = bom_hdr.bom_no AND bom_dtl.bom_rev = bom_hdr.bom_rev
GO

commit
