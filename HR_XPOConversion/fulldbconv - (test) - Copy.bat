sqlcmd -S CONTECH -d HRContechTest1 -U sa -P edi@GKG -b ^
-i section001_HR.sql,^
section002_GB.sql,^
section003_HR.sql,^
section004_GB.sql,^
section005_HR.sql,^
section017_HR.sql,^
section018_GB.sql,^
section026_HR.sql,^
section027_HR.sql,^
section028_HR.sql,^
section034_HR.sql,^
section038_HR.sql,^
-o dbconv_20210324.log