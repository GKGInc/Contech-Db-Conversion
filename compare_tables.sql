-- check tables to make sure all of them made it over

--SELECT 'test2' as dbname, t.name AS tblname
-- FROM test2.sys.tables t
--UNION 
--SELECT 'rawUpsize_Contech' AS dbname, t.name AS tblname
-- FROM rawUpsize_Contech.sys.tables t


SET NOCOUNT ON
DECLARE @SkipTables table (TableName nvarchar(100))

INSERT INTO @SkipTables (TableName)
 SELECT * FROM (SELECT 'carcmpls' UNION ALL
				SELECT 'cartrack' UNION ALL 
				SELECT 'coccrtdt' UNION ALL
				SELECT 'coccrthd' UNION ALL
				SELECT 'cocinsdt' UNION ALL
				SELECT 'cocinshd' UNION ALL
				SELECT 'codmanshppack' UNION ALL
				SELECT 'convert' UNION ALL
				SELECT 'empedpnd' UNION ALL
				SELECT 'fmfilled' UNION ALL
				SELECT 'fmmaster' UNION ALL
				SELECT 'ironlyrd' UNION ALL
				SELECT 'job_hist' UNION ALL
				SELECT 'job_rels' UNION ALL
				SELECT 'jobroute' UNION ALL
				SELECT 'jobrtbgi' UNION ALL
				SELECT 'jobrtcnt' UNION ALL
				SELECT 'jobrtinv' UNION ALL
				SELECT 'jobsetup' UNION ALL
				SELECT 'lab001' UNION ALL
				SELECT 'matljobs' UNION ALL
				SELECT 'menu_opt' UNION ALL
				SELECT 'po_cat' UNION ALL
				SELECT 'po_cost' UNION ALL
				SELECT 'scp44025' UNION ALL
				SELECT 'screens' UNION ALL
				SELECT 'shipcarrier' UNION ALL
				SELECT 'tdorderd' UNION ALL
				SELECT 'tdorderh' UNION ALL
				SELECT 'tdrcving' UNION ALL
				SELECT 'user_lev' UNION ALL
				SELECT 'user_scr') t(Col)



SET NOCOUNT OFF

SELECT t1.name AS tbl_Not_In_Raw
 FROM test2.sys.tables  t1
 WHERE t1.name NOT IN (select t2.name FROM rawUpsize_Contech.sys.tables t2) 

SELECT t1.name AS tbl_Not_In_New
 FROM rawUpsize_Contech.sys.tables  t1
 WHERE t1.name NOT IN (select t2.name FROM TEST2.sys.tables t2) 
     AND t1.name NOT IN (select TableName FROM @SkipTables)

