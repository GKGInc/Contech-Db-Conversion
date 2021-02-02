-- ***************************************************
-- Section 006: bom_hdr, bom_dtl
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section006_GB.sql'

begin tran

begin try

    -- bom_hdr PK:
    --      bom_dtl.bom_hdrid (new)

    -- field data type changes:
    -- notes (text) -> notes (varchar(2000))
    -- price_note (text) -> price_note (varchar(2000))

    -- FK fields:
    -- customerid: customer.customerid
    -- mfgcatid: mfgcat.mfgcatid (on bom_hdr.mfg_cat = mfgcat.mfg_cat

    -- notes:
    -- (1)
    --      bom_hdr had duplicate records (2):
    --      bom_no	bom_rev
    --      53622	4
    --      50398	15
    --      The script only imports the first instance of these bom_dtl records.

    print 'table: dbo.bom_hdr: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bom_hdr')
        BEGIN
            drop table dbo.bom_hdr
        END

    CREATE TABLE [dbo].[bom_hdr](
        bom_hdrid int identity(1, 1),
        [bom_no] [numeric](5, 0) NOT NULL,
        [bom_rev] [numeric](2, 0) NOT NULL,
        [part_no] [char](15) NOT NULL,
        [part_rev] [char](10) NOT NULL,
        [part_desc] [char](50) NOT NULL,
        [price] [numeric](8, 4) NOT NULL,
        [price_ire] [numeric](8, 4) NOT NULL,
        [price_rev] [datetime] NULL,
        [unit] [char](4) NOT NULL,
        [date_rev] [datetime] NULL,
        [sts] [char](1) NOT NULL,
        -- [cust_no] [char](5) NOT NULL,
        customerid int NOT NULL,
        [date_ent] [datetime] NULL,
        [code_info] [numeric](1, 0) NOT NULL,
        [tube_lenth] [char](40) NOT NULL,
        [tube_dim] [char](50) NOT NULL,
        [assembly] [char](15) NOT NULL,
        [scr_code] [char](1) NOT NULL,
        [quota] [char](5) NOT NULL,
        -- [notes] [text] NOT NULL,
        [notes] varchar(2000) default '' NOT NULL,
        [mfg_no] [numeric](5, 0) NOT NULL,
        [spec_no] [char](5) NOT NULL,
        [spec_rev] [char](2) NOT NULL,
        [dspec_rev] [datetime] NULL,
        [doc_no] [char](5) NOT NULL,
        [doc_rev] [char](2) NOT NULL,
        [ddoc_rev] [datetime] NULL,
        [computer] [char](1) NOT NULL,
        [waste] [char](10) NOT NULL,
        [qty_case] [numeric](6, 0) NOT NULL,
        -- [price_note] [text] NOT NULL,
        [price_note] varchar(2000) default '' NOT NULL,
        -- [mfg_cat] [char](2) NOT NULL,
        mfgcatid int NOT NULL,
        [expfactor] [int] NOT NULL,
        [sts_loc] [char](20) NOT NULL,
        [expunit] [char](1) NOT NULL,
        CONSTRAINT [PK_bom_hdr] PRIMARY KEY CLUSTERED
        (
            [bom_hdrid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    with cte_bom_hdr
        as (select *, row_number() over(partition by bom_no, bom_rev order by bom_no, bom_rev) rowrank
            from [rawUpsize_Contech].dbo.bom_hdr)
    insert into [dbo].[bom_hdr]
    select bom_no,
           bom_rev,
           part_no,
           part_rev,
           part_desc,
           price,
           price_ire,
           price_rev,
           unit,
           date_rev,
           sts,
           -- cust_no,
           isnull(cus.customerid, 0),
           date_ent,
           code_info,
           tube_lenth,
           tube_dim,
           assembly,
           scr_code,
           quota,
           notes,
           mfg_no,
           spec_no,
           spec_rev,
           dspec_rev,
           doc_no,
           doc_rev,
           ddoc_rev,
           computer,
           waste,
           qty_case,
           price_note,
           -- mfg_cat,
           isnull(mc.mfgcatid, 0),
           expfactor,
           sts_loc,
           expunit
    FROM cte_bom_hdr bom_hdr
    left outer join dbo.customer cus ON bom_hdr.cust_no = cus.cust_no
    left outer join dbo.mfgcat mc ON bom_hdr.mfg_cat = mc.mfg_cat and RTRIM(bom_hdr.mfg_cat) != ''
    where bom_hdr.rowrank = 1;

    print 'table: dbo.bom_hdr: end'

    -- ***************************************************
    -- table: bom_dtl

    -- re-mapped columns:
    -- bom_dtlid : a real identity PK, see Note# (1)

    -- removed columns:
    --      bom_dtl.bom_no
    --      bom_dtl.bom_ref

    -- new columns:
    -- bom_hdrid : replaces bom_no/bom_rev link to bom_hdr

    -- table PK:
    -- bom_dtlid PK:
    --      bom_dtlid (already existed); converted to primary key, values from bom_dtlid NOT used as new PK

    -- FK fields:
    -- bom_hdrid : bom_hdr.bom_hdrid (on bom_dtl.bom_no/bom_rev = bom_hdr.bom_no/bom_rev)
    -- componetid : componet.componeid (on bom_dtl.comp = componet.comp)

    -- notes:
    -- (1) the original bom_dtl.bom_dtlid column had duplicates because it wasn't unique by design
    -- https://gkginc.slack.com/archives/G01JTKDEAUQ/p1611778528034300

    print 'table: dbo.bom_dtl: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'bom_dtl')
        BEGIN
            drop table dbo.bom_dtl
        END

    CREATE TABLE [dbo].[bom_dtl](
        -- [bom_dtlid] [int] NOT NULL
        bom_dtlid int identity(1, 1),
        -- [bom_no] [numeric](5, 0) NOT NULL,
        -- [bom_rev] [numeric](2, 0) NOT NULL,
        bom_hdrid int NOT NULL,
        bom_dtlref int not null, -- values come from the original bom_dtl.bom_dtlid (not unique)
        [order] [numeric](2, 0) NOT NULL,
        -- [comp] [char](5) NOT NULL,
        componetid int NOT NULL,
        [quan] [numeric](8, 6) NOT NULL,
        [coc] [char](1) NOT NULL,
        CONSTRAINT [PK_bom_dtl] PRIMARY KEY CLUSTERED
        (
            [bom_dtlid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    INSERT INTO dbo.bom_dtl
        (bom_hdrid, bom_dtlref, [order], componetid, quan, coc)
    SELECT bom_hdr.[bom_hdrid]
         ,bom_dtl.bom_dtlid
        ,[order]
        ,isnull(c.componetid, 0)
        ,[quan]
        ,[coc]
    FROM [rawUpsize_Contech].dbo.bom_dtl
    INNER JOIN dbo.bom_hdr
        ON bom_dtl.bom_no = bom_hdr.bom_no AND bom_dtl.bom_rev = bom_hdr.bom_rev
    left outer join componet c ON bom_dtl.comp = c.comp

    commit
    print 'table: dbo.bom_dtl: end'

end try
begin catch
    rollback
    print 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section006_GB.sql'
