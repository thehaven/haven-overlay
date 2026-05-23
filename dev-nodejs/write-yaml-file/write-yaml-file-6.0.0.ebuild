# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="write-yaml-file"
inherit npm

DESCRIPTION="Stringify and write YAML to a file atomically"
HOMEPAGE="https://github.com/zkochan/packages/tree/main/write-yaml-file#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/js-yaml
	dev-nodejs/write-file-atomic
"
BDEPEND="${RDEPEND}"
