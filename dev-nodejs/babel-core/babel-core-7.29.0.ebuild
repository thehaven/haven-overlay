# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/core"
inherit npm

DESCRIPTION="Babel compiler core."
HOMEPAGE="https://babel.dev/docs/en/next/babel-core"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-code-frame
	dev-nodejs/babel-generator
	dev-nodejs/babel-helper-compilation-targets
	dev-nodejs/babel-helper-module-transforms
	dev-nodejs/babel-helpers
	dev-nodejs/babel-parser
	dev-nodejs/babel-template
	dev-nodejs/babel-traverse
	dev-nodejs/babel-types
	dev-nodejs/convert-source-map
	dev-nodejs/debug
	dev-nodejs/gensync
	dev-nodejs/jridgewell-remapping
	dev-nodejs/json5
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
