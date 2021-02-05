/****** Script for SelectTopNRows command from SSMS  ******/

--select 'componet' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
--from
--	(select (select count(*) from componet) as new_cnt,
--		(select count(*) from rawUpsize_Contech.dbo.componet) as raw_cnt) tbl_cnt

select 'bom_hdr' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
from
	(select (select count(*) from bom_hdr) as new_cnt,
		(select count(*) from rawUpsize_Contech.dbo.bom_hdr) as raw_cnt) tbl_cnt

select 'bom_dtl' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
from
	(select  
		(select count(*) from bom_dtl) as new_cnt,
		(select count(*) from rawUpsize_Contech.dbo.bom_dtl) as raw_cnt) tbl_cnt

select 'pouches' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
from
	(select  
		(select count(*) from pouches) as new_cnt,
		(select count(*) from rawUpsize_Contech.dbo.pouches) as raw_cnt) tbl_cnt

select 'dspnsers' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
from
	(select  
		(select count(*) from dspnsers) as new_cnt,
		(select count(*) from rawUpsize_Contech.dbo.dspnsers) as raw_cnt) tbl_cnt

--select 'orders' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
--from
--	(select  
--		(select count(*) from orders) as new_cnt,
--		(select count(*) from rawUpsize_Contech.dbo.orders) as raw_cnt) tbl_cnt

--select 'bom_alt' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
--from
--	(select  
--		(select count(*) from bom_alt) as new_cnt,
--		(select count(*) from rawUpsize_Contech.dbo.bom_alt) as raw_cnt) tbl_cnt


--select 'aropen' as tablename, new_cnt, raw_cnt, (new_cnt - raw_cnt) as delta
--from
--	(select  
--		(select count(*) from aropen) as new_cnt,
--		(select count(*) from rawUpsize_Contech.dbo.aropen) as raw_cnt) tbl_cnt
