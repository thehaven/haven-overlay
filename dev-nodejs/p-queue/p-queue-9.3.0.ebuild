# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="p-queue"
inherit npm

DESCRIPTION="Promise queue with concurrency control"
HOMEPAGE="https://github.com/sindresorhus/p-queue#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/eventemitter3
	dev-nodejs/p-timeout
"
BDEPEND="${RDEPEND}"
