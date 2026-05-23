# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ecdsa-sig-formatter"

inherit npm

DESCRIPTION="Translate ECDSA signatures between ASN.1/DER and JOSE-style concatenation"
HOMEPAGE="https://github.com/Brightspace/node-ecdsa-sig-formatter#readme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/safe-buffer
"
BDEPEND="${RDEPEND}"
