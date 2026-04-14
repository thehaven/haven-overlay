# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="cli-${PV}"

DESCRIPTION="AI-native open-source vector database for embeddings"
HOMEPAGE="https://www.trychroma.com https://github.com/chroma-core/chroma"
SRC_URI="
	amd64? ( https://github.com/chroma-core/chroma/releases/download/${MY_PV}/chroma-linux -> ${P}-amd64 )
"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/chroma"

src_unpack() {
	# Single binary, no archive to extract
	cp "${DISTDIR}/${P}-amd64" "${WORKDIR}/chroma" || die
}

src_install() {
	exeinto /usr/bin
	newexe chroma chroma
}

pkg_postinst() {
	einfo "ChromaDB vector database installed."
	einfo ""
	einfo "Quick start:"
	einfo "  chroma run --path /var/lib/chroma"
	einfo ""
	einfo "API: http://localhost:8000"
	einfo "See https://docs.trychroma.com/ for documentation."
}
