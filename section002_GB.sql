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


-- Section 017: prdlinhd | Note: User JEN, BOBBY, PRODUCTION not found in [users] table
-- Section 025: cartrack | Note: Multiple users are not found in [users] table: ALISON, PRODUCTION, BOBBY
-- Section 025: changelog | Note: User ANGEL, ALEJANDRO, RAMAAR, RODRIGUEZ, N/A not fould in [users] table
-- Section 033: incasdsp | Note: Users CTDSMOBILE & CTDSMOB not found in [users] table
-- Section 039: poconfrm | Note: Users LEGACY, MARY, ABBY, GKGINC not found in [users] table
-- Section 041: quotas	 | Note: User GKGINC not found in [users] table
-- Section 041: req_case | Note: Users RYAN, PRODUCTION,DOUG, {multiple numbers} not found in [users] table
-- Section 045: userrmnd | Note: Users MARY,BIGSEXY,BOBBY,KEN,DOUG,ANGEL,ALEJANDRO,ERIC,RAMAAR not found in [users] table
-- Section 040: userrmnd | Note: Users BOBBY not found in [users] table

-- users missing from tables:
-- used in
-- fplabel, fpshpbox
insert into dbo.users (username, password) values ('PRODUCTION', '');

-- used in:
-- fppallet, fpbox
insert into dbo.users (username, password) values ('NA', '');

-- used in:
-- fpbox
insert into dbo.users (username, password) values ('ALISON', '');

-- used in:
-- fpbox, fpshpbox, bompriclog
insert into dbo.users (username, password) values ('GKGINC', '');

-- used in fpshpbox:
insert into dbo.users (username, password) values ('CTDSMOBILE', '');
insert into dbo.users (username, password) values ('GKGAUTO', '');
insert into dbo.users (username, password) values ('LEGACY', '');
insert into dbo.users (username, password) values ('CTDSMOB', '');

-- used in:
-- autoinvoice
insert into dbo.users (username, password) values ('ABBY', '');

-- used in:
-- bompriclog
insert into dbo.users (username, password) values ('KELLY', '');
insert into dbo.users (username, password) values ('MARY', '');


-- other name from other tables
insert into dbo.users (username, password) values ('JEN', '');
insert into dbo.users (username, password) values ('BOBBY', '');
insert into dbo.users (username, password) values ('ANGEL', '');
insert into dbo.users (username, password) values ('ALEJANDRO', '');
insert into dbo.users (username, password) values ('RAMAAR', '');
insert into dbo.users (username, password) values ('RODRIGUEZ', '');
insert into dbo.users (username, password) values ('N/A', '');
insert into dbo.users (username, password) values ('RYAN', '');
insert into dbo.users (username, password) values ('DOUG', '');
insert into dbo.users (username, password) values ('BIGSEXY', '');
insert into dbo.users (username, password) values ('KEN', '');
insert into dbo.users (username, password) values ('ERIC', '');





commit

-- Section 2 END *************************************