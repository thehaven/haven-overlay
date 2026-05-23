# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="define-data-property"

inherit npm

DESCRIPTION="Define a data property on an object. Will fall back to assignment in an engine without descriptors."
HOMEPAGE="https://github.com/ljharb/define-data-property#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-define-property
	dev-nodejs/es-errors
	dev-nodejs/gopd
"
BDEPEND="${RDEPEND}"
