#!/bin/bash

FILOGIC_MK_FILE="target/linux/mediatek/image/filogic.mk"

if [ ! -f "$FILOGIC_MK_FILE" ]; then
    echo "Error: filogic.mk file not found: $FILOGIC_MK_FILE"
    exit 1
fi

# 检查是否已经添加过
if grep -q "beeconmini_seed-ac2" "$FILOGIC_MK_FILE"; then
    echo "SEED AC2 device definition already exists, skipping..."
    exit 0
fi

echo "Adding SEED AC2 device definition to filogic.mk..."

# 在 bananapi_bpi-r3 设备定义后添加 SEED AC2 定义
sed -i '/^TARGET_DEVICES += bananapi_bpi-r3$/a\
\
define Device/beeconmini_seed-ac2\
  DEVICE_VENDOR := BeeconMini\
  DEVICE_MODEL := SEED AC2\
  DEVICE_DTS := mt7981b-beeconmini-seed-ac2\
  DEVICE_DTS_DIR := ../dts\
  DEVICE_PACKAGES := kmod-fs-f2fs kmod-fs-ext4 mkf2fs e2fsprogs kmod-switch-rtl8373 kmod-mt7981-firmware mt7981-wo-firmware\
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata\
endef\
TARGET_DEVICES += beeconmini_seed-ac2' "$FILOGIC_MK_FILE"

echo "SEED AC2 device definition added to filogic.mk"