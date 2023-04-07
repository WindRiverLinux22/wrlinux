#
# Copyright (C) 2021 Wind River Systems, Inc.
#

LICENSE = "MIT"

CONTAINER_CORE_BOOT ?= " \
    base-files \
    base-passwd \
    ${VIRTUAL-RUNTIME_update-alternatives} \
"

TARGET_CORE_BOOT:append:x86-64 = " efibootmgr"

# No bsp packages for container
python () {
    if not bb.utils.to_boolean(d.getVar('IMAGE_ENABLE_CONTAINER')):
        d.appendVar('IMAGE_FEATURES', ' wr-bsps')
        d.appendVar('IMAGE_FEATURES', ' x11-base')
}

IMAGE_FEATURES += "package-management empty-root-password"

inherit wrlinux-image

python (){
    bbincluded = (d.getVar('BBINCLUDED') or '').split()
    skip = '/wrlinux-bin-image.conf'
    for i in bbincluded:
        if i.endswith(skip):
            skip = ''
            break
    if skip:
        raise bb.parse.SkipRecipe("This recipe is highly customized for gen-image, cannot be used for any other cases")
}
