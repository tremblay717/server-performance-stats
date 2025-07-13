# Total CPU usage
# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)
# Top 5 processes by CPU usage
# Top 5 processes by memory usage

#!/bin/bash

clear
tput bold
tput setaf 6  # Cyan

cat << 'EOF'
   _____                              _____ __        __      
  / ___/___  ______   _____  _____   / ___// /_____ _/ /______
  \__ \/ _ \/ ___/ | / / _ \/ ___/   \__ \/ __/ __ `/ __/ ___/
 ___/ /  __/ /   | |/ /  __/ /      ___/ / /_/ /_/ / /_(__  ) 
/____/\___/_/    |___/\___/_/      /____/\__/\__,_/\__/____/                                                             
EOF

tput sgr0
echo -e "\n========================"
sleep 0.5


# Total CPU USAGE
echo -e "\nTotal CPU Usage: $(top -bn1 | grep "%Cpu(s)" | awk '{print $2}')%\n"

echo -e "========================\n"

# TOTAL MEMORY
# Storing Memory Stats
memory_stats=$(free -m | grep "Mem:")

# Total Memory
total_mem=$(echo $memory_stats | awk '{print $2}')

# Used Memory
used_mem=$(echo $memory_stats | awk '{print $3}')
used_mem_perc=$(echo "scale=2; $used_mem / $total_mem * 100" | bc)

# Free Memory
unused_mem=$( echo $memory_stats | awk '{print $7}')
unused_mem_perc=$(echo "scale=2; $unused_mem / $total_mem * 100" | bc)

# Display Memory Stats
echo "Total Memory: ${total_mem}M"
echo "Used Memory: ${used_mem}M - ${used_mem_perc}%"
echo "Free Memory: ${unused_mem}M - ${unused_mem_perc}%"

echo -e "\n========================\n"

# Disk Usage

function convertUnit () {
    if [[ $1 == *"G"* ]]; then
        clean_data=$(echo "$1" | sed 's/G//')
        echo $clean_data
    elif [[ $1 == *"M"* ]]; then
        clean_data=$(echo "$1" | sed 's/M//')
        gb_convert=$(echo "scale=2; $clean_data / 1024" | bc)
        echo $gb_convert
    else
        echo "0"
    fi
}


# Extracting Disk Usage
total_disk_list=$(df -H | grep -v "Filesystem" | awk '{print $2}')

total=0
for item in $total_disk_list; do
    data=$(convertUnit $item)
    total=$(echo "$total + $data" | bc)
done

echo "Total Disk Storage: ${total}G"

# Extracting Used Storage
total_used_disk_list=$(df -H | grep -v "Filesystem" | awk '{print $3}')
used_storage=0
for item in $total_used_disk_list; do
    data=$(convertUnit $item)
    used_storage=$(echo "$used_storage + $data" | bc)
done

echo "Total Used Storage: ${used_storage}G"

# Extracting Available Storage
total_free_disk_list=$(df -H | grep -v "Filesystem" | awk '{print $4}')
free_storage=0
for item in $total_free_disk_list; do
    data=$(convertUnit $item)
    free_storage=$(echo "$free_storage + $data" | bc)
done

echo "Total Free Storage: ${free_storage}G"

echo -e "\n========================\n"

# CPU USAGE
echo -e "TOP 5 CPU PROCESS:\n"
ps -eo user,pid,%cpu,%mem,comm --sort=-%cpu | head -n 6

echo -e "\n========================\n"

# MEMORY USAGE
echo -e "TOP 5 MEMORY PROCESS:\n"
ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 6

echo -e "\n"