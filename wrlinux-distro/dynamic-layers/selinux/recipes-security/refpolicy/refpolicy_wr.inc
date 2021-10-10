#
# Copyright (C) 2012-2014, 2019 Wind River Systems, Inc.
#

RDEPENDS:${PN} += "policycoreutils"

FILESEXTRAPATHS:prepend := "${THISDIR}/refpolicy-wr:"

SRC_URI += "\
        file://0001-policy-modules-system-selinuxutil-allow-secadm-to-ma.patch \
        file://0002-policy-modules-app-crash-add-crash-policy-module.patch \
        file://0003-policy-modules-admin-newgrp-add-newgrp-policy-module.patch \
        file://0004-policy-modules-system-systemd-set-correct-context-fo.patch \
        file://0005-policy-modules-system-sysnetwork-allow-systemd_netwo.patch \
        file://0006-policy-modules-services-radius-fix-freeradius-startu.patch \
        file://0007-policy-modules-services-radius-allow-radius_t-to-bin.patch \
        file://0008-policy-modules-services-samba-allow-smbd_t-nmbd_t-to.patch \
        file://0009-policy-modules-services-postfix.te-allow-postfix_loc.patch \
        file://0010-policy-modules-services-mta-allow-user_mail_t-to-man.patch \
        file://0011-policy-modules-admin-logwatch-fix-avc-denials-for-lo.patch \
        file://0012-policy-modules-services-zebra-allow-zebra_t-to-read-.patch \
        file://0013-policy-modules-services-ftp-fix-avc-denials-for-ftpd.patch \
        file://0014-policy-modules-services-watchdog-allow-watchdog_t-to.patch \
        file://0015-policy-modules-system-mount-allow-mount_t-to-getattr.patch \
        file://0016-policy-modules-services-postfix-allow-postfix_postdr.patch \
        file://0017-Revert-kernel-Drop-unlabeled_t-as-a-files_mountpoint.patch \
        file://0018-policy-modules-roles-sysadm-allow-sysadm_t-to-read-f.patch \
        "

OSTREE_POLICY_PATCHES = "\
        file://wr-policy-file_contexts.subs_dist-fix-label-for-usr-etc.patch \
        file://wr-policy-files-add-lable-if-mnt-opt-media-is-symlinks-file.patch \
        file://wr-policy-system-mount.te-allow-mount-on-symlink-file.patch \
        file://wr-policy-system-locallogin.te-allow-login-read-symlink-file.patch \
        file://wr-policy-allow-mount-to-dirs-under-tmp.patch \
        file://wr-policy-Add-ostree-policy.patch \
        file://wr-policy-Allow-sshd_t-and-staff_t-read-symlinks.patch \
        file://wr-policy-lable-system-export-as-ostree_exec_t.patch \
        file://wr-policy-file_contexts.subs_dist-set-aliases-for-var-home-and.patch \
        file://wr-policy-modules-system-mount-allow-mount-command-to-m.patch \
        file://wr-policy-modules-system-systemd-allow-systemd_generato.patch \
        file://wr-policy-modules-system-userdomain-allow-domain-read-h.patch \
        file://wr-policy-modules-system-systemd-allow-systemd_tmpfiles.patch \
        file://wr-policy-modules-admin-ostree-fix-ostree-unlock.patch \
        "

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'ostree', '${OSTREE_POLICY_PATCHES}', '', d)}"
