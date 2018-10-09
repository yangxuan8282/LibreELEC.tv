# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson_gx_mali_450"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/superna9999/meson_gx_mali_450"
PKG_VERSION="0dd4530" #r7p0
PKG_SHA256=""
PKG_URL="https://github.com/superna9999/meson_gx_mali_450/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="meson_gx_mali_450-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="meson_gx_mali_450: Linux kernel driver for the Mali Utgard GPU in Amlogic Meson SoCs"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  make ARCH=$TARGET_KERNEL_ARCH \
       CROSS_COMPILE=$TARGET_KERNEL_PREFIX \
       KDIR=$(kernel_path) \
       USING_UMP=0 \
       BUILD=release \
       MALI_DMA_BUF_MAP_ON_ATTACH=1 \
       USING_PROFILING=0 \
       MALI_PLATFORM=meson \
       USING_DVFS=0 -C driver/src/devicedrv/mali
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp driver/src/devicedrv/mali/mali.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME/
}
