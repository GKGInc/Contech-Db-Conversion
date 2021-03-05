sqlcmd -S CONTECH -d TEST6 -U sa -P edi@GKG -b ^
-i section001_HR_XPO.sql,^
section002_GB_XPO.sql,^
section003_HR_XPO.sql,^
section004_GB_XPO.sql,^ -o GB_codefirst.log