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

wall "	#Architecture:	$arch
	#CPU physical:	$cpu
	#vCPU:	$vcpu
	#Memory Usage:	${used_ram}/${total_ram}MiB (${per_ram}%)
	#Disk Usage:	${used_disk}/${total_disk} ($per_disk)
	#CPU load:	${cpu_load}%
	#Last boot:	$last_boot
	#LVM use:	$lvm"
