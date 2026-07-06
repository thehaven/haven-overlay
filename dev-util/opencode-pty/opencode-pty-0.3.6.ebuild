# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-pty"
inherit npm

DESCRIPTION="OpenCode plugin for interactive PTY management - run background processes, send input, read output with regex filtering"
HOMEPAGE="https://github.com/shekohex/opencode-pty#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bun-pty
	dev-nodejs/open
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/opencode-ai-sdk
"
BDEPEND="${RDEPEND}"
