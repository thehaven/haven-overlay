# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gemini CLI - a command-line AI workflow tool by Google"
HOMEPAGE="https://github.com/google-gemini/gemini-cli"

# Starting with v0.40.0 the npm package ships a fully-bundled build
# under bundle/ with zero runtime npm dependencies.  The separate
# gemini-cli-core tarball is no longer needed — core is bundled in.
SRC_URI="
	https://registry.npmjs.org/@google/gemini-cli/-/${P}.tgz
"

S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RDEPEND="
	>=net-libs/nodejs-20
"

src_unpack() {
	# npm tarballs extract to a directory named 'package/'
	unpack "${P}.tgz"
	mv package "${P}" || die
}

src_compile() {
	# Nothing to compile — upstream ships a pre-bundled build.
	:
}

src_install() {
	local LIBDIR="/usr/lib/${P}"

	# Install the self-contained bundle tree
	insinto "${LIBDIR}"
	doins -r bundle
	doins package.json

	# The entry point bundle/gemini.js already carries a shebang
	# (#!/usr/bin/env -S node --no-warnings=DEP0040) but we use a
	# thin wrapper so the path is stable across upgrades.
	cat > "${T}/gemini" <<-EOF
	#!/bin/sh
	exec node --no-warnings=DEP0040 --no-deprecation "${LIBDIR}/bundle/gemini.js" "\$@"
	EOF
	dobin "${T}/gemini"
}

pkg_postinst() {
	elog "Gemini CLI has been installed to /usr/bin/gemini."
	elog ""
	elog "Starting with v0.40.0, all dependencies are pre-bundled."
	elog "No npm network access is required at install time."
	elog ""
	elog "On first run, 'gemini' will prompt you to authenticate with Google."
}
