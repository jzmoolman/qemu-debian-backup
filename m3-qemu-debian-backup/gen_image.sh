#!/bin/bash

set -e

SD_SIZE=1000
SD_BOOT_SIZE=64
SD_SWAP_SIZE=
SD_IMG=debian-riscv64.sd.img

#mount -l | grep `pwd`/ | while IFS=' ' #read -ra LINE ; do
#  sudo umount ${LINE[0]}
#done check the rest

echo $SD_SIZE
rm -f $SD_IMG
dd if=/dev/zero of=$SD_IMG bs=1M count=1000

SD_LOOP=$(sudo losetup --find --partscan --show $SD_IMG)
echo "SD image device: ${SD_LOOP}"

sudo sfdisk ${SD_LOOP} <<-__EOF__
1M,${SD_BOOT_SIZE}M,0xE,*
,,,-
__EOF__

sudo partprobe ${SD_LOOP}

UUID=68d82fa1-1bb5-435f-a5e3-862176586eec
sudo mkfs.vfat -F 16 -n BOOT ${SD_LOOP}p1
sudo mkfs.ext4 -E nodiscard -L rootfs -U $UUID ${SD_LOOP}p2

mkdir -p mnt/boot
mkdir -p mnt/rootfs

sudo mount ${SD_LOOP}p1 mnt/boot
sudo mount ${SD_LOOP}p2 mnt/rootfs
sudo mount -t ext2 ./build-rocket64/buildroot.build/images/rootfs.ext2 mnt/ext2


pushd mnt/rootfs
sudo cp -r ../ext2/* .
popd

pushd mnt/boot
sudo cp ../../build-rocket64/buildroot.build/images/fw_payload.elf boot.elf
popd



sudo umount ${SD_LOOP}p1
sudo umount ${SD_LOOP}p2

#umount ext
sudo fsck -f -p -T ${SD_LOOP}p1 || true
sudo fsck -f -p -T ${SD_LOOP}p2

sudo losetup -d ${SD_LOOP}
