-- ***************************************************
-- Section 040: mfgcat, mfg_loc, bom_hdr, bom_dtl
-- ***************************************************


print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section004_GB.sql'

BEGIN TRAN;

BEGIN TRY

    -- =========================================================
    -- Table: mfgcat
    -- =========================================================

    -- Column changes:
    --  - Added [mfgcatid] as primary key

    PRINT 'Table: dbo.mfgcat: start'

	declare @sql_mfgcat varchar(4000);
	
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfgcat'))
	BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('mfgcat')) > 0)
		BEGIN		
			--DECLARE @SQL varchar(4000)=''
			SELECT @sql_mfgcat = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('mfgcat')
			PRINT (@sql_mfgcat)	
			EXEC (@sql_mfgcat)
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

    PRINT 'Table: dbo.mfgcat: end'

    -- =========================================================
    -- Table: mfg_loc
    -- =========================================================

    -- Column changes:
    --  - Changed [mfg_locid] to be primary key

    PRINT 'Table: dbo.mfg_loc: start'

	declare @sql_mfg_loc varchar(4000);

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfg_loc'))
	BEGIN		
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('mfg_loc')) > 0)
		BEGIN
			--DECLARE @SQL varchar(4000)=''
			SELECT @sql_mfg_loc = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('mfg_loc')
			PRINT (@sql_mfg_loc)	
			EXEC (@sql_mfg_loc)
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

    PRINT 'Table: dbo.mfg_loc: end'


    -- ***************************************************
    -- Table bom_hdr
    -- ***************************************************

    PRINT 'Table: dbo.bom_hdr: start'

    INSERT into dbo.bom_hdr (bom_no, ScreenCode)
    SELECT bom_no,
           max(scr_code)
    FROM [rawUpsize_Contech].dbo.bom_hdr
    GROUP BY bom_no;

    PRINT 'Table: dbo.bom_hdr: end'


    -- ***************************************************
    -- Table: bom_hdr_rev
    -- ***************************************************

    -- bom_hdr_rev PK:
    --      bom_hdr_revid INT (new)

    -- field data type changes:
    -- notes (text) -> notes (varchar(2000))
    -- price_note (text) -> price_note (varchar(2000))

    -- FK fields:
    -- mfgcatid: mfgcat.mfgcatid (on bom_hdr.mfg_cat = mfgcat.mfg_cat

    -- notes:
    -- (1)
    --      bom_hdr had duplicate records (2):
    --      bom_no	bom_rev
    --      53622	4
    --      50398	15
    --      The script only imports the first instance of these bom_dtl records.
    -- (2) removed the customer field, only using bom_cust table to relate to customers

    print 'table: dbo.bom_rev: start';

    with cte_bom_hdr
        as (select *, row_number() over(partition by bom_no, bom_rev order by bom_no, bom_rev) rowrank
            from [rawUpsize_Contech].dbo.bom_hdr),
	cte_dspnsers 
		as (select *, row_number() over(partition by bom_no, bom_rev order by bom_no, bom_rev) rowrank 
			from [rawUpsize_Contech].dbo.dspnsers)
    insert into [dbo].[bom_rev] (
        [bom_hdrid]
		,[bom_rev]
		,[part_no]
		,[part_rev]
		,[part_desc]
		,[price]
		,[price_ire]
		,[price_rev]
		,[unit]
		,[date_rev]
		,[sts]
		,[date_ent]
		,[code_info]
		,[tube_lenth]
		,[TubeDiameter]
		,[quota]
		,[notes]
		,[mfg_no]
		,[spec_no]
		,[spec_rev]
		,[dspec_rev]
		,[doc_no]
		,[doc_rev]
		,[ddoc_rev]
		,[computer]
		,[waste]
		,[BillByCaseAmt]
		,[price_note]
		,[mfgcatid]
		,[expfactor]
		,[sts_loc]
		,[expunit]
		
		,[coil_od]
		,[PolyBagQty]
		,[TwistTieQty]
		,[UnitsPerBag]
		,[qty_corr]
		,[lbl_corr]
		,[start]
		,[ending]
		,[window]
		,[LuerRequired]
		,[LuerFit]
		,[LuerPlacement]
		,[j_req]
		,[j_place]

		,[PouchType1]
		,[PouchType2]
		,[LotNumberPrintOption1]
		,[LotNumberPrintOption2]
		,[LotNoLabelPrintOption1]
		,[LotNoLabelPrintOption2]
		,[PlaceLabelOption1]
		,[PlaceLabelOption2]
		,[InsertRequired1]
		,[InsertRequired2]
		,[InsertLotNoRequired1]
		,[InsertLotNoRequired2]
		,[NumberOfLabels1]
		,[NumberOfLabels2]
		,[UnitsPerUnitBox]
		,[BoxesPerOvershipper]
		,[NumLabelsPerOvershipper]
		,[NumLabelsPerUnitBox]		
		)
    select
        newhdr.bom_hdrid,
        bom_hdr.[bom_rev],
		bom_hdr.[part_no],
		bom_hdr.[part_rev],
		bom_hdr.[part_desc],
		bom_hdr.[price],
		bom_hdr.[price_ire],
		bom_hdr.[price_rev],
		bom_hdr.[unit],
		bom_hdr.[date_rev],
		bom_hdr.[sts],
		-- cust_no,
		bom_hdr.[date_ent],
		bom_hdr.[code_info],
		bom_hdr.[tube_lenth],
		bom_hdr.tube_dim,
		-- bom_hdr.assembly,
		bom_hdr.[quota],
		bom_hdr.[notes],
		bom_hdr.[mfg_no],
		bom_hdr.[spec_no],
		bom_hdr.[spec_rev],
		bom_hdr.[dspec_rev],
		bom_hdr.[doc_no],
		bom_hdr.[doc_rev],
		bom_hdr.[ddoc_rev],
		bom_hdr.[computer],
		bom_hdr.[waste],
		bom_hdr.qty_case,
		bom_hdr.[price_note],
		-- mfg_cat,
		mc.mfgcatid,
		bom_hdr.[expfactor],
		bom_hdr.[sts_loc],
		bom_hdr.[expunit],

		ISNULL(d.[coil_od], '')
		,ISNULL(d.[qtypolybag], '')
		,ISNULL(d.[no_twist], '')
		,ISNULL(d.[qty_bag], '')
		,ISNULL(d.[qty_corr], '')
		,ISNULL(d.[lbl_corr], '')
		,ISNULL(d.[start], '')
		,ISNULL(d.[ending], '')
		,ISNULL(d.[window], '')
		,ISNULL(d.[luer_req], '')
		,ISNULL(d.[luer_fit], '')
		,ISNULL(d.[luer_place], '')
		,ISNULL(d.[j_req], '')
		,ISNULL(d.[j_place], '')
		
		,ISNULL(p.[pouch], '')
		,ISNULL(p.[pouch2], '')
		,ISNULL(p.[lot_no], '')
		,ISNULL(p.[lot_no2], '')
		,ISNULL(p.[lbl1], '')
		,ISNULL(p.[lbl2], '')
		,ISNULL(p.[lbl_side], '')
		,ISNULL(p.[lbl_side2], '')
		,ISNULL(p.[insert_], '')
		,ISNULL(p.[insert2], '')
		,ISNULL(p.[insertlot], '')
		,ISNULL(p.[insertlot2], '')
		,ISNULL(p.[lbl_unit], '')
		,ISNULL(p.[lbl_unit2], '')
		,ISNULL(p.[qty_disp], '')
		,ISNULL(p.[qty_oship], '')
		,ISNULL(p.[lbl_oship], '')
		,ISNULL(p.[lbl_disp], '')

    FROM cte_bom_hdr bom_hdr
        inner join dbo.bom_hdr newhdr ON bom_hdr.bom_no = newhdr.bom_no
		left outer join dbo.mfgcat mc ON bom_hdr.mfg_cat = mc.mfg_cat and RTRIM(bom_hdr.mfg_cat) != ''
		left outer join [rawUpsize_Contech].dbo.pouches p ON bom_hdr.bom_no = p.bom_no AND bom_hdr.bom_rev = p.bom_rev
		left outer join cte_dspnsers d on bom_hdr.bom_no = d.bom_no and bom_hdr.bom_rev = d.bom_rev
    where bom_hdr.rowrank = 1 and (d.rowrank is null OR d.rowrank = 1)

    print 'table: dbo.bom_rev: end'


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
	
    INSERT INTO [dbo].[bom_dtl]
        ([bom_revid], [bom_dtlref], [SequenceNumber], [componetid], [quan], [coc])
    SELECT bom_rev.bom_revid
        ,bom_dtl.[bom_dtlid]
        ,bom_dtl.[order]
        ,isnull(componet.[componetid], NULL)
        ,bom_dtl.[quan]
        ,bom_dtl.[coc]
    FROM [dbo].[bom_hdr] bom_hdr
        INNER JOIN dbo.bom_rev bom_rev
            ON bom_hdr.bom_hdrid = bom_rev.bom_hdrid
        INNER JOIN [rawUpsize_Contech].[dbo].[bom_dtl] bom_dtl
            ON bom_dtl.[bom_no] = bom_hdr.[bom_no] AND bom_dtl.[bom_rev] = bom_rev.[bom_rev]
        LEFT OUTER JOIN [dbo].[componet] componet
            ON bom_dtl.[comp] = componet.[comp]

    print 'table: dbo.bom_dtl: end'

    -- ***************************************************

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section040.sql'
