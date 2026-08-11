# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_AUTO_BIN=1
NPM_MODULE="svelte-language-server"
inherit npm

DESCRIPTION="A language server for Svelte"
HOMEPAGE="https://www.npmjs.com/package/svelte-language-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	npm_src_install

	# Smoke test: verify the bin symlink was created (bin name is
	# "svelteserver" per package.json, not "svelte-language-server")
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/svelteserver" ]] || \
		die "NPM_AUTO_BIN did not create /usr/bin/svelteserver"
}
