# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@redis/client"

inherit npm

DESCRIPTION="The source code and documentation for this package are in the main [node-redis](https://github.com/redis/node-redis) repo."
HOMEPAGE="https://github.com/redis/node-redis/tree/master/packages/client"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/cluster-key-slot
"
BDEPEND="${RDEPEND}"
