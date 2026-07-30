# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="GitLab CI templates for Renovate"
HOMEPAGE="https://gitlab.com/renovate-bot/renovate-runner"
S="${WORKDIR}/renovate-runner-v${PV}"
SRC_URI="https://gitlab.com/renovate-bot/renovate-runner/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"

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
	elog "Renovate GitLab CI templates have been installed to:"
	elog "  /usr/share/${PN}"
	elog ""
	elog "To use these in your .gitlab-ci.yml, you can include them:"
	elog "  include:"
	elog "    - local: /usr/share/${PN}/templates/renovate.gitlab-ci.yml"
	elog ""
	elog "Note: For self-hosted runners, ensure the renovate binary is in the PATH."
}
