# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="globalthis"


DESCRIPTION="ECMAScript spec-compliant polyfill/shim for \`globalThis\`"
HOMEPAGE="https://github.com/ljharb/System.global#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/define-properties
	dev-nodejs/gopd
"
BDEPEND=""
