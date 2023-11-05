# Born2beroot

## Description
This project aims to introduce you to the wonderful world of virtualization.

The aim of this repo is to keep track of the subject step by step and backup any useful scripts or tips/tricks.

## Installation
Latest stable version of Debian (12.2) downloaded on [debian.org](https://www.debian.org/)

- VirtualBox settings
	- Name and operating system
		- Name: maroth
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
		- Cancelled data replacement step to save disk space
	- Separate /home partition
	- Passphrase: passphrase
	- Used whole space
	- No proxy for package manager
	- No additional software
	- Grub installed in primary drive
		- /dev/sda

After following those steps, the `lsblk` command gives a result similar to the example in the subject.

## Tools
**substitute user**: to start a root shell, use `su -` or `su -l`
> The (-) switch has the same effect as logging into a system directly with that user account. In essence, you become that user.

**sudo**: `apt install sudo` -> `adduser maroth sudo` to add the user to the sudo group.

**AppArmor**: comes preinstalled with Debian (check if running with `aa-status`). It's a security system that can restrict the actions of processes.

**vim**: `sudo apt install vim`

## SSH Service
[SSH on Debian Wiki](https://wiki.debian.org/SSH)

OpenSSH is the most popular and widely used implementation of SSH.

- `sudo apt install openssh-server`
- Changing the port in `/etc/ssh/sshd_config` (line 14)
- `sudo service ssh restart`
- `sudo service ssh status` to check the port

It must not be possible to connect using SSH as root :

- `PermitRootLogin no` (line 33 in `sshd_config`)

To check if SSH is working correctly, we can connect via SSH to the VM (need create a portforwarding rule in Advanced Network VirtualBox settings)

`ssh 127.0.0.1 -p 4242 -l [user]`

## UFW firewall
[Uncomplicated Firewall (ufw) on Debian Wiki](https://wiki.debian.org/Uncomplicated%20Firewall%20%28ufw%29)

