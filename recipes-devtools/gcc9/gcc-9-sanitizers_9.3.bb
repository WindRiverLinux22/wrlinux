require recipes-devtools/gcc9/gcc-${PV}.inc
require gcc-configure-common.inc

LICENSE = "NCSA | MIT"

LIC_FILES_CHKSUM = "\
    file://libsanitizer/LICENSE.TXT;md5=0249c37748936faf5b1efd5789587909 \
"

EXTRA_OECONF_PATHS = "\
    --with-sysroot=/not/exist \
    --with-build-sysroot=${STAGING_DIR_TARGET} \
"

do_configure () {
    rm -rf ${B}/${TARGET_SYS}/libsanitizer/
    mkdir -p ${B}/${TARGET_SYS}/libsanitizer/
    cd ${B}/${TARGET_SYS}/libsanitizer/
    chmod a+x ${S}/libsanitizer/configure
    relpath=${@os.path.relpath("${S}/libsanitizer", "${B}/${TARGET_SYS}/libsanitizer")}
    $relpath/configure ${CONFIGUREOPTS} ${EXTRA_OECONF}
    # Easiest way to stop bad RPATHs getting into the library since we have a
    # broken libtool here
    sed -i -e 's/hardcode_into_libs=yes/hardcode_into_libs=no/' ${B}/${TARGET_SYS}/libsanitizer/libtool
    # Link to the sysroot's libstdc++ instead of one gcc thinks it just built
    sed -i -e '/LIBSTDCXX_RAW_CXX_\(CXXFLAGS\|LDFLAGS\)\s*=/d' ${B}/${TARGET_SYS}/libsanitizer/*/Makefile
}

EXTRACONFFUNCS += "extract_gcc9_stashed_builddir"
do_configure[depends] += "gcc-9-cross-${TARGET_ARCH}:do_gcc9_stash_builddir"

do_compile () {
    cd ${B}/${TARGET_SYS}/libsanitizer/
    oe_runmake MULTIBUILDTOP=${B}/${TARGET_SYS}/libsanitizer/
}

do_install () {
    cd ${B}/${TARGET_SYS}/libsanitizer/
    oe_runmake 'DESTDIR=${D}' MULTIBUILDTOP=${B}/${TARGET_SYS}/libsanitizer/ install
    if [ -d ${D}${infodir} ]; then
        rmdir --ignore-fail-on-non-empty -p ${D}${infodir}
    fi
    chown -R root:root ${D}
    # only keep the version specific things
    rm -rf ${D}${libdir}/lib*
}

INHIBIT_DEFAULT_DEPS = "1"
ALLOW_EMPTY:${PN} = "1"
DEPENDS = "virtual/crypt gcc-runtime virtual/${TARGET_PREFIX}gcc"

# used to fix ../../../../../../../../../work-shared/gcc-8.3.0-r0/gcc-8.3.0/libsanitizer/libbacktrace/../../libbacktrace/elf.c:772:21: error: 'st.st_mode' may be used uninitialized in this function [-Werror=maybe-uninitialized]
DEBUG_OPTIMIZATION:append = " -Wno-error"

PACKAGES = "${PN} ${PN}-dbg"

do_package_write_ipk[depends] += "virtual/${MLPREFIX}${TARGET_PREFIX}compilerlibs:do_packagedata"
do_package_write_deb[depends] += "virtual/${MLPREFIX}${TARGET_PREFIX}compilerlibs:do_packagedata"
do_package_write_rpm[depends] += "virtual/${MLPREFIX}${TARGET_PREFIX}compilerlibs:do_packagedata"

# Only x86, powerpc, sparc, s390, arm, and aarch64 are supported
COMPATIBLE_HOST = '(x86_64|i.86|powerpc|sparc|s390|arm|aarch64).*-linux'
# musl is currently broken entirely
COMPATIBLE_HOST:libc-musl = 'null'

FILES:${PN} = "${libdir}/gcc/${TARGET_SYS}/${BINV}/include/sanitizer/*.h"

# Building with thumb enabled on armv4t armv5t fails with
# sanitizer_linux.s:5749: Error: lo register required -- `ldr ip,[sp],#8'
ARM_INSTRUCTION_SET:armv4 = "arm"
ARM_INSTRUCTION_SET:armv5 = "arm"
