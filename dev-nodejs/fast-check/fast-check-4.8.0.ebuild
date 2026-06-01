# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fast-check"
inherit npm

DESCRIPTION="Property based testing framework for JavaScript (like QuickCheck)"
HOMEPAGE="https://fast-check.dev/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/pure-rand
"
BDEPEND="${RDEPEND}"
