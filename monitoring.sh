#!/bin/sh

ARCHITECTURE=$(uname -a)
NUMBERPY=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)
NUMBERPV=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
MEMORYUSAGE=$(free -m | grep Mem: | awk '{printf "%s/%sMB (%.2f%%)\n",$3,$2,$3*100/$2}')
DISKUSAGE=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')
CPULOAD=$(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')
LASTBOOT=$(who -b | awk '{printf"%s %s\n",$3,$4}')
LVM=$(if cat /etc/fstab | grep -q "/dev/mapper/";then echo "yes";else echo "no";fi)
TCPCNX=$(cat /proc/net/sockstat | awk '$1 == "TCP:"{printf "%d ESTABLISHED\n",$3}')
USERLOG=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
CMD=$(sudo grep -a sudo /var/log/auth.log | grep TSID | wc -l)
wall "
#Architecture : ${ARCHITECTURE}
#CPU physical : ${NUMBERPY}
#vCPU : ${NUMBERPV}
#Memory Usage: ${MEMORYUSAGE}
#Disk Usage: ${DISKUSAGE}
#CPU load: ${CPULOAD}
#Last boot: ${LASTBOOT}
#LVM use: ${LVM}
#Connexions TCP : ${TCPCNX}
#User log: ${USERLOG}
#Network: IP ${IP} (${MAC})
#Sudo: ${CMD} cmd"
"
