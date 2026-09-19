# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CLI code generator for schema-to-code translation (CUE, JSON Schema, OpenAPI)"
HOMEPAGE="https://github.com/grafana/cog"
SRC_URI="https://github.com/grafana/cog/releases/download/v${PV}/cog_Linux_x86_64.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="usr/bin/cog"

src_install() {
	dobin cog
	fperms 0755 /usr/bin/cog
}

pkg_postinst() {
	elog "cog ${PV} installed."
	elog "Usage: cog generate --help"
	elog "Docs: https://github.com/grafana/cog"
}
