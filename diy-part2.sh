#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

############# Modify default parameters here #################
HOSTNAME=K2P-Nuc
IPADDRESS=192.168.2.1
SSID=k2p
ENCRYPTION=psk2+ccmp
KEY=24094572
###############################################################

#修改路由器名称
sed -i "s/hostname='OpenWrt'/hostname='$HOSTNAME'/g" package/base-files/files/bin/config_generate

#修改默认IP
sed -i 's/192.168.1.1/$IPADDRESS/g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(TZ=UTC-8 date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings


#删除原默认主题
rm -rf package/lean/luci-theme-argon
rm -rf package/lean/luci-theme-bootstrap
rm -rf package/lean/luci-theme-material
# rm -rf package/lean/luci-theme-netgear

#取消原主题luci-theme-bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 修改 netgear 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-netgear/g' feeds/luci/collections/luci/Makefile


# Modify default WiFi SSID
sed -i "s/set wireless.default_radio\${devidx}.ssid=OpenWrt/set wireless.default_radio\${devidx}.ssid='$SSID'/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default WiFi Encryption
sed -i "s/set wireless.default_radio\${devidx}.encryption=none/set wireless.default_radio\${devidx}.encryption='$ENCRYPTION'/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default WiFi Key
sed -i "/set wireless.default_radio\${devidx}.mode=ap/a\                        set wireless.default_radio\${devidx}.key='$KEY'" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Forced WiFi to enable
sed -i 's/set wireless.radio\${devidx}.disabled=1/set wireless.radio\${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh