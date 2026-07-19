# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Self-hosted audiobook and podcast server"
HOMEPAGE="https://github.com/advplyr/audiobookshelf"
SRC_URI="
	https://github.com/advplyr/audiobookshelf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/audiobookshelf-client-node_modules-${PV}.tar.xz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/audiobookshelf-server-node_modules-${PV}.tar.xz
"

S="${WORKDIR}/${P}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/audiobookshelf
	acct-user/audiobookshelf
	net-libs/nodejs
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	net-libs/nodejs
"

src_unpack() {
	# Extract source
	unpack ${P}.tar.gz

	# Extract client node_modules
	mkdir -p "${S}/client" || die
	cd "${S}/client" || die
	unpack audiobookshelf-client-node_modules-${PV}.tar.xz

	# Extract server node_modules
	cd "${S}" || die
	unpack audiobookshelf-server-node_modules-${PV}.tar.xz
}

src_prepare() {
	default
	# Prepend shebang to index.js to allow running it directly
	sed -i "1i#!/usr/bin/env node" index.js \
		|| die "failed to add shebang to index.js"

	# Fix buffer-equal-constant-time for Node.js v26+ which removed SlowBuffer.
	# Affects both the node_modules copy and the upstream-vendored copy.
	local p="s/var SlowBuffer = require('buffer').SlowBuffer;"
	p+="/var SlowBuffer = require('buffer').SlowBuffer || { prototype: {} };/"
	sed -i "$p" \
		node_modules/buffer-equal-constant-time/index.js \
		server/libs/jwa/buffer-equal-constant-time/index.js \
		|| die "failed to patch buffer-equal-constant-time"
}

src_compile() {
	cd "${S}" || die

	# Fix sqlite3 bindings path for the current node ABI
	# The sqlite3 binary is pre-built in the vendor tarball
	local node_abi="node-v$(node -p process.versions.modules)-linux-x64"
	local sqlite3_binding="node_modules/sqlite3/lib/binding/${node_abi}/node_sqlite3.node"
	mkdir -p "$(dirname "${sqlite3_binding}")" || die
	cp node_modules/sqlite3/build/Release/node_sqlite3.node "${sqlite3_binding}" \
		|| die "failed to copy sqlite3 binding"

	cd "${S}/client" || die
	npm run generate || die "failed to generate client static files"
}

src_install() {
	local mod_dir="/usr/$(get_libdir)/node_modules/audiobookshelf"
	insinto "${mod_dir}"
	doins index.js prod.js package.json
	doins -r server
	doins -r node_modules

	# Install compiled client static assets
	insinto "${mod_dir}/client"
	doins -r client/dist

	# Install systemd service and configuration files
	insinto /etc
	doins "${FILESDIR}/audiobookshelf.conf"
	systemd_dounit "${FILESDIR}/audiobookshelf.service"

	# Install entry binary symlink
	fperms +x "${mod_dir}/index.js"
	dosym "../../$(get_libdir)/node_modules/audiobookshelf/index.js" \
		"/usr/bin/audiobookshelf"

	# Create state, config, metadata directories with correct ownership
	keepdir /var/lib/audiobookshelf
	keepdir /var/log/audiobookshelf

	fowners -R audiobookshelf:audiobookshelf /var/lib/audiobookshelf
	fowners -R audiobookshelf:audiobookshelf /var/log/audiobookshelf
}
