# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="minipass-pipeline"

inherit npm

DESCRIPTION="create a pipeline of streams using Minipass"
HOMEPAGE="https://github.com/isaacs/minipass-pipeline#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minipass
"
BDEPEND=""
