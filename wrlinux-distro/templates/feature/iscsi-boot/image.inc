IMAGE_INSTALL += "lsscsi"
IMAGE_INSTALL += "iscsi-initiator-utils"

IMAGE_INSTALL_INITRAMFS += " \
                            os-release-initrd \
                            iscsi-initiator-utils \
                            lsscsi \
                            kernel-module-iscsi-tcp \
                            kernel-module-iscsi-boot-sysfs \
                           "
