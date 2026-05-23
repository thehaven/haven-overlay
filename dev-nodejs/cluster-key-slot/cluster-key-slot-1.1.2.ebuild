# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="cluster-key-slot"

inherit npm

DESCRIPTION="Generates CRC hashes for strings - for use by node redis clients to determine key slots."
HOMEPAGE="https://github.com/Salakar/cluster-key-slot#readme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
