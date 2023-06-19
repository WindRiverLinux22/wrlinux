Under Linux, insert a micro SD card to a USB SD Card Reader. Assuming the USB
SD Card Reader takes device /dev/sdX, use dd to copy the image to it. Before
the image can be burned onto a micro SD card, it should be un-mounted. Some
Linux distros may automatically mount when it is plugged in. Using device
/dev/sdX as an example, find all mounted partitions:

    $ mount | grep sdX

and un-mount those that are mounted, for example:

    $ sudo umount /dev/sdX*

#### Verify checksum for the downloaded image
There is a sha256sum.txt which saves the image's checksum, you can verify it by
command sha256sum, for example:

$ sha256sum -c sha256sum.txt
wrlinux-image-full-intel-x86-64.ustart.img.gz: OK
ovmf.qcow2: OK

