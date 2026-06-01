# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opencode-ai/plugin"
inherit npm

DESCRIPTION="Node.js module"
HOMEPAGE="https://www.npmjs.com/package/@opencode-ai/plugin"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/effect
	dev-nodejs/opencode-ai-sdk
	dev-nodejs/zod
"
BDEPEND="${RDEPEND}"
