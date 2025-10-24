#!/bin/bash

echo "=== Verifying SEED AC2 Patches ==="

check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1"
        return 0
    else
        echo "✗ $1"
        return 1
    fi
}

echo "1. Checking RTL8373 driver..."
check_file "package/kernel/rtl8373/Makefile"

echo "2. Checking device tree..."
check_file "target/linux/mediatek/dts/mt7981b-beeconmini-seed-ac2.dts"

echo "3. Checking network config..."
if grep -q "seed-ac2" target/linux/mediatek/filogic/base-files/etc/board.d/02_network 2>/dev/null; then
    echo "✓ Network config applied"
else
    echo "✗ Network config missing"
fi

echo "4. Checking device definition..."
if grep -q "beeconmini_seed-ac2" target/linux/mediatek/image/filogic.mk 2>/dev/null; then
    echo "✓ Device definition applied"
else
    echo "✗ Device definition missing"
fi

echo "=== Verification complete ==="