# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="envsitter-guard"
inherit npm

DESCRIPTION="OpenCode plugin that prevents agents/tools from reading or editing sensitive .env* files, while still allowing safe inspection via EnvSitter."
HOMEPAGE="https://github.com/boxpositron/envsitter-guard#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/envsitter
	dev-nodejs/opencode-ai-plugin
"
BDEPEND="${RDEPEND}"
