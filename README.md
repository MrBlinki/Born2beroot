# Born2beroot

## Description
This project aims to introduce you to the wonderful world of virtualization.

The aim of this repo is to keep track of the subject step by step and backup any useful scripts or tips/tricks.

## Table of contents
1. [Installation](#installation)
1. [Tools](#tools)
1. [SSH Service](#ssh-service)
1. [UFW firewall](#ufw-firewall)
1. [Hostname](#hostname)
1. [Strong password policy](#strong-password-policy)
1. [SUDO configuration](#sudo-configuration)
1. [Users and groups](#users-and-groups)
1. [monitoring.sh](#monitoringsh)

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

**dpkg**: Package manager. Run `dpkg -s PACKAGE` to search for a package

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

Installation
- `sudo apt install ufw`
- `sudo ufw enable`

Check status : `sudo ufw status`

By default, UFW denies all incoming connections and allows all outgoing connections.
To re-define the default behavior, run:
- `sudo ufw default deny incoming`
- `sudo ufw default allow outgoing`

Default configuration file : `/etc/default/ufw`

Open port 4242 : `sudo ufw allow 4242`

Delete rule :
- `sudo ufw status numbered` to get the index of the rule
- `sudo ufw delete NUMBER`

## Hostname
[Hostname on Debian Wiki](https://wiki.debian.org/Hostname)

- Update `/etc/hostname`
- Update `/etc/hosts`, so local address(es) resolves with the new system name.
- Restart the system

## Strong password policy
[LinuxTechi - How to enforce password Policies in Linux](https://www.linuxtechi.com/enforce-password-policies-linux-ubuntu-centos/)

To change existing users password expiry information, use `chage` (see [man chage](https://man7.org/linux/man-pages/man1/chage.1.html)):
- Your password has to expire every 30 days: `sudo chage -M 30 LOGIN`
- The minimum number of days allowed before the modification of a password will be set to 2: `sudo chage -m 2 LOGIN`
- The user has to receive a warning message 7 days before their password expires: `sudo chage -W 7 LOGIN`

To change the default configuration for new users, edit `/etc/login.defs` (line 165):
- `PASS_MAX_DAYS 30`
- `PASS_MIN_DAYS 2`
- `PASS_WARN_AGE 7`

To check password expiry information, use `chage -l LOGIN`

Additional PAM package is needed to add rules:
- `sudo apt install libpam-pwquality`

(The PAM packages are located in `/usr/lib/x86_64-linux-gnu/security`)

[Debian manpage for pam_pwquality.so](https://manpages.debian.org/testing/libpam-pwquality/pam_pwquality.8.en.html)

Append line 25 of `/etc/pam.d/common-password`:
- Your password must be at least 10 characters long: `minlen=10`
- It must contain
	- An uppercase letter: `ucredit=-1`
	- A lowercase letter: `lcredit=-1`
	- A number: `dcredit=-1`
- It must not contain:
	- More than 3 consecutive identical characters: `maxrepeat=3`
	- The name of the user: `reject_username`
- The password must have at least 7 characters that are not part of the former password: `difok=7`
	>Note that root is not asked for an old password so the checks that compare the old and new password are not performed
- Root password has to comply with this policy : `enforce_for_root`

NB: The negative values indicate the minimum number of X needed in the password. A positive number would use the credit system of pam_pwquality.

To change the password, use `passwd`

New password set to personal 42 password

## SUDO configuration
[DigitalOcean - How To Edit the Sudoers File](https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file)

`visudo` checks the syntax of the config file before closing it. To change the editor used by visudo, run `sudo update-alternatives --config editor`

[man sudoers](https://www.sudo.ws/docs/man/sudoers.man/)

Configuration file: `/etc/sudoers`
- Limit authentication to 3 attempts: `Defaults	passwd_tries=3`
- Custom message when wrong password: `Defaults	badpass_message="*BUZZ*Wrong password"`
- Log inputs and outputs:
	- `Defaults	logfile="/var/log/sudo/sudo.log"`
	- `Defaults log_input`
	- `Defaults log_output`
- Enable TTY mode: `Defaults	requiretty`
- Paths that can be used by sudo are restricted by:  `Defaults	secure_path=...`

The `log_input` and `log_output` archive everything in `/var/log/sudo-io`. We can then use `sudoreplay` to replay a specific sudo session by specifying it's ID. (IDs can be found bt running `sudo sudoreplay -l`).

## Users and groups
[Debian Manpage on adduser](https://manpages.debian.org/testing/adduser/adduser.8.en.html)

- Create the user42 group: `sudo addgroup user42`
- Add user to a group: `sudo adduser USER GROUP`
- To check groups of a user: `groups USER`
- To check users of a group: `cat /etc/group | grep GROUP`

## monitoring.sh
List of how to get each info required by the subject:
- Architecture of OS and kernel version: `uname -a`
- Number of physical processors: `grep "physical id" /proc/cpuinfo | sort | uniq | wc -l`
	>This command looks through the /proc/cpuinfo file for lines containing the string "physical id", sorts them, removes duplicates, and counts the number of unique lines. The resulting number is the number of physical processors.
- Number of virtual processors: `nproc --all`
- Current available RAM and utilization rate as a percentage:
	- `free -m` to get info in Mi
	- `grep Mem` to get only the line concerning RAM
	- `awk` to make calculations on the fields (e.g. second field is `$2`)
- Current available memory (i.e. disk usage):
	- `df -h` to get info in human-readable units
	- `grep /$` to get the line ending with a / (i.e the line for the root directory)
	- `awk` to get the fields
- Current utilization rate of processors as a percentage:
	- `top -bn1` to get the CPU load (`b`=batch mode, `n1`=execute 1 time)
	- `grep ^top` to get the line starting with top (first line)
	- `awk` get the load average percentage (first of the three = last 1 minute)
- Date and time of the last boot: `who -b`
- Wether LVM is active or not:
	- `lsblk | grep lvm`
	- Count the number of lines with `wc`
- Number of active connections: `ss -s` to show a summary of socket statitstics
- Number of users using the server: `users | wc -w`
- IPv4: `hostname -I`
- MAC address: `ip link show | grep ether`
- Number of commands executed with sudo: `sudo grep COMMAND /var/log/sudo/sudo.log | wc -l`

Script in `/usr/local/bin`

Cronjob Setup:
- `sudo crontab -e`
- Cronjob every 10 minutes : `*/10 * * * *`