# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="get-intrinsic"
inherit npm

DESCRIPTION="Get and robustly cache all JS language-level intrinsics at first require time"
HOMEPAGE="https://github.com/ljharb/get-intrinsic#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/call-bind-apply-helpers
	dev-nodejs/es-define-property
	dev-nodejs/es-errors
	dev-nodejs/es-object-atoms
	dev-nodejs/function-bind
	dev-nodejs/get-proto
	dev-nodejs/gopd
	dev-nodejs/has-symbols
	dev-nodejs/hasown
	dev-nodejs/math-intrinsics
"
BDEPEND="${RDEPEND}"
