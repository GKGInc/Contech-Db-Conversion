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

begin transaction

select * into [Contech_Test].dbo.customer

alter table [Contech_Test].dbo.customer
	add customerid int identity
go

alter table [Contech_Test].dbo.customer
	add constraint customer_pk
		primary key nonclustered (customerid)
go


commit