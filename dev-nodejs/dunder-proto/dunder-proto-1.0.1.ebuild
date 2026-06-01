# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="dunder-proto"
inherit npm

DESCRIPTION="If available, the \`Object.prototype.__proto__\` accessor and mutator, call-bound"
HOMEPAGE="https://github.com/es-shims/dunder-proto#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/call-bind-apply-helpers
	dev-nodejs/es-errors
	dev-nodejs/gopd
"
BDEPEND="${RDEPEND}"
