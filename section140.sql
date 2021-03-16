-- ***************************************************
-- Section 014: mfgstage
-- ***************************************************

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section014_GB.sql'
DECLARE @SQL varchar(4000)=''

begin tran

begin try

    -- ***************************************************
    -- table: mfgstage

    -- table PK:
    --  mfgstageid: converted existing col to identity PK

    print 'table: dbo.mfgstage: start'

    --DECLARE @SQL varchar(4000)=''
    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'mfgstage')
    BEGIN
		-- Check for Foreign Key Contraints and remove them
		WHILE ((SELECT COUNT([name]) FROM sys.foreign_keys WHERE referenced_object_id = object_id('mfgstage')) > 0)
		BEGIN				
			SELECT @SQL = 'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(k.parent_object_id) + '.[' + OBJECT_NAME(k.parent_object_id) + '] DROP CONSTRAINT ' + k.name FROM sys.foreign_keys k WHERE referenced_object_id = object_id('mfgstage')
			EXEC (@SQL)
			PRINT (@SQL)
		END
            
		DROP TABLE [dbo].[mfgstage]
		PRINT 'Table [dbo].[mfgstage] dropped'
    END

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
