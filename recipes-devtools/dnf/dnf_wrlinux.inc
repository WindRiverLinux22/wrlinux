FILESEXTRAPATHS:append := ":${THISDIR}/dnf"

# Tell dnf to only pull validation keys from the local key directory
# /etc/rpm/keys/
# (this only works for 'rpm' repositories)
PACKAGECONFIG[keyringpath] = ",,,"
OVERRIDES .= "${@['', ':rpm-keyring-path']['keyringpath' in (d.getVar('PACKAGECONFIG', True) or "").split()]}"
SRC_URI:append:rpm-keyring-path = " \
    file://0001-force-to-disable-gpgcheck-of-base-config.patch \
"

do_install:append:rpm-keyring-path () {
        mkdir -p ${D}${sysconfdir}/yum.repos.d
}

# For Distro only
python() {
    bbincluded = (d.getVar('BBINCLUDED') or '').split()
    skip = '/wrlinux-bin-image.conf'
    for i in bbincluded:
        if i.endswith(skip):
            skip = ''
            break
    if not skip:
        d.appendVar('SRC_URI', ' file://0001-dnf-Warn-when-non-Wind-River-package-repositories-ar.patch')
}
# End of Distro
