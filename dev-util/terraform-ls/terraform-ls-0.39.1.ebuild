# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terraform Language Server"
HOMEPAGE="https://github.com/hashicorp/terraform-ls"
SRC_URI="https://releases.hashicorp.com/${PN}/${PV}/${PN}_${PV}_linux_amd64.zip"

S="${WORKDIR}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"
RDEPEND=""

QA_PREBUILT="usr/bin/terraform-ls"

src_install() {
	dobin terraform-ls
	dodoc LICENSE.txt
}
