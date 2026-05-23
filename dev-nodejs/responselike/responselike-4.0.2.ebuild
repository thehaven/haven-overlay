# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="responselike"

inherit npm

DESCRIPTION="A response-like object for mocking a Node.js HTTP response stream"
HOMEPAGE="https://github.com/sindresorhus/responselike#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/lowercase-keys
"
BDEPEND="${RDEPEND}"
