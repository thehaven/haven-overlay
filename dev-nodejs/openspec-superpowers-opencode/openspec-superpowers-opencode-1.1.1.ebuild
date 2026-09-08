# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@moyaspace/openspec-superpowers-opencode"
NPM_AUTO_BIN=1
inherit npm

DESCRIPTION="Bridges Superpowers + OpenSpec workflows into OpenCode with worktree isolation"
HOMEPAGE="https://github.com/moyaspace/openspec-superpowers-opencode"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

# Pure Node.js CLI with zero runtime npm dependencies. The package.json
# `install` script (scripts/shims-installer.js) is a convenience for the
# npm-global install path and is not run here — inherit npm extracts the
# tarball without invoking npm, and NPM_AUTO_BIN creates the /usr/bin
# symlinks (oso, openspec-superpowers-opencode, create-openspec-superpowers-opencode)
# from the package.json bin field.
