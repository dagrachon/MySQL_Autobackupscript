@echo off
:: -------------------------------------------------------------------------
:: small cmd-script to automate backups of your MySQL-Database on Windows
::
:: Name: MySQL_Auto_Backup.cmd
::
:: Author: marcus s.
:: Contact: https://github.com/dagrachon
:: -------------------------------------------------------------------------
::
:: change dir to the working directory / installation directory of your mysql
:: if needed, change to another partition with ":[partition-letter]", e.g. :E
cd \Program Files\

:: set Timestamp for Backupfiles
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set backuptime=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%%ldt:~10,2%

:: Error log path - Important in debugging your issues
set errorLogPath="%cd%\MySQLBackups\log\dumperrors.txt"

:: MySQL EXE Path
set mysqldumpexe="%cd%\mysql\bin\mysqldump.exe"

:: Backupfiles path
set backupfldr=%cd%\MySQLBackups\backupfiles\

:: Schema name
set dbschema="test_sql"

:: Path to zip executable
set zipper="C:\Program Files\7-Zip\7z.exe"

:: Number of days to retain .zip backup files
set retaindays=10

:: DONE WITH SETTINGS

:: GO FORTH AND BACKUP YOUR DATABASE!

:: turn on if you are debugging
@echo off

:: without stored credentials in a my.cnf/.ini file, you must pass the credentials as parameters with the %mysqldumpexe%-command
::
:: set dbuser="username"
:: set password="secret"
:: --user=%dbuser% --password=%dbpass%

echo make dump from database %dbschema%
%mysqldumpexe% --opt %dbschema% --routines --log-error=%errorLogPath% > "%backupfldr%%dbschema%.%backuptime%.sql"

::echo "Zipping all files ending in .sql in the folder"

:: .zip option clean but not as compressed
%zipper% a -tzip "%backupfldr%%dbschema%MySQL-FullBackup.%backuptime%.zip" "%backupfldr%*.sql"

::echo "Deleting all the files ending in .sql only"

del "%backupfldr%*.sql"

:: Set the number of days to keep backups, using the win program "Forfiles" for this, mine is set to 10 days  "-10"
:: echo "Deleting zip files older than 10 days now"
Forfiles /P %backupfldr% /s /m *.* /D -%retaindays% /C "cmd /C del @PATH"

