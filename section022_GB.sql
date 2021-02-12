-- ***************************************************
-- Section 022: autoinvoice, bdocpend
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section022_GB.sql'
DECLARE @SQL varchar(4000)=''

-- ***************************************************
-- table: autoinvoice
-- ***************************************************

-- re-mapped columns:
-- invoice_no  -> aropenid

-- table PK:
-- autoinvoiceid: added identity PK col

-- FK fields:
-- aropenid: aropen.aropenid
-- add_userid: users.userid

begin tran;

begin try

    print 'table: dbo.autoinvoice: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'autoinvoice')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('autoinvoice')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('autoinvoice')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[autoinvoice]
		PRINT 'Table [dbo].[autoinvoice] dropped'
    END

    CREATE TABLE [dbo].[autoinvoice](
        autoinvoiceid int identity (1, 1), -- new PK field
        -- [invoice_no] [int] NOT NULL,
        [aropenid] [int]  NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] [int] NULL,
        [add_dt] [datetime] NULL,
        [usersess] [char](10) default '' NOT NULL,
        [action] [char](10) default '' NOT NULL,
        CONSTRAINT [PK_autoinvoice] PRIMARY KEY CLUSTERED
        (
            [autoinvoiceid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_autoinvoice_aropen FOREIGN KEY ([aropenid]) REFERENCES [dbo].[aropen] ([aropenid]) ON DELETE NO ACTION
		,CONSTRAINT FK_autoinvoice_users FOREIGN KEY ([add_userid]) REFERENCES [dbo].[users] ([userid]) ON DELETE NO ACTION
    ) ON [PRIMARY];
	
	ALTER TABLE [dbo].[autoinvoice] NOCHECK CONSTRAINT [FK_autoinvoice_aropen];
	ALTER TABLE [dbo].[autoinvoice] NOCHECK CONSTRAINT [FK_autoinvoice_users];

    insert into dbo.autoinvoice
    (aropenid, add_userid, add_dt, usersess, action)
    select -- invoice_no,
           isnull(inv.aropenid, NULL),
           -- add_user,
           isnull(addu.userid, NULL),
           add_dt,
           usersess,
           action
    from [rawUpsize_Contech].dbo.autoinvoice
    left outer join dbo.aropen inv ON autoinvoice.invoice_no = inv.invoice_no
    left outer join dbo.users addu ON autoinvoice.add_user = addu.username
    order by autoinvoice.add_dt;

    commit

    print 'table: dbo.autoinvoice: end'

end try
begin catch

    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)

end catch;

-- ***************************************************
-- table: bdocpend
-- ***************************************************

-- re-mapped columns:
-- bom_no   ___ bom_hdrid
-- bom_rev  _/

-- new columns:
-- bom_hdrid: replaces the bom_no/bom_rev columns as ref to bom_hdr

-- table PK:
-- bdocpendid: new identity PK

-- FK fields:
-- bom_hdrid: bom_hdr.bom_hdrid

begin tran;

begin try

    print 'table: dbo.bdocpend: start'
	
    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bdocpend')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bdocpend')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bdocpend')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[bdocpend]
		PRINT 'Table [dbo].[bdocpend] dropped'
    END

    CREATE TABLE [dbo].[bdocpend](
        bdocpendid int identity (1, 1), -- new col
        -- [bom_no] [numeric](5, 0) NOT NULL,
        -- [bom_rev] [numeric](2, 0) NOT NULL,
        [bom_hdrid] [int] NULL, -- new col
        [doc_no] [char](5) default '' NOT NULL,
        [doc_rev] [char](2) default '' NOT NULL,
        [ndoc_no] [char](5) default '' NOT NULL,
        [ndoc_rev] [char](2) default '' NOT NULL,
        [add_date] [datetime] NULL,
        [status] [char](1) default '' NOT NULL,
        CONSTRAINT [PK_bdocpend] PRIMARY KEY CLUSTERED
        (
            [bdocpendid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_bdocpend_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] ([bom_hdrid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[bdocpend] NOCHECK CONSTRAINT [FK_bdocpend_bom_hdr];

    insert into dbo.bdocpend
    (bom_hdrid, doc_no, doc_rev, ndoc_no, ndoc_rev, add_date, status)
    select -- bom_no,
           -- bom_rev,
           bom.bom_hdrid,
           bdocpend.doc_no,
           bdocpend.doc_rev,
           ndoc_no,
           ndoc_rev,
           add_date,
           status
    from [rawUpsize_Contech].dbo.bdocpend
    inner join dbo.bom_hdr bom ON bdocpend.bom_no = bom.bom_no and bdocpend.bom_rev = bom.bom_rev

    commit

    print 'table: dbo.bdocpend: end'

end try
begin catch
    rollback

    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)

end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section022_GB.sql'
