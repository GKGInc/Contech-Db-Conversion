-- ***************************************************
-- Section 4: customer
-- ***************************************************

-- PK:
--
-- column name changes:
--
-- new column mapping:
--
-- other:
--

use Contech_Test

begin transaction

IF EXISTS(select * from INFORMATION_SCHEMA.tables where TABLE_SCHEMA = 'dbo' and table_name = 'customer')
    BEGIN
        drop table dbo.customer
    END
GO

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
	memo text default '' not null,
	vat char(25) default '' not null,
	b_address char(35) default '' not null,
	b_address2 char(35) default '' not null,
	b_city char(30) default '' not null,
	b_state char(3) default '' not null,
	b_zip char(11) default '' not null,
	b_country char(15) default '' not null
)
GO

insert into dbo.customer (
    [cust_no]
      ,[active]
      ,[name]
      ,[address]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[terms]
      ,[country]
      ,[phone]
      ,[fax]
      ,[email]
      ,[memo]
      ,[vat]
      ,[b_address]
      ,[b_address2]
      ,[b_city]
      ,[b_state]
      ,[b_zip]
      ,[b_country]
)
SELECT [cust_no]
      ,[active]
      ,[name]
      ,[address]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[terms]
      ,[country]
      ,[phone]
      ,[fax]
      ,[email]
      ,[memo]
      ,[vat]
      ,[b_address]
      ,[b_address2]
      ,[b_city]
      ,[b_state]
      ,[b_zip]
      ,[b_country]
  FROM [rawUpsize_Contech].dbo.[customer]
GO

commit