# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-supermemory"
inherit npm

DESCRIPTION="OpenCode plugin that gives coding agents persistent memory using Supermemory"
HOMEPAGE="https://github.com/supermemoryai/opencode-supermemory#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/supermemory
"
BDEPEND="${RDEPEND}"
