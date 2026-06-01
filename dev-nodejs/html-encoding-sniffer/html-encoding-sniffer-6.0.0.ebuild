# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="html-encoding-sniffer"
inherit npm

DESCRIPTION="Sniff the encoding from a HTML byte stream"
HOMEPAGE="https://github.com/jsdom/html-encoding-sniffer#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/exodus-bytes
"
BDEPEND="${RDEPEND}"
