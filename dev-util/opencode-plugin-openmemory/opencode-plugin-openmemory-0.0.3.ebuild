# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@happycastle/opencode-openmemory"
NPM_FILES="dist package.json"
inherit npm

DESCRIPTION="OpenCode plugin that gives coding agents persistent memory using OpenMemory"
HOMEPAGE="https://github.com/happycastle114/opencode-openmemory"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"
