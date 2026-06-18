# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ink"
inherit npm

DESCRIPTION="React for CLI"
HOMEPAGE="https://github.com/vadimdemedes/ink#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/alcalzone-ansi-tokenize
	dev-nodejs/ansi-escapes
	dev-nodejs/ansi-styles
	dev-nodejs/auto-bind
	dev-nodejs/chalk
	dev-nodejs/cli-boxes
	dev-nodejs/cli-cursor
	dev-nodejs/cli-truncate
	dev-nodejs/code-excerpt
	dev-nodejs/es-toolkit
	dev-nodejs/indent-string
	dev-nodejs/is-in-ci
	dev-nodejs/patch-console
	dev-nodejs/react-reconciler
	dev-nodejs/scheduler
	dev-nodejs/signal-exit
	dev-nodejs/slice-ansi
	dev-nodejs/stack-utils
	dev-nodejs/string-width
	dev-nodejs/terminal-size
	dev-nodejs/type-fest
	dev-nodejs/widest-line
	dev-nodejs/wrap-ansi
	dev-nodejs/ws
	dev-nodejs/yoga-layout
"
BDEPEND="${RDEPEND}"
