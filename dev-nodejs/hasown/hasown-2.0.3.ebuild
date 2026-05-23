# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="hasown"


DESCRIPTION="A robust, ES3 compatible, \"has own property\" predicate."
HOMEPAGE="https://github.com/inspect-js/hasOwn#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/function-bind
"
BDEPEND=""
