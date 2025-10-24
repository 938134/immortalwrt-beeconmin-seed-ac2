# BeeconMini SEED AC2 OpenWrt 云编译项目

本项目提供 BeeconMini SEED AC2 路由器的 OpenWrt 云编译支持，基于 GitHub Actions 实现自动化编译和发布。

## 特性

- ✅ RTL8373 交换机驱动支持
- ✅ SEED AC2 设备树定义
- ✅ 网络接口配置
- ✅ 平台升级支持
- ✅ 自动化云编译

## 文件结构

- `.github/workflows/` - GitHub Actions 工作流
- `patches/` - 补丁文件和驱动源码
- `scripts/` - 补丁应用和验证脚本

## 使用方法

1. Fork 本仓库
2. 在 GitHub 仓库设置中启用 Actions
3. 推送代码到 main 分支触发自动编译
4. 在 Actions 页面下载编译好的固件

## 支持的 OpenWrt 版本

- ImmortalWrt 23.05/24.10
- OpenWrt 23.05.x
- LEDE 分支

## 硬件规格

- SoC: MediaTek MT7981B
- 交换机: Realtek RTL8373
- 接口: 2.5G WAN + 千兆 LAN