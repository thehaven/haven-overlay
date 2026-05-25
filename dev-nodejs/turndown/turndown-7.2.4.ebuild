# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="turndown"
inherit npm

DESCRIPTION="A library that converts HTML to Markdown"
HOMEPAGE="https://github.com/mixmark-io/turndown#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mixmark-io-domino
"
BDEPEND="${RDEPEND}"
