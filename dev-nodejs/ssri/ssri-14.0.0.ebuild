# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ssri"

inherit npm

DESCRIPTION="Standard Subresource Integrity library -- parses, serializes, generates, and verifies integrity metadata according to the SRI spec."
HOMEPAGE="https://github.com/npm/ssri#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minipass
"
BDEPEND="${RDEPEND}"
