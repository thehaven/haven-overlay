# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="SAST tool for detecting and preventing hardcoded secrets"
HOMEPAGE="https://github.com/gitleaks/gitleaks"
SRC_URI="https://github.com/gitleaks/gitleaks/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

src_compile() {
	ego build -ldflags "-s -w -X github.com/zricethezav/gitleaks/v8/version.Version=${PV}" -o ${PN} .
}

src_install() {
	dobin ${PN}
	einstalldocs
}

pkg_postinst() {
	elog "Gitleaks has been installed."
	elog "Basic usage:"
	elog "  gitleaks detect --source /path/to/repo --verbose"
	elog "  gitleaks protect --staged --verbose"
}
