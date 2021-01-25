-- =========================================================
-- Section 026: clsficat
-- =========================================================

-- Column changes:
--  - Set [clsficatid] to be primary key

USE [Contech_Test]

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'clsficat'))
    DROP TABLE [clsficat]

CREATE TABLE [dbo].[clsficat](
	[clsficatid] [int] IDENTITY(1,1) NOT NULL,
	[descript] [char](60) NOT NULL DEFAULT '',
	CONSTRAINT [PK_clsficat] PRIMARY KEY CLUSTERED 
	(
		[clsficatid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [clsficat] ON;

INSERT INTO [clsficat] ([clsficatid],[descript])
SELECT [clsficatid]
      ,[descript]
  FROM [rawUpsize_Contech].[dbo].[clsficat]
  
SET IDENTITY_INSERT [clsficat] OFF;

--SELECT * FROM [clsficat]

-- =========================================================