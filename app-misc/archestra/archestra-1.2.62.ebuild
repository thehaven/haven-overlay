# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit python-single-r1

DESCRIPTION="Archestra AI platform — migration kit for existing AI pilots"
HOMEPAGE="https://github.com/archestra-ai/archestra"
SRC_URI="https://github.com/archestra-ai/archestra/archive/refs/tags/platform-v${PV}.tar.gz -> ${P}.tar.gz"

# Upstream extracts into archestra-platform-v${PV}/
S="${WORKDIR}/archestra-platform-v${PV}/migration-kit"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="${PYTHON_DEPS}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	# Install migration-kit scripts to /usr/share
	local kitdir="/usr/share/${PN}"
	insinto "${kitdir}"
	doins install.py
	doins -r scripts/

	# Install documentation
	einstalldocs
	dodoc SKILL.md
	dodoc -r references/

	# Wrapper symlink for the main installer
	dosym "${kitdir}/install.py" "/usr/bin/${PN}-migrate"
	fperms 0755 "${kitdir}/install.py"
}
