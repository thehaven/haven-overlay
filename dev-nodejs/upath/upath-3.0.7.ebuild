# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="upath"
inherit npm

DESCRIPTION="A drop-in replacement / proxy to Node.js path, replacing \\\\ with / for all results & adding file extension functions."
HOMEPAGE="https://github.com/anodynos/upath/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
