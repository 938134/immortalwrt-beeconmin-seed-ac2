#!/bin/bash
set -e

echo "=== Applying SEED AC2 Patches ==="

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Script directory: $SCRIPT_DIR"
echo "Project root: $PROJECT_ROOT"

# 1. Copy RTL8373 driver
echo "1. Installing RTL8373 driver..."
mkdir -p package/kernel/
if [ -d "$PROJECT_ROOT/patches/drivers/rtl8373" ]; then
    cp -r "$PROJECT_ROOT/patches/drivers/rtl8373" package/kernel/
    echo "✓ RTL8373 driver copied"
else
    echo "⚠ RTL8373 driver directory not found at: $PROJECT_ROOT/patches/drivers/rtl8373"
    ls -la "$PROJECT_ROOT/patches/" || echo "Patches directory not found"
fi

# 2. Copy device tree
echo "2. Installing device tree..."
mkdir -p target/linux/mediatek/dts
if [ -f "$PROJECT_ROOT/patches/dts/mt7981b-beeconmini-seed-ac2.dts" ]; then
    cp "$PROJECT_ROOT/patches/dts/mt7981b-beeconmini-seed-ac2.dts" target/linux/mediatek/dts/
    echo "✓ Device tree copied"
else
    echo "⚠ Device tree file not found at: $PROJECT_ROOT/patches/dts/mt7981b-beeconmini-seed-ac2.dts"
fi

# 3. Apply patch files
echo "3. Applying patch files..."
for patch in "$PROJECT_ROOT/patches/"*.patch; do
    if [ -f "$patch" ]; then
        echo "Applying $(basename "$patch")..."
        if patch -p1 --fuzz=3 < "$patch"; then
            echo "✓ $(basename "$patch") applied successfully"
        else
            echo "⚠ $(basename "$patch") may be already applied or failed"
        fi
    fi
done

echo "=== All patches applied ==="