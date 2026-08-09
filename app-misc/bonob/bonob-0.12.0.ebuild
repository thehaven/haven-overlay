# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sonos SMAPI bridge for Subsonic-API music servers (Node/TypeScript)"
HOMEPAGE="https://github.com/simojenki/bonob"
# Single-package TypeScript project; not on the npm registry. The repo
# tags releases without publishing tarballs, so build from the GitHub tag
# archive (`archive/refs/tags/...` extracts to `<repo>-<ver>/` without the
# `v` prefix — verified empirically on the prime-agent pattern).
SRC_URI="https://github.com/simojenki/bonob/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# sharp (image processing, runtime dep) needs libvips. The canonical Gentoo atom is
# media-libs/libvips (this host's pruned ::gentoo tree may not carry it; see packages.gentoo.org).
# No declared
# `engines` in package.json; CI runs Node 22 — that is the floor.
RDEPEND="
	>=net-libs/nodejs-22
	media-libs/libvips
"
BDEPEND=">=net-libs/nodejs-22[npm]"

# npm ci fetches the registry during src_compile: with the default
# network-sandbox namespace disabled, the build has no connectivity, so
# this value OPENS network for this package (per `man 5 ebuild`). Tests
# require a Sonos device + a Subsonic-API server; the sandbox is not
# safe to run them in CI without fixtures.
RESTRICT="network-sandbox test"

# npm deps ship prebuilt .node addons (sharp's @img/sharp-linux-x64 binary,
# plus xmllint-wasm etc.). The x64 build is the one used on amd64.
QA_PREBUILT="*"

src_compile() {
	# Full install incl. dev deps so `tsc` (typescript) is available.
	npm ci --ignore-scripts --no-audit --no-fund || die
	npm run build || die
	# Prune devDependencies; optionalDependencies (sharp's platform binary,
	# xmllint-wasm) stay installed.
	npm prune --omit=dev || die
	# Co-locate runtime resources with the compiled output: tsc only emits
	# .js/.d.ts. The app reads web/ and the WSDL relative to its own
	# __dirname (build/src/), so they must live in build/web/ and
	# build/src/ respectively.
	cp -r web build/ || die
	cp src/*.wsdl build/src/ || die
}

src_install() {
	local libdir
	libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${PN}"

	# Compiled output and package metadata.
	insinto "${module_dir}"
	doins -r build package.json

	# Production-only dependency tree (sharp's platform binary lives here).
	cp -a node_modules "${D}${module_dir}/" || die

	# Prune musl/Alpine variants of sharp — sharp ships glibc + musl
	# builds for every platform; on glibc Gentoo only the linux-x64
	# variants are loadable, the rest are dead weight and produce QA
	# soname warnings.
	rm -rf "${D}${module_dir}/node_modules/@img/"*musl*

	dodoc LICENSE README.md

	# Launcher: cd into the module dir so relative paths (WSDL, web/)
	# resolve correctly regardless of the caller's cwd.
	dodir /usr/bin
	cat > "${D}/usr/bin/bonob" <<-EOF
		#!/bin/sh
		cd "${module_dir}"
		exec node build/src/app.js "\$@"
	EOF
	fperms +x /usr/bin/bonob
}

pkg_postinst() {
	einfo "bonob is the Sonos SMAPI bridge for Subsonic-API music servers."
	einfo "Configure via env vars (BNB_URL, BNB_SECRET, BNB_SUBSONIC_URL, BNB_PORT=4534)"
	einfo "and start it with: bonob"
	einfo "See https://github.com/simojenki/bonob for full configuration."
}
