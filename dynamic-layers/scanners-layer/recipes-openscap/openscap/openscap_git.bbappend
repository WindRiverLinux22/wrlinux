SRCREV = "c70bc47449398dc31b66cb00ca00c820a369c4e3"
SRC_URI = "git://github.com/OpenSCAP/openscap.git;branch=maint-1.3;protocol=https \
          "
PV = "1.3.1+git${SRCPV}"

# Fix build failure with gcc-10
CFLAGS:append = " -fcommon"
