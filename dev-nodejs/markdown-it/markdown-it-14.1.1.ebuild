# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="markdown-it"

inherit npm

DESCRIPTION="Markdown-it - modern pluggable markdown parser."
HOMEPAGE="https://github.com/markdown-it/markdown-it#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/argparse
	dev-nodejs/entities
	dev-nodejs/linkify-it
	dev-nodejs/mdurl
	dev-nodejs/punycode-js
	dev-nodejs/uc-micro
"
BDEPEND="${RDEPEND}"
