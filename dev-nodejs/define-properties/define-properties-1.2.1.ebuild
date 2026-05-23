# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="define-properties"

inherit npm

DESCRIPTION="Define multiple non-enumerable properties at once. Uses \`Object.defineProperty\` when available; falls back to standard assignment in older engines."
HOMEPAGE="https://github.com/ljharb/define-properties#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/define-data-property
	dev-nodejs/has-property-descriptors
	dev-nodejs/object-keys
"
BDEPEND=""
