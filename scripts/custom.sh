#!/bin/bash
#========================================================================================================================
# Description: Automatically Build ImmortalWrt for Amlogic
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt.git / Branch: 21.02
#========================================================================================================================

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

# Set ssid
sed -i "s/OpenWrt/LYNX/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Set default password
sed -i '18s/^/# /' package/emortal/default-settings/files/99-default-settings

# Set timezone
sed -i -e "s/CST-8/WIB-7/g" -e "s/Shanghai/Jakarta/g" package/emortal/default-settings/files/99-default-settings-chinese

# Add luci-theme-tano
svn co https://github.com/lynxnexy/luci-theme-tano/trunk feeds/luci/themes/luci-theme-tano

# Add luci-app-3ginfo-lite
svn co https://github.com/4IceG/luci-app-3ginfo-lite/trunk feeds/luci/applications/luci-app-3ginfo-lite

# Add luci-app-modeminfo
# svn co https://github.com/koshev-msk/luci-app-modeminfo/trunk feeds/luci/applications/luci-app-modeminfo

# Add luci-app-mmconfig
# svn co https://github.com/koshev-msk/luci-app-mmconfig/trunk feeds/luci/applications/luci-app-mmconfig

# Add Fibocom L850/L860 scripts
# svn co https://github.com/koshev-msk/xmm-modem/trunk feeds/luci/applications/xmm-modem

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk feeds/luci/applications/luci-app-amlogic

# Add p7zip
svn co https://github.com/hubutui/p7zip-lede/trunk package/utils/p7zip

# Add luci-app-3ginfo-lite
svn co https://github.com/4IceG/luci-app-3ginfo-lite/trunk package/luci-app-3ginfo-lite

# Set preset-clash-core
mkdir -p files/etc/openclash/core
OPENCLASH_MAIN_URL=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-armv8 | awk -F '"' '{print $4}')
CLASH_TUN_URL=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-armv8 | awk -F '"' '{print $4}')
CLASH_GAME_URL=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-armv8 | awk -F '"' '{print $4}')
wget -qO- $OPENCLASH_MAIN_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_GAME_URL | tar xOvz > files/etc/openclash/core/clash_game
chmod +x files/etc/openclash/core/clash*

# Set preset-speedtest
mkdir -p files/bin
wget -qO- https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-aarch64.tgz | tar xOvz > files/bin/speedtest
chmod +x files/bin/speedtest
