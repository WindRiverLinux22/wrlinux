RECIPE_LIST_LAYERS:remove = "meta-anaconda"

# Recipes allowed for meta-openembedded/meta-gnome
WRL_RECIPES:gnome-layer += "\
    keybinder \
    libgnomekbd \
    libnma \
    libtimezonemap \
    libuser \
    metacity \
    network-manager-applet \
    usermode \
    libgtop \
"

# Recipes allowed for meta-openembedded/meta-python
WRL_RECIPES:meta-python += "\
    python3-blivet \
    python3-blivetgui \
    python3-coverage \
    python3-langtable \
    python3-meh \
    python3-ntplib \
    python3-ordered-set \
    python3-pid \
    python3-prctl \
    python3-pydbus \
    python3-pykickstart \
    python3-pyparted \
    python3-pytz \
    python3-pyudev \
    python3-requests-file \
    python3-requests-ftp \
    python3-setuptools-scm \
    python3-systemd \
    python3-wrapt \
"

# Recipes allowed for meta-openembedded/meta-filesystems
WRL_RECIPES:filesystems-layer += "\
    ntfs-3g-ntfsprogs \
    xfsprogs \
"

# Recipes allowed for meta-openembedded/meta-oe
WRL_RECIPES:openembedded-layer += "\
    augeas \
    libinih \
    libpwquality \
    libreport \
    libtar \
    fltk \
    glade \
    gnome-doc-utils-stub \
    gnulib \
    isomd5sum \
    pps-tools \
    satyr \
    tigervnc \
    uthash \
    xmlrpc-c \
"

# Recipes allowed for meta-openembedded/meta-networking
WRL_RECIPES:networking-layer += "\
    chrony \
"
