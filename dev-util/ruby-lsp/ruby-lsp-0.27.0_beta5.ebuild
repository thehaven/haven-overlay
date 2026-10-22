# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="An opinionated language server for Ruby"
HOMEPAGE="https://github.com/Shopify/ruby-lsp"

# rubygems publishes prereleases with a dot before the tag (0.27.0.beta5);
# Portage spells the same version with an underscore (0.27.0_beta5). Map
# the PMS version back to the upstream gem name for the download URL.
MY_PV="${PV/_alpha/.alpha}"
MY_PV="${MY_PV/_beta/.beta}"
MY_PV="${MY_PV/_rc/.rc}"
MY_PV="${MY_PV/_pre/.pre}"

SRC_URI="https://rubygems.org/downloads/${PN}-${MY_PV}.gem"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="dev-lang/ruby"
RDEPEND="dev-lang/ruby"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}/" || die
}

src_compile() { :; }

src_install() {
	local inst_dir="/usr/$(get_libdir)/${PN}"

	gem install --no-document \
		--install-dir "${ED}${inst_dir}" \
		--bindir "${ED}${inst_dir}/bin" \
		"${WORKDIR}/${PN}-${MY_PV}.gem" || die

	[[ -f "${ED}${inst_dir}/bin/ruby-lsp" ]] || die "ruby-lsp binary was not created"

	dodir /usr/bin
	cat <<-EOF > "${ED}/usr/bin/ruby-lsp" || die
		#!/bin/sh
		export GEM_HOME="${inst_dir}"
		exec "${inst_dir}/bin/ruby-lsp" "\$@"
	EOF
	fperms +x /usr/bin/ruby-lsp
}

pkg_postinst() {
	einfo "ruby-lsp ${PV}: LSP server for Ruby — works with OpenCode"
	einfo "Binary: /usr/bin/ruby-lsp"
}
