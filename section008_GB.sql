-- ***************************************************
-- Section 008: custpohd, custpodt
-- ***************************************************


print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section008_GB.sql'


begin tran

begin try

    -- ***************************************************
    -- custpohd

    -- column name changes:
    --   cust_no -> customerid
    --   add_user -> add_userid
    --   mod_user -> mod_userid

    --  PK:
    --   custpohdid: converted to identity

    -- notes:

    print 'table: dbo.custpohd: start'


    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'custpohd')
        BEGIN
            drop table dbo.custpohd
        END

    CREATE TABLE [dbo].[custpohd](
        [custpohdid] [int] identity (1, 1),
        [cust_po] [char](15) NOT NULL,
        -- [cust_no] [char](5) NOT NULL,
        customerid int NOT NULL,
        [einvoice] [bit] default (0) NOT NULL,
        [ship_to] [char](1) default '' NOT NULL,
        [add_dt] [datetime] NULL,
        -- [add_user] [char](15) default '' NOT NULL,
        add_userid int default 0 NOT NULL,
        [mod_dt] [datetime] NULL,
        -- [mod_user] [char](15) default '' NOT NULL,
        mod_userid int default 0 NOT NULL,
        [po_date] [datetime] NULL,
        [iskanban] [bit] default (0) NOT NULL,
        [kb_end] [datetime] NULL,
        [status] [char](1) default '' NOT NULL,
        [confirm_dt] [datetime] NULL,
        [confirm_user] [char](10) default '' NOT NULL,
        [confirm_no] [char](20) default '' NOT NULL,
        [confirm_contact] [char](50) default '' NOT NULL,
        [confirm_contactid] [int] default 0 NOT NULL,
        CONSTRAINT [PK_custpohd] PRIMARY KEY CLUSTERED
        (
            [custpohdid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert dbo.custpohd ON

    insert into dbo.custpohd
    (custpohdid, cust_po, customerid, einvoice, ship_to, add_dt, add_userid, mod_dt, mod_userid, po_date, iskanban, kb_end, status, confirm_dt, confirm_user, confirm_no, confirm_contact, confirm_contactid)
    select custpohd.custpohdid,
           custpohd.cust_po,
           -- custpohd.cust_no,
           ISNULL(c.customerid, 0),
           custpohd.einvoice,
           custpohd.ship_to,
           custpohd.add_dt,
           -- custpohd.add_user,
           ISNULL(addu.userid, 0),
           custpohd.mod_dt,
           -- custpohd.mod_user,
           ISNULL(modu.userid, 0),
           custpohd.po_date,
           custpohd.iskanban,
           custpohd.kb_end,
           custpohd.status,
           custpohd.confirm_dt,
           custpohd.confirm_user,
           custpohd.confirm_no,
           custpohd.confirm_contact,
           custpohd.confirm_contactid
    from [rawUpsize_Contech].dbo.custpohd
        left outer join customer c on custpohd.cust_no = c.cust_no and rtrim(custpohd.cust_no) != ''
        left outer join users addu on custpohd.add_user = addu.username and rtrim(custpohd.add_user) != ''
        left outer join users modu on custpohd.mod_user = modu.username and rtrim(custpohd.mod_user) != ''

    set identity_insert dbo.custpohd OFF

    commit

    print 'table: dbo.custpohd: end'

end try
begin catch

    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    raiserror ('Exiting script...', 20, -1)

end catch


begin tran;

begin try

    print 'table: dbo.custpodt: start'

    -- ***************************************************
    -- custpodt

    -- column name changes:
    -- add_user -> add_userid
    -- mod_user -> mod_userid

    -- table PK:
    -- custpodtid: converted to identity PK

    -- notes:
    -- (1)

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'custpodt')
        BEGIN
            drop table dbo.custpodt
        END


    CREATE TABLE [dbo].[custpodt](
        [custpodtid] int identity (1, 1),
        [custpohdid] [int] NOT NULL,
        [line_no] [char](5) default '' NOT NULL,
        [uom] [char](5) default '' NOT NULL,
        [part_no] [char](15) NOT NULL,
        [order_qty] [int] NOT NULL,
        [need_by] [datetime] NULL,
        [price] [numeric](9, 2) default 0 NOT NULL,
        [add_dt] [datetime] NULL,
        -- [add_user] [char](15) NOT NULL,
        add_userid int default (0) NOT NULL,
        [mod_dt] [datetime] NULL,
        -- [mod_user] [char](15) NOT NULL,
        mod_userid int default (0) NOT NULL,
        [part_desc] [char](200) default '' NOT NULL,
        [release_qty] [int] default 0 NOT NULL,
        [min_releases] [int] default 0 NOT NULL,
        [lead_days] [int] default 0 NOT NULL,
        CONSTRAINT [PK_custpodt] PRIMARY KEY CLUSTERED
        (
            [custpodtid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert dbo.custpodt ON

    insert into dbo.custpodt
    (custpodtid, custpohdid, line_no, uom, part_no, order_qty, need_by, price, add_dt, add_userid, mod_dt, mod_userid, part_desc, release_qty, min_releases, lead_days)
    select custpodtid,
           custpohdid,
           line_no,
           uom,
           part_no,
           order_qty,
           need_by,
           price,
           add_dt,
           -- add_user,
           ISNULL(addu.userid, 0),
           mod_dt,
           -- mod_user,
           ISNULL(modu.userid, 0),
           part_desc,
           release_qty,
           min_releases,
           lead_days
    from [rawUpsize_Contech].dbo.custpodt
    left outer join dbo.users addu on custpodt.add_user = addu.username
    left outer join dbo.users modu on custpodt.mod_user = modu.username

    set identity_insert dbo.custpodt OFF

    print 'table: dbo.custpodt: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    raiserror ('Exiting script...', 20, -1)

end catch


begin tran;
begin try
    -- ***************************************************
    -- table: complnts

    -- column name changes:
    --   invoice_no -> aropenid, converting ref# to FK id

    -- table PK:
    -- complntid: new identity col added

    -- FK fields:
    -- corractnid : corractn.corractnid (on complnts.car_no = corractn.car_no)

    -- notes:
    -- (1) as of 1/27/2021, complnts.car_no had not values

    print 'table: dbo.complnts: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'complnts')
            drop table dbo.complnts

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
        -- [car_no] [char](8) default '' NOT NULL,
        corractnid int default 0 NOT NULL,
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
           -- car_no,
           ISNULL(car.corractnid, 0), -- see note(1)
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
    left outer join dbo.corractn car on complnts.car_no = car.car_no and complnts.car_no != ''

    print 'table: dbo.complnts: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    raiserror ('Exiting script...', 20, -1)

end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section008_GB.sql'
