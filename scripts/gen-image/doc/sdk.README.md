# Wind River Linux images SDK

The SDK is used for the following 4 images
container/wrlinux-image-minimal
container/wrlinux-image-full
target/wrlinux-image-minimal
target/wrlinux-image-full

## Supported host
X86-64

## Installed packages
Check sdk.host.manifest and sdk.target.manifest

## Install the SDK
$ ./wrlinux-*-wrlinux-image-full-sdk.sh

## Enable SDK
$ . environment-setup-*-wrs-linux

Check environment-setup-*-wrs-linux for the exported variables.

## feature/lat
The SDK supports feature/lat if there is an appsdk.README.md, check the file
for detailed info of lat.

## Use SDK's compiler
$ $CC <src>.c

Use $CONFIGURE_FLAGS if you need run configure:
$ ./configure $CONFIGURE_FLAGS

