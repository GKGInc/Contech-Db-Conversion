
print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section004_GB.sql'
DECLARE @SQL varchar(4000)=''

-- =========================================================
-- Section 004: mfgcat -- Moved from Section 007
-- =========================================================

-- Column changes:
--  - Added [mfgcatid] as primary key

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.mfgcat: start'
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfgcat'))
	BEGIN
			-- Check for Foreign Key Contraints and remove them
		IF ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('mfgcat')) > 0)
		BEGIN		
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('mfgcat')
			EXEC (@SQL)
		END

		DROP TABLE [dbo].[mfgcat]
	END

	CREATE TABLE [dbo].[mfgcat](
		[mfgcatid] [int] IDENTITY(1,1) NOT NULL,
		[acct_code] [char](1) NOT NULL DEFAULT '',
		[mfg_cat] [char](2) NOT NULL DEFAULT '',
		[desc] [char](35) NOT NULL DEFAULT '',
		CONSTRAINT [PK_mfgcat] PRIMARY KEY CLUSTERED 
		(
			[mfgcatid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

	INSERT INTO [dbo].[mfgcat] SELECT * FROM [rawUpsize_Contech].[dbo].[mfgcat] 

	--SELECT * FROM [dbo].[mfgcat]

    PRINT 'Table: dbo.mfgcat: end'

-- =========================================================
-- Section 004: mfg_loc -- Moved from Section 007
-- =========================================================

-- Column changes:
--  - Changed [mfg_locid] to be primary key

    PRINT 'Table: dbo.mfg_loc: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfg_loc'))
	BEGIN		
		-- Check for Foreign Key Contraints and remove them
		IF ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('mfg_loc')) > 0)
		BEGIN
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('mfg_loc')
			EXEC (@SQL)
		END

		DROP TABLE [dbo].[mfg_loc]
		PRINT 'Table [dbo].[mfg_loc] dropped'
	END

	CREATE TABLE [dbo].[mfg_loc](
		[mfg_locid] [int] IDENTITY(1,1) NOT NULL,
		[loc_description] [char](50) NOT NULL DEFAULT '',
		[lot_suffix] [char](2) NOT NULL DEFAULT '',
		[address] [char](75) NOT NULL DEFAULT '',
		[address2] [char](75) NOT NULL DEFAULT '',
		[city] [char](75) NOT NULL DEFAULT '',
		[state] [char](2) NOT NULL DEFAULT '',
		[country] [char](75) NOT NULL DEFAULT '',
		[phone] [char](20) NOT NULL DEFAULT '',
		[fax] [char](20) NOT NULL DEFAULT '',
		[email] [char](100) NOT NULL DEFAULT '',
		[zip] [char](15) NOT NULL DEFAULT '',
		[cust_no] [char](5) NOT NULL DEFAULT '',
		[ven_id] [char](6) NOT NULL DEFAULT '',
		CONSTRAINT [PK_mfg_loc] PRIMARY KEY CLUSTERED 
		(
			[mfg_locid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	SET IDENTITY_INSERT [dbo].[mfg_loc] ON;

	INSERT INTO [dbo].[mfg_loc] ([mfg_locid],[loc_description],[lot_suffix],[address],[address2],[city],[state],[country],[phone],[fax],[email],[zip],[cust_no],[ven_id]) 
	SELECT [mfg_locid],[loc_description],[lot_suffix],[address],[address2],[city],[state],[country],[phone],[fax],[email],[zip],[cust_no],[ven_id]
	FROM [rawUpsize_Contech].[dbo].[mfg_loc] ORDER BY 1
  
	SET IDENTITY_INSERT [dbo].[mfg_loc] OFF;

	--SELECT * FROM [dbo].[mfg_loc]

    PRINT 'Table: dbo.mfg_loc: end'

-- ***************************************************
-- Section 004: bom_hdr, bom_dtl -- Moved from Section 006
-- ***************************************************

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

    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'bom_hdr')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		IF ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bom_hdr')) > 0)
		BEGIN
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bom_hdr')
			EXEC (@SQL)
		END

		DROP TABLE [dbo].[bom_hdr]
		PRINT 'Table [dbo].[bom_hdr] dropped'

    END

    CREATE TABLE [dbo].[bom_hdr](
        [bom_hdrid] [int] identity(1, 1),
        [bom_no] [numeric](5, 0) NOT NULL DEFAULT 0.0,
        [bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0.0,
        [part_no] [char](15) NOT NULL DEFAULT '',
        [part_rev] [char](10) NOT NULL DEFAULT '',
        [part_desc] [char](50) NOT NULL DEFAULT '',
        [price] [numeric](8, 4) NOT NULL DEFAULT 0.0,
        [price_ire] [numeric](8, 4) NOT NULL DEFAULT 0.0,
        [price_rev] [datetime] NULL,
        [unit] [char](4) NOT NULL DEFAULT '',
        [date_rev] [datetime] NULL,
        [sts] [char](1) NOT NULL DEFAULT '',
        -- [cust_no] [char](5) NOT NULL,
        [customerid] int NOT NULL DEFAULT 0,
        [date_ent] [datetime] NULL,
        [code_info] [numeric](1, 0) NOT NULL DEFAULT 0,
        [tube_lenth] [char](40) NOT NULL DEFAULT '',
        [tube_dim] [char](50) NOT NULL DEFAULT '',
        [assembly] [char](15) NOT NULL DEFAULT '',
        [scr_code] [char](1) NOT NULL DEFAULT '',
        [quota] [char](5) NOT NULL DEFAULT '',
        -- [notes] [text] NOT NULL,
        [notes] varchar(2000) default '' NOT NULL,
        [mfg_no] [numeric](5, 0) NOT NULL DEFAULT 0,
        [spec_no] [char](5) NOT NULL DEFAULT '',
        [spec_rev] [char](2) NOT NULL DEFAULT '',
        [dspec_rev] [datetime] NULL,
        [doc_no] [char](5) NOT NULL DEFAULT '',
        [doc_rev] [char](2) NOT NULL DEFAULT '',
        [ddoc_rev] [datetime] NULL,
        [computer] [char](1) NOT NULL DEFAULT '',
        [waste] [char](10) NOT NULL DEFAULT '',
        [qty_case] [numeric](6, 0) NOT NULL DEFAULT 0.0,
        -- [price_note] [text] NOT NULL,
        [price_note] varchar(2000) NOT NULL DEFAULT '',
        -- [mfg_cat] [char](2) NOT NULL,
        [mfgcatid] int NOT NULL DEFAULT 0,			
        [expfactor] [int] NOT NULL DEFAULT 0,
        [sts_loc] [char](20) NOT NULL DEFAULT '',
        [expunit] [char](1) NOT NULL DEFAULT '',
        CONSTRAINT [PK_bom_hdr] PRIMARY KEY CLUSTERED
        (
            [bom_hdrid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT [FK_bom_hdrcustomer] FOREIGN KEY ([customerid]) REFERENCES [dbo].[customer] ([customerid]) ON DELETE NO ACTION
		,CONSTRAINT [FK_bom_hdrmfgcat] FOREIGN KEY ([mfgcatid]) REFERENCES [dbo].[mfgcat] ([mfgcatid]) ON DELETE NO ACTION
    ) ON [PRIMARY];

	--ALTER TABLE [dbo].[bom_hdr]
	--	WITH NOCHECK 
	--	ADD CONSTRAINT [FK_bom_hdrcustomer] FOREIGN KEY([customerid])
	--	REFERENCES [dbo].[customer] (customerid) 
	--ON DELETE NO ACTION;

	ALTER TABLE [dbo].[bom_hdr] NOCHECK CONSTRAINT [FK_bom_hdrcustomer];

	--ALTER TABLE [dbo].[bom_hdr]
	--	WITH NOCHECK 
	--	ADD CONSTRAINT [FK_bom_hdrmfgcat] FOREIGN KEY ([mfgcatid]) 
	--	REFERENCES [dbo].[mfgcat] (mfgcatid) 
	--ON DELETE NO ACTION;

	ALTER TABLE [dbo].[bom_hdr] NOCHECK CONSTRAINT [FK_bom_hdrmfgcat];

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
           --cus.customerid,
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
    where bom_hdr.rowrank = 1  
	--and cus.customerid is not null
	
    print 'table: dbo.bom_hdr: end'

    -- ***************************************************
    -- table: bom_dtl
    -- ***************************************************

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
    -- (1) the original bom_dtl.bom_dtlid column had duplicates because it wasn't unique by design. renaming that field
    --     to bom_dtlref, and creating a new PK field
    -- https://gkginc.slack.com/archives/G01JTKDEAUQ/p1611778528034300

    print 'table: dbo.bom_dtl: start'

	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'bom_dtl')
	BEGIN
			-- Check for Foreign Key Contraints and remove them
		IF ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bom_dtl')) > 0)
		BEGIN
			--DECLARE @SQL varchar(4000)=''
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('[bom_dtl]')
			EXEC (@SQL)
		END

		PRINT 'Table [dbo].[bom_dtl] dropped'
		DROP TABLE [dbo].[bom_dtl]
	END

    CREATE TABLE [dbo].[bom_dtl](
        -- [bom_dtlid] [int] NOT NULL
        [bom_dtlid] int identity(1, 1),
        -- [bom_no] [numeric](5, 0) NOT NULL,
        -- [bom_rev] [numeric](2, 0) NOT NULL,
        [bom_hdrid] int NOT NULL DEFAULT 0,
        [bom_dtlref] int not null, -- values come from the original bom_dtl.bom_dtlid (not unique)
        [order] [numeric](2, 0) NOT NULL DEFAULT 0,
        -- [comp] [char](5) NOT NULL,
        [componetid] int NOT NULL DEFAULT 0,
        [quan] [numeric](8, 6) NOT NULL DEFAULT 0.0,
        [coc] [char](1) NOT NULL DEFAULT '',
        CONSTRAINT [PK_bom_dtl] PRIMARY KEY CLUSTERED
        (
            [bom_dtlid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		,CONSTRAINT FK_bom_dtlbom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] (bom_hdrid) ON DELETE CASCADE NOT FOR REPLICATION 
		,CONSTRAINT FK_bom_dtlcomponet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] (componetid) ON DELETE NO ACTION
    ) ON [PRIMARY]
	
	--ALTER TABLE [dbo].[bom_dtl]
	--	WITH NOCHECK 
	--	ADD CONSTRAINT [FK_bom_dtlcomponet] FOREIGN KEY(componetid)
	--	REFERENCES [dbo].[componet] (componetid) 
	--ON DELETE NO ACTION;
	
	ALTER TABLE [dbo].[bom_dtl] NOCHECK CONSTRAINT [FK_bom_dtlcomponet];

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

    print 'table: dbo.bom_dtl: end'

    -- ***************************************************

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section004_GB.sql'
