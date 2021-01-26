-- ***************************************************
-- Section 014: mfgstage
-- ***************************************************

begin tran

-- ***************************************************
-- table: mfgstage

-- table PK:
--  mfgstageid: converted existing col to identity PK


IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'mfgstage')
        drop table dbo.mfgstage
GO

CREATE TABLE [dbo].[mfgstage](
	[mfgstageid] [int] identity (1, 1),
	[stage_desc] [char](15) NOT NULL,
    CONSTRAINT [PK_mfgstage] PRIMARY KEY CLUSTERED
    (
        [mfgstageid] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

set identity_insert [dbo].[mfgstage] ON

insert into dbo.mfgstage
(mfgstageid, stage_desc)
select * from [rawUpsize_Contech].dbo.mfgstage
GO

set identity_insert [dbo].[mfgstage] OFF
GO

commit
GO

-- rollback