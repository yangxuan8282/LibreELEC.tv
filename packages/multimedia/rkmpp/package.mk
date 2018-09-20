# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkmpp"
PKG_VERSION="15e357ffd0c98e3099be81eb91b4a48cf8db78a7"
PKG_SHA256="b919e2ffafbfeb38a53765d684bb9e16d9c41a0408ce0c72c567c99ae329593b"
PKG_ARCH="arm aarch64"
PKG_LICENSE="APL"
PKG_SITE="https://github.com/rockchip-linux/mpp"
PKG_URL="https://github.com/rockchip-linux/mpp/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="mpp-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_SECTION="multimedia"
PKG_SHORTDESC="rkmpp: Rockchip Media Process Platform (MPP) module"
PKG_LONGDESC="rkmpp: Rockchip Media Process Platform (MPP) module"

if [ "$DEVICE" = "RK3328" -o "$DEVICE" = "RK3399" ]; then
  PKG_ENABLE_VP9D="ON"
else
  PKG_ENABLE_VP9D="OFF"
fi

PKG_CMAKE_OPTS_TARGET="-DRKPLATFORM=ON \
                       -DENABLE_VP9D=$PKG_ENABLE_VP9D \
                       -DHAVE_DRM=ON"
