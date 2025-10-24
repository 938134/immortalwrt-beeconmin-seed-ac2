#!/bin/bash

echo "=== Verifying all BeeconMini SEED AC2 patches ==="

check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1 exists"
        if grep -q "beeconmini.*seed.*ac2" "$1" || grep -q "beeconmini_seed-ac2" "$1"; then
            echo "  ✓ SEED AC2 configuration found in $1"
            return 0
        else
            echo "  ✗ SEED AC2 configuration NOT found in $1"
            return 1
        fi
    else
        echo "✗ $1 not found"
        return 1
    fi
}

ALL_SUCCESS=true

echo "1. Checking RTL8373 driver..."
check_file "package/kernel/rtl8373/Makefile" || ALL_SUCCESS=false

echo "2. Checking device tree..."
check_file "target/linux/mediatek/dts/mt7981b-beeconmini-seed-ac2.dts" || ALL_SUCCESS=false

echo "3. Checking network configuration..."
check_file "target/linux/mediatek/filogic/base-files/etc/board.d/02_network" || ALL_SUCCESS=false

echo "4. Checking platform upgrade..."
check_file "target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh" || ALL_SUCCESS=false

echo "5. Checking device definition..."
check_file "target/linux/mediatek/image/filogic.mk" || ALL_SUCCESS=false

echo "=== Verification complete ==="

if $ALL_SUCCESS; then
    echo "🎉 All SEED AC2 patches applied successfully!"
    exit 0
else
    echo "❌ Some patches may have failed. Please check the output above."
    exit 1
fi