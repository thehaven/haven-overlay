# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Vulnerability scanner for container images and filesystems"
HOMEPAGE="https://github.com/anchore/grype"
SRC_URI="https://github.com/anchore/grype/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

src_compile() {
	ego build -ldflags "-s -w -X main.version=${PV}" -o bin/${PN} ./cmd/grype
}

src_install() {
	dobin bin/${PN}
	einstalldocs
}

pkg_postinst() {
	elog "Grype has been installed."
	elog "To scan an image:"
	elog "  grype <image-name>"
}
