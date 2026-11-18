# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun systemd

DESCRIPTION="Self-hosted audiobook and podcast server"
HOMEPAGE="https://github.com/advplyr/audiobookshelf"
SRC_URI="https://github.com/advplyr/audiobookshelf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

RDEPEND="
	acct-group/audiobookshelf
	acct-user/audiobookshelf
	net-libs/nodejs
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	net-libs/nodejs[npm]
	sys-devel/gcc
	dev-lang/python
"

src_prepare() {
	default
	# Prepend shebang to index.js to allow running it directly
	sed -i "1i#!/usr/bin/env node" index.js \
		|| die "failed to add shebang to index.js"

	# Fix buffer-equal-constant-time for Node.js v26+ which removed SlowBuffer
	# (upstream-vendored copy; the node_modules copy is patched in src_compile
	# after bun install).
	local p="s/var SlowBuffer = require('buffer').SlowBuffer;"
	p+="/var SlowBuffer = require('buffer').SlowBuffer || { prototype: {} };/"
	sed -i "$p" \
		server/libs/jwa/buffer-equal-constant-time/index.js \
		|| die "failed to patch buffer-equal-constant-time"
}

src_compile() {
	cd "${S}" || die

	# Server deps from source (replaces the server node_modules tarball).
	rm -f package-lock.json
	bun install --ignore-scripts || die "bun install failed"

	# Patch the installed buffer-equal-constant-time copy (SlowBuffer fix).
	local p="s/var SlowBuffer = require('buffer').SlowBuffer;"
	p+="/var SlowBuffer = require('buffer').SlowBuffer || { prototype: {} };/"
	sed -i "$p" node_modules/buffer-equal-constant-time/index.js \
		|| die "failed to patch node_modules buffer-equal-constant-time"

	# Compile the sqlite3 native binding for the current node ABI
	# (bun install --ignore-scripts skips its postinstall).
	npm rebuild sqlite3 || die "npm rebuild sqlite3 failed"

	# Client static assets from source (replaces the client tarball).
	cd "${S}/client" || die
	rm -f package-lock.json
	bun install --ignore-scripts || die "client bun install failed"
	bun run generate || die "failed to generate client static files"
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
