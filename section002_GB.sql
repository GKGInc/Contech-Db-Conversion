-- ***************************************************
-- Section 2: users
-- ***************************************************

-- PK:
--      userid int
-- column name changes:
--      userid -> username
--      level -> rolelevel
-- new column mapping:
--      userkey -> userid
--      userid -> username
-- other:
--      added defaults to some fields

use Contech_Test

begin transaction

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'users')
    BEGIN
        drop table dbo.users
    END

CREATE TABLE dbo.users
	(
	userid int NOT NULL IDENTITY (1, 1),
	username char(10) NOT NULL,
	password char(15) NOT NULL,
	rolelevel char(2) default '' NOT NULL,
	last_name char(20) default '' NOT NULL,
	first_name char(15) default '' NOT NULL,
	mi char(1) default '' NOT NULL,
	empnumber char(10) default '' NOT NULL,
	netuser char(50) default '' NOT NULL,
	mfg_locid int default 0 NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.users SET (LOCK_ESCALATION = TABLE)
GO

SET IDENTITY_INSERT dbo.users ON
GO

INSERT INTO dbo.users (userid, username, password, rolelevel, last_name, first_name, mi, empnumber, netuser, mfg_locid)
		SELECT userkey, userid, password, [level], last_name, first_name, mi, empnumber, netuser, mfg_locid
FROM [rawUpsize_Contech].dbo.users WITH (HOLDLOCK TABLOCKX)

SET IDENTITY_INSERT dbo.users OFF
GO

ALTER TABLE dbo.users ADD CONSTRAINT
	PK_users PRIMARY KEY CLUSTERED
	(
	    userid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

commit

-- Section 2 END *************************************