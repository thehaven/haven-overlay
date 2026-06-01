# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="effect"
inherit npm

DESCRIPTION="The missing standard library for TypeScript, for writing production-grade software."
HOMEPAGE="https://effect.website"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fast-check
	dev-nodejs/standard-schema-spec
"
BDEPEND="${RDEPEND}"
