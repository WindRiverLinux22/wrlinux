FILESEXTRAPATHS:append := ":${THISDIR}/rpm"

# Add in the macros.krp file to point to the keyring directory
# to put keys...
PACKAGECONFIG[keyringpath] = ",,,"
OVERRIDES .= "${@['', ':rpm-keyring-path']['keyringpath' in (d.getVar('PACKAGECONFIG', True) or "").split()]}"
SRC_URI:append:rpm-keyring-path = " \
    file://macros.krp \
    file://0001-do-not-limit-the-format-of-key-file.patch \
"

# Enforce signature checking and validation
PACKAGECONFIG[enforcesig] = ",,,"
OVERRIDES .= "${@['', ':rpm-enforce']['enforcesig' in d.getVar('PACKAGECONFIG', True).split()]}"
CFLAGS:append:rpm-enforce = " -DMANDATORY_KNOWN_SIG"
SRC_URI:append:rpm-enforce = " file://0002-signature-error.patch"

do_install:append:rpm-keyring-path () {
	mkdir -p ${D}${sysconfdir}/rpm/
	install -m 0644 ${WORKDIR}/macros.krp ${D}${sysconfdir}/rpm/
}
