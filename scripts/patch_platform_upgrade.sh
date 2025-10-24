#!/bin/bash

PLATFORM_FILE="target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh"

if [ ! -f "$PLATFORM_FILE" ]; then
    echo "Error: Platform file not found: $PLATFORM_FILE"
    exit 1
fi

# 检查是否已经添加过
if grep -q "beeconmini,seed-ac2" "$PLATFORM_FILE"; then
    echo "SEED AC2 platform upgrade configuration already exists, skipping..."
    exit 0
fi

# 在 platform_do_upgrade() 函数中添加 SEED AC2 支持
sed -i '/^platform_do_upgrade() {/,/^}/ {
    /^[[:space:]]*\*)/i\
\tbeeconmini,seed-ac2)\
\t\tCI_KERNPART="kernel"\
\t\tCI_ROOTPART="rootfs"\
\t\tCI_DATAPART="rootfs_data"\
\t\temmc_do_upgrade "$1"\
\t\t;;
}' "$PLATFORM_FILE"

# 在 platform_copy_config() 函数中添加 SEED AC2 支持
sed -i 's/\(glinet,gl-mt6000|\)/\1\\\n\tbeeconmini,seed-ac2|/' "$PLATFORM_FILE"

echo "Platform upgrade configuration for SEED AC2 added successfully."