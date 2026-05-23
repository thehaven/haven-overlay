# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="call-bound"

inherit npm

DESCRIPTION="Robust call-bound JavaScript intrinsics, using \`call-bind\` and \`get-intrinsic\`."
HOMEPAGE="https://github.com/ljharb/call-bound#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/call-bind-apply-helpers
	dev-nodejs/get-intrinsic
"
BDEPEND=""
