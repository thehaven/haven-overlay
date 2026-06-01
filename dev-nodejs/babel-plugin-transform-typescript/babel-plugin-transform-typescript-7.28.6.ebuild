# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/plugin-transform-typescript"
inherit npm

DESCRIPTION="Transform TypeScript into ES.next"
HOMEPAGE="https://babel.dev/docs/en/next/babel-plugin-transform-typescript"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-annotate-as-pure
	dev-nodejs/babel-helper-create-class-features-plugin
	dev-nodejs/babel-helper-plugin-utils
	dev-nodejs/babel-helper-skip-transparent-expression-wrappers
	dev-nodejs/babel-plugin-syntax-typescript
"
BDEPEND="${RDEPEND}"
