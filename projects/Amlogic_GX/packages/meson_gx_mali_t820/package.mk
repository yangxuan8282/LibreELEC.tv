# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson_gx_mali_t820"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/chewitt/meson_gx_mali_t820"
PKG_VERSION="7ca4d0160148f311fef583b881a3943814341abf" #r26p0
PKG_SHA256=""
PKG_URL="https://github.com/chewitt/meson_gx_mali_t820/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="meson_gx_mali_t820-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_LONGDESC="meson_gx_mali_450: Linux drivers for Mali GPUs found in Amlogic Meson SoCs"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  DRIVER_DIR=$PKG_BUILD/driver/product/kernel/drivers/gpu/arm/midgard/

  make ARCH=$TARGET_KERNEL_ARCH CROSS_COMPILE=$TARGET_KERNEL_PREFIX KDIR=$(kernel_path) \
       CONFIG_MALI_MIDGARD=m \
       CONFIG_MALI_PLATFORM_NAME=meson \
       EXTRA_CFLAGS="-DCONFIG_MALI_MIDGARD=m \
                     -DCONFIG_MALI_PLATFORM_NAME=meson" -C $DRIVER_DIR
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp $DRIVER_DIR/mali_kbase.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME/
}
