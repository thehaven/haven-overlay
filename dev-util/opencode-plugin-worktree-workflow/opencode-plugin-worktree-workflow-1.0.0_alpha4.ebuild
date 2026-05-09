# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for git worktree lifecycle management"
HOMEPAGE="https://github.com/kdcokenny/opencode-worktree"
SRC_URI="https://github.com/kdcokenny/opencode-worktree/archive/refs/heads/main.tar.gz -> opencode-worktree-main.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode dev-vcs/git"

S="${WORKDIR}/opencode-worktree-main"

src_compile() {
	# No build script, no package.json in root (based on earlier ls)
	# It's a collection of .ts files in src/plugin
	einfo "Source contains .ts files only. Installing as-is."
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r src
}

pkg_postinst() {
	einfo "opencode-worktree-workflow installed."
	einfo "Note: This plugin appears to be source-only (TypeScript)."
	einfo "OpenCode may need to be configured to load .ts files via bun."
}
