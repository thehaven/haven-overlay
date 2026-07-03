# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Language Server for Terraform files, providing LSP support in opencode"
HOMEPAGE="https://github.com/hashicorp/terraform-ls"

BASE_URI="https://releases.hashicorp.com/terraform-ls/${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/terraform-ls_${PV}_linux_amd64.zip -> ${P}-linux-amd64.zip )
	arm64? ( ${BASE_URI}/terraform-ls_${PV}_linux_arm64.zip -> ${P}-linux-arm64.zip )
"

S="${WORKDIR}"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror strip"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/terraform-ls"

src_install() {
	dobin terraform-ls
}

pkg_postinst() {
	einfo "terraform-ls ${PV} installed."
	einfo "opencode will auto-detect terraform-ls and use it as the LSP server for .tf files."
	einfo ""
	einfo "terraform fmt (formatter for .tf/.tfvars) requires a separate terraform or opentofu binary:"
	einfo "  emerge app-admin/terraform   (HashiCorp Terraform)"
	einfo "  emerge app-admin/opentofu    (OpenTofu fork)"
}
