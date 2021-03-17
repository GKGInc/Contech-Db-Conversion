sqlcmd -S CONTECH -d GBContechTest -U sa -P edi@GKG -b ^
-i section010_XPO.sql,^
section020_XPO.sql,^
section030_XPO.sql,^
section040_XPO.sql ^
-o GB_BOM_codefirst.log