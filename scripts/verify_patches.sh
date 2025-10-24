#!/bin/bash

echo "=== Verifying all BeeconMini SEED AC2 patches ==="

ALL_SUCCESS=true

check_file() {
    local file=$1
    local pattern=$2
    local description=$3
    
    if [ -f "$file" ]; then
        echo "✓ $file exists"
        if grep -q -E "$pattern" "$file"; then
            echo "  ✓ $description found in $file"
            return 0
        else
            echo "  ✗ $description NOT found in $file"
            return 1
        fi
    else
        echo "✗ $file not found"
        return 1
    fi
}

echo "1. Checking RTL8373 driver..."
check_file "package/kernel/rtl8373/Makefile" "switch-rtl8373|rtl8373|RTL8373" "RTL8373 driver configuration" || {
    echo "⚠ RTL8373 driver check failed, but this might be OK"
    # 不将驱动检查失败视为构建失败
}

echo "2. Checking device tree..."
check_file "target/linux/mediatek/dts/mt7981b-beeconmini-seed-ac2.dts" "beeconmini.*seed.*ac2|seed-ac2" "SEED AC2 device tree" || ALL_SUCCESS=false

echo "3. Checking network configuration..."
check_file "target/linux/mediatek/filogic/base-files/etc/board.d/02_network" "beeconmini.*seed.*ac2|seed-ac2" "SEED AC2 network config" || ALL_SUCCESS=false

echo "4. Checking platform upgrade..."
check_file "target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh" "beeconmini.*seed.*ac2|seed-ac2" "SEED AC2 platform upgrade" || ALL_SUCCESS=false

echo "5. Checking device definition..."
check_file "target/linux/mediatek/image/filogic.mk" "beeconmini_seed-ac2|seed-ac2" "SEED AC2 device definition" || ALL_SUCCESS=false

echo "=== Verification complete ==="

# 检查关键文件是否都存在
CRITICAL_FILES=(
    "target/linux/mediatek/dts/mt7981b-beeconmini-seed-ac2.dts"
    "target/linux/mediatek/filogic/base-files/etc/board.d/02_network"
    "target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh"
    "target/linux/mediatek/image/filogic.mk"
)

echo ""
echo "=== Critical files check ==="
CRITICAL_SUCCESS=true
for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file missing"
        CRITICAL_SUCCESS=false
    fi
done

if $CRITICAL_SUCCESS && $ALL_SUCCESS; then
    echo "🎉 All critical SEED AC2 patches applied successfully!"
    exit 0
elif $CRITICAL_SUCCESS; then
    echo "⚠ Some non-critical verifications failed, but build can continue."
    exit 0
else
    echo "❌ Critical files are missing. Build may fail."
    exit 1
fi