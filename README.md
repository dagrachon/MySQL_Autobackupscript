# MySQL_Autobackupscript
Readme:

This cmd-script is used to create MySQL-Dumps, zip them and store them up to x Days.

Usage:

Automation is achieved by creating a scheduled task executing this script.

For security reasons, the user credentials are stored seperate in a my.cnf file in the mysql home directory as followed:
\Program Files\mysql\my.cnf
> [mysqldump]
> user =username
> password =secret