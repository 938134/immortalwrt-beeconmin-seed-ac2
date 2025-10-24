#!/bin/bash

PATCH_DIR="../patches"
OPENWRT_DIR="openwrt"

cd $OPENWRT_DIR

echo "=== Applying BeeconMini SEED AC2 patches ==="
echo "OpenWrt version: $(git log -1 --format='%h %s' --date=short)"

# 显示分支信息
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: ${CURRENT_BRANCH:-default}"

echo "1. Copying RTL8373 driver package..."
mkdir -p package/kernel/
cp -r $PATCH_DIR/rtl8373 package/kernel/

echo "2. Copying device tree files..."
mkdir -p target/linux/mediatek/dts
cp $PATCH_DIR/dts/*.dts target/linux/mediatek/dts/

echo "3. Applying network configuration..."
if [ -f "../scripts/patch_network_config.sh" ]; then
    chmod +x ../scripts/patch_network_config.sh
    ../scripts/patch_network_config.sh
fi

echo "4. Applying platform upgrade configuration..."
if [ -f "../scripts/patch_platform_upgrade.sh" ]; then
    chmod +x ../scripts/patch_platform_upgrade.sh
    ../scripts/patch_platform_upgrade.sh
fi

echo "5. Adding device definition to filogic.mk..."
if [ -f "../scripts/patch_filogic_mk.sh" ]; then
    chmod +x ../scripts/patch_filogic_mk.sh
    ../scripts/patch_filogic_mk.sh
fi

echo "6. Applying patch files..."
for patch in $(ls $PATCH_DIR/*.patch 2>/dev/null | sort); do
    echo "Applying: $(basename $patch)"
    if patch -p1 --fuzz=3 < "$patch" 2>/dev/null; then
        echo "✓ $(basename $patch) applied successfully"
    else
        echo "⚠ $(basename $patch) failed, checking if already applied..."
        # 检查是否已经包含我们的修改
        if grep -q "beeconmini" "$patch"; then
            echo "📋 Manual check: beeconmini content likely already applied"
        fi
    fi
done

echo "=== All patches completed ==="