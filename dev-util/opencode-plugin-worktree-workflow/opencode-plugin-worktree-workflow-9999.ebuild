# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="OpenCode plugin for git worktree lifecycle management"
HOMEPAGE="https://github.com/kdcokenny/opencode-worktree"
EGIT_REPO_URI="https://github.com/kdcokenny/opencode-worktree.git"

LICENSE="MIT"
S="${WORKDIR}/${P}"

SLOT="0"


RESTRICT="test"

RDEPEND="
	dev-util/opencode
	dev-vcs/git
"

src_compile() {
	# No build script, no package.json in root
	# It's a collection of .ts files in src/plugin
	einfo "Source contains .ts files only. Installing as-is."
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r src
}

pkg_postinst() {
	einfo "opencode-worktree-workflow installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/src/plugin/worktree.ts\""
}
