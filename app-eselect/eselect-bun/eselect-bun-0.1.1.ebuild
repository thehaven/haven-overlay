# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage active Bun JavaScript runtime and package manager version"
HOMEPAGE="https://bun.sh"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=app-admin/eselect-1.2.4"

src_install() {
	insinto /usr/share/eselect/modules
	doins "${FILESDIR}/bun.eselect"
}
