# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="undici-types"
inherit npm

DESCRIPTION="TypeScript definitions for undici (runtime dep of @types/node)"
HOMEPAGE="https://github.com/nodejs/undici"
SRC_URI="https://registry.npmjs.org/${NPM_MODULE}/-/${NPM_MODULE}-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="${RDEPEND}"
