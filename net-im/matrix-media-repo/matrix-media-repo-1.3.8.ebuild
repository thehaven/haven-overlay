# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline systemd tmpfiles

DESCRIPTION="Matrix media repository with multi-domain in mind"
HOMEPAGE="https://github.com/turt2live/matrix-media-repo"
SRC_URI="https://github.com/turt2live/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="postgres s3"

DEPEND="acct-user/matrix-media-repo acct-group/matrix-media-repo"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w" -o media_repo ./cmd/media_repo
}

src_install() {
	newbin media_repo matrix-media-repo
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles
}
