# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="buffer-from"
inherit npm

DESCRIPTION="A [ponyfill](https://ponyfill.com) for \`Buffer.from\`, uses native implementation if available."
HOMEPAGE="https://github.com/LinusU/buffer-from#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
