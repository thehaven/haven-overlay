# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Obsidian plugin for Paperclip AI orchestration"
HOMEPAGE="https://github.com/istib/obsidian-paperclip"
SRC_URI="https://github.com/istib/obsidian-paperclip/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="
	>=net-libs/nodejs-20[npm]
"
RDEPEND="
	>=net-libs/nodejs-20
	app-misc/paperclipai
"

src_compile() {
	npm install || die
	npm run build || die
}

src_install() {
	insinto /opt/obsidian-plugins/obsidian-paperclip
	doins main.js manifest.json styles.css
	einstalldocs
}

pkg_postinst() {
	elog "To use this plugin in Obsidian:"
	elog "1. Open your vault's plugins folder."
	elog "2. Symlink the plugin: ln -s /opt/obsidian-plugins/obsidian-paperclip .obsidian/plugins/obsidian-paperclip"
	elog "3. Enable 'Paperclip' in Obsidian settings."
}
