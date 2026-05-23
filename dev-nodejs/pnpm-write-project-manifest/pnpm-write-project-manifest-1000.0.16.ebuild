# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/write-project-manifest"

inherit npm

DESCRIPTION="Write a project manifest (called package.json in most cases)"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/pkg-manifest/write-project-manifest#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/json5
	dev-nodejs/pnpm-text-comments-parser
	dev-nodejs/pnpm-types
	dev-nodejs/write-file-atomic
	dev-nodejs/write-yaml-file
"
BDEPEND=""
