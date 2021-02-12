-- ***************************************************
-- Section 012: req_hdr, req_dtl
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section012_GB.sql'
DECLARE @SQL varchar(4000)=''

begin tran

begin try

    -- ***************************************************
    -- table: req_hdr
    -- ***************************************************

    -- re-mapped columns:
    -- job_no (int) -> ordersid (int)

    -- table PK:
    -- req_hdrid

    -- FK fields:
    -- ordersid: converted job_no (int) to orders.ordersid PK

    -- notes:
    -- (1)

    print 'table: dbo.req_hdr: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'req_hdr')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('req_hdr')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('req_hdr')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[req_hdr]
		PRINT 'Table [dbo].[req_hdr] dropped'
    END

    CREATE TABLE [dbo].[req_hdr](
        [req_hdrid] [int] identity (1, 1),
        -- [job_no] [int] NOT NULL,
        [orderid] [int] NULL,
        [qty] [int] default 0 NOT NULL,
        [start_dt] [datetime] NULL,
        [end_dt] [datetime] NULL,
        [req_status] [char](1) default '' NOT NULL,
        [add_dt] [datetime] NULL,
        [coffer] [char](15) default '' NOT NULL,
        [qty_prod] [int] default 0 NOT NULL,
        CONSTRAINT [PK_req_hdr] PRIMARY KEY CLUSTERED
        (
            [req_hdrid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_req_hdr_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION

    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[req_hdr] NOCHECK CONSTRAINT [FK_req_hdr_orders];

    set identity_insert dbo.req_hdr ON

    insert into dbo.req_hdr
    (req_hdrid, orderid, qty, start_dt, end_dt, req_status, add_dt, coffer, qty_prod)
    select req_hdrid,
           -- job_no,
           isnull(ord.orderid, NULL),
           qty,
           start_dt,
           end_dt,
           req_status,
           req_hdr.add_dt,
           coffer,
           qty_prod
    from [rawUpsize_Contech].dbo.req_hdr
    left outer join orders ord ON req_hdr.job_no = ord.job_no and req_hdr.job_no != 0

    set identity_insert dbo.req_hdr OFF

    print 'table: dbo.req_hdr: end'
	
    -- ***************************************************
    -- table: req_dtl
    -- ***************************************************

    -- re-mapped columns:
    -- comp (char) -> componetid (int)

    -- table PK:
    -- req_dtlid: converted to identity PK

    -- FK fields:
    -- componentid: ref to componet.componetid

    -- notes:
    -- (1) req_dtlid has a duplicate req_dtlid values:
    -- 266910
    -- 266907
    -- 266914

    print 'table: dbo.req_dtl: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'req_dtl')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('req_dtl')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('req_dtl')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[req_dtl]
		PRINT 'Table [dbo].[req_dtl] dropped'
    END

    CREATE TABLE [dbo].[req_dtl](
        [req_dtlid] [int] identity (1, 1),
        [req_hdrid] [int] NOT NULL,
        -- [comp] [char](5) default '' NOT NULL,
        [componetid] [int] NULL,
        [qty] [int] default 0 NOT NULL,
        [ratio] [numeric](8, 6) default 0 NOT NULL,
        [scrap] [int] default 0 NOT NULL,
        [restock] [int] default 0 NOT NULL,
        [mfg_usage] [int] default 0 NOT NULL,
        [filled] [bit] default 0 NOT NULL,
        [adjust] [int] default 0 NOT NULL,
        CONSTRAINT [PK_req_dtl] PRIMARY KEY CLUSTERED
        (
            [req_dtlid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_req_dtl_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[req_dtl] NOCHECK CONSTRAINT [FK_req_dtl_componet];

    set identity_insert dbo.req_dtl ON;

    WITH reqdtl_cte (req_dtlid, req_hdrid, comp, qty, ratio, scrap, restock, mfg_usage, filled, adjust, rowrank)
        as (
            select req_dtl.*, row_number() over(partition by req_dtlid order by req_dtlid) as rowrank
            from [rawUpsize_Contech].dbo.req_dtl
        )
    insert into dbo.req_dtl
    (req_dtlid, req_hdrid, componetid, qty, ratio, scrap, restock, mfg_usage, filled, adjust)
    select req_dtl.req_dtlid,
           req_dtl.req_hdrid,
           -- comp,
           isnull(cmp.componetid, NULL) as componetid,
           req_dtl.qty,
           req_dtl.ratio,
           req_dtl.scrap,
           req_dtl.restock,
           req_dtl.mfg_usage,
           req_dtl.filled,
           req_dtl.adjust
    from reqdtl_cte req_dtl
    left outer join dbo.componet cmp on req_dtl.comp = cmp.comp and rtrim(req_dtl.comp) != ''
    where req_dtl.rowrank = 1;

    set identity_insert dbo.req_dtl OFF;

    print 'table: dbo.req_dtl: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section012_GB.sql'
