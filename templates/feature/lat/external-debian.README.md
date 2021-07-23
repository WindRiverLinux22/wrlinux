# Using the Wind River Linux Assembly Tool - create OSTree debian-based image

## 1. Supported machine
intel-x86-64

## 2. Create  debian-11 (bullseye) based package feed for LAT support
See layers/wr-ostree/data/debian/README.txt for details

Then http://<web-server-url>/debian is accessible

## 3. Build steps
### 3.1 Setup project
$ setup.sh --machines=intel-x86-64 --dl-layers \
    --distro=wrlinux-graphics \
    --templates feature/ostree feature/lat feature/docker --layers wr-ostree

### 3.2 Source a build
$ . ./oe-init-build-env

### 3.3 Edit local.conf to enable external-debian
$ echo 'DEBIAN_CUSTOMIZE_FEED_URI = "http://<web-server-url>/debian"' >> conf/local.conf

### 3.4 Change debian mirror and distro
(Optional, if not set, default is http://ftp.us.debian.org/debian)
$ echo 'DEFAULT_DEBIAN_MIRROR = "http://ftp.cn.debian.org/debian"' >>  conf/local.conf

### 3.5 Build
#### 3.5.1 Build with minimal rpms
$ bitbake appsdk-native && bitbake container-base -cpopulate_sdk && bitbake package-index build-sysroots

#### 3.5.2 Build with full rpms
$ bitbake world appsdk-native && bitbake container-base -cpopulate_sdk && bitbake package-index build-sysroots

## 4. Install AppSDK
### 4.1 Install SDK
$ ./wrlinux-graphics-*-glibc-x86_64-intel_x86_64-container-base-sdk.sh -y -d stx
$ cd stx

### 4.2 Root privilege is required
$ sudo su
$ . environment-setup-corei7-64-wrs-linux

## 5. Generate default debian based image
### 5.1 Example Yamls, provides three yaml files, edit yamls file for further
customization
$ appsdk exampleyamls --pkg-type external-debian
+-----------+-------------------------------------------------+
| Yaml Type |                      Name                       |
+===========+=================================================+
| Image     | debian-container-base-intel-x86-64.yaml         |
|           | debian-image-base-intel-x86-64.yaml             |
|           | debian-initramfs-ostree-image-intel-x86-64.yaml |
|           |                                                 |
+-----------+-------------------------------------------------+

### 5.2 Debian based container image
$ appsdk --log-dir log gencontainer exampleyamls/debian-container-base-intel-x86-64.yaml

### 5.3 Debian based initramfs image with LAT installer
$ appsdk --log-dir log geninitramfs exampleyamls/debian-initramfs-ostree-image-intel-x86-64.yaml

### 5.4 Debian based image with LAT installer
5.4.1 Create ustart image
$ appsdk --log-dir log genimage exampleyamls/debian-image-base-intel-x86-64.yaml

5.4.2 Create ISO image
$ appsdk --log-dir log genimage exampleyamls/debian-image-base-intel-x86-64.yaml --type iso

5.4.3 Create PXE TFTP files
$ appsdk --log-dir log genimage exampleyamls/debian-image-base-intel-x86-64.yaml --type pxe

## License
The sdk is provided under the GPL-2.0 license.

Copyright (c) 2021 Wind River Systems Inc.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License version 2 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307 USA

The sdk includes third party software which might be available under
additional open source licenses, including the base Wind River Linux CD
distribution along with third party dependencies.

## Legal Notices
All product names, logos, and brands are property of their respective owners.
All company, product and service names used in this software are for
identification purposes only. Wind River is a registered trademark of Wind River
Systems, Inc. Linux is a registered trademark owned by Linus Torvalds.

Disclaimer of Warranty / No Support: Wind River does not provide support and
maintenance services for this software, under Wind River’s standard Software
Support and Maintenance Agreement or otherwise. Unless required by applicable
law, Wind River provides the software (and each contributor provides its
contribution) on an “AS IS” BASIS, WITHOUT WARRANTIES OF ANY KIND, either
express or implied, including, without limitation, any warranties of TITLE,
NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are
solely responsible for determining the appropriateness of using or
redistributing the software and assume any risks associated with your exercise
of permissions under the license.
