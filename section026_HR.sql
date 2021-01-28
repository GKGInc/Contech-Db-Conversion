-- =========================================================
--USE [Contech_Test]

PRINT(CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section026_HR.sql'

BEGIN TRAN;

BEGIN TRY

-- =========================================================
-- Section 026: clsficat
-- =========================================================

-- Column changes:
--  - Set [clsficatid] to be primary key

    PRINT 'Table: dbo.clsficat: start'

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'clsficat'))
		DROP TABLE [dbo].[clsficat]

	CREATE TABLE [dbo].[clsficat](
		[clsficatid] [int] IDENTITY(1,1) NOT NULL,
		[descript] [char](60) NOT NULL DEFAULT '',
		CONSTRAINT [PK_clsficat] PRIMARY KEY CLUSTERED 
		(
			[clsficatid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	SET IDENTITY_INSERT [dbo].[clsficat] ON;

	INSERT INTO [dbo].[clsficat] ([clsficatid],[descript])
	SELECT [clsficatid]
		  ,[descript]
	  FROM [rawUpsize_Contech].[dbo].[clsficat]
  
	SET IDENTITY_INSERT [dbo].[clsficat] OFF;

	--SELECT * FROM [dbo].[clsficat]
	
    PRINT 'Table: dbo.clsficat: end'
	
-- =========================================================

    COMMIT

END TRY
BEGIN CATCH

    ROLLBACK
    PRINT 'ERROR - line: ' + ERROR_LINE() + ', message: ' + ERROR_MESSAGE();

    RAISERROR ('Exiting script...', 20, -1)

END CATCH;

PRINT (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section026_HR.sql'

-- =========================================================