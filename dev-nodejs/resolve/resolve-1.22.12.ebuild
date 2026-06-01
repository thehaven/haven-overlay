# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="resolve"
inherit npm

DESCRIPTION="resolve like require.resolve() on behalf of files asynchronously and synchronously"
HOMEPAGE="https://github.com/browserify/resolve#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-errors
	dev-nodejs/is-core-module
	dev-nodejs/path-parse
	dev-nodejs/supports-preserve-symlinks-flag
"
BDEPEND="${RDEPEND}"
