# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Prime Agent: self-improving RLM coding and research agent"
HOMEPAGE="https://github.com/PrimeIntellect-ai/prime-agent"
# npm-workspaces monorepo; the CLI (packages/coding-agent) is bundled with
# esbuild but imports ~20 external runtime packages (chalk, zeromq,
# @earendil-works/pi-*, ...), so the production dependency tree must be
# installed alongside dist/. The repo is not on the npm registry; the
# release assets are produced by scripts/release.mjs from this source.
SRC_URI="https://github.com/PrimeIntellect-ai/prime-agent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/prime-agent-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# npm ci fetches from the registry during src_compile: with the default
# network-sandbox namespace this build would have no connectivity, so the
# value OPENS network for this package (per man 5 ebuild); the build is
# otherwise fully offline and deterministic via the in-repo lockfile.
# Bun is NOT used: bun 1.3.x cannot migrate this npm lockfile and its stash
# layout does not hoist transitive deps (@smithy/*), breaking tsgo builds.
RESTRICT="network-sandbox test"

# npm deps (zeromq, koffi, ...) ship prebuilt .node addons for multiple
# platforms; the x64 one is the one used on amd64.
QA_PREBUILT="*"

# package.json engines: node >=22.8.0; npm is needed for ci/build scripts
RDEPEND=">=net-libs/nodejs-22.8.0"
BDEPEND=">=net-libs/nodejs-22.8.0[npm]"

src_compile() {
	# Full install (incl. dev deps) for the build...
	npm ci --ignore-scripts --no-audit --no-fund || die
	# ...builds all four workspaces (tui, ai, agent, coding-agent) and
	# bundles dist/bundle/cli.js in packages/coding-agent.
	npm run build || die
	# Reinstall production-only: the built bundle only needs runtime deps;
	# drop build tooling (tsgo, esbuild, typescript, ...) from the tree.
	rm -rf node_modules || die
	npm ci --omit=dev --ignore-scripts --no-audit --no-fund || die
}

src_install() {
	local libdir
	libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${PN}"

	# Main package: the equivalent of the released npm tarball.
	insinto "${module_dir}"
	doins -r packages/coding-agent/dist
	doins packages/coding-agent/package.json packages/coding-agent/postinstall.cjs
	dodoc packages/coding-agent/CHANGELOG.md packages/coding-agent/README.md

	# Runtime dependency tree (production-only). node_modules/ contains
	# relative symlinks to the workspace packages, so packages/ must be
	# installed alongside it for those links to resolve.
	cp -a node_modules "${D}${module_dir}/" || die
	insinto "${module_dir}/packages"
	doins -r packages/tui packages/ai packages/agent packages/coding-agent

	# Prune foreign-platform native addons (koffi/zeromq ship builds for
	# every OS/arch); keep linux x64 glibc only.
	rm -rf "${D}${module_dir}/node_modules/koffi/build/koffi"/{darwin_*,freebsd_*,openbsd_*,win32_*,musl_*,linux_arm*,linux_ia32,linux_loong*,linux_riscv*}
	rm -rf "${D}${module_dir}/node_modules/zeromq/build"/{darwin,win32}
	rm -rf "${D}${module_dir}/node_modules/zeromq/build/linux/arm64"
	rm -rf "${D}${module_dir}"/node_modules/zeromq/build/linux/x64/node/musl-*

	# Direct symlink (no npm shim): the target must be executable
	fperms +x "${module_dir}/dist/bundle/cli.js"
	dosym "../../${libdir}/node_modules/${PN}/dist/bundle/cli.js" /usr/bin/prime-agent
}

# The agent bootstraps its own IPython kernel (ipykernel + the
# dev-python/prime-agent-runtime shim) into ~/.prime/agent/kernel-venv via uv
# on first run; it never consumes system Python packages.
pkg_postinst() {
	einfo "Prime Agent bootstraps its IPython kernel (uv-managed venv) on first run."
	einfo "Start it from the repository/directory you want it to work in:"
	einfo "  cd /path/to/project && prime-agent"
	einfo "First launch: /login to choose a subscription or API-key provider."
}
