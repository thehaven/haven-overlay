# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="clipanion"

MY_PV="4.0.0-rc.4"
SRC_URI="https://registry.npmjs.org/${NPM_MODULE}/-/${NPM_MODULE##*/}-${MY_PV}.tgz -> ${P}.tgz"

DESCRIPTION="Type-safe CLI library / framework with no runtime dependencies"
HOMEPAGE="https://mael.dev/clipanion/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/typanion
"
BDEPEND=""
