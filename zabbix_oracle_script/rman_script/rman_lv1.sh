#!/usr/bin/bash
#
backup_home='/dbbackup/paic'
datafiles=$backup_home/Wednesday_dt_inc1_%u_%T
archivelogs=$backup_home/Wednesday_arch_%u_%T
controlfiles=$backup_home/Wednesday_ctf_%u_%T

echo $datafiles
echo $archivelogs
echo $controlfiles


sudo su - oracle <<EOF > /usr/local/webserver/zabbix_oracle_script/rman_logs/lv1_`date +%Y%m%d`.log
rman target /
run
{
allocate channel c1 type disk;
allocate channel c2 type disk;
allocate channel c3 type disk;
allocate channel c4 type disk;
allocate channel c5 type disk;
allocate channel c6 type disk;
backup as compressed backupset incremental level 1 database include current controlfile format '$datafiles';
backup current controlfile format '$controlfiles';
BACKUP as compressed backupset ARCHIVELOG ALL NOT BACKED UP 1 TIMES format '$archivelogs';
crosscheck archivelog all;
delete  noprompt expired archivelog all;
DELETE noprompt ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-7';
release channel c1;
release channel c2;
release channel c3;
release channel c4;
release channel c5;
release channel c6;
}
EOF
