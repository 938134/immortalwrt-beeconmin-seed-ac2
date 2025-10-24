#!/bin/bash

PATCH_DIR="../patches"
OPENWRT_DIR="openwrt"

cd $OPENWRT_DIR

echo "=== Applying BeeconMini SEED AC2 patches ==="

echo "1. Copying RTL8373 driver package..."
mkdir -p package/kernel/
cp -r $PATCH_DIR/rtl8373 package/kernel/

echo "2. Copying device tree files..."
mkdir -p target/linux/mediatek/dts
cp $PATCH_DIR/dts/*.dts target/linux/mediatek/dts/

echo "3. Applying network configuration..."
chmod +x ../scripts/patch_network_config.sh
../scripts/patch_network_config.sh

echo "4. Applying platform upgrade configuration..."
chmod +x ../scripts/patch_platform_upgrade.sh
../scripts/patch_platform_upgrade.sh

echo "5. Adding device definition to filogic.mk..."
chmod +x ../scripts/patch_filogic_mk.sh
../scripts/patch_filogic_mk.sh

echo "6. Applying patch files..."
for patch in $(ls $PATCH_DIR/*.patch | sort); do
    echo "Applying: $(basename $patch)"
    if patch -p1 --fuzz=3 < "$patch" 2>/dev/null; then
        echo "✓ $(basename $patch) applied successfully"
    else
        echo "⚠ $(basename $patch) failed or already applied, continuing..."
    fi
done

echo "=== All patches completed ==="