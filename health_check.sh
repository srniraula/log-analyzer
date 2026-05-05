#!/bin/bash
LOGFILE="/home/srn/health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Checking Docker status
echo "##########################"
echo "Docker is: "
docker_status=`systemctl is-active docker`
echo $docker_status
echo "Docker is $docker_status in the system" >> $LOGFILE
echo "##########################"

# Checking disk usage
echo "##########################"
echo "Disk usage of main SDD is: "
disk_usage=`df -h | grep /dev/nvme0n1p2 | awk '{gsub(/%/, "", $5); print $5}'`
if [ $disk_usage -gt 80 ]; then 
	echo "WARNING: The disk usage is above 80%"
	echo "WARNING: The disk usage is above 80% at $TIMESTAMP" >> $LOGFILE
else
	echo "The disk usage is $disk_usage at $TIMESTAMP"
	echo "The disk usage is $disk_usage at $TIMESTAMP" >> $LOGFILE
fi
echo "##########################"


