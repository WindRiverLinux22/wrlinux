# Simplified kickstart support for Binary
Define a limited set of kickstart with limited capabilities, and use
existing shell commands (such as bash/cat/sed/mount/umount) to implement
a simplified kickstart framework for Binary

## Limited set of kickstart
### Param: lat-disk
Configures disk device to be installed and allocate spaces to partitions
 
No upstream definition, newly added by LAT
```
--install-device=
    ask | /dev/sda,LABEL=x # One or more devices separated by a comma
 
--fat-size=
    MB size of fat partition
    NOTE: Only works if installer image (SRC) and install device (DEST) are
    not on the same device. Such as the installer image is on device /dev/sda,
    and the install device is /dev/sdb
 
--boot-size=
    MB size of boot partition
 
--root-size=
    MB size of root partition
 
--var-size=
    MB size of var partition (0 for auto expand)
 
--timeout=
    Number of seconds to wait before erasing disk, 0 means do not wait
 
Example:
    # Try to install a list of available devices
    # /dev/nvme0n1,/dev/mmcblk0,/dev/sda,/dev/vda
    # It is useful while install device is not clear
    # The boot size is 512MB, root size is 8096MB,
    # the rest free disk space is expanded to /var,
    # wait 60 seconds before erasing disk
    lat-disk --install-device=/dev/nvme0n1,/dev/mmcblk0,/dev/sda,/dev/vda --boot-size=512 --root-size=8096 --var-size=0 --timeout=60
 
    # Prompt for the installation target device, without wait to ignore option --timeout
    lat-disk --install-device=ask
 
    # Set /dev/sda as default installation target, without prompt
    lat-disk --install-device=/dev/sda --timeout=0
 
    # Set /dev/sda as default installation target, wait 60 seconds to
    # prompt for the installation target device
    lat-disk --install-device=/dev/sda --timeout=60
 
```

## Make kickstart configuration be accessible on web server
1) Prepare kickstart configuration lat-disk.ks, prompt for the installation target device
```
$ cat >/path/to/http_service_data/lat-disk.ks<< ENDOF
lat-disk --install-device=ask 
ENDOF
```

2) Setup web server
```
$ python3 -m http.server 8888 --directory /path/to/http_service_data
```

3) Verify lat-disk.ks be accessible on web server
```
$ wget http://<web-server-ipaddr>:8888/lat-disk.ks
--2023-03-27 08:31:42--  http://<web-server-ipaddr>:8888/lat-disk.ks
Connecting to <web-server-ipaddr>:8888... connected.
HTTP request sent, awaiting response... 200 OK
Length: 130 [application/octet-stream]
Saving to: 'lat-disk.ks'

lat-disk.ks                                                   100%[====================>]     130  --.-KB/s    in 0s      

2023-03-27 08:31:42 (10.6 MB/s) - 'lat-disk.ks' saved [130/130]
```

## Enable kickstart for Binary
For binary, the kickstart is disabled by default, you need to edit boot
configuration to enable it, according to the bootloader of binary, there
are two ways to enable kickstart: GRUB vs U-Boot

### GRUB way
Supported BSP:
- intel-socfpga-64
- intel-x86-64

1) Power on, boot grub
```
                             GNU GRUB  version 2.06

 ����������������������������������������������������������������������������Ŀ
 �*OSTree Install PUUID=f2219c2f-e6cd-498b-99d0-10fdb4457aaa,UUID=F221-9C2F   � 
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            �
 �                                                                            � 
 ������������������������������������������������������������������������������

      Use the ^ and v keys to select which entry is highlighted.          
      Press enter to boot the selected OS, `e' to edit the commands       
      before booting or `c' for a command-line.
```

2) Press e to edit grub menu
3) Configure kickstart url, append ks=http://<web-server-ipaddr>:8888/lat-disk.ks to boot args
```
                             GNU GRUB  version 2.06

 ����������������������������������������������������������������������������Ŀ
 �setparams 'OSTree Install PUUID=f2219c2f-e6cd-498b-99d0-10fdb4457aaa,UUID=F\� 
 �221-9C2F'                                                                   �
 �                                                                            �
 �    set fallback=1                                                          �
 �    efi-watchdog enable 0 180                                               �
 �    linux ${prefix}/bzImage console=ttyS0,115200 console=tty1 rdinit=/insta\�
 �ll instdev=PUUID=f2219c2f-e6cd-498b-99d0-10fdb4457aaa,UUID=F221-9C2F instna\�
 �me=wrlinux instbr=wrlinux-image-small insturl=file:///sysroot/boot/efi/ostr\�
 �ee_repo instab=0 instsf=1 VSZ=0 RSZ=4096 BSZ=200 FSZ=32 BLM=2506 instdate=@\�
 �1679902240 instw=60  kernelparams= instl=/sysroot/boot/efi/ostree_repo ks=h\�
 �ttp://<web-server-ipaddr>:8888/lat-disk.ks                                  �
 �    initrd ${prefix}/initrd                                                 �
 �                                                                            � 
 ������������������������������������������������������������������������������

      Minimum Emacs-like screen editing is supported. TAB lists           
      completions. Press Ctrl-x or F10 to boot, Ctrl-c or F2 for a        
      command-line or ESC to discard edits and return to the GRUB menu.
```

