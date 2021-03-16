-- ***************************************************
-- Section 016: accounts, asstcalib, assthist
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section016_GB.sql'
DECLARE @SQL varchar(4000)=''

begin tran

begin try

    -- ***************************************************
    -- table: accounts
    -- ***************************************************

    -- table PK:
    -- accountid: added new identity field

    print 'table: dbo.accounts: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'accounts')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('accounts')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('accounts')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[accounts]
		PRINT 'Table [dbo].[accounts] dropped'
    END

    CREATE TABLE [dbo].[accounts](
        [accountid] int identity (1, 1), -- new
        [acct_code] [char](1) NOT NULL,
        [desc] [char](35) default '' NOT NULL,
        CONSTRAINT [PK_accounts] PRIMARY KEY CLUSTERED
        (
            [accountid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    insert into dbo.accounts
    select * FROM [rawUpsize_Contech].dbo.accounts

    print 'table: dbo.accounts: end'

    -- ***************************************************
    -- table: asstcalib
    -- ***************************************************

    -- re-mapped columns:
    -- asset_no (char) -> assetsid (int)
    -- add_empe (char) -> add_employeeid (int)
    -- rev_emp (char)-> rev_employeeid (int)

    -- new columns:
    --

    -- table PK:
    -- asstcalibid: converted existing field to identity field

    -- FK fields:
    -- assetsid: assets.assetsid
    -- add_employeeid: employee.employeeid
    -- rev_employeeid: employee.employeeid

    -- notes:
    -- (1) changed criteria type from (text) to (varchar(2000)), query confirms longest values < 1000

    print 'table: dbo.asstcalib: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'asstcalib')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('asstcalib')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('asstcalib')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[asstcalib]
		PRINT 'Table [dbo].[asstcalib] dropped'
    END

    CREATE TABLE [dbo].[asstcalib](
        -- [asstcalibid] [int] NOT NULL,
        [asstcalibid] [int] identity (1, 1),
        -- [asset_no] [char](10) NOT NULL,
        [assetid] [int] NULL,
        [criteria] varchar(2000) default '' NOT NULL,
        -- [add_empe] [char](10) NOT NULL,
        [add_employeeid] [int] NULL,
        [add_dt] [datetime] NULL,
        [rev_rec] [int] default 0 NOT NULL,
        [rev_dt] [datetime] NULL,
        -- [rev_emp] [char](10) NOT NULL,
        [rev_employeeid] [int] NULL,
        CONSTRAINT [PK_asstcalib] PRIMARY KEY CLUSTERED
        (
            [asstcalibid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_asstcalib_asset FOREIGN KEY ([assetid]) REFERENCES [dbo].[assets] ([assetid]) ON DELETE NO ACTION
		,CONSTRAINT FK_asstcalib_add_employee FOREIGN KEY ([add_employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_asstcalib_rev_employee FOREIGN KEY ([rev_employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[asstcalib] NOCHECK CONSTRAINT [FK_asstcalib_asset];
	ALTER TABLE [dbo].[asstcalib] NOCHECK CONSTRAINT [FK_asstcalib_add_employee];
	ALTER TABLE [dbo].[asstcalib] NOCHECK CONSTRAINT [FK_asstcalib_rev_employee];

    set identity_insert dbo.asstcalib ON

    insert into dbo.asstcalib
    (asstcalibid, assetid, criteria, add_employeeid, add_dt, rev_rec, rev_dt, rev_employeeid)
    select asstcalibid,
           -- asset_no,
           isnull(a.assetid, NULL),
           criteria,
           -- add_empe,
           ISNULL(adde.employeeid, NULL),
           add_dt,
           asstcalib.rev_rec,
           asstcalib.rev_dt,
           -- rev_emp
            isnull(reve.employeeid, NULL)
    FROM [rawUpsize_Contech].dbo.asstcalib
    inner join dbo.assets a ON asstcalib.asset_no = a.asset_no
    left outer join dbo.employee adde ON asstcalib.add_empe = adde.empnumber
    left outer join dbo.employee reve ON asstcalib.rev_emp = reve.empnumber

    set identity_insert dbo.asstcalib OFF

    print 'table: dbo.asstcalib: end'

    -- ***************************************************
    -- table: assthist
    -- ***************************************************

    -- re-mapped columns:
    -- asset_no (char) -> assetsid (int)
    -- empnumber (char) -> employeeid (int)
    -- add_empe (char) -> add_employeeid (int)
    -- rev_emp (char) - rev_employeeid (int)

    -- table PK:
    -- assthistid: converted existing col to identity PK

    -- FK fields:
    -- asset

    -- notes:
    -- (1) changed criteria type from (text) to (varchar(2000)), query confirms longest values < 1000

    print 'table: dbo.assthist: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'assthist')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('assthist')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('assthist')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[assthist]
		PRINT 'Table [dbo].[assthist] dropped'
    END

    CREATE TABLE [dbo].[assthist](
        -- [assthistid] [int] NOT NULL,
        [assthistid] [int] identity (1, 1),
        -- [asset_no] [char](10) NOT NULL,
        [assetid] [int] NULL,
        [asstevntid] [int] NOT NULL,
        [location] [char](3) default '' NOT NULL,
        [comments] varchar(2000) default '' NOT NULL,
        [inspect_by] [char](50) default '' NOT NULL,
        [evnt_date] [datetime] NULL,
        [evnt_type] [char](2) default '' NOT NULL,
        -- [empnumber] [char](10) NOT NULL,
        [employeeid] [int] NULL,
        [add_dt] [datetime] NULL,
        -- [add_empe] [char](10) NOT NULL,
        [add_employeeid] [int] NULL,
        [evntaction] [bit] default 0 NOT NULL,
        [evnt_name] [char](30) default '' NOT NULL,
        [rev_rec] [int] default 0 NOT NULL,
        [rev_dt] [datetime] NULL,
        -- [rev_emp] [char](10) NOT NULL
        [rev_employeeid] [int] NULL,
        CONSTRAINT [PK_assthist] PRIMARY KEY CLUSTERED
        (
            [assthistid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_assthist_asset FOREIGN KEY ([assetid]) REFERENCES [dbo].[assets] ([assetid]) ON DELETE NO ACTION
		,CONSTRAINT FK_assthist_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_assthist_add_employee FOREIGN KEY ([add_employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
		,CONSTRAINT FK_assthist_rev_employee FOREIGN KEY ([rev_employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	ALTER TABLE [dbo].[assthist] NOCHECK CONSTRAINT [FK_assthist_asset];
	ALTER TABLE [dbo].[assthist] NOCHECK CONSTRAINT [FK_assthist_employee];
	ALTER TABLE [dbo].[assthist] NOCHECK CONSTRAINT [FK_assthist_add_employee];
	ALTER TABLE [dbo].[assthist] NOCHECK CONSTRAINT [FK_assthist_rev_employee];

    set identity_insert dbo.assthist ON

    insert into dbo.assthist
    (assthistid, assetid, asstevntid, location, comments, inspect_by, evnt_date, evnt_type, employeeid, add_dt, add_employeeid, evntaction, evnt_name, rev_rec, rev_dt, rev_employeeid)
    select assthistid,
           -- asset_no,
           a.assetid,
           asstevntid,
           assthist.location,
           comments,
           inspect_by,
           evnt_date,
           evnt_type,
           -- empnumber,
           isnull(emp.employeeid, NULL),
           add_dt,
           -- add_empe,
           isnull(adde.employeeid, NULL),
           evntaction,
           evnt_name,
           assthist.rev_rec,
           assthist.rev_dt,
           -- rev_emp
           isnull(reve.employeeid, NULL)
    from [rawUpsize_Contech].dbo.assthist
    inner join assets a ON assthist.asset_no = a.asset_no
    left outer join employee emp ON assthist.empnumber = emp.empnumber
    left outer join employee adde on assthist.add_empe = adde.empnumber
    left outer join employee reve on assthist.rev_emp = reve.empnumber;

    set identity_insert dbo.assthist OFF;

    print 'table: dbo.assthist: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section016_GB.sql'
