require linux-yocto-wrlinux.inc
include srcrev.inc
require linux-yocto-extra-kernel-src.inc

SRCREV_machine:qemuarm = "${AUTOREV}"
SRCREV_machine:qemuarm64 = "${AUTOREV}"
SRCREV_machine:qemumips = "${AUTOREV}"
SRCREV_machine:qemuppc = "${AUTOREV}"
SRCREV_machine:qemuriscv64 = "${AUTOREV}"
SRCREV_machine:qemuriscv32 = "${AUTOREV}"
SRCREV_machine:qemux86 = "${AUTOREV}"
SRCREV_machine:qemux86-64 = "${AUTOREV}"
SRCREV_machine:qemumips64 = "${AUTOREV}"
SRCREV_machine = "${AUTOREV}"
SRCREV_meta = "${AUTOREV}"
