# Upload Data to SIA using a simple script. The script compares uploading files in SIA and delete uploaded files for save Disk Storage
# This script arises from the need to upload backup files made for example with Borg Backup or Bacula. We are talking about files with a minimum of 500MB.

#!/bin/bash
TIMEDATE=$(date +"%y%m%d-%H%M%S")
DATE=$(date +"%y%m%d")
HOSTNAME=$(hostname -f)
SIAUPFLD="/mnt/sia-data/upload"

# siac renter createbackup $HOSTNAME-$DATE    -> Add this line in your cron to make a backup of your renter data to SIA

test -f /root/files.txt | touch /root/files.txt
cd $SIAUPFLD
siac renter uploads | awk ' {RS="/"} {print $1} ' |grep disk > /root/files.txt
comm -2 -3 <(ls) <(sort /root/files.txt) | tail +2 | xargs rm

num_of_lines=$(cat /root/files.txt | wc -l)

if [[ $num_of_lines -lt 30 ]]
then
        echo "Uploading new files"
#!/bin/bash
TIMEDATE=$(date +"%y%m%d-%H%M%S")
DATE=$(date +"%y%m%d")

test -f /root/files.txt | touch /root/files.txt
cd /mnt/sia-data/upload
siac renter uploads | awk ' {RS="/"} {print $1} ' |grep disk > /root/files.txt
comm -2 -3 <(ls) <(sort /root/files.txt) | tail +2 | xargs rm

num_of_lines=$(cat /root/files.txt | wc -l)

# || [[ -n /root/files.txt ]]

if [[ $num_of_lines -lt 30 ]]
then
        echo "Uploading new files"
        
        #Only for test purposes, you can made fake files and upload to SIA for check performance and the best size of your backup files
        #N=1; BS=5000MB; COUNT=1; n=1; while [ $n -le $N ]; do echo /mnt/sia-data/upload/disk-$TIMEDATE.img; dd if=/dev/zero of=/mnt/sia-data/upload/disk-$TIMEDATE.img bs=$BS count=$COUNT; n=$(( n+1 )); done
        
        siac renter upload /mnt/sia-data/upload/disk-$TIMEDATE.img $HOSTNAME-$DATE/disk-$TIMEDATE.img

else
        echo "Pool Full $num_of_lines"
fi
