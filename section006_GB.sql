-- ***************************************************
-- Section 006: aropen -- Moved from Section 004
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section006_GB.sql'

begin tran

begin try

    -- ***************************************************
    -- aropen

    -- re-mapped columns
    -- job_no -> orderid
    -- cust_no -> customerid

    -- new columns:
    -- aropenid

    -- FK fields:
    -- orderid: orders.orderid (on orders.job_no = aropen.job_no

    -- table PK:
    -- aropenid: added new identity PK column, aropenid

    print 'table: dbo.aropen: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'aropen')
        BEGIN
            drop table dbo.aropen
        END

    CREATE TABLE [dbo].[aropen](
        [aropenid] int identity(1, 1),
        [invoice_no] [numeric](9, 0) NOT NULL,
        -- [job_no] [int] NOT NULL,
        orderid int default (0) not null,
        [total] [numeric](9, 2) NOT NULL,
        -- [cust_no] [char](5) default '' NOT NULL,
        customerid int default (0) not null,
        [balancedue] [numeric](9, 2) NOT NULL,
        [codepd] [char](1) default '' NOT NULL,
        [cust_po] [char](15) default '' NOT NULL,
        [price] [numeric](9, 4) NOT NULL,
        [case_price] [numeric](9, 4) NOT NULL,
        [part_desc] [char](50) default '' NOT NULL,
        [part_no] [char](15) default '' NOT NULL,
        [ct_lot] [char](8) default '' NOT NULL,
        [cus_lot] [char](12) default '' NOT NULL,
        [memo] varchar(2000) default '' NOT NULL,
        [date_invoc] [datetime] NULL,
        [ship_via] [char](20) default '' NOT NULL,
        [terms] [char](10) default '' NOT NULL,
        [unit] [char](4) default '' NOT NULL,
        [freight] [numeric](6, 2) NOT NULL,
        [subc_cost] [numeric](10, 5) NOT NULL,
        [ship_to] [char](1) default '' NOT NULL,
        [entrdate] [datetime] NULL,
        [sh_qty] [numeric](7, 0) NOT NULL,
        [case_qty] [numeric](7, 2) NOT NULL,
        [charge_1] [numeric](8, 2) NOT NULL,
        [charge_2] [numeric](8, 2) NOT NULL,
        [code] [char](1) default '' NOT NULL,
        [dr_cr] [char](2) default '' NOT NULL,
        [code_po] [char](1) default '' NOT NULL,
        [mfg_cat] [char](2) default '' NOT NULL,
        [insurance] [numeric](9, 2) NOT NULL,
        [vat] [numeric](9, 2) NOT NULL,
        [vat_stat] [char](1) default '' NOT NULL,
        [part_rev] [char](15) default '' NOT NULL,
        [coc_lot_no] [char](10) default '' NOT NULL,
        [coc_exp_date] [datetime] NULL,
        [coc_memo] [text] default '' NOT NULL,
        [packing] [numeric](10, 0) NOT NULL,
        [discount] [numeric](7, 3) NOT NULL,
        [lading] [bit] NOT NULL,
        [nolading] [bit] NOT NULL,
        [cr_invoice] [numeric](9, 0) NOT NULL,
        [complnt_no] [int] NOT NULL,
        [cust_po_ln] [char](5) default '' NOT NULL,
        [cust_po_um] [char](5) default '' NOT NULL,
        [custpodtid] [int] NOT NULL,
        [fprice] [numeric](8, 2) NOT NULL,
        [fexchrate] [numeric](9, 5) NOT NULL,
        [currency] [char](3) default '' NOT NULL,
        [bill_to] [char](1) default '' NOT NULL,
        CONSTRAINT [PK_aropen] PRIMARY KEY CLUSTERED
        (
            [aropenid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    insert into dbo.aropen
    select invoice_no,
           -- job_no,
           isnull(ord.orderid, 0),
           total,
           -- cust_no,
           isnull(cus.customerid, 0),
           balancedue,
           codepd,
           aropen.cust_po,
           aropen.price,
           case_price,
           aropen.part_desc,
           aropen.part_no,
           aropen.ct_lot,
           aropen.cus_lot,
           aropen.memo,
           date_invoc,
           ship_via,
           aropen.terms,
           aropen.unit,
           freight,
           subc_cost,
           aropen.ship_to,
           entrdate,
           sh_qty,
           case_qty,
           charge_1,
           charge_2,
           aropen.code,
           dr_cr,
           aropen.code_po,
           mfg_cat,
           insurance,
           aropen.vat,
           vat_stat,
           aropen.part_rev,
           coc_lot_no,
           coc_exp_date,
           aropen.coc_memo,
           packing,
           discount,
           lading,
           nolading,
           cr_invoice,
           complnt_no,
           aropen.cust_po_ln,
           aropen.cust_po_um,
           custpodtid,
           aropen.fprice,
           aropen.fexchrate,
           aropen.currency,
           aropen.bill_to
    from [rawUpsize_Contech].dbo.aropen
    left outer join dbo.orders ord on aropen.job_no = ord.job_no
    left outer join dbo.customer cus on aropen.cust_no = cus.cust_no

    print 'table: dbo.aropen: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section006_GB.sql'

-- ***************************************************