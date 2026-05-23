# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-factory-space"
inherit npm

DESCRIPTION="micromark factory to parse markdown space (found in lots of places)"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-types
"
BDEPEND="${RDEPEND}"
