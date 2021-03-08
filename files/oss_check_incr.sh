#!/bin/bash
time_stand=`date +'%Y%m%d'`
time_stand_last=`date -d "1 day ago" +'%Y%m%d'`
command_file=$1
target_vm=$2
target_file=$3
echo "------------$2-$3--------------"
data_used1=`$1 ls oss://bucket-elc-crm-db/dbbackup/full/$target_vm/dbbackup/Incr/$time_stand/"$target_file""$time_stand".bak|awk 'NR==2{print $5}'`
data_used2=`$1 ls oss://bucket-elc-crm-db/dbbackup/full/$target_vm/dbbackup/Incr/$time_stand_last/"$target_file""$time_stand_last".bak|awk 'NR==2{print $5}'`
if [ "$data_used1" == '' ]; then
echo $2 $3 Backup failed
else
incr_data=`echo "$data_used1"-"$data_used2" |bc`
half_data=`echo "$data_used2" / 2 |bc`
if [ "$incr_data" -gt "$half_data" ]; then
echo $2 $3 Backup successful,but too much change,Pls care!
$1 ls oss://bucket-elc-crm-db/dbbackup/full/$target_vm/dbbackup/Incr/$time_stand/"$target_file""$time_stand".bak
else
echo $2 $3 Backup successful
$1 ls oss://bucket-elc-crm-db/dbbackup/full/$target_vm/dbbackup/Incr/$time_stand/"$target_file""$time_stand".bak
fi
fi
echo "------------$2-$3--------------"
