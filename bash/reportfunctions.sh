#!/bin/bash

#Function for CPU report
function cpureport {
    echo "CPU Report"
    echo "CPU Manufacturer: $(lscpu | grep "Vendor ID" | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Model: $(lscpu | grep "CPU model name" | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Architecture: $(lscpu | grep "Architecture" | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Core Count: $(lscpu | grep "Core(s) per socket" | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Maximum Speed: $(lscpu | grep "CPU MHz" | awk -F ':' '{print $2}' | xargs) MHz"
    echo "Cache Sizes:"
    lscpu | grep "L1d\|L1i\|L2\|L3" | awk -F ':' '{print $1 ": " $2}' | xargs
    echo
}

#Function for computer report
function computerreport {
    echo "Computer Report"
    echo "Computer Manufacturer: $(dmidecode -s system-manufacturer)"
    echo "Computer Description/Model: $(dmidecode -s system-product-name)"
    echo "Computer Serial Number: $(dmidecode -s system-serial-number)"
    echo
}

#Function for OS report
function osreport {
    echo "OS Report"
    echo "Linux Distro: $(lsb_release -ds)"
    echo "Distro Version: $(lsb_release -rs)"
    echo
}

# Function for RAM report
function ramreport {
    echo "RAM Report"
    echo "Installed Memory Components:"
    echo "Manufacturer | Model | Size | Speed | Location"
    dmidecode -t memory | awk -F '|' '/Manufacturer|Part Number|Size|Speed|Locator/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); printf "%-12s |", $2} NR%5==0 {print ""}'
    echo
    echo "Total Installed RAM: $(free -h | awk '/^Mem:/ {print $2}')"
    echo
}

# Function for video report
function videoreport {
    echo "Video Report"
    echo "Video Card/Chipset Manufacturer: $(lspci | grep -i | awk -F ':' '{print $3}' | xargs)"
    echo "Video Card/Chipset Description/Model: $(lspci | grep -i | awk -F ':' '{print $4}' | xargs)"
    echo
}

# Function for disk report
function diskreport {
    echo "Disk Report"
    echo "Installed Disk Drives:"
    echo "Manufacturer | Model | Size | Partition | Mount Point | Filesystem Size | Filesystem Free Space"
    lsblk -bo NAME,MODEL,SIZE,TYPE,MOUNTPOINT,FSTYPE,FSSIZE,FSUSED | awk -F '|' '/disk/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); printf "%-12s |", $2} NR%7==0 {print ""}'
    echo
}

# Function to generate network report
function networkreport {
    echo "Network Report"
    echo "Installed Network Interfaces:"
    echo "Manufacturer | Model/Description | Link State | Current Speed | IP Addresses | Bridge Master | DNS Servers | Search Domains"
    ip -o link show | awk -F ': ' '/^[0-9]+:/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); printf "%-12s |", $2} NR%2==0 {print ""}'
    echo
}

# Function to display error message
function errormessage {
    local error_message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
   
    echo "Error: $error_message" >&2
    echo "$timestamp: $error_message" >> /var/log/systeminfo.log
}

case "$1" in
    cpureport)
        cpureport
        ;;
    computerreport)
        computerreport
        ;;
    osreport)
        osreport
        ;;
    ramreport)
        ramreport
        ;;
    videoreport)
        videoreport
        ;;
    diskreport)
        diskreport
        ;;
    networkreport)
        networkreport
        ;;
    errormessage)
        errormessage "$2"
        ;;
    *)
        echo "Error"
        ;;
esac