4) Go on boot
Press Ctrl-x or F10 to boot

5) Prompt for the installation target device
```
Set install device:  instdev=ask FSZ=32 BSZ=512 RSZ=8096 VSZ=0
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda    QEMU       16G QEMU HARDDISK    disk 
B - Reboot
Select disk to format and install:
```

### U-Boot way
Supported BSP:
- amd-snowyowl-64
- axxiaarm64
- axxiaarm
- bcm-2xxx-rpi4
- marvell-cn96xx
- nxp-imx6
- nxp-imx8
- nxp-ls1028
- nxp-ls1043
- nxp-lx2xxx
- nxp-s32g
- ti-j72xx
- xilinx-zynqmp
- xilinx-zynq

1) Power on,  boot U-Boot
```
U-Boot 2022.01 (Jan 10 2022 - 18:46:34 +0000)

DRAM:  1 GiB
Flash: 64 MiB
Loading Environment from Flash... *** Warning - bad CRC, using default environment

In:    pl011@9000000
Out:   pl011@9000000
Err:   pl011@9000000
Net:   eth0: virtio-net#31
Hit any key to stop autoboot:  2
```

2) Hit any key to enter U-Boot shell
3) Configure kickstart url, set U-Boot environment variable instargs_ext
```
=> setenv instargs_ext ks=http://<web-server-ipaddr>/lat-disk.ks
```

4) Go on boot
```
=> boot
```

5) Prompt for the installation target device
```
...
Add extra install args ks=http://<web-server-ipaddr>:8888/lat-disk.ks from U-Boot shell
...
Set install device:  instdev=ask FSZ=32 BSZ=512 RSZ=8096 VSZ=0
    NAME   VENDOR      SIZE MODEL TYPE LABEL
0 - vda    0x554d4551   14G       disk 
B - Reboot
Select disk to format and install: 
```


## FAQ
### How to configure network during installation for kickstart
Due to the kickstart configuration is an URL which requires networks
and IP is available. Provide two ways to set boot args to configure
network for kickstart

1. Static IP

   instnet=0 ip=<client-ip>::<gw-ip>:<netmask>:<hostname>:<device>:off:<dns0-ip>:<dns1-ip>
   Example:
    ip=10.0.2.15::10.0.2.1:255.255.255.0:tgt:eth0:off:10.0.2.3:8.8.8.8

2. DHCP IPv4
   instnet=dhcp - use dhcp ipv4
   instnet=dhcp dhcpargs=DHCP_ARGS - use dhcp ipv4, specify which interface to use
   instnet=dhcp BOOTIF=BOOT_IF_MAC - use dhcp ipv4, MAC address of the net interface,
                                     its interface is used by dhcp client. MAC format,
                                     such as BOOTIF=52:54:00:12:34:56 or BOOTIF=01-52-54-00-12-34-56
   Example:
     instnet=dhcp
     instnet=dhcp dhcpargs=eth0
     instnet=dhcp BOOTIF=52:54:00:12:34:56


## License
The image is provided under the GPL-2.0 license.

Copyright (c) 2023 Wind River Systems Inc.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License version 2 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307 USA

The images include third party software which might be available under
additional open source licenses, including the base Wind River Linux CD
distribution along with third party dependencies.

## Legal Notices
All product names, logos, and brands are property of their respective owners.
All company, product and service names used in this software are for
identification purposes only. Wind River is a registered trademark of Wind River
Systems, Inc. Linux is a registered trademark owned by Linus Torvalds.

Disclaimer of Warranty / No Support: Wind River does not provide support and
maintenance services for this software, under Wind River's standard Software
Support and Maintenance Agreement or otherwise. Unless required by applicable
law, Wind River provides the software (and each contributor provides its
contribution) on an "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, either
express or implied, including, without limitation, any warranties of TITLE,
NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are
solely responsible for determining the appropriateness of using or
redistributing the software and assume any risks associated with your exercise
of permissions under the license.
