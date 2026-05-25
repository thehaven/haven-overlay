# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-background-agents"
inherit npm

DESCRIPTION="Claude Code-style background agents with async delegation for OpenCode"
HOMEPAGE="https://github.com/kdcokenny/opencode-background-agents"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/opencode-ai-sdk
"
BDEPEND="${RDEPEND}"
