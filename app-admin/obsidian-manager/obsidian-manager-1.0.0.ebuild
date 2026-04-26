# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Manager for headless Obsidian instances via systemd"
HOMEPAGE="https://github.com/haven/obsidian-manager"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	|| ( app-editors/obsidian app-editors/obsidian-bin )
	net-misc/kasmvnc-bin
	dev-util/obsidian-mcp
	x11-base/xorg-server[xvfb]
	acct-user/obsidian
	acct-group/obsidian
	app-admin/pass
	dev-lang/python
"

S="${WORKDIR}"

src_install() {
	newbin "${FILESDIR}/obsidian-vault-provision" obsidian-vault-provision
	newbin "${FILESDIR}/obsidian-vault-sync" obsidian-vault-sync
	newbin "${FILESDIR}/obsidian-plugin-update" obsidian-plugin-update
	
	systemd_dounit "${FILESDIR}/obsidian-headless@.service"
	systemd_dounit "${FILESDIR}/obsidian-mcp@.service"
	systemd_dounit "${FILESDIR}/obsidian-sync@.service"
	systemd_dounit "${FILESDIR}/obsidian-sync@.timer"
	
	keepdir /var/lib/obsidian
	keepdir /etc/obsidian/vaults
	
	fowners obsidian:obsidian /var/lib/obsidian
	fowners obsidian:obsidian /etc/obsidian/vaults
	fperms 0750 /var/lib/obsidian
	fperms 0750 /etc/obsidian/vaults
}
