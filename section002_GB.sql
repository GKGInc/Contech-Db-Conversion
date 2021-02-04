-- ***************************************************
-- Section 2: customer, users
-- ***************************************************


print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' START script section002_GB.sql'

begin tran

begin try

    -- ***************************************************
    -- table: customer

    -- re-mapped columns:
    -- memo (text) -> memo (varchar(1000))

    -- table PK:
    -- customerid int

    -- notes:
    -- (1) converted memo column type to varchar(1000) queries showed that the max len for existing values was < 500

    print 'table: dbo.customer: start'

    IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'customer')
        BEGIN
            drop table dbo.customer
        END

    create table dbo.customer
    (
        customerid int NOT NULL IDENTITY (1, 1),
        cust_no char(5) not null,
        active bit default 0 not null,
        name char(75) not null,
        address char(35) default '' not null,
        address2 char(35) default '' not null,
        city char(30) default '' not null,
        state char(3) default '' not null,
        zip char(11) default '' not null,
        terms char(10) default '' not null,
        country char(15) default '' not null,
        phone char(17) default '' not null,
        fax char(17) default '' not null,
        email char(100) default '' not null,
        memo varchar(1000) default '' not null,
        vat char(25) default '' not null,
        b_address char(35) default '' not null,
        b_address2 char(35) default '' not null,
        b_city char(30) default '' not null,
        b_state char(3) default '' not null,
        b_zip char(11) default '' not null,
        b_country char(15) default '' not null,
        CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED
        (
            [customerid] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    INSERT into dbo.customer
        SELECT * FROM [rawUpsize_Contech].dbo.[customer]

    print 'table: dbo.customer: end'

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
    print 'table: dbo.users: start'

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

    ALTER TABLE dbo.users SET (LOCK_ESCALATION = TABLE)

    SET IDENTITY_INSERT dbo.users ON

    INSERT INTO dbo.users (userid, username, password, rolelevel, last_name, first_name, mi, empnumber, netuser, mfg_locid)
            SELECT userkey, userid, password, [level], last_name, first_name, mi, empnumber, netuser, mfg_locid
    FROM [rawUpsize_Contech].dbo.users WITH (HOLDLOCK TABLOCKX)

    SET IDENTITY_INSERT dbo.users OFF

    ALTER TABLE dbo.users ADD CONSTRAINT
        PK_users PRIMARY KEY CLUSTERED
        (
            userid
        ) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

    print 'adding orphaned users that existed in other tables...'

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
    print 'table: dbo.users: end'

end try
begin catch
    rollback
    PRINT 'ERROR - line: ' + ISNULL(STR(ERROR_LINE()), 'none') + ', message: ' + isnull(STR(ERROR_MESSAGE()), 'none');

    raiserror ('Exiting script...', 20, -1)
end catch

print (CONVERT( VARCHAR(24), GETDATE(), 121)) + ' END script section002_GB.sql'
