SUMMARY = "The implementation of SOME/IP"
SECTION = "base"
LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=815ca599c9df247a0c7f619bab123dad"

DEPENDS = "boost dlt-daemon"

SRC_URI = "git://github.com/GENIVI/${BPN}.git;branch=master;protocol=https;name=vsomeip \
           git://github.com/google/googletest.git;branch=main;protocol=https;name=googletest;destsuffix=googletest \
           file://0001-Support-boost-1.75.patch \
           file://0002-Fix-pkgconfig-dir-for-multilib.patch \
           file://0003-Install-example-configuration-files-to-etc-vsomeip.patch \
          "

SRCREV_vsomeip = "13f9c89ced6ffaeb1faf485152e27e1f40d234cd"
SRCREV_googletest = "e2239ee6043f73722e7aa812a459f54a28552929"
SRCREV_FORMAT = "vsomeip_googletest"

S = "${WORKDIR}/git"

inherit cmake pkgconfig

EXTRA_OECMAKE = "-DINSTALL_LIB_DIR:PATH=${baselib} \
                 -DINSTALL_CMAKE_DIR:PATH=${baselib}/cmake/vsomeip3 \
                "

# For vsomeip test
EXTRA_OECMAKE += "-DTEST_IP_MASTER=10.0.3.1 \
                  -DTEST_IP_SLAVE=10.0.3.2 \
                  -DTEST_IP_SLAVE_SECOND=10.0.3.3 \
                 "

RDEPENDS:${PN}-test += "bash"

do_configure:prepend() {
   export GTEST_ROOT=${WORKDIR}/googletest
}

do_compile:append() {
   cmake_runcmake_build --target examples
   cmake_runcmake_build --target build_tests
}

do_install:append() {
    install -d ${D}/opt/${PN}-test/examples
    install -m 0755 ${B}/examples/*-sample ${D}/opt/${PN}-test/examples
    install -d ${D}/opt/${PN}-test/examples/routingmanagerd
    install -m 0755 ${B}/examples/routingmanagerd/routingmanagerd \
        ${D}/opt/${PN}-test/examples/routingmanagerd

    install -d ${D}/opt/${PN}-test/test
    cp -f ${B}/test/*test* ${D}/opt/${PN}-test/test

    cp -rf ${S}/config ${D}/opt/${PN}-test
}

PACKAGES += "${PN}-test"

FILES:${PN}-dbg += " \
   /opt/${PN}-test/.debug/* \
   "
FILES:${PN}-test = " \
   /opt/${PN}-test \
   "
