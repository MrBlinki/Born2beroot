# Born2beroot

## Description

This project aims to introduce you to the wonderful world of virtualization.

The aim of this repo is to keep track of the subject step by step and backup any
useful scripts or tips/tricks.


## Installation

Latest stable version of Debian (12.2) downloaded on [debian.org](https://www.debian.org/)

- VirtualBox settings
	- Name and operating system
		- Name: Born2beroot
		- Machine Folder: /goinfre/maroth/VMs
		- Type: Linux
		- Version: Debian (64-bit)
	- Memory size: 1024MB
	- Hard disk: Create a virtual disk now
		- VDI
		- Dynamically allocated
		- 8.00 GB
- Debian installer
	- Install (not Graphical install)
	- English
	- Switzerland
	- Locales: United States
	- Keyboard: American english
	- Hostname: maroth42
	- Domain name: *left blank*
	- Passwords (to be changed later): pass
	- User: maroth
	- Partition guided LVM encrypted
	- Separate /home partition
	- Passphrase: passphrase
	- Used whole space
	- No proxy for package manager
	- No additional software
	- Grub installed in primary drive
		- /dev/sda

After following those steps, the `lsblk` command gives a result similar to the
example in the subject.