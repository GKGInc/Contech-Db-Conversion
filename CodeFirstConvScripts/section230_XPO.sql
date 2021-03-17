-- =========================================================
-- Section 230: bom_alt, bom_cust, bom_hist, bom_pend, bom_pric
-- =========================================================


PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section023_HR.sql'

BEGIN TRAN;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section023_HR.sql'

BEGIN TRY

-- =========================================================
-- Table: bom_alt
-- =========================================================

-- Column changes:
--  - Added [bom_altid] to be primary key
--  - Added [bom_hdrid] to reference [bom_hdr] table using columns [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Changed the [bom_dtlid] field name to [bom_dtlref]. It will reference the existing value in the bom_dtlref field
-- Maps:
--	- [bom_alt].[bom_hdrid]				-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [bom_alt].[bom_dtlid]				-- FK = [bom_dtl].[bom_dtlid]
--	- [bom_alt].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]

    PRINT 'Table: dbo.bom_alt: start'

    INSERT INTO [dbo].[bom_alt]
        ([bom_dtlid],
        [componetid])
    select bom_dtl.bom_dtlid,
        --,[bom_alt].[comp]
        ISNULL(componet.[componetid], NULL)
        --,[bom_alt].[bom_no]
        --,[bom_alt].[bom_rev]
    FROM dbo.bom_hdr
        INNER JOIN dbo.bom_rev ON bom_hdr.bom_hdrid = bom_rev.bom_hdrid
        INNER JOIN dbo.bom_dtl ON bom_rev.bom_revid = bom_dtl.bom_revid
        INNER JOIN [rawUpsize_Contech].dbo.bom_alt
            ON bom_hdr.bom_no = bom_alt.bom_no
            AND bom_rev.bom_rev = bom_alt.bom_rev
            AND bom_dtl.bom_dtlref = bom_alt.bom_dtlid
        LEFT JOIN dbo.componet ON bom_alt.comp = componet.comp

    PRINT 'Table: dbo.bom_alt: end'

    -- =========================================================
-- Table: bom_cust
-- =========================================================

-- Column changes:
--  - Set [bom_custid] to be primary key
--  - Added [bom_hdrid] to reference [bom_hdr] table using columns [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
--  - Changed [cust_no] [char](5) to [customerid] [int] to reference [customer] table
--  - Changed [add_user] [char](10) to [userid] [int] to reference [users] table
-- Maps:
--	- [bom_cust].[bom_hdrid]				-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]
--	- [bom_cust].[cust_no] --> [customerid]	-- FK = [customer].[cust_no] -> [customer].[customerid]
--	- [bom_cust].[add_user]	--> userid		-- FK = [users].[username] --> [users].[userid]

    PRINT 'Table: dbo.bom_cust: start'

    SET IDENTITY_INSERT [dbo].[bom_cust] ON;

    INSERT INTO [dbo].[bom_cust] ([bom_custid],
                                  [bom_hdrid],
                                  [customerid],
                                  [sts],
                                  [kanban],
                                  [add_date],
                                  [add_userid],
                                  [bom_main],
                                  [sts_loc],
                                  [kanban_loc],
                                  [suppdata],
                                  [sd_loc])
    SELECT bom_cust.[bom_custid]
         ,ISNULL(bom_hdr.[bom_hdrid], 0) as [bom_hdrid]
         --,[bom_cust].[bom_no]
         --,[bom_cust].[bom_rev]
         --,[bom_cust].[cust_no]
         ,ISNULL(customer.[customerid], NULL) as [customerid]
         ,[bom_cust].[sts]
         ,[bom_cust].[kanban]
         ,[bom_cust].[add_date]
         --,[bom_cust].[add_user]
         ,ISNULL(users.[userid] , NULL) as [userid]
         ,[bom_cust].[bom_main]
         ,[bom_cust].[sts_loc]
         ,[bom_cust].[kanban_loc]
         ,[bom_cust].[suppdata]
         ,[bom_cust].[sd_loc]
    FROM [rawUpsize_Contech].dbo.bom_cust
             LEFT JOIN (SELECT bom_rev.bom_revid, bom_hdr.bom_no
                        FROM dbo.bom_hdr
                        INNER JOIN dbo.bom_rev ON bom_hdr.bom_hdrid = bom_rev.bom_hdrid) bom_hdr ON [bom_cust].[bom_no] = bom_hdr.[bom_no] AND [bom_cust].[bom_rev] = bom_hdr.[bom_rev]
             LEFT JOIN [dbo].[customer] customer ON [bom_cust].[cust_no] = customer.[cust_no]
             LEFT JOIN [dbo].[users] users ON [bom_cust].[add_user] = users.[username]

    SET IDENTITY_INSERT [dbo].[bom_cust] OFF;

    PRINT 'Table: dbo.bom_cust: end'

    -- =========================================================
