# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_AUTO_BIN=1
NPM_MODULE="@vue/language-server"
inherit npm

DESCRIPTION="Vue language server"
HOMEPAGE="https://www.npmjs.com/package/@vue/language-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	npm_src_install

	# Smoke test: verify the bin symlink was created
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/vue-language-server" ]] || \
		die "NPM_AUTO_BIN did not create /usr/bin/vue-language-server"
}
