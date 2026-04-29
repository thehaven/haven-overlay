# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-module-offline.eclass
# @MAINTAINER:
# Haven Overlay Maintainers
# @AUTHOR:
# Haven Overlay
# @BLURB: Wrapper around go-module to enforce offline builds
# @DESCRIPTION:
# Sets RESTRICT="network-sandbox" or ensures vendor tarball is used.

if [[ -z ${_GO_MODULE_OFFLINE_ECLASS} ]]; then
_GO_MODULE_OFFLINE_ECLASS=1

inherit go-module

go-module-offline_src_unpack() {
    go-module_src_unpack
}

EXPORT_FUNCTIONS src_unpack

fi
