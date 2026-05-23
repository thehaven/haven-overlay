# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="global-agent"


DESCRIPTION="Global HTTP/HTTPS proxy configurable using environment variables."
HOMEPAGE="https://github.com/gajus/global-agent#readme"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/globalthis
	dev-nodejs/matcher
	dev-nodejs/semver
	dev-nodejs/serialize-error
"
BDEPEND=""
