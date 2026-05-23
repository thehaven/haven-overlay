# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="read-yaml-file"


DESCRIPTION="Read and parse a YAML file"
HOMEPAGE="https://www.npmjs.com/package/read-yaml-file"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/js-yaml
	dev-nodejs/strip-bom
"
BDEPEND=""
