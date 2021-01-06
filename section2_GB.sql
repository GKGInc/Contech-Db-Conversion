-- ***************************************************
-- Section 2: users
-- ***************************************************

-- column name changes:
--      userid -> username
--      level -> rolelevel
-- maps:
--      userkey -> userid
--      userid -> username

use rawUpsize_Contech

begin transaction

drop table [Contech_Test].dbo.users

CREATE TABLE [Contech_Test].dbo.users
	(
	userid int NOT NULL IDENTITY (1, 1),
	username char(10) NOT NULL,
	password char(15) NOT NULL,
	rolelevel char(2) NOT NULL,
	last_name char(20) NOT NULL,
	first_name char(15) NOT NULL,
	mi char(1) NOT NULL,
	empnumber char(10) NOT NULL,
	netuser char(50) NOT NULL,
	mfg_locid int NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [Contech_Test].dbo.users SET (LOCK_ESCALATION = TABLE)
GO

SET IDENTITY_INSERT [Contech_Test].dbo.users ON
GO

INSERT INTO [Contech_Test].dbo.users (userid, username, password, rolelevel, last_name, first_name, mi, empnumber, netuser, mfg_locid)
		SELECT userkey, userid, password, [level], last_name, first_name, mi, empnumber, netuser, mfg_locid
FROM dbo.users WITH (HOLDLOCK TABLOCKX)

SET IDENTITY_INSERT [Contech_Test].dbo.users OFF
GO

ALTER TABLE [Contech_Test].dbo.users ADD CONSTRAINT
	PK_users PRIMARY KEY CLUSTERED
	(
	    userid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

commit

-- Section 2 END *************************************