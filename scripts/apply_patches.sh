#!/bin/bash
set -e

echo "=== Applying SEED AC2 Patches ==="

# 1. Copy RTL8373 driver
echo "Installing RTL8373 driver..."
mkdir -p package/kernel/
cp -r patches/drivers/rtl8373 package/kernel/

# 2. Copy device tree
echo "Installing device tree..."
mkdir -p target/linux/mediatek/dts
cp patches/dts/*.dts target/linux/mediatek/dts/

# 3. Apply patch files
echo "Applying patch files..."
for patch in patches/*.patch; do
    if [ -f "$patch" ]; then
        echo "Applying $(basename $patch)..."
        patch -p1 --fuzz=3 < "$patch" || echo "Patch may be already applied: $patch"
    fi
done

echo "=== All patches applied ==="