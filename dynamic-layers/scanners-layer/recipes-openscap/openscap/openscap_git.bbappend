SRCREV = "55efbfda0f617e05862ab6ed4862e10dbee52b03"
SRC_URI = "git://github.com/OpenSCAP/openscap.git;branch=maint-1.3;protocol=https \
          "
PV = "1.3.7"

# Fix build failure with gcc-10
CFLAGS:append = " -fcommon"

DEPENDS:append = " xmlsec1"
DEPENDS:append:class-native = " xmlsec1-native"

inherit systemd

SYSTEMD_SERVICE:${PN} = "oscap-remediate.service"
SYSTEMD_AUTO_ENABLE = "disable"
