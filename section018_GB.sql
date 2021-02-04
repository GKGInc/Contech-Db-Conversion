-- ***************************************************
-- Section 018: tcompont, tbom_hdr, tbom_dtl, tbom_his, tbomdocs, tbomtble, tdspnser, tpouches, tquotas
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section018_GB.sql'

begin tran

begin try

    -- ***************************************************
    -- table: tcompont

    -- re-mapped columns:
    -- cust_no -> customerid
    -- material -> materialid

    -- column datatype changes:
    -- memo: text -> varchar(500)

    -- table PK:
    --tcompontid: added new identity PK column

    -- FK fields:
    -- customerid -> customer.customerid
    -- material -> material.materialid

    print 'table: dbo.tcompont: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tcompont')
            drop table dbo.tcompont

    CREATE TABLE [dbo].[tcompont](
        tcompontid int identity (1, 1),
        [comp] [char](5) default '' NOT NULL,
        [desc] [char](75) default '' NOT NULL,
        [desc2] [char](75) default '' NOT NULL,
        [memo1] [char](51) default '' NOT NULL,
        [insp] [char](2) default '' NOT NULL,
        -- [cust_no] [char](5) NOT NULL,
        customerid int default 0 NOT NULL,
        [cost] [numeric](9, 5) default 0 NOT NULL,
        [unit] [char](4) default '' NOT NULL,
        -- [ven_id] [char](6) default '' NOT NULL,
        vendorid int default 0 NOT NULL,
        [price] [numeric](9, 5) default 0 NOT NULL,
        [ctp_min] [numeric](10, 0) default 0 NOT NULL,
        [cmi_inv] [char](1) default '' NOT NULL,
        [cmi_min] [numeric](10, 0) default 0 NOT NULL,
        [cmi_price] [numeric](9, 5) default 0 NOT NULL,
        -- [material] [char](3) NOT NULL,
        materialid int default 0 NOT NULL,
        [cust_comp] [char](12) default '' NOT NULL,
        [cus_comp_r] [char](3) default '' NOT NULL,
        [cust_desc] [char](50) default '' NOT NULL,
        [memo] varchar(500) default '' NOT NULL,
        [inventory] [numeric](10, 0) default 0 NOT NULL,
        [drw] [char](8) default '' NOT NULL,
        [inc] [char](8) default '' NOT NULL,
        [price_ire] [numeric](9, 5) default 0 NOT NULL,
        [phys_inv] [numeric](10, 0) default 0 NOT NULL,
        [inv_card] [numeric](10, 0) default 0 NOT NULL,
        [quar] [numeric](10, 0) default 0 NOT NULL,
        [hold] [numeric](10, 0) default 0 NOT NULL,
        [reject] [numeric](10, 0) default 0 NOT NULL,
        [class] [char](4) default '' NOT NULL,
        [comp_rev] [char](2) default '' NOT NULL,
        [samp_plan] [char](2) default '' NOT NULL,
        [lbl] [char](8) default '' NOT NULL,
        [xinv] [bit] default 0 NOT NULL,
        [pickconv] [numeric](9, 2) default 0 NOT NULL,
        [back_dist] [bit] default 0 NOT NULL,
        [expire] [bit] default 0 NOT NULL,
        [comptype] [char](3) default '' NOT NULL,
        [color] [char](15) default '' NOT NULL,
        [color_no] [char](20) default '' NOT NULL,
        [pantone] [char](15) default '' NOT NULL,
        [fda_food] [int] default 0 NOT NULL,
        [fda_med] [int] default 0 NOT NULL,
        [coneg] [int] default 0 NOT NULL,
        [prop65] [int] default 0 NOT NULL,
        [rohs] [int] default 0 NOT NULL,
        [eu_94_62] [int] default 0 NOT NULL,
        CONSTRAINT [PK_tcompont] PRIMARY KEY CLUSTERED
        (
            [tcompontid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tcompont
    select comp,
           [desc],
           desc2,
           memo1,
           insp,
           -- cust_no,
           isnull(c.customerid, 0),
           cost,
           tcompont.[unit],
           -- ven_id,
           isnull(ven.vendorid, 0),
           price,
           ctp_min,
           cmi_inv,
           cmi_min,
           cmi_price,
           -- material,
           isnull(mat.materialid, 0),
           cust_comp,
           cus_comp_r,
           cust_desc,
           tcompont.memo,
           inventory,
           drw,
           inc,
           price_ire,
           phys_inv,
           inv_card,
           quar,
           hold,
           reject,
           class,
           comp_rev,
           samp_plan,
           lbl,
           xinv,
           pickconv,
           back_dist,
           expire,
           comptype,
           color,
           color_no,
           pantone,
           fda_food,
           fda_med,
           coneg,
           prop65,
           rohs,
           eu_94_62
    from [rawUpsize_Contech].dbo.tcompont
    left outer join dbo.customer c ON tcompont.cust_no = c.cust_no and rtrim(tcompont.cust_no) != ''
    left outer join dbo.material mat on tcompont.material = mat.material and rtrim(tcompont.material) != ''
    left outer join dbo.vendor ven on tcompont.ven_id = ven.ven_id

    print 'table: dbo.tcompont: end'

    -- ***************************************************
    -- table: tbom_hdr

    -- re-mapped columns:
    -- cust_no (char) -> customerid (int)
    -- mfg_cat (char) -> mfgcatid (int)

    -- column datatype changes:
    -- notes: text -> varchar(2000)
    -- price_note: text -> varchar(500)

    -- table PK:
    -- tbom_hdrid: added new identity PK column

    -- FK fields:
    -- customerid: ref to customer.customerid

    print 'table: dbo.tbom_hdr: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tbom_hdr')
            drop table dbo.tbom_hdr

    CREATE TABLE [dbo].[tbom_hdr](
        [tbom_hdrid] int identity (1, 1),
        [bom_no] [numeric](5, 0) NOT NULL,
        [bom_rev] [numeric](2, 0) NOT NULL,
        [part_no] [char](15) default '' NOT NULL,
        [part_rev] [char](10) default '' NOT NULL,
        [part_desc] [char](50) default '' NOT NULL,
        [price] [numeric](8, 4) default 0 NOT NULL,
        [price_ire] [numeric](8, 4) default 0 NOT NULL,
        [price_rev] [datetime] NULL,
        [unit] [char](4) default '' NOT NULL,
        [date_rev] [datetime] NULL,
        [sts] [char](1) default '' NOT NULL,
        -- [cust_no] [char](5) NOT NULL,
        [customerid] int default 0 NOT NULL,
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
        [price_note] varchar(500) default '' NOT NULL,
        -- [mfg_cat] [char](2) NOT NULL,
        mfgcatid int default 0 NOT NULL,
        [rbom_no] [numeric](5, 0) default 0 NOT NULL,
        [sts_loc] [char](20) default '' NOT NULL,
        CONSTRAINT [PK_tbom_hdr] PRIMARY KEY CLUSTERED
        (
            [tbom_hdrid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tbom_hdr
    (bom_no, bom_rev, part_no, part_rev, part_desc, price, price_ire, price_rev, "unit", date_rev, sts, customerid, date_ent, code_info, tube_lenth, tube_dim, assembly, scr_code, quota, notes, mfg_no, spec_no, spec_rev, dspec_rev, doc_no, doc_rev, ddoc_rev, computer, waste, qty_case, price_note, mfgcatid, rbom_no, sts_loc)
    select bom_no,
           bom_rev,
           part_no,
           part_rev,
           part_desc,
           price,
           price_ire,
           price_rev,
           tbom_hdr.[unit],
           date_rev,
           sts,
           -- tbom_hdr.cust_no,
           isnull(c.customerid, 0),
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
           isnull(mfgc.mfgcatid, 0),
           rbom_no,
           sts_loc
    from [rawUpsize_Contech].dbo.tbom_hdr
    left outer join dbo.customer c ON tbom_hdr.cust_no = c.cust_no and rtrim(tbom_hdr.cust_no) != ''
    left outer join dbo.mfgcat mfgc ON tbom_hdr.mfg_cat = mfgc.mfg_cat and rtrim(tbom_hdr.mfg_cat) != ''

    print 'table: dbo.tbom_hdr: end'

    -- ***************************************************
    -- table: tbom_dtl

    -- re-mapped columns:
    -- comp (char) -> tcompontid (int)

    -- new columns:
    -- tbom_hdrid: FK to tbom_hdr

    -- removed columns:
    -- bom_no: old FK to parent
    -- bom_rev: old FK to parent

    -- table PK:
    -- tbom_dtlid: added new identity PK column

    -- FK fields:
    -- tcompontid: FK to tcompont

    -- notes:
    -- (1) there were orphaned records for bom_no = 10794. not importing them

    print 'table: dbo.tbom_dtl: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tbom_dtl')
            drop table dbo.tbom_dtl

    CREATE TABLE [dbo].[tbom_dtl](
        tbom_dtlid int identity (1, 1),
        tbom_hdrid int not null,
        [order] [numeric](2, 0) NOT NULL,
        -- [comp] [char](5) NOT NULL,
        tcompontid int default 0 NOT NULL,
        [quan] [numeric](8, 6) NOT NULL,
        [coc] [char](1) NOT NULL,
        -- [bom_no] [numeric](5, 0) NOT NULL,
        -- [bom_rev] [numeric](2, 0) NOT NULL
        CONSTRAINT [PK_tbom_dtl] PRIMARY KEY CLUSTERED
        (
            [tbom_dtlid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tbom_dtl
    select tbh.tbom_hdrid,
           [order],
           isnull(tc.tcompontid, 0),
           quan,
           coc
    from [rawUpsize_Contech].dbo.tbom_dtl
    inner join dbo.tbom_hdr tbh ON tbom_dtl.bom_no = tbh.bom_no and tbom_dtl.bom_rev = tbh.bom_rev
    left outer join dbo.tcompont tc ON tbom_dtl.comp = tc.comp and rtrim(tbom_dtl.comp) != ''

    print 'table: dbo.tbom_dtl: end'

    -- ***************************************************
    -- table: tbom_his

    -- re-mapped columns:
    -- mod_user (char) -> mod_userid (int)

    -- removed columns:
    -- bom_no: old FK to tbom_hdr
    -- rev: old FK to tbom_hdr

    -- changed data types:
    -- notes: text -> varchar(500)

    -- table PK:
    -- tbom_hisid: added new identity PK column

    -- FK fields:
    -- mod_userid

    print 'table: dbo.tbom_his: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tbom_his')
            drop table dbo.tbom_his

    CREATE TABLE [dbo].[tbom_his](
        tbom_hisid int identity (1, 1),
        tbom_hdrid int not null,
        -- [bom_no] [numeric](5, 0) NOT NULL,
        [type] [char](4) NOT NULL,
        [notes] varchar(500) NOT NULL,
        [number] [char](5) NOT NULL,
        -- [rev] [char](2) NOT NULL,
        [daterev] [datetime] NULL,
        -- [mod_user] [char](10) NOT NULL,
        [mod_userid] int default 0 not null,
        [mod_dt] [datetime] NULL,
        CONSTRAINT [PK_tbom_his] PRIMARY KEY CLUSTERED
        (
            [tbom_hisid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tbom_his
    select tbom.tbom_hdrid,
           -- bom_no,
           type,
           tbom_his.notes,
           number,
           -- rev,
           daterev,
           -- mod_user,
           isnull(modu.userid, 0),
           mod_dt
    from [rawUpsize_Contech].dbo.tbom_his
    inner join dbo.tbom_hdr tbom ON tbom_his.bom_no = tbom.bom_no AND tbom_his.rev = tbom.bom_rev
    left outer join dbo.users modu ON tbom_his.mod_user = modu.username and rtrim(tbom_his.mod_user) != ''

    print 'table: dbo.tbom_his: end'

    -- ***************************************************
    -- table: tbomdocs

    -- new columns:
    -- tbom_hdrid

    -- removed columns:
    -- bom_no
    -- bom_rev

    -- table PK:
    -- tbomdocsid: added new identity PK column

    -- FK fields:
    -- tbom_hdrid

    -- notes:
    -- (1) no combination of columns is unique for all rows in original table
    -- (2) not importing orphaned records related to that one bom_no 10794 not in tbom_hdr

    print 'table: dbo.tbomdocs: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tbomdocs')
            drop table dbo.tbomdocs

    CREATE TABLE [dbo].[tbomdocs](
        tbomdocsid int identity (1, 1),
        tbom_hdrid int NOT NULL,
        [document] [char](15) NOT NULL,
        -- [bom_no] [numeric](5, 0) NOT NULL,
        -- [bom_rev] [numeric](2, 0) NOT NULL,
        [coc] [char](1) default '' NOT NULL,
        CONSTRAINT [PK_tbomdocs] PRIMARY KEY CLUSTERED
        (
            [tbomdocsid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tbomdocs
    select tbom.tbom_hdrid,
           document,
           -- bom_no,
           -- bom_rev,
           coc
    from [rawUpsize_Contech].dbo.tbomdocs
    inner join dbo.tbom_hdr tbom ON tbomdocs.bom_no = tbom.bom_no AND tbomdocs.bom_rev = tbom.bom_rev

    print 'table: dbo.tbomdocs: end'

    -- ***************************************************
    -- table: tbomtble

    -- new columns:
    -- tbom_hdrid: FK to tbom_hdr

    -- removed columns:
    -- bom_no
    -- bom_rev

    -- table PK:
    -- tbomtbleid: added new identity PK column

    -- FK fields:
    -- tbom_hdrid

    -- notes:
    -- (1) not importing orphaned records related to that one bom_no 10794 not in tbom_hdr

    print 'table: dbo.tbomtble: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tbomtble')
            drop table dbo.tbomtble

    CREATE TABLE [dbo].[tbomtble](
        [tbomtbleid] int identity (1, 1),
        [tbom_hdrid] int not null,
        -- [bom_no] [numeric](5, 0) NOT NULL,
        [table] [char](10) NOT NULL,
        CONSTRAINT [PK_tbomtble] PRIMARY KEY CLUSTERED
        (
            [tbomtbleid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
        -- [bom_rev] [numeric](2, 0) NOT NULL
    ) ON [PRIMARY]

    insert into dbo.tbomtble
    select tbom.tbom_hdrid,
           [table]
    from [rawUpsize_Contech].dbo.tbomtble
    inner join dbo.tbom_hdr tbom ON tbomtble.bom_no = tbom.bom_no AND tbomtble.bom_rev = tbom.bom_rev

    print 'table: dbo.tbomtble: end'

    -- ***************************************************
    -- table: tdspnser

    -- new columns:
    -- tbom_hdrid: FK to tbom_hdr

    -- removed columns:
    -- bom_no
    -- bom_rev

    -- table PK:
    -- tdspnserid: added new identity PK column

    -- notes:
    -- (1) not importing orphaned records related to that one bom_no 10794 not in tbom_hdr

    print 'table: dbo.tdspnser: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tdspnser')
            drop table dbo.tdspnser

    CREATE TABLE [dbo].[tdspnser](
        [tdspnserid] int identity (1, 1),
        [tbom_hdrid] int NOT NULL,
        -- [bom_no] [numeric](5, 0) NOT NULL,
        --[bom_rev] [numeric](2, 0) NOT NULL,
        [coil_od] [char](20) default '' NOT NULL,
        [qtypolybag] [char](3) default '' NOT NULL,
        [no_twist] [char](3) default '' NOT NULL,
        [qty_bag] [char](6) default '' NOT NULL,
        [qty_corr] [char](6) default '' NOT NULL,
        [lbl_corr] [char](3) default '' NOT NULL,
        [start] [char](20) default '' NOT NULL,
        [ending] [char](20) default '' NOT NULL,
        [window] [char](20) default '' NOT NULL,
        [luer_req] [char](1) default '' NOT NULL,
        [luer_fit] [char](15) default '' NOT NULL,
        [luer_place] [char](10) default '' NOT NULL,
        [j_req] [char](1) default '' NOT NULL,
        [j_place] [char](10) default '' NOT NULL,
        CONSTRAINT [PK_tdspnser] PRIMARY KEY CLUSTERED
        (
            [tdspnserid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tdspnser
    select  tbom.tbom_hdrid,
           -- bom_no,
           -- bom_rev,
           coil_od,
           qtypolybag,
           no_twist,
           qty_bag,
           qty_corr,
           lbl_corr,
           start,
           ending,
           window,
           luer_req,
           luer_fit,
           luer_place,
           j_req,
           j_place
    from [rawUpsize_Contech].dbo.tdspnser
    inner join dbo.tbom_hdr tbom ON tdspnser.bom_no = tbom.bom_no AND tdspnser.bom_rev = tbom.bom_rev

    print 'table: dbo.tdspnser: end'

    -- ***************************************************
    -- table: tpouches

    -- new columns:
    -- tbom_hdrid: FK to tbom_hdr

    -- removed columns:
    -- bom_no
    -- bom_rev

    -- table PK:
    -- tpouchesid: added new identity PK column

    -- FK fields:
    -- tbom_hdrid

    print 'table: dbo.tpouches: end'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tpouches')
            drop table dbo.tpouches

    CREATE TABLE [dbo].[tpouches](
        [tpouchesid] int identity (1, 1),
        [tbom_hdrid] int not null,
        --[bom_no] [numeric](5, 0) NOT NULL,
        --[bom_rev] [numeric](2, 0) NOT NULL,
        [pouch] [char](10) default '' NOT NULL,
        [pouch2] [char](10) default '' NOT NULL,
        [lot_no] [char](10) default '' NOT NULL,
        [lot_no2] [char](10) default '' NOT NULL,
        [lbl1] [char](10) default '' NOT NULL,
        [lbl2] [char](10) default '' NOT NULL,
        [lbl_side] [char](10) default '' NOT NULL,
        [lbl_side2] [char](10) default '' NOT NULL,
        [insert_] [char](3) default '' NOT NULL,
        [insert2] [char](3) default '' NOT NULL,
        [insertlot] [char](12) default '' NOT NULL,
        [insertlot2] [char](12) default '' NOT NULL,
        [lbl_unit] [char](3) default '' NOT NULL,
        [lbl_unit2] [char](3) default '' NOT NULL,
        [qty_disp] [char](3) default '' NOT NULL,
        [qty_oship] [char](3) default '' NOT NULL,
        [lbl_oship] [char](3) default '' NOT NULL,
        [lbl_disp] [char](3) default '' NOT NULL,
        CONSTRAINT [PK_tpouches] PRIMARY KEY CLUSTERED
        (
            [tpouchesid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tpouches
    select tbom.tbom_hdrid,
           --bom_no,
           --bom_rev,
           pouch,
           pouch2,
           lot_no,
           lot_no2,
           lbl1,
           lbl2,
           lbl_side,
           lbl_side2,
           insert_,
           insert2,
           insertlot,
           insertlot2,
           lbl_unit,
           lbl_unit2,
           qty_disp,
           qty_oship,
           lbl_oship,
           lbl_disp
    from [rawUpsize_Contech].dbo.tpouches
    inner join dbo.tbom_hdr tbom ON tpouches.bom_no = tbom.bom_no AND tpouches.bom_rev = tbom.bom_rev

    print 'table: dbo.tpouches: end'


    -- ***************************************************
    -- table: tquotas

    -- new columns:
    -- tbom_hdrid: FK to tbom_hdr

    -- removed columns:
    -- bom_no
    -- bom_rev

    -- table PK:
    -- tquotasid: added new identity PK column

    -- FK fields:
    -- tbom_hdrid

    -- notes:
    -- (1) not importing orphaned records related to that one bom_no 10794 not in tbom_hdr

    print 'table: dbo.tquotas: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'tquotas')
            drop table dbo.tquotas


    CREATE TABLE [dbo].[tquotas](
        [tquotasid] int identity (1, 1),
        [tbom_hdrid] int not null,
        -- [bom_no] [numeric](5, 0) NOT NULL,
        -- [bom_rev] [numeric](2, 0) NOT NULL,
        [quota] [numeric](6, 0) NOT NULL,
        [type] [char](15) default '' NOT NULL,
        [mfgstageid] [int] NOT NULL,
        CONSTRAINT [PK_tquotas] PRIMARY KEY CLUSTERED
        (
            [tquotasid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.tquotas
    select tbom.tbom_hdrid,
           -- bom_no,
           -- bom_rev,
           tquotas.quota,
           type,
           mfgstageid
    from [rawUpsize_Contech].dbo.tquotas
    inner join dbo.tbom_hdr tbom ON tquotas.bom_no = tbom.bom_no AND tquotas.bom_rev = tbom.bom_rev

    print 'table: dbo.tquotas: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section018_GB.sql'


