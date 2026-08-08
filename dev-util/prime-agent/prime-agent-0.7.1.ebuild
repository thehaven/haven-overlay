# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Self-improving RLM agent for coding workflows and autonomous tasks"
HOMEPAGE="https://github.com/PrimeIntellect-ai/prime-agent"
SRC_URI="https://github.com/PrimeIntellect-ai/prime-agent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0 ISC BSD MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Network is ALLOWED here (this value disables the default global
# FEATURES=network-sandbox namespace for this package): `npm ci` fetches the
# workspace dependency tree and the packages/ai "generate-models" build step
# pulls model lists from upstream APIs.
RESTRICT="network-sandbox"

RDEPEND="
	>=net-libs/nodejs-24
	dev-python/uv
	dev-vcs/git
"
BDEPEND=">=net-libs/nodejs-24[npm]"

src_compile() {
	# npm workspaces monorepo (packages/{ai,agent,coding-agent,tui}).
	# --ignore-scripts skips husky (root prepare) and the coding-agent
	# postinstall, which is a no-op before the build anyway. The build
	# compiles the four workspaces with tsgo, then esbuild-bundles the
	# `pi` CLI entry (packages/coding-agent/dist/bundle/cli.js).
	npm ci --ignore-scripts || die "npm ci failed"
	npm run build || die "npm run build failed"
}

src_install() {
	local module_dir="/usr/$(get_libdir)/node_modules/${PN}"

	# Install the whole build tree (packages with built dist/, hoisted
	# node_modules incl. native zeromq/koffi addons and workspace symlinks,
	# bundled prime-agent-runtime Python shim, skills).
	insinto "${module_dir}"
	doins -r .

	# Wrapper for the bundled CLI entry (upstream npm bin is `pi`, which is
	# too generic for /usr/bin; upstream's own installer uses `prime-agent`).
	dodir /usr/bin
	cat > "${D}/usr/bin/prime-agent" <<-EOF
	#!/bin/sh
	exec node "${module_dir}/packages/coding-agent/dist/bundle/cli.js" "\$@"
	EOF
	fperms +x /usr/bin/prime-agent

	einstalldocs
}
