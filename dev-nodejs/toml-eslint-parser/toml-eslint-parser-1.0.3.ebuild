# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="toml-eslint-parser"

inherit npm

DESCRIPTION="A TOML parser that produces output compatible with ESLint"
HOMEPAGE="https://github.com/ota-meshi/toml-eslint-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/eslint-visitor-keys
"
BDEPEND="${RDEPEND}"
