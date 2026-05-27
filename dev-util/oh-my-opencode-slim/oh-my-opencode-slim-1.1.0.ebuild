# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Slim agent harness for OpenCode with TUI and CLI"
HOMEPAGE="https://github.com/alvinunreal/oh-my-opencode-slim"
SRC_URI="https://github.com/alvinunreal/oh-my-opencode-slim/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/oh-my-opencode-slim-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="
	dev-util/opencode
	dev-util/zod
	net-libs/nodejs
"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building oh-my-opencode-slim..."
	bun run build || die
}

src_test() {
	local libdir="$(get_libdir)"
	local node_path="${S}/node_modules:/usr/${libdir}/node_modules"
	NODE_PATH="${node_path}" node -e "require('zod')" \
		|| die "zod peerDependency not found; ensure dev-util/zod is installed"
}

src_install() {
	local libdir="$(get_libdir)"
	insinto "/usr/${libdir}/node_modules/${PN}"
	doins -r dist package.json

	dosym "../${libdir}/node_modules/${PN}/dist/cli/index.js" \
		/usr/bin/oh-my-opencode-slim
	fperms +x "/usr/${libdir}/node_modules/${PN}/dist/cli/index.js"
}

pkg_postinst() {
	einfo "oh-my-opencode-slim installed."
	einfo "Runtime dependencies (@ast-grep/cli, jsdom, etc.) are resolved"
	einfo "at runtime via the opencode plugin system."
}
