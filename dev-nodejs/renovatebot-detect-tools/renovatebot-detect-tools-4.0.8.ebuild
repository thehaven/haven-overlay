# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@renovatebot/detect-tools"

inherit npm

DESCRIPTION=""
HOMEPAGE="https://github.com/renovatebot/detect-tools#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fs-extra
	dev-nodejs/toml-eslint-parser
	dev-nodejs/upath
	dev-nodejs/zod
"
BDEPEND="${RDEPEND}"
