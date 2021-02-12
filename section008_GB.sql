-- ***************************************************
-- Section 008: custpohd, custpodt
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section008_GB.sql'
DECLARE @SQL varchar(4000)=''

begin tran

begin try

    -- ***************************************************
    -- custpohd
    -- ***************************************************

    -- column name changes:
    --   cust_no -> customerid
    --   add_user -> add_userid
    --   mod_user -> mod_userid

    --  PK:
    --   custpohdid: converted to identity

    -- notes:

    print 'table: dbo.custpohd: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'custpohd')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('custpohd')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('custpohd')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[custpohd]
		PRINT 'Table [dbo].[custpohd] dropped'
    END

    CREATE TABLE [dbo].[custpohd](
        [custpohdid] [int] identity (1, 1),
        [cust_po] [char](15) NOT NULL,
        -- [cust_no] [char](5) NOT NULL,
        [customerid] [int] NULL,
        [einvoice] [bit] default (0) NOT NULL,
        [ship_to] [char](1) default '' NOT NULL,
        [add_dt] [datetime] NULL,
        -- [add_user] [char](15) default '' NOT NULL,
        [add_userid] [int] NULL,
        [mod_dt] [datetime] NULL,
        -- [mod_user] [char](15) default '' NOT NULL,
        [mod_userid] [int] NULL,
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
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_custpohd_customerid FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT FK_custpohd_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_custpohd_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[custpohd] NOCHECK CONSTRAINT [FK_custpohd_customerid];
	ALTER TABLE [dbo].[custpohd] NOCHECK CONSTRAINT [FK_custpohd_add_user];
	ALTER TABLE [dbo].[custpohd] NOCHECK CONSTRAINT [FK_custpohd_mod_user];

    set identity_insert dbo.custpohd ON

    insert into dbo.custpohd
    (custpohdid, cust_po, customerid, einvoice, ship_to, add_dt, add_userid, mod_dt, mod_userid, po_date, iskanban, kb_end, status, confirm_dt, confirm_user, confirm_no, confirm_contact, confirm_contactid)
    select custpohd.custpohdid,
           custpohd.cust_po,
           -- custpohd.cust_no,
           ISNULL(c.customerid, NULL),
           custpohd.einvoice,
           custpohd.ship_to,
           custpohd.add_dt,
           -- custpohd.add_user,
           ISNULL(addu.userid, NULL),
           custpohd.mod_dt,
           -- custpohd.mod_user,
           ISNULL(modu.userid, NULL),
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

    print 'table: dbo.custpohd: end'
	--SELECT * FROM [dbo].[custpohd]

    -- ***************************************************
    -- custpodt
    -- ***************************************************

    -- column name changes:
    -- add_user -> add_userid
    -- mod_user -> mod_userid

    -- table PK:
    -- custpodtid: converted to identity PK

    -- notes:
    -- (1)

    print 'table: dbo.custpodt: start'
	
	--DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'custpodt')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('custpodt')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('custpodt')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[custpodt]
		PRINT 'Table [dbo].[custpodt] dropped'
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
        [add_userid] [int] NULL,
        [mod_dt] [datetime] NULL,
        -- [mod_user] [char](15) NOT NULL,
        [mod_userid] [int] NULL,
        [part_desc] [char](200) default '' NOT NULL,
        [release_qty] [int] default 0 NOT NULL,
        [min_releases] [int] default 0 NOT NULL,
        [lead_days] [int] default 0 NOT NULL,
        CONSTRAINT [PK_custpodt] PRIMARY KEY CLUSTERED
        (
            [custpodtid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_custpodt_custpohd FOREIGN KEY ([custpohdid]) REFERENCES [dbo].[custpohd] ([custpohdid]) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_custpodt_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_custpodt_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[custpodt] NOCHECK CONSTRAINT [FK_custpodt_add_user];
	ALTER TABLE [dbo].[custpodt] NOCHECK CONSTRAINT [FK_custpodt_mod_user];

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
           ISNULL(addu.userid, NULL),
           mod_dt,
           -- mod_user,
           ISNULL(modu.userid, NULL),
           part_desc,
           release_qty,
           min_releases,
           lead_days
    from [rawUpsize_Contech].dbo.custpodt
    left outer join dbo.users addu on custpodt.add_user = addu.username
    left outer join dbo.users modu on custpodt.mod_user = modu.username
	WHERE custpohdid > 0 
		AND custpohdid IN (SELECT custpohdid FROM [dbo].[custpohd])
	
    set identity_insert dbo.custpodt OFF

    print 'table: dbo.custpodt: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)

end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section008_GB.sql'
