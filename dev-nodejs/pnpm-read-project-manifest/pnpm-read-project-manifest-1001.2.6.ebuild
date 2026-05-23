# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/read-project-manifest"
inherit npm

DESCRIPTION="Read a project manifest (called package.json in most cases)"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/pkg-manifest/read-project-manifest#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fast-deep-equal
	dev-nodejs/gwhitney-detect-indent
	dev-nodejs/is-windows
	dev-nodejs/json5
	dev-nodejs/parse-json
	dev-nodejs/pnpm-error
	dev-nodejs/pnpm-graceful-fs
	dev-nodejs/pnpm-manifest-utils
	dev-nodejs/pnpm-text-comments-parser
	dev-nodejs/pnpm-types
	dev-nodejs/pnpm-write-project-manifest
	dev-nodejs/read-yaml-file
	dev-nodejs/strip-bom
"
BDEPEND="${RDEPEND}"