-- Table: bom_hist
-- =========================================================

-- Column changes:
--  - Added bom_histid to be primary key
--  - Changed [emp_no] [char](10) to [employeeid] [int] to reference [employee] table
--  - Changed [notes] from [text] to [varchar](2000)
-- Maps:
--	- [bom_hist].[bom_no]					-- FK = [bom_hdr].[bom_no]
--	- [bom_hist].[emp_no] --> [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    PRINT 'Table: dbo.bom_hist: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_hist')
        BEGIN
            -- Check for Foreign Key Contraints and remove them
            WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bom_hist')) > 0)
                BEGIN
                    SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bom_hist')
                    EXEC (@SQL)
                    PRINT (@SQL)
                END

            DROP TABLE [dbo].[bom_hist]
            PRINT 'Table [dbo].[bom_hist] dropped'
        END

    CREATE TABLE [dbo].[bom_hist](
                                     [bom_histid] [int] IDENTITY(1,1) NOT NULL,
                                     [bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
                                     [type] [char](4) NOT NULL DEFAULT '',
                                     [notes] [varchar](2000) NOT NULL DEFAULT '',
                                     [number] [char](5) NOT NULL DEFAULT '',
                                     [rev] [char](2) NOT NULL DEFAULT '',
                                     [daterev] [datetime] NULL,
        --[emp_no] [char](10) NOT NULL DEFAULT '',		-- FK = [employee].[empnumber]
                                     [employeeid] [int] NULL,						-- FK = [employee].[empnumber] -> [employee].[employeeid]
                                     [rev_dt] [datetime] NULL,
                                     CONSTRAINT [PK_bom_hist] PRIMARY KEY CLUSTERED
                                         (
                                          [bom_histid] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ,CONSTRAINT FK_bom_hist_employee FOREIGN KEY ([employeeid]) REFERENCES [dbo].[employee] ([employeeid]) ON DELETE NO ACTION
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[bom_hist] NOCHECK CONSTRAINT [FK_bom_hist_employee];

    INSERT INTO [dbo].[bom_hist] ([bom_no],[type],[notes],[number],[rev],[daterev],[employeeid],[rev_dt])
    SELECT [rawUpsize_Contech].[dbo].[bom_hist].[bom_no]
         ,[rawUpsize_Contech].[dbo].[bom_hist].[type]
         ,[rawUpsize_Contech].[dbo].[bom_hist].[notes]
         ,[rawUpsize_Contech].[dbo].[bom_hist].[number]
         ,[rawUpsize_Contech].[dbo].[bom_hist].[rev]
         ,[rawUpsize_Contech].[dbo].[bom_hist].[daterev]
         --,[rawUpsize_Contech].[dbo].[bom_hist].[emp_no]
         ,ISNULL(employee.[employeeid], NULL) AS [employeeid]	-- FK = [employee].[empnumber] -> [employee].[employeeid]
         ,[rawUpsize_Contech].[dbo].[bom_hist].[rev_dt]
    FROM [rawUpsize_Contech].[dbo].[bom_hist]
             LEFT JOIN [dbo].[employee] employee ON [rawUpsize_Contech].[dbo].[bom_hist].[emp_no] = employee.[empnumber]	-- FK = [employee].[empnumber] -> [employee].[employeeid]

    --SELECT * FROM [dbo].[bom_hist]

    PRINT 'Table: dbo.bom_hist: end'

    -- =========================================================
-- Table: bom_pend
-- =========================================================

-- Column changes:
--  - Added bom_pendid to be primary key
--  - Changed [comp] [char](5) to [componetid] [int] to reference [componet] table
--  - Added [bom_hdrid] to reference [bom_hdr] table using columns [bom_no] + [bom_rev]
--  - Removed columns [bom_no] + [bom_rev]
-- Maps:
--	- [bom_pend].[comp] --> [componetid]	-- FK = [componet].[comp] --> [componet].[componetid]
--	- [bom_pend].[bom_hdrid]	-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] == [bom_hdr].[bom_hdrid]

    PRINT 'Table: dbo.bom_pend: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_pend')
        BEGIN
            -- Check for Foreign Key Contraints and remove them
            WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bom_pend')) > 0)
                BEGIN
                    SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bom_pend')
                    EXEC (@SQL)
                    PRINT (@SQL)
                END

            DROP TABLE [dbo].[bom_pend]
            PRINT 'Table [dbo].[bom_pend] dropped'
        END

    CREATE TABLE [dbo].[bom_pend](
                                     [bom_pendid] [int] IDENTITY(1,1) NOT NULL,
        --[comp] [char](5) NOT NULL DEFAULT '',			-- FK = [componet].[comp]
                                     [componetid] [int] NULL,						-- FK = [componet].[comp] --> [componet].[componetid]
                                     [bom_hdrid] [int] NULL,							-- FK = [bom_hdr].[bom_no] + [bom_hdr].[bom_rev] = [bom_hdr].[bom_hdrid]
        --[bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
        --[bom_rev] [numeric](2, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_rev]
                                     [status] [char](1) NOT NULL DEFAULT '',
                                     [date] [datetime] NULL,
                                     CONSTRAINT [PK_bom_pend] PRIMARY KEY CLUSTERED
                                         (
                                          [bom_pendid] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ,CONSTRAINT FK_bom_pend_bom_hdr FOREIGN KEY ([bom_hdrid]) REFERENCES [dbo].[bom_hdr] (bom_hdrid) ON DELETE NO ACTION --ON DELETE CASCADE NOT FOR REPLICATION
        ,CONSTRAINT FK_bom_pend_componet FOREIGN KEY ([componetid]) REFERENCES [dbo].[componet] ([componetid]) ON DELETE NO ACTION
    ) ON [PRIMARY]

    ALTER TABLE [dbo].[bom_pend] NOCHECK CONSTRAINT [FK_bom_pend_bom_hdr];
    ALTER TABLE [dbo].[bom_pend] NOCHECK CONSTRAINT [FK_bom_pend_componet];

    INSERT INTO [dbo].[bom_pend] ([componetid],[bom_hdrid],[status],[date])
    SELECT --[rawUpsize_Contech].[dbo].[bom_pend].[comp]
        ISNULL(componet.[componetid], NULL) AS [componetid]
         ,ISNULL(bom_hdr.[bom_hdrid], NULL) as [bom_hdrid]
         --,[rawUpsize_Contech].[dbo].[bom_pend].[bom_no]
         --,[rawUpsize_Contech].[dbo].[bom_pend].[bom_rev]
         ,[rawUpsize_Contech].[dbo].[bom_pend].[status]
         ,[rawUpsize_Contech].[dbo].[bom_pend].[date]
    FROM [rawUpsize_Contech].dbo.bom_pend
             LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[bom_pend].[comp] = componet.[comp]
             LEFT JOIN [dbo].[bom_hdr] bom_hdr ON [rawUpsize_Contech].[dbo].[bom_pend].[bom_no] = bom_hdr.[bom_no] AND [rawUpsize_Contech].[dbo].[bom_pend].[bom_rev] = bom_hdr.[bom_rev]

    --SELECT * FROM [dbo].[bom_pend]

    PRINT 'Table: dbo.bom_pend: end'

    -- =========================================================
-- Section 023: bom_pric
-- =========================================================

-- Column changes:
--  - Set [bom_pricid] to be primary key
--  - Changed [price_note] from text to varchar(2000)
-- Maps:
--	- [bom_pend].[bom_no]		-- FK = [bom_hdr].[bom_no]

    PRINT 'Table: dbo.bom_pric: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'bom_pric')
        BEGIN
            -- Check for Foreign Key Contraints and remove them
            WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('bom_pric')) > 0)
                BEGIN
                    SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('bom_pric')
                    EXEC (@SQL)
                    PRINT (@SQL)
                END

            DROP TABLE [dbo].[bom_pric]
            PRINT 'Table [dbo].[bom_pric] dropped'
        END

    CREATE TABLE [dbo].[bom_pric](
                                     [bom_pricid] [int] IDENTITY(1,1) NOT NULL,
                                     [bom_no] [numeric](5, 0) NOT NULL DEFAULT 0,	-- FK = [bom_hdr].[bom_no]
                                     [qty_from] [int] NOT NULL DEFAULT 0,
                                     [qty_to] [int] NOT NULL DEFAULT 0,
                                     [price] [numeric](8, 4) NOT NULL DEFAULT 0.0,
                                     [price_rev] [datetime] NULL,
                                     [price_note] varchar(2000) NOT NULL DEFAULT '',
                                     CONSTRAINT [PK_bom_pric] PRIMARY KEY CLUSTERED
                                         (
                                          [bom_pricid] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    SET IDENTITY_INSERT [dbo].[bom_pric] ON;

    INSERT INTO [dbo].[bom_pric] ([bom_pricid],[bom_no],[qty_from],[qty_to],[price],[price_rev],[price_note])
    SELECT [bom_pricid]
         ,[bom_no]
         ,[qty_from]
         ,[qty_to]
         ,[price]
         ,[price_rev]
         ,[price_note]
    FROM [rawUpsize_Contech].[dbo].[bom_pric]

    SET IDENTITY_INSERT [dbo].[bom_pric] OFF;

    --SELECT * FROM [dbo].[bom_pric]

    PRINT 'Table: dbo.bom_pric: end'

-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================