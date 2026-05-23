# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="call-bind-apply-helpers"

inherit npm

DESCRIPTION="Helper functions around Function call/apply/bind, for use in \`call-bind\`"
HOMEPAGE="https://github.com/ljharb/call-bind-apply-helpers#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-errors
	dev-nodejs/function-bind
"
BDEPEND=""
