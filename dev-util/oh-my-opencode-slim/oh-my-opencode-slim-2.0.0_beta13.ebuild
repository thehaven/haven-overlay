# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="Slim agent harness for OpenCode with TUI and CLI"
HOMEPAGE="https://github.com/alvinunreal/oh-my-opencode-slim"
SRC_URI="https://github.com/alvinunreal/${PN}/archive/refs/tags/v${PV/_beta/-beta.}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

RDEPEND="
        dev-util/zod
        net-libs/nodejs
"
# Runtime deps (jsdom, @opencode-ai/*, opentui-*) come from bun install
# in src_compile (source-based resolution).
BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"

S="${WORKDIR}/${PN}-${PV/_beta/-beta.}"

src_compile() {
        # Source-based deps (replaces the former MY_NODE_D mirror tarball).
        rm -f package-lock.json
        bun install --ignore-scripts || die "bun install failed"
        bun run build || die
}

src_test() {
        local libdir="$(get_libdir)"
        local node_path="${WORKDIR}/node_modules:/usr/${libdir}/node_modules"
        NODE_PATH="${node_path}" node -e "require('zod')" \
                || die "zod peerDependency not found; ensure dev-util/zod is installed"
}

src_install() {
        local libdir="$(get_libdir)"
        insinto "/usr/${libdir}/node_modules/${PN}"
        doins -r dist package.json node_modules

        # CLI entry point
        fperms +x "/usr/${libdir}/node_modules/${PN}/dist/cli/index.js"
        dosym "../${libdir}/node_modules/${PN}/dist/cli/index.js" \
                "/usr/bin/oh-my-opencode-slim"
}

pkg_postinst() {
        einfo "oh-my-opencode-slim installed."
        einfo "To use this plugin, add it to your opencode.json:"
        einfo "  \"/usr/\$(get_libdir)/node_modules/\${PN}/dist/index.js\""
}
