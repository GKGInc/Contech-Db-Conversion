--USE [Contech_Test]
-- ***************************************************
-- Section 010: complnts, cmpcases, ralabel, rabox
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section010_GB.sql'

begin tran

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

    -- ***************************************************
    -- table: cmpcases

    -- column name changes:
    --  cmpcasesid -> cmpcaseid  (PK)
    --  matlin_key -> matlinid,  (FK to matlin)
    --  comp -> componetid  (FK to componet)
    --  userid (char) -> userid (int)  (FK to user)

    -- table PK:
    -- cmpcaseid: converted to identity pk

    -- notes:
    -- (1)

    print 'table: dbo.cmpcases: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'cmpcases')
            drop table dbo.cmpcases

    CREATE TABLE [dbo].[cmpcases](
        [cmpcaseid] [int] identity (1, 1),
        [bar_code] [char](9) default '' NOT NULL,
        [case_no] [int] default 0 NOT NULL,
        -- [matlin_key] [int] default 0 NOT NULL,
        [matlinid] int default 0 NOT NULL,
        -- [comp] [char](5) default '' NOT NULL,
        [componetid] int default 0 NOT NULL,
        [ct_lot] [char](4) default '' NOT NULL,
        [loc_row] [int] default 0 NOT NULL,
        [loc_rack] [int] default 0 NOT NULL,
        [loc_level] [char](2) default '' NOT NULL,
        [qty] [int] default 0 NOT NULL,
        [aloc_qty] [int] default 0 NOT NULL,
        [restock] [bit] default 0 NOT NULL,
        [last_mod] [datetime] NULL,
        -- [userid] [char](10) default '' NOT NULL,
        [userid] int default 0 NOT NULL,
        [insp_date] [datetime] NULL,
        [consign] [bit] default 0 NOT NULL,
        [mfg_locid] [int] default 0 NOT NULL,
        CONSTRAINT [PK_cmpcases] PRIMARY KEY CLUSTERED
        (
            [cmpcaseid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert dbo.cmpcases ON

    insert into dbo.cmpcases
    (cmpcaseid, bar_code, case_no, matlinid, componetid, ct_lot, loc_row, loc_rack, loc_level, qty, aloc_qty, restock, last_mod, userid, insp_date, consign, mfg_locid)
    select cmpcasesid,
           bar_code,
           case_no,
           matlin_key,
           isnull(cmp.componetid, 0),
           ct_lot,
           loc_row,
           loc_rack,
           loc_level,
           qty,
           aloc_qty,
           restock,
           last_mod,
           isnull(u.userid, 0),
           insp_date,
           consign,
           cmpcases.mfg_locid
    from [rawUpsize_Contech].dbo.cmpcases
    left outer join dbo.componet cmp ON cmpcases.comp = cmp.comp and (cmpcases.comp is not null AND cmpcases.comp != '')
    left outer join dbo.users u on cmpcases.userid = u.username and RTRIM(cmpcases.userid) != ''

    set identity_insert dbo.cmpcases OFF

    print 'table: dbo.cmpcases: end'

    -- ***************************************************
    -- table: ralabel

    -- column name changes:
    --  add_user -> add_userid
    --  mod_user -> mod_userid

    -- table PK:
    -- ralabelid: converted to identity pk

    -- FK fields:
    --  prodctraid -> direct ref to prodctra.prodctraid
    --  add_userid -> converted username ref to userid
    --  mod_userid -> converted username ref to userid
    --  fplocatnid -> direct ref to fplocatn.fplocatnid

    -- notes:
    -- (1)

    print 'table: dbo.ralabel: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'ralabel')
            drop table dbo.ralabel

    CREATE TABLE [dbo].[ralabel](
        [ralabelid] [int] identity (1, 1),
        [prodctraid] [int] default 0 NOT NULL,
        [labelno] [int] default 0 NOT NULL,
        [qty] [int] default 0 NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        add_userid [int] default 0 NOT NULL,
        [add_dt] [datetime] NULL,
        -- [mod_user] [char](10) NOT NULL,
        mod_userid [int] default 0 NOT NULL,
        [mod_dt] [datetime] NULL,
        [fplocatnid] [int] default 0 NOT NULL,
        [orig_qty] [int] default 0 NOT NULL,
        CONSTRAINT [PK_ralabel] PRIMARY KEY CLUSTERED
        (
            [ralabelid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert [dbo].[ralabel] ON

    insert into dbo.ralabel
    (ralabelid, prodctraid, labelno, qty, add_userid, add_dt, mod_userid, mod_dt, fplocatnid, orig_qty)
    select ralabelid,
           prodctraid,
           labelno,
           qty,
           -- add_user,
           isnull(addu.userid, 0),
           add_dt,
           -- mod_user,
           isnull(modu.userid, 0),
           mod_dt,
           fplocatnid,
           orig_qty
    from [rawUpsize_Contech].dbo.ralabel
    left outer join dbo.users addu on ralabel.add_user = addu.username and rtrim(ralabel.add_user) != ''
    left outer join dbo.users modu on ralabel.add_user = modu.username and rtrim(ralabel.mod_user) != ''

    set identity_insert [dbo].[ralabel] OFF

    print 'table: dbo.ralabel: end'

    -- ***************************************************
    -- table: rabox

    -- column name changes:
    -- add_user -> add_userid
    -- mod_user -> mod_userid

    -- table PK:
    -- raboxid: converted to identity PK

    -- FK fields:
    --  ralabelid -> direct ref to ralabel.ralabelid
    --  add_userid -> converted username ref to userid
    --  mod_userid -> converted username ref to userid
    --  fplocatnid -> direct ref to fplocatn.fplocatnid

    -- notes:
    -- (1)

    print 'table: dbo.rabox: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'rabox')
            drop table dbo.rabox

    CREATE TABLE [dbo].[rabox](
        [raboxid] int identity (1, 1),
        [ralabelid] [int] default 0 NOT NULL,
        [labelno] [int] default 0 NOT NULL,
        [qty] [int] default 0 NOT NULL,
        -- [add_user] [char](10) NOT NULL,
        [add_userid] int default 0 NOT NULL,
        [add_dt] [datetime] NULL,
        -- [mod_user] [char](10) NOT NULL,
        [mod_userid] [int] default 0 NOT NULL,
        [mod_dt] [datetime] NULL,
        [fplocatnid] [int] default 0 NOT NULL,
        [orig_qty] [int] default 0 NOT NULL,
        CONSTRAINT [PK_rabox] PRIMARY KEY CLUSTERED
        (
            [raboxid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert [dbo].[rabox] ON

    insert into dbo.rabox
    (raboxid, ralabelid, labelno, qty, add_userid, add_dt, mod_userid, mod_dt, fplocatnid, orig_qty)
    select raboxid,
           ralabelid,
           labelno,
           qty,
           -- add_user,
           isnull(addu.userid, 0),
           add_dt,
           -- mod_user,
          isnull(addu.userid, 0),
           mod_dt,
           fplocatnid,
           orig_qty
    FROM [rawUpsize_Contech].dbo.rabox
    left outer join dbo.users addu on rabox.add_user = addu.username and rtrim(rabox.add_user) != ''
    left outer join dbo.users modu on rabox.add_user = modu.username and rtrim(rabox.mod_user) != ''

    set identity_insert [dbo].[rabox] OFF

    print 'table: dbo.rabox: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch
GO

-- =========================================================
-- Section 010: corractn --> Moved from section 029
-- =========================================================

-- Column changes:
--  - Set [corractnid] to be primary key
--  - Changed [remarks] from text to varchar(2000)
--  - Changed [ven_cause] from text to varchar(2000)
--  - Changed [ven_prevnt] from text to varchar(2000)
--  - Changed [evd_effect] from text to varchar(2000)
--  - Changed [car_no] [char](8) to [corractnid] [int] to reference [corractn] table
--  - Changed [qrn_no] [char](8) to [qrnid] [int] to reference [qrn] table
--  - Renamed [matlin_key] to [matlinid]
--  - Changed [comp] [char](5) to [componetid] [int] to reference [users] table
--  - Renamed [complnt_no] to [complntid] [to reflect new standards
-- Maps:
--	- [corractn].[car_no]		-- FK = [cartrack].[car_no]
--	- [corractn].[qrn_no]		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
--	- [corractn].[matlinid]		-- FK = [matlin].[matlin_key] --> [matlin].[matlinid]
--	- [corractn].[comp]			-- FK = [componet].[comp] --> [componet].[componetid]
--	- [corractn].[complnt_no]	-- FK = [complnts].[complnt_no] --> [complnts].[complntid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.corractn: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'corractn'))
		DROP TABLE [dbo].[corractn]

	CREATE TABLE [dbo].[corractn](
		[corractnid] [int] identity(1,1) NOT NULL,
		[car_no] [char](8) NOT NULL DEFAULT '',	-- FK = [corractn].[car_no] 
		[car_date] [datetime] NULL,
		--[qrn_no] [char](8) NOT NULL,			-- FK = [qrn].[qrn_no] 
		[qrnid] [int] NOT NULL DEFAULT 0,		-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		--[matlin_key] [int] NOT NULL DEFAULT 0,-- FK = [matlin].[matlin_key]
		[matlinid] [int] NOT NULL DEFAULT 0,	-- FK = [matlin].[matlin_key] --> [matlin].[matlinid]
		[source] [char](2) NOT NULL DEFAULT '',
		--[comp] [char](5) NOT NULL,			-- FK = [componet].[comp] 
		[componetid] [int] NOT NULL,			-- FK = [componet].[comp] --> [componet].[componetid]
		[comp_desc] [char](75) NOT NULL DEFAULT '',
		[qty_rej] [int] NOT NULL DEFAULT '',
		[remarks] varchar(2000) NOT NULL DEFAULT '',
		[ven_cause] varchar(2000) NOT NULL DEFAULT '',
		[ven_prevnt] varchar(2000) NOT NULL DEFAULT '',
		[ven_sign] [char](50) NOT NULL DEFAULT '',
		[ven_title] [char](50) NOT NULL DEFAULT '',
		[ven_date] [datetime] NULL,
		[init_note] [datetime] NULL,
		[follow_up] [datetime] NULL,
		[final_note] [datetime] NULL,
		[revgrpmeet] [datetime] NULL,
		[issued_by] [char](50) NOT NULL DEFAULT '',
		[evd_effect] varchar(2000) NOT NULL DEFAULT '',
		[rspns_appr] [int] NOT NULL DEFAULT 0,
		[c_method] [bit] NOT NULL DEFAULT 0,
		[c_material] [bit] NOT NULL DEFAULT 0,
		[c_manpower] [bit] NOT NULL DEFAULT 0,
		[c_machinry] [bit] NOT NULL DEFAULT 0,
		[close_date] [datetime] NULL,
		[c_vendor] [bit] NOT NULL DEFAULT 0,
		[urgent] [bit] NOT NULL DEFAULT 0,
		[r_replcmnt] [bit] NOT NULL DEFAULT 0,
		[r_credit] [bit] NOT NULL DEFAULT 0,
		[corr_type] [char](1) NOT NULL DEFAULT '',
		[approve1] [char](50) NOT NULL DEFAULT '',
		[approve1dt] [datetime] NULL,
		[approve1ti] [char](50) NOT NULL DEFAULT '',
		[approve2] [char](50) NOT NULL DEFAULT '',
		[approve2ti] [char](50) NOT NULL DEFAULT '',
		[approve2dt] [datetime] NULL,
		[completeby] [char](50) NOT NULL DEFAULT '',
		[completeti] [char](50) NOT NULL DEFAULT '',
		[completedt] [datetime] NULL,
		[close_by] [char](50) NOT NULL DEFAULT '',
		[issued_to] [char](4) NOT NULL DEFAULT '',
		[expclosedt] [datetime] NULL,
		[ref_doc] [char](25) NOT NULL DEFAULT '',
		--[complnt_no] [int] NOT NULL DEFAULT 0,	-- FK = [complnts].[complnt_no]
		[complntid] [int] NOT NULL DEFAULT 0,		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]  
		[c_inconclu] [bit] NOT NULL DEFAULT 0,
		CONSTRAINT [PK_corractn] PRIMARY KEY CLUSTERED 
		(
			[corractnid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[corractn] ON;

	INSERT INTO [dbo].[corractn] ([corractnid],[car_no],[car_date],[qrnid],[matlinid],[source],[componetid],[comp_desc],[qty_rej],[remarks],[ven_cause],[ven_prevnt],[ven_sign],[ven_title],[ven_date],[init_note],[follow_up],[final_note],[revgrpmeet],[issued_by],[evd_effect],[rspns_appr],[c_method],[c_material],[c_manpower],[c_machinry],[close_date],[c_vendor],[urgent],[r_replcmnt],[r_credit],[corr_type],[approve1],[approve1dt],[approve1ti],[approve2],[approve2ti],[approve2dt],[completeby],[completeti],[completedt],[close_by],[issued_to],[expclosedt],[ref_doc],[complntid],[c_inconclu])
	SELECT [rawUpsize_Contech].[dbo].[corractn].[corractnid]
		  ,[rawUpsize_Contech].[dbo].[corractn].[car_no]
		  ,[rawUpsize_Contech].[dbo].[corractn].[car_date]
		  --,[rawUpsize_Contech].[dbo].[corractn].[qrn_no]		-- FK = [qrn].[qrn_no] 
		  ,ISNULL(qrn.[qrnid], 0) AS [qrnid]					-- FK = [qrn].[qrn_no] --> [qrn].[qrnid]
		  ,[rawUpsize_Contech].[dbo].[corractn].[matlin_key]	-- FK = [matlin].[matlin_key] --> [matlin].[matlinid]		
		  ,[rawUpsize_Contech].[dbo].[corractn].[source]
		  --,[rawUpsize_Contech].[dbo].[corractn].[comp]		-- FK = [componet].[comp] 
		  ,ISNULL(componet.[componetid], 0) AS [componetid]		-- FK = [componet].[comp] --> [componet].[componetid]
		  ,[rawUpsize_Contech].[dbo].[corractn].[comp_desc]
		  ,[rawUpsize_Contech].[dbo].[corractn].[qty_rej]
		  ,[rawUpsize_Contech].[dbo].[corractn].[remarks]
		  ,[rawUpsize_Contech].[dbo].[corractn].[ven_cause]
		  ,[rawUpsize_Contech].[dbo].[corractn].[ven_prevnt]
		  ,[rawUpsize_Contech].[dbo].[corractn].[ven_sign]
		  ,[rawUpsize_Contech].[dbo].[corractn].[ven_title]
		  ,[rawUpsize_Contech].[dbo].[corractn].[ven_date]
		  ,[rawUpsize_Contech].[dbo].[corractn].[init_note]
		  ,[rawUpsize_Contech].[dbo].[corractn].[follow_up]
		  ,[rawUpsize_Contech].[dbo].[corractn].[final_note]
		  ,[rawUpsize_Contech].[dbo].[corractn].[revgrpmeet]
		  ,[rawUpsize_Contech].[dbo].[corractn].[issued_by]
		  ,[rawUpsize_Contech].[dbo].[corractn].[evd_effect]
		  ,[rawUpsize_Contech].[dbo].[corractn].[rspns_appr]
		  ,[rawUpsize_Contech].[dbo].[corractn].[c_method]
		  ,[rawUpsize_Contech].[dbo].[corractn].[c_material]
		  ,[rawUpsize_Contech].[dbo].[corractn].[c_manpower]
		  ,[rawUpsize_Contech].[dbo].[corractn].[c_machinry]
		  ,[rawUpsize_Contech].[dbo].[corractn].[close_date]
		  ,[rawUpsize_Contech].[dbo].[corractn].[c_vendor]
		  ,[rawUpsize_Contech].[dbo].[corractn].[urgent]
		  ,[rawUpsize_Contech].[dbo].[corractn].[r_replcmnt]
		  ,[rawUpsize_Contech].[dbo].[corractn].[r_credit]
		  ,[rawUpsize_Contech].[dbo].[corractn].[corr_type]
		  ,[rawUpsize_Contech].[dbo].[corractn].[approve1]
		  ,[rawUpsize_Contech].[dbo].[corractn].[approve1dt]
		  ,[rawUpsize_Contech].[dbo].[corractn].[approve1ti]
		  ,[rawUpsize_Contech].[dbo].[corractn].[approve2]
		  ,[rawUpsize_Contech].[dbo].[corractn].[approve2ti]
		  ,[rawUpsize_Contech].[dbo].[corractn].[approve2dt]
		  ,[rawUpsize_Contech].[dbo].[corractn].[completeby]
		  ,[rawUpsize_Contech].[dbo].[corractn].[completeti]
		  ,[rawUpsize_Contech].[dbo].[corractn].[completedt]
		  ,[rawUpsize_Contech].[dbo].[corractn].[close_by]
		  ,[rawUpsize_Contech].[dbo].[corractn].[issued_to]
		  ,[rawUpsize_Contech].[dbo].[corractn].[expclosedt]
		  ,[rawUpsize_Contech].[dbo].[corractn].[ref_doc]
		  --,[rawUpsize_Contech].[dbo].[corractn].[complnt_no]	-- FK = [complnts].[complnt_no]  
		  ,ISNULL(complnts.[complntid], 0) AS [complntid]		-- FK = [complnts].[complnt_no] --> [complnts].[complntid]  
		  ,[rawUpsize_Contech].[dbo].[corractn].[c_inconclu]
	  FROM [rawUpsize_Contech].[dbo].[corractn]
	  LEFT JOIN [dbo].[qrn] qrn ON [rawUpsize_Contech].[dbo].[corractn].[qrn_no] = qrn.[qrn_no] 
	  LEFT JOIN [dbo].[componet] componet ON [rawUpsize_Contech].[dbo].[corractn].[comp] = componet.[comp] 
	  LEFT JOIN [dbo].[complnts]  ON [rawUpsize_Contech].[dbo].[corractn].[complnt_no] = complnts.[complnt_no] 

	SET IDENTITY_INSERT [dbo].[corractn] OFF;

	--SELECT * FROM [dbo].[corractn]

    COMMIT

    PRINT 'Table: dbo.corractn: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section010_GB.sql'

