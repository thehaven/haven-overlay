# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manager for headless Obsidian instances via systemd"
HOMEPAGE="https://github.com/haven/obsidian-manager"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-editors/obsidian-bin
	x11-base/xorg-server[xvfb]
	acct-user/obsidian
	acct-group/obsidian
"

S="${WORKDIR}"

src_install() {
	newbin "${FILESDIR}/obsidian-vault-provision" obsidian-vault-provision
	
	systemd_dounit "${FILESDIR}/obsidian-headless@.service"
	
	keepdir /var/lib/obsidian
	fowners obsidian:obsidian /var/lib/obsidian
	fperms 0750 /var/lib/obsidian
}
