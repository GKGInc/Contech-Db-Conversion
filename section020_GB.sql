-- ***************************************************
-- Section 020: fplabel, fpbox, fplocatn, fppallet, fppltbox, fpshpbox, fptransfer, fptrnbox, fpweight
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section020_GB.sql'
DECLARE @SQL varchar(4000)=''

begin tran

begin try

    -- ***************************************************
    -- table: fplabel
    -- ***************************************************

    -- re-mapped columns:
    -- req_hdrid -> orderid
    -- add_user -> add_userid
    -- mod_user -> mod_userid

    -- table PK:
    -- fplabelid: converted existing col to identity PK

    -- FK fields:
    -- orderid: orders.orderid
    -- add_userid: users.userid
    -- mod_userid: users.userid

    -- notes:
    -- (1) Victor: req_hdrid needs to change to job_no -> orders.job_no. values in req_hdrid are orders.job_no values

    print 'table: dbo.fplabel: start'
	
    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fplabel')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fplabel')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fplabel')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fplabel]
		PRINT 'Table [dbo].[fplabel] dropped'
    END

    CREATE TABLE [dbo].[fplabel](
        -- [fplabelid] [int] NOT NULL,
        [fplabelid] [int] identity (1, 1),
        -- [req_hdrid] [int] NOT NULL, -- see Note#1
        [orderid] [int] NULL, -- see Note#1
        [labelno] [int] NOT NULL,
        [qty] [int] NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] [int] NULL,
        [add_dt] [datetime] NULL,
        -- [mod_user] [char](10) NOT NULL,
        [mod_userid] [int] NULL,
        [mod_dt] [datetime] NULL,
        [ship_via] [char](20) default '' NOT NULL,
        [mfg_locid] [int] NOT NULL,
        CONSTRAINT [PK_fplabel] PRIMARY KEY CLUSTERED
        (
            [fplabelid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_fplabel_orders FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_fplabel_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_fplabel_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[fplabel] NOCHECK CONSTRAINT [FK_fplabel_orders];
	ALTER TABLE [dbo].[fplabel] NOCHECK CONSTRAINT [FK_fplabel_add_user];
	ALTER TABLE [dbo].[fplabel] NOCHECK CONSTRAINT [FK_fplabel_mod_user];

    set identity_insert dbo.fplabel ON;

    WITH unq_fplable (fplabelid, req_hdrid, labelno, qty, add_user, add_dt, mod_user, mod_dt, ship_via, mfg_locid, rowrank)
    as (select fplabel.*, row_number() over(partition by fplabelid order by fplabelid) as rowrank
        from [rawUpsize_Contech].dbo.fplabel)
    INSERT INTO dbo.fplabel
    (fplabelid, orderid, labelno, qty, add_userid, add_dt, mod_userid, mod_dt, ship_via, mfg_locid)
    select fplabelid,
           -- req_hdrid,
           isnull(o.orderid, NULL),
           labelno,
           fplabel.qty,
           -- add_user,
           isnull(addu.userid, NULL),
           fplabel.add_dt,
           -- mod_user,
           isnull(modu.userid, NULL),
           mod_dt,
           ship_via,
           fplabel.mfg_locid
    from unq_fplable fplabel
    left outer join dbo.orders o on o.job_no = fplabel.req_hdrid
    left outer join dbo.users addu ON fplabel.add_user = addu.username
    left outer join dbo.users modu ON fplabel.mod_user = modu.username
    where fplabel.rowrank = 1;

    set identity_insert dbo.fplabel OFF;

    print 'table: dbo.fplabel: end'

    -- ***************************************************
    -- table: fpbox
    -- ***************************************************

    -- re-mapped columns:
    -- add_user (char) -> add_userid (int)

    -- table PK:
    -- fpboxid: converted existing col to identity PK

    -- FK fields:
    -- fplabelid: no change
    -- add_userid: users.userid

    print 'table: dbo.fpbox: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fpbox')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fpbox')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fpbox')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fpbox]
		PRINT 'Table [dbo].[fpbox] dropped'
    END

    CREATE TABLE [dbo].[fpbox](
        -- [fpboxid] [int] NOT NULL,
        [fpboxid] [int] identity (1,1),
        [fplabelid] [int] NOT NULL,
        [qty] [int] default 0 NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] [int] NULL,
        [add_dt] [datetime] NULL,
        CONSTRAINT [PK_fpbox] PRIMARY KEY CLUSTERED
        (
            [fpboxid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_fpbox_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[fpbox] NOCHECK CONSTRAINT [FK_fpbox_add_user];

    set identity_insert dbo.fpbox ON

    insert into dbo.fpbox
    (fpboxid, fplabelid, qty, add_userid, add_dt)
    select fpboxid,
           fplabelid,
           qty,
           -- add_user,
           isnull(addu.userid, NULL),
           add_dt
    FROM [rawUpsize_Contech].dbo.fpbox
    left outer join dbo.users addu ON fpbox.add_user = addu.username

    set identity_insert dbo.fpbox OFF

    print 'table: dbo.fpbox: end'

    -- ***************************************************
    -- table: fplocatn
    -- ***************************************************

    -- table PK:
    -- fplocatnid: convert existing col to identity

    print 'table: dbo.fplocatn: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fplocatn')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fplocatn')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fplocatn')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fplocatn]
		PRINT 'Table [dbo].[fplocatn] dropped'
    END

    CREATE TABLE [dbo].[fplocatn](
        -- [fplocatnid] [int] NOT NULL,
        [fplocatnid] [int] identity (1, 1),
        [staging] [bit] default 0 NOT NULL,
        [location] [char](5) default '' NOT NULL,
        [locfloor] [int] default 0 NOT NULL,
        [allowmix] [bit] default 0 NOT NULL,
        CONSTRAINT [PK_fplocatn] PRIMARY KEY CLUSTERED
        (
            [fplocatnid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert dbo.fplocatn ON
	
    insert into dbo.fplocatn
    (fplocatnid, staging, location, locfloor, allowmix)
    select fplocatnid, staging, location, locfloor, allowmix
    from [rawUpsize_Contech].dbo.fplocatn


    set identity_insert dbo.fplocatn OFF

    print 'table: dbo.fplocatn: end'

    -- ***************************************************
    -- table: fppallet
    -- ***************************************************

    -- re-mapped columns:
    -- add_user (char) -> add_userid (int)
    -- mod_user (char) -> mod_userid (int)

    -- table PK:
    -- fppalletid: converted existing to identity PK

    -- FK fields:
    -- fplocatnid: no change
    -- add_userid: users.userid
    -- mod_userid: users.userid

    print 'table: dbo.fppallet: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fppallet')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fppallet')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fppallet')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fppallet]
		PRINT 'Table [dbo].[fppallet] dropped'
    END

    CREATE TABLE [dbo].[fppallet](
        -- [fppalletid] [int] NOT NULL,
        [fppalletid] [int] identity (1, 1),
        [fplocatnid] [int] NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] [int] NULL,
        [add_dt] [datetime] NULL,
        -- [mod_user] [char](10) NOT NULL,
        [mod_userid] [int] NULL,
        [mod_dt] [datetime] NULL,
        [ship_dt] [datetime] NULL,
        [ship_user] [char](10) default '' NOT NULL,
        [allowmix] [bit] default 0 NOT NULL,
        CONSTRAINT [PK_fppallet] PRIMARY KEY CLUSTERED
        (
            [fppalletid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_fppallet_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_fppallet_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[fppallet] NOCHECK CONSTRAINT [FK_fppallet_add_user];
	ALTER TABLE [dbo].[fppallet] NOCHECK CONSTRAINT [FK_fppallet_mod_user];

    set identity_insert dbo.fppallet ON

    insert into dbo.fppallet
    (fppalletid, fplocatnid, add_userid, add_dt, mod_userid, mod_dt, ship_dt, ship_user, allowmix)
    select fppalletid,
           fplocatnid,
           -- add_user,
           isnull(addu.userid, NULL),
           add_dt,
           -- mod_user,
           isnull(modu.userid, NULL),
           mod_dt,
           ship_dt,
           ship_user,
           allowmix
    from [rawUpsize_Contech].dbo.fppallet
    left outer join dbo.users addu ON fppallet.add_user = addu.username
    left outer join dbo.users modu ON fppallet.mod_user = modu.username

    set identity_insert dbo.fppallet OFF

    print 'table: dbo.fppallet: end'

    -- ***************************************************
    -- table: fppltbox
    -- ***************************************************

    -- re-mapped columns:
    -- add_user (char) -> add_userid (int)

    -- table PK:
    -- fppltboxid: converted to identity PK

    -- FK fields:
    -- fppalletid: no change
    -- fplabelid: no change
    -- add_userid: users.userid

    print 'table: dbo.fppltbox: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fppltbox')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fppltbox')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fppltbox')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fppltbox]
		PRINT 'Table [dbo].[fppltbox] dropped'
    END

    CREATE TABLE [dbo].[fppltbox](
        -- [fppltboxid] [int] NOT NULL,
        [fppltboxid] [int] identity (1, 1),
        [fppalletid] [int] NOT NULL,
        [fplabelid] [int] NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] [int] NULL,
        [add_dt] [datetime] NULL,
        CONSTRAINT [PK_fppltbox] PRIMARY KEY CLUSTERED
        (
            [fppltboxid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_fppltbox_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[fppltbox] NOCHECK CONSTRAINT [FK_fppltbox_add_user];

    set identity_insert dbo.fppltbox ON

    insert into dbo.fppltbox
    (fppltboxid, fppalletid, fplabelid, add_userid, add_dt)
    select fppltboxid,
           fppalletid,
           fplabelid,
           -- add_user,
           isnull(addu.userid, NULL),
           add_dt
    FROM [rawUpsize_Contech].dbo.fppltbox
    left outer join users addu ON fppltbox.add_user = addu.username

    set identity_insert dbo.fppltbox OFF

    print 'table: dbo.fppltbox: end'

    -- ***************************************************
    -- table: fpshpbox
    -- ***************************************************

    -- re-mapped columns:
    -- add_user (char) -> add_userid

    -- table PK:
    -- fpshpboxid: converted to identity PK

    -- FK fields:
    -- shipmentid: ?
    -- fplabelid: no change
    -- add_userid: user

    -- notes:
    -- (1) shipmentid; all but 24 rows are 0 and teh rest are -1. ignoring this column
    -- (2) add_userid; there were a few user names not in the users table (add those missing users in section 002)

    print 'table: dbo.fpshpbox: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fpshpbox')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fpshpbox')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fpshpbox')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fpshpbox]
		PRINT 'Table [dbo].[fpshpbox] dropped'
    END

    CREATE TABLE [dbo].[fpshpbox](
        -- [fpshpboxid] [int] NOT NULL,
        [fpshpboxid] [int] identity (1, 1),
        [shipmentid] [int] NOT NULL,
        [fplabelid] [int] NOT NULL,
        [qty] [int] NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] [int] NULL,
        [add_dt] [datetime] NULL,
        CONSTRAINT [PK_fpshpbox] PRIMARY KEY CLUSTERED
        (
            [fpshpboxid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_fpshpbox_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[fpshpbox] NOCHECK CONSTRAINT [FK_fpshpbox_add_user];

    set identity_insert dbo.fpshpbox ON

    insert into dbo.fpshpbox
    (fpshpboxid, shipmentid, fplabelid, qty, add_userid, add_dt)
    select fpshpboxid,
           shipmentid,
           fplabelid,
           qty,
           -- add_user,
           isnull(addu.userid, NULL),
           add_dt
    from [rawUpsize_Contech].dbo.fpshpbox
    left outer join dbo.users addu ON fpshpbox.add_user = addu.username

    set identity_insert dbo.fpshpbox OFF

    print 'table: dbo.fpshpbox: end'

    -- ***************************************************
    -- table: fptransfer
    -- ***************************************************

    -- re-mapped columns:
    -- job_no -> orderid
    -- add_user -> add_userid
    -- mod_user -> mod_userid

    -- table PK:
    -- fptransferid: converted existing col to identity PK

    -- FK fields:
    -- orderid: orders.orderid

    -- notes:
    -- (1)

    print 'table: dbo.fptransfer: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fptransfer')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fptransfer')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fptransfer')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fptransfer]
		PRINT 'Table [dbo].[fptransfer] dropped'
    END

    CREATE TABLE [dbo].[fptransfer](
        -- [fptransferid] [int] NOT NULL,
        [fptransferid] [int] identity (1, 1),
        -- [job_no] [int] NOT NULL,
        [orderid] [int] NULL,
        [rel_qty] [int] default 0 NOT NULL,
        [jobstatus] [char](1) default '' NOT NULL,
        [postatus] [char](1) default '' NOT NULL,
        [price] [numeric](9, 4) default 0 NOT NULL,
        [add_dt] [datetime] NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] int default 0 NOT NULL,
        [mod_dt] [datetime] NULL,
        -- [mod_user] [char](10) NOT NULL,
        [mod_userid] int default 0 NOT NULL,
        [ship_dt] [datetime] NULL,
        [lading] [bit] default 0 NOT NULL,
        [nolading] [bit] default 0 NOT NULL,
        [freight] [numeric](6, 2) default 0 NOT NULL,
        [sched_ship] [datetime] NULL,
        [rev_relid] [int] default 0 NOT NULL,
        [invoice_dt] [datetime] NULL,
        CONSTRAINT [PK_fptransfer] PRIMARY KEY CLUSTERED
        (
            [fptransferid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_fptransfer_order FOREIGN KEY ([orderid]) REFERENCES [dbo].[orders] ([orderid]) ON DELETE NO ACTION
		,CONSTRAINT FK_fptransfer_add_user FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
		,CONSTRAINT FK_fptransfer_mod_user FOREIGN KEY ([mod_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[fptransfer] NOCHECK CONSTRAINT [FK_fptransfer_order];
	ALTER TABLE [dbo].[fptransfer] NOCHECK CONSTRAINT [FK_fptransfer_add_user];
	ALTER TABLE [dbo].[fptransfer] NOCHECK CONSTRAINT [FK_fptransfer_mod_user];

    set identity_insert dbo.fptransfer ON

    insert into dbo.fptransfer
    (fptransferid, orderid, rel_qty, jobstatus, postatus, price, add_dt, add_userid, mod_dt, mod_userid, ship_dt, lading, nolading, freight, sched_ship, rev_relid, invoice_dt)
    select fptransferid,
           -- job_no,
           o.orderid,
           rel_qty,
           jobstatus,
           postatus,
           fptransfer.price,
           fptransfer.add_dt,
           -- add_user,
           isnull(addu.userid, NULL),
           mod_dt,
           -- mod_user,
           isnull(modu.userid, NULL),
           ship_dt,
           lading,
           nolading,
           freight,
           sched_ship,
           rev_relid,
           invoice_dt
    from [rawUpsize_Contech].dbo.fptransfer
    inner join dbo.orders o on fptransfer.job_no = o.job_no
    left outer join dbo.users addu ON fptransfer.add_user = addu.username
    left outer join dbo.users modu ON fptransfer.mod_user = modu.username

    set identity_insert dbo.fptransfer OFF

    print 'table: dbo.fptransfer: start'

    -- ***************************************************
    -- table: fptrnbox
    -- ***************************************************

    -- table PK:
    -- fptrnboxid: converted to identity PK

    -- FK fields:
    -- fptrnboxid: no change
    -- fplocatnid: no change

    print 'table: dbo.fptrnbox: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fptrnbox')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fptrnbox')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fptrnbox')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fptrnbox]
		PRINT 'Table [dbo].[fptrnbox] dropped'
    END

    CREATE TABLE [dbo].[fptrnbox](
        -- [fptrnboxid] [int] NOT NULL,
        [fptrnboxid] [int] identity (1, 1),
        [fplabelid] [int] NOT NULL,
        [fplocatnid] [int] NOT NULL,
        [add_dt] [datetime] NULL,
        CONSTRAINT [PK_fptrnbox] PRIMARY KEY CLUSTERED
        (
            [fptrnboxid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert dbo.fptrnbox ON

    insert into dbo.fptrnbox
    (fptrnboxid, fplabelid, fplocatnid, add_dt)
    select fptrnboxid,
           fplabelid,
           fplocatnid,
           add_dt
    from [rawUpsize_Contech].dbo.fptrnbox

    set identity_insert dbo.fptrnbox OFF

    print 'table: dbo.fptrnbox: end'

    -- ***************************************************
    -- table: fpweight
    -- ***************************************************

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

    print 'table: dbo.fpweight: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'fpweight')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('fpweight')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('fpweight')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[fpweight]
		PRINT 'Table [dbo].[fpweight] dropped'
    END

    CREATE TABLE [dbo].[fpweight](
        -- [fpweightid] [int] NOT NULL,
        [fpweightid] [int] identity (1, 1),
        [part_no] [char](15) NOT NULL,
        [case_qty] [int] NOT NULL,
        [case_wt] [numeric](9, 2) NOT NULL,
        CONSTRAINT [PK_fpweight] PRIMARY KEY CLUSTERED
        (
            [fpweightid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert [dbo].[fpweight] ON

    insert into [dbo].[fpweight]
    (fpweightid, part_no, case_qty, case_wt)
    select fpweightid,
           part_no,
           case_qty,
           case_wt
    from [rawUpsize_Contech].dbo.fpweight

    set identity_insert [dbo].[fpweight] OFF

    print 'table: dbo.fpweight: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section020_GB.sql'
