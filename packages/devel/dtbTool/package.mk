PKG_NAME="dtbTool"
PKG_VERSION="1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD-3-Clause"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="Amlogic DTB combiner."
PKG_LONGDESC="Combines DTBs into Amlogic's multi-DTB format."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

makeinstall_host() {
    mkdir -p "$ROOT/$TOOLCHAIN/bin"
    cp -a "$ROOT/$PKG_BUILD/dtbTool" "$ROOT/$TOOLCHAIN/bin/"
}
