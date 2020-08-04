#!/bin/bash
/mysql/app/5.7.25/bin/mysqldump -ualauda -pcpaasCeb@123 -S /mysqldata/3309/socket/mysql.sock -F -A -B --events > /mysqldata/backup/mysql_full_backup_{{ pre_version }}.sql
