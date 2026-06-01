# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentui/solid"
inherit npm

DESCRIPTION="SolidJS renderer for OpenTUI"
HOMEPAGE="https://github.com/anomalyco/opentui#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-core
	dev-nodejs/babel-plugin-module-resolver
	dev-nodejs/babel-preset-solid
	dev-nodejs/babel-preset-typescript
	dev-nodejs/entities
	dev-nodejs/opentui-core
	dev-nodejs/s-js
"
BDEPEND="${RDEPEND}"
