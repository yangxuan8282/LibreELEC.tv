# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="autoscript-amlogic"
PKG_VERSION="0.1"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"

make_target() {
  for src in $PKG_DIR/scripts/*autoscript.src ; do
    $TOOLCHAIN/bin/mkimage -A $TARGET_KERNEL_ARCH -O linux -T script -C none -d "$src" "$(basename $src .src)" > /dev/null
  done
  for src in $PKG_DIR/instboot/*.ini ; do
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i "$src"
  done
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  cp -a $PKG_BUILD/*autoscript $INSTALL/usr/share/bootloader/
  cp -a $PKG_DIR/instboot/*.zip $INSTALL/usr/share/bootloader/
  cp -a $PKG_DIR/instboot/*.sh $INSTALL/usr/share/bootloader/
  cp -a $PKG_DIR/instboot/*.ini $INSTALL/usr/share/bootloader/
}
