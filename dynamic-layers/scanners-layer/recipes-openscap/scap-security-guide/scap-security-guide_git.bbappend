FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9bfa86579213cb4c6adaffface6b2820"

SRCREV = "30b8273257ea357335def3f18d603d2024d13a18"
SRC_URI = "git://github.com/OpenSCAP/scap-security-guide.git;branch=stable;protocol=https \
           file://0001-Add-product-WRLinux-LTS22.patch \
           file://0002-Add-prodtype-wrlinuxlts22-to-rules.patch \
           file://0003-Set-correct-package-names-for-wrlinuxlts22.patch \
           file://0004-Fix-path-of-systemctl-for-service_enable-service_dis.patch \
           file://0005-Fix-accounts_passwords_pam_faillock_deny.patch \
           file://0006-Fix-accounts_passwords_pam_faillock_deny_root.patch \
           file://0007-Fix-accounts_passwords_pam_faillock_unlock_time.patch \
           file://0008-Fix-accounts_passwords_pam_faillock_interval.patch \
           file://0009-Fix-accounts_password_pam_unix_remember.patch \
           file://0010-Fix-set_password_hashing_algorithm.patch \
           file://0011-Fix-display_login_attempts.patch \
           file://0012-Use-pam-pwquality-instead-of-pam-tally2.patch \
           file://0013-Fix-accounts_maximum_age_login_defs.patch \
           file://0014-Fix-accounts_password_set_max_life_existing.patch \
           file://0015-Fix-accounts_logon_fail_delay.patch \
           file://0016-Fix-accounts_umask_etc_login_defs.patch \
           file://0017-Fix-banner_etc_issue.patch \
           file://0018-Fix-no_empty_passwords.patch \
           file://0019-Fix-selinux_policytype.patch \
           file://0020-Fix-require_singleuser_auth.patch \
           file://0021-Fix-audit_rules.patch \
           file://0022-Fix-openssh-rules.patch \
           file://0023-Enable-sysctl-rules-for-wrlinux.patch \
           file://0024-Enable-snmpd_not_default_password-rule.patch \
           file://0025-Eanble-kernel_module_disabled-rule.patch \
           file://0026-Fix-sudo_remove_nopasswd.patch \
           file://0027-Fix-mount_option_home_nosuid.patch \
           file://0028-Fix-chronyd_or_ntpd_set_maxpoll.patch \
           file://0029-Fix-file_groupownership_home_directories.patch \
           file://0030-Replace-firewalld-with-iptables.patch \
           file://0031-Replace-aide-with-samhain.patch \
          "

PV = "0.1.62"

EXTRA_OECMAKE += "-DSSG_PRODUCT_CHROMIUM=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_DEBIAN9=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_DEBIAN10=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_DEBIAN11=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_EKS=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_FEDORA=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_FIREFOX=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_FUSE6=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_JRE=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_MACOS1015=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_OCP4=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_RHCOS4=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_OL7=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_OL8=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_OL9=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_OPENSUSE=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_RHEL7=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_RHEL8=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_RHEL9=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_RHV4=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_SLE12=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_SLE15=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_UBUNTU1604=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_UBUNTU1804=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_UBUNTU2004=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_VSEL=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_WRLINUX8=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_WRLINUX1019=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_WRLINUXLTS21=OFF"
EXTRA_OECMAKE += "-DSSG_PRODUCT_WRLINUXLTS22=ON"
