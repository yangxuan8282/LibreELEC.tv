# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

if [ "$1" = "KVIM2.aarch64" ] || [ "$1" = "KVIM2.arm" ]; then
  exit 0
else
  exit 1
fi
