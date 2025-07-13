#!/bin/bash

# You are required to write a script server-stats.sh that can analyse basic server 
# performance stats. You should be able to run the script on any Linux server and 
# it should give you the following stats:

# Total CPU usage
# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)
# Top 5 processes by CPU usage
# Top 5 processes by memory usage

# Stretch goal: Feel free to optionally add more stats such as 
# 
# os version, uptime, load average, logged in users, failed login attempts etc.
#


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

# OS INFO SECTION
tput setaf 5  # Magenta
cat << 'EOF'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⣠⣤⣤⣤⣀⣀⠈⠋⠉⣁⣠⣤⣤⣤⣀⡀⠀⠀
⠀⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀
⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣀
⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁
⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀
⠀⠀⠀⠈⠙⢿⣿⣿⣿⠿⠟⠛⠻⠿⣿⣿⣿⡿⠋⠀⠀⠀
EOF
tput sgr0

os_type=$(sw_vers | grep "ProductName" | awk '{printf $2}')
os_version=$(sw_vers | grep "ProductVersion" | awk '{printf $2}')

echo -e "\nOS INFORMATION"
echo "OS: ${os_type}"
echo "Version: ${os_version}"
echo -e "\n========================\n"

# CPU USAGE SECTION
echo "CPU STATS"
echo $(top -l 2 | grep -E "^CPU")
echo -e "\n========================\n"

# MEMORY USAGE SECTION
echo "Memory STATS"

# Memory stats from top
memory_stats=$(top -l 1 | grep -E "^PhysMem:")
echo $memory_stats

# Getting total memory usage
used_memory=$(echo "$memory_stats" | awk '{print $2}' | sed 's/M//')

# Getting unused memory
free_memory=$(echo $memory_stats | awk '{print $8}' | sed 's/M//')

# Total Memory
total_memory=$(($used_memory + $free_memory))

# % used memory
perc_used_mem=$(bc -l <<< "scale=2;(($used_memory / $total_memory) * 100)")

# % free memory
perc_free_mem=$(bc -l <<< "scale=2;(($free_memory / $total_memory) * 100)")

echo "Total Memory = ${total_memory}M"
echo "Used Memory = ${used_memory}M - ${perc_used_mem}%"
echo "Free Memory = ${free_memory}M - ${perc_free_mem}%"

echo -e "\n========================\n"


# Ki means Kibibytes (2^10 bytes)
# Mi means Mebibytes (2^20 bytes)
# Gi means Gibibytes (2^30 bytes)
# Bi means Bytes (1 byte)



# Total Disk Size
totalDiskSize=0
disk_size_list=()

# Function to display in MB Disk Usage
convertDiskUnit () {
    if [[ $1 == *"Gi"* ]]; then
        clean_data=$(echo "$1" | sed 's/Gi//')
        # mb_size=$(( $clean_data * 1024  ))
        echo $clean_data
    fi

}


# Disk Usage Section
echo -e "Disk STATS\n"

# Display df -h cmd
df -h

# Disk Usage - Excluding First Line and map auto_home
# Creating list
disk_size_list+=($(df -h | grep -v "Filesystem" | grep -v "map auto_home" | awk '{print $3}'))
map_autohome=($(df -h | grep "map auto_home" | awk '{print $4}'))
disk_size_list+=($map_autohome)


for item in "${disk_size_list[@]}"; do
    convertDiskUnit "$item"
done