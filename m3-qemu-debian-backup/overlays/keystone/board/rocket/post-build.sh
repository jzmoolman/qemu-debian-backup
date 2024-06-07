#!/bin/sh

cp -rf $BR2_EXTERNAL_KEYSTONE_PATH/board/rokcet/rokcet-sdk/rootfs/* $BUILDROOT_OVERLAYDIR/ | true

# Install udev rules & systemd units
