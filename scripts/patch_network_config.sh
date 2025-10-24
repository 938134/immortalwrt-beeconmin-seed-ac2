#!/bin/bash

NETWORK_FILE="target/linux/mediatek/filogic/base-files/etc/board.d/02_network"

if [ ! -f "$NETWORK_FILE" ]; then
    echo "Error: Network file not found: $NETWORK_FILE"
    exit 1
fi

# 检查是否已经添加过
if grep -q "beeconmini,seed-ac2" "$NETWORK_FILE"; then
    echo "SEED AC2 network configuration already exists, skipping..."
    exit 0
fi

# 在 interfaces 部分添加 SEED AC2 配置
sed -i '/zyxel,ex5601-t0-ubootmod)/a\
\	beeconmini,seed-ac2)\
\		ucidef_set_interfaces_lan_wan eth0 eth1\
\		;;' "$NETWORK_FILE"

# 在 MAC 地址部分添加 SEED AC2 配置
sed -i '/yuncore,ax835)/a\
\	beeconmini,seed-ac2)\
\		lan_mac=$(mtd_get_mac_binary "art" 0x0)\
\		wan_mac=$(macaddr_add "$lan_mac" 1)\
\		;;' "$NETWORK_FILE"

echo "Network configuration for SEED AC2 added successfully."