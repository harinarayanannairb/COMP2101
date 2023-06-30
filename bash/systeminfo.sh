#!/bin/bash

# Function library file sourcing
source reportfunctions.sh

# Function to display help message
display_help() {
    echo "Usage: systeminfo.sh [OPTIONS]"
    echo "Options:"
    echo "  -h    Display help for your script and exits"
    echo "  -v    Run your script verbosely, showing any errors to the user instead of sending them to the logfile"
    echo "  -system    Runs only the computerreport, osreport, cpureport, ramreport, and videoreport"
    echo "  -disk    Run only the diskreport"
    echo "  -network    Run only the networkreport"
}

# Function to perform computer report
# Function to print a full system report
full_system_report() {
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
}
