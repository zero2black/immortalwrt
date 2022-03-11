#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: 21.02
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
#sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
#sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# change ssid
sed -i "s/OpenWrt/LYNX/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# change timezone
sed -i -e "s/CST-8/WIB-7/g" -e "s/Shanghai/Jakarta/g" package/emortal/default-settings/files/99-default-settings-chinese

# Add luci-app-3ginfo-lite
svn co https://github.com/4IceG/luci-app-3ginfo-lite/trunk package/luci-app-3ginfo-lite

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='openwrt'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk package/luci-app-amlogic

# Add p7zip
svn co https://github.com/hubutui/p7zip-lede/trunk package/lean/p7zip

# Add luci-app-3ginfo-lite
svn co https://github.com/4IceG/luci-app-3ginfo-lite/trunk package/luci-app-3ginfo-lite

# preset-clash-core
mkdir -p files/etc/openclash/core
OPENCLASH_MAIN_URL=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-armv8 | awk -F '"' '{print $4}')
CLASH_TUN_URL=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-armv8 | awk -F '"' '{print $4}')
CLASH_GAME_URL=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-armv8 | awk -F '"' '{print $4}')
wget -qO- $OPENCLASH_MAIN_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_GAME_URL | tar xOvz > files/etc/openclash/core/clash_game
chmod +x files/etc/openclash/core/clash*

# Add autocore
# svn co https://github.com/ophub/amlogic-s9xxx-openwrt/trunk/amlogic-s9xxx/common-files/patches/autocore package/lean/autocore

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
