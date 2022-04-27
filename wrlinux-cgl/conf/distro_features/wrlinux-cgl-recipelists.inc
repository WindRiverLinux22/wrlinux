#
# Copyright (C) 2016 - 2017 Wind River Systems, Inc.
#
# Explicitly allow these recipes in wrlinux cgl
#

# Recipes allowed the whole wrlinux-cgl layer
RECIPE_LIST_LAYERS:remove = "${@bb.utils.contains('DISTRO_FEATURES', 'cgl', 'wrlinux-cgl', '', d)}"

# Enable items for wrlinux-cgl distro
#
# For meta-cgl/meta-cgl-common
WRL_RECIPES:cgl-common += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'cgl', '${WRL_RECIPES_CGL_COMMON}', '', d)}  \
"
WRL_RECIPES_CGL_COMMON = " \
    cluster-glue \
    crmsh \
    libmailtools-perl \
    libsocket6-perl \
    libtest-pod-perl \
    libwww-perl \
    ocfs2-tools \
    pacemaker \
    resource-agents \
    ucarp \
"

# For meta-openembedded/meta-python
WRL_RECIPES:meta-python += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'cgl', '${WRL_RECIPES_META_PYTHON}', '', d)}  \
"
WRL_RECIPES_META_PYTHON = " \
    python3-dnspython \
    python3-parallax \
"

# For meta-openembedded/meta-networking
WRL_RECIPES:networking-layer += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'cgl', '${WRL_RECIPES_META_NETWORKING}', '', d)}  \
"
WRL_RECIPES_META_NETWORKING = " \
    bridge-utils \
    chrony \
    corosync \
    kronosnet \
    freediameter \
    frr \
    geoip \
    geoip-perl \
    ifenslave \
    ippool \
    ipvsadm \
    iscsi-initiator-utils \
    libldb \
    libmaxminddb \
    libtdb \
    libtevent \
    ndpi \
    netkit-rsh \
    netkit-telnet \
    ntopng \
    openhpi \
    openipmi \
    open-isns \
    openl2tp \
    rdate \
    rdist \
    samba \
    tftp-hpa \
    tnftp \
    traceroute \
    tunctl \
    vblade \
    vlan \
    vsftpd \
"

# For meta-openembedded/meta-oe
WRL_RECIPES:openembedded-layer += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'cgl', '${WRL_RECIPES_META_OE}', '', d)}  \
"
WRL_RECIPES_META_OE = " \
    c-ares \
    crash \
    doxygen \
    edac-utils \
    indent \
    ipmitool \
    libnet \
    libparse-yapp-perl \
    libqb \
    postgresql \
    pps-tools \
    smartmontools \
    zabbix \
    zstd \
"

# For meta-openembedded/meta-perl
WRL_RECIPES:perl-layer += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'cgl', '${WRL_RECIPES_META_PERL}', '', d)}  \
"
WRL_RECIPES_META_PERL = " \
    libauthen-sasl-perl \
    libdigest-hmac-perl \
    libdigest-sha1-perl \
    libhtml-parser-perl \
    libhtml-tagset-perl \
    libio-socket-ssl-perl \
    libnet-dns-perl \
    libnet-dns-sec-perl \
    libnet-libidn-perl \
    libnet-ssleay-perl \
    libnet-telnet-perl \
    libtext-iconv-perl \
    libxml-filter-buffertext-perl \
    libxml-libxml-perl \
    libxml-sax-writer-perl \
"

# For meta-virtualization
WRL_RECIPES:virtualization-layer += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'cgl', 'lxc', '', d)} \
"
