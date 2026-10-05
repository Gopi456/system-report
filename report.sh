#!/bin/sh

SERVER_NAME="${1:-$(hostname)}"

echo "=========================================="
echo "         LINUX SYSTEM REPORT"
echo "=========================================="

echo
echo "Server Name"
echo "------------------------------------------"
echo "$SERVER_NAME"

echo
echo "Hostname"
echo "------------------------------------------"
hostname

echo
echo "Current Date"
echo "------------------------------------------"
date

echo
echo "Current User"
echo "------------------------------------------"
whoami

echo
echo "Operating System / Kernel"
echo "------------------------------------------"
uname -a

echo
echo "Disk Usage"
echo "------------------------------------------"
df -h

echo
echo "Memory Information"
echo "------------------------------------------"
free -h

echo
echo "Running Processes"
echo "------------------------------------------"
ps aux

echo
echo "=========================================="
echo "         END OF SYSTEM REPORT"
echo "=========================================="