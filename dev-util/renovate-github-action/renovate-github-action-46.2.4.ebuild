# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="GitHub Action for Renovate"
HOMEPAGE="https://github.com/renovatebot/github-action"
S="${WORKDIR}/github-action-${PV}"
SRC_URI="https://github.com/renovatebot/github-action/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-util/renovate"

src_install() {
	insinto /usr/share/${PN}
	doins -r .
	einstalldocs
}

pkg_postinst() {
	elog "Renovate GitHub Action templates have been installed to:"
	elog "  /usr/share/${PN}"
	elog ""
	elog "You can reference these in your local GitHub Actions runner or copy"
	elog "the relevant workflow files to your repository's .github/workflows/ directory."
}
