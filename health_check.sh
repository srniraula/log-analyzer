#!/bin/bash
LOGFILE="/home/srn/health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

{
#CPU USAGE
cpu_usage=$(top -bn1 | grep '%Cpu(s)' | awk '{print $2}')
if (( $(echo "$cpu_usage <= 70" | bc -l) )); then
	echo "[INFO]:	[$TIMESTAMP]	CPU: $cpu_usage"
elif (( $(echo "$cpu_usage > 70" | bc -l) )); then
	echo "[WARNING]:	[$TIMESTAMP]	CPU: $cpu_usage"
fi

#MEMORY USAGE
mem_usage=$(free -m | grep 'Mem:' | awk '{printf "%.2f", $3/$2 * 100}')
if (( $(echo "$mem_usage <= 70" | bc -l) )); then
	echo "[INFO]:	[$TIMESTAMP]	Mem: $mem_usage"
elif (( $(echo "$mem_usage > 70" | bc -l) )); then
	echo "[WARNING]:	[$TIMESTAMP]	Mem: $mem_usage"
else
	echo "logging error for memory usage"
fi

#Running Processes count
echo "[INFO]:	[$TIMESTAMP]	Number of running processes: $(ps aux | wc -l)"

# System uptime
echo "[INFO]:	[$TIMESTAMP]	Uptime: $(uptime -p)"

# Load Average
read load_avg_1min load_avg_5min load_avg_15min num_rproc_to_total_proc latest_pid < /proc/loadavg

if (( $(echo "$load_avg_1min/$(nproc) > 1" | bc -l) || $(echo "$load_avg_5min/$(nproc) > 1" | bc -l) || $(echo "$load_avg_15min/$(nproc) > 1" | bc -l) )); then
	if (( $(echo "$load_avg_1min > $load_avg_5min" | bc -l) )); then
		echo "[WARNING]:	[$TIMESTAMP]	cpu load average: $load_avg_1min, $load_avg_5min, $load_avg_15min, LOAD IS INCREASING and CPU utilization is > 100%"
	else
		echo "[WARNING]:	[$TIMESTAMP]	cpu load average: $load_avg_1min, $load_avg_5min, $load_avg_15min and CPU utilization is > 100%"
	fi
else
	echo "[INFO]:	[$TIMESTAMP]	cpu load average: $load_avg_1min, $load_avg_5min, $load_avg_15min"
fi

# Network connectivity
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? == 0 ]; then
	echo "[INFO]:	[$TIMESTAMP]	Network connectivity: reachable"
else
	echo "[WARNING]:	[$TIMESTAMP]	Network connectivity: not reachable"
fi

# TOP 3 CPU consuming processes
top3_cpu_cproc=$(ps aux --sort=-%cpu | awk 'NR>1 && NR<=4 {print $11,$3}')
echo "[INFO]:	[$TIMESTAMP]	Top 3 CPU consuming processes: "$top3_cpu_cproc""

# Top 3 MEMORY consuming processes
top3_mem_cproc=$(ps aux --sort=-%mem | awk 'NR>1 && NR<=4 {print $11, $4}')
echo "[INFO]:	[$TIMESTAMP]	Top 3 Memory consuming processes: "$top3_mem_cproc""

# Checking disk usage
disk_usage=`df -h | grep /dev/nvme0n1p2 | awk '{gsub(/%/, "", $5); print $5}'`
if [ $disk_usage -gt 80 ]; then 
	echo "[WARNINGING]:	[$TIMESTAMP]	Disk usage:$disk_usage (greater than 80%)"
else
	echo "[INFO]:	[$TIMESTAMP]	Disk usage:$disk_usage (normal)"
fi
} >> $LOGFILE 2>&1