-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section019_HR.sql'

-- =========================================================
-- Section 019: rev_rel
-- =========================================================

-- Column changes:
--  - Set [rev_relid] to be primary key
--  - Renamed [job_no] to [orderid] to reference [orders] table
--  - Changed [add_user] [char](10) to [add_userid] [int] to reference [users] table
--  - Changed [mod_user] [char](10) to [mod_userid] [int] to reference [users] table
-- Maps:
--	- [rev_rel].[job_no] --> [orderid]			-- FK = [orders].[job_no] --> [orders].[orderid]
--	- [rev_rel].[add_user] --> [add_userid]		-- FK = [users].[username] --> [users].[userid]
--	- [rev_rel].[mod_user] --> [mod_userid]		-- FK = [users].[username] --> [users].[userid]

BEGIN TRAN;

BEGIN TRY

    PRINT 'Table: dbo.rev_rel: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'rev_rel'))
		DROP TABLE [dbo].[rev_rel]

	CREATE TABLE [dbo].[rev_rel](
		[rev_relid] [int] IDENTITY(1,1) NOT NULL,
		--[job_no] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] 
		[orderid] [int] NOT NULL DEFAULT 0,			-- FK = [orders].[job_no] --> [orders].[orderid]
		[rel_qty] [int] NOT NULL DEFAULT 0,		
		[jobstatus] [char](1) NOT NULL DEFAULT '',
		[postatus] [char](1) NOT NULL DEFAULT '',
		[price] [numeric](9, 4) NOT NULL DEFAULT 0.0,
		[add_dt] [datetime] NULL,
		--[add_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[add_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[mod_dt] [datetime] NULL,
		--[mod_user] [char](10) NOT NULL DEFAULT '',	-- FK = [users].[username]
		[mod_userid] [int] NOT NULL DEFAULT 0,			-- FK = [users].[username] --> [users].[userid]
		[ship_dt] [datetime] NULL,
		[lading] [bit] NOT NULL DEFAULT 0,
		[nolading] [bit] NOT NULL DEFAULT 0,
		[freight] [numeric](6, 2) NOT NULL DEFAULT 0.0,
		[sched_ship] [datetime] NULL,
		CONSTRAINT [PK_rev_rel] PRIMARY KEY CLUSTERED 
		(
			[rev_relid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] 

	SET IDENTITY_INSERT [dbo].[rev_rel] ON;

	INSERT INTO [dbo].[rev_rel] ([rev_relid],[orderid],[rel_qty],[jobstatus],[postatus],[price],[add_dt],[add_userid],[mod_dt],[mod_userid],[ship_dt],[lading],[nolading],[freight],[sched_ship])
	SELECT [rawUpsize_Contech].[dbo].[rev_rel].[rev_relid]
		  --,[rawUpsize_Contech].[dbo].[rev_rel].[job_no]
		  ,ISNULL(orders.[orderid], 0) AS [ordersid]		-- FK = [orders].[job_no] --> [orders].[orderid]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[rel_qty]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[jobstatus]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[postatus]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[price]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[add_dt]
		  --,[rawUpsize_Contech].[dbo].[rev_rel].[add_user] 
		  ,ISNULL(addUser.[userid] , 0) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[mod_dt]
		  --,[rawUpsize_Contech].[dbo].[rev_rel].[mod_user] 
		  ,ISNULL(modUser.[userid] , 0) as [userid]			
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[ship_dt]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[lading]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[nolading]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[freight]
		  ,[rawUpsize_Contech].[dbo].[rev_rel].[sched_ship]
	  FROM [rawUpsize_Contech].[dbo].[rev_rel]
	  LEFT JOIN [dbo].[orders] orders ON [rawUpsize_Contech].[dbo].[rev_rel].[job_no] = orders.[job_no]		-- FK = [orders].[job_no] --> [orders].[orderid]
	  LEFT JOIN [dbo].[users] addUser ON [rawUpsize_Contech].[dbo].[rev_rel].[add_user] = addUser.[username]	-- FK = [users].[username] --> [users].[userid]
	  LEFT JOIN [dbo].[users] modUser ON [rawUpsize_Contech].[dbo].[rev_rel].[mod_user] = modUser.[username]	-- FK = [users].[username] --> [users].[userid]
    
	SET IDENTITY_INSERT [dbo].[rev_rel] OFF;

	--SELECT * FROM [dbo].[rev_rel]
	
    COMMIT

    PRINT 'Table: dbo.rev_rel: end'

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================
-- Section 019: corractn --> Moved from section 029
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
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

-- =========================================================

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section019_HR.sql'

-- =========================================================