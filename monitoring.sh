#!/bin/bash
arch=$(uname -a)
cpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(nproc --all)
used_ram=$(free -m | grep Mem | awk '{print $3}')
total_ram=$(free -m | grep Mem | awk '{print $2}')
per_ram=$(free -m | grep Mem | awk '{printf("%.2f", $3/$2*100)}')
used_disk=$(df -h | grep /$ | awk '{print $3}' | tr -d 'G')
total_disk=$(df -h | grep /$ | awk '{print $2}')
per_disk=$(df -h | grep /$ | awk '{print $5}')
cpu_load=$(top -bn1 | grep ^top | awk '{print $(NF-2)}' | tr -d ',')
last_boot=$(who -b | awk '{print $(NF-1)" "$NF}')
count_lvm=$(lsblk | grep lvm | wc -l)
if [count_lvm -gt 0]; then
	lvm=$(echo Yes)
else
	lvm=$(echo No)
fi
active_connections=$(ss -s | grep estab | awk '{print $4}' | tr -d ',')
count_users=$(users | wc -w)
ipv4=$(hostname -I)
mac=$(ip link show | grep ether | awk '{print $2}')
count_sudo=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

echo "	#Architecture:	$arch
	#CPU physical:	$cpu
	#vCPU:	$vcpu
	#Memory Usage:	${used_ram}/${total_ram}MiB (${per_ram}%)
	#Disk Usage:	${used_disk}/${total_disk} ($per_disk)
	#CPU load:	${cpu_load}%
	#Last boot:	$last_boot
	#LVM use:	$lvm
	#Connections TCP:	$active_connections ESTABLISHED
	#User log:	$count_users
	#Network:	IP $ipv4($mac)
	#Sudo:	$count_sudo cmd"
