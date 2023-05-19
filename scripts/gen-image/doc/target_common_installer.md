1) The installation process will wait for selecting disk to install
```
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda  QEMU       32G QEMU HARDDISK    disk 
1 - sdc  QEMU       64G QEMU HARDDISK    disk 
B - Reboot
R - Refresh

Press Enter to install on sdc or Esc to select a different device?
```

2) You can press Enter to install on the default device
```
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda  QEMU       32G QEMU HARDDISK    disk 
1 - sdc  QEMU       64G QEMU HARDDISK    disk 
B - Reboot
R - Refresh

Press Enter to install on sdc or Esc to select a different device?
Choose to install on disk: 1 (sdc  QEMU       64G QEMU HARDDISK    disk)
```

3) Or press Esc to select a different device, enter the index of disk
```
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda  QEMU       32G QEMU HARDDISK    disk 
1 - sdc  QEMU       64G QEMU HARDDISK    disk 
B - Reboot
R - Refresh

Press Enter to install on sdc or Esc to select a different device?
Select disk to format and install: 0
```

4) Check to ERASE disk
If disk is not empty, you need to double check
```
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda  QEMU       32G QEMU HARDDISK    disk 
1 - sdc  QEMU       64G QEMU HARDDISK    disk 
B - Reboot
R - Refresh

Press Enter to install on sdc or Esc to select a different device?
Select disk to format and install: 0

The disk /dev/sda is not empty, ERASE /dev/sda (y/n) y
Are you sure to ERASE /dev/sda (y/n) y
```

5) Special warning for arm/aarch64 boards
For arm/aarch64 boards, if you don't select to install on a suggested disk, the
installation may fail and re-install repeatedly, or failed to boot after
installed.
```
    NAME   VENDOR      SIZE MODEL            TYPE LABEL
0 - sda  QEMU          1G QEMU HARDDISK    disk 
1 - vda  0x554d4551   16G                  disk 
2 - sdb  QEMU         32G QEMU HARDDISK    disk 
B - Reboot
R - Refresh

Press Enter to install on vda or Esc to select a different device?
Select disk to format and install: 2

WARNING: You choose to install on *sdb* which is not the suggested disk *vda*
WARNING: It may fail to install and re-install repeatedly, or failed to boot after installed.
ERASE /dev/sdb (y/n) 
```

6) Enter a shell if installation is failed
```
    NAME   VENDOR      SIZE MODEL            TYPE LABEL
0 - sda  QEMU          1G QEMU HARDDISK    disk 
1 - vda  0x554d4551   16G                  disk 
2 - sdb  QEMU         32G QEMU HARDDISK    disk 
B - Reboot
R - Refresh

Press Enter to install on vda or Esc to select a different device?
Select disk to format and install: 0
[snip]
Failed to add #6 partition: No space left on device
Leaving.

Create partition failed

Save install-fail-230519-042339.log to partition /dev/vda1
Installation failed, starting boot shell. System will reboot on exit 
You can execute the install with verbose message:
     INSTSH=0 bash -v -x /install
bash-5.1# 
```

7) Save installation log
The installation log will be saved to /var/nstall-<yymmdd>-<hhmmss>.log when the
installation is done successfully.
```
Save install-230517-090727.log to /var
install (1): drop_caches: 3
sysrq: Resetting
[snip]
intel-x86-64 login: root
root@intel-x86-64:~# ls /var/install-230517-090727.log 
/var/install-230517-090727.log
```

The installation log will be saved to first available partition of the disk when
the installation is failed, for example /dev/vda1, you can get the log via:
```
bash-5.1# mount /dev/vda1 /mnt
bash-5.1# ls /mnt/install-fail-230519-042339.log
/mnt/install-fail-230519-042339.log
```

