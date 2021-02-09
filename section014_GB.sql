-- ***************************************************
-- Section 014: mfgstage
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section014_GB.sql'

begin tran

begin try

    -- ***************************************************
    -- table: mfgstage

    -- table PK:
    --  mfgstageid: converted existing col to identity PK

    print 'table: dbo.mfgstage: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'mfgstage')
            drop table dbo.mfgstage

    CREATE TABLE [dbo].[mfgstage](
        [mfgstageid] [int] identity (1, 1),
        [stage_desc] [char](15) NOT NULL,
        CONSTRAINT [PK_mfgstage] PRIMARY KEY CLUSTERED
        (
            [mfgstageid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]

    set identity_insert [dbo].[mfgstage] ON

    insert into dbo.mfgstage
    (mfgstageid, stage_desc)
    select * from [rawUpsize_Contech].dbo.mfgstage

    set identity_insert [dbo].[mfgstage] OFF

    print 'table: dbo.mfgstage: end'

    commit

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(ERROR_MESSAGE(), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section014_GB.sql'
