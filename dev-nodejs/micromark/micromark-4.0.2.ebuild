# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark"

inherit npm

DESCRIPTION="small commonmark compliant markdown parser with positional info and concrete tokens"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/decode-named-character-reference
	dev-nodejs/devlop
	dev-nodejs/micromark-core-commonmark
	dev-nodejs/micromark-factory-space
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-chunked
	dev-nodejs/micromark-util-combine-extensions
	dev-nodejs/micromark-util-decode-numeric-character-reference
	dev-nodejs/micromark-util-encode
	dev-nodejs/micromark-util-normalize-identifier
	dev-nodejs/micromark-util-resolve-all
	dev-nodejs/micromark-util-sanitize-uri
	dev-nodejs/micromark-util-subtokenize
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
	dev-nodejs/types-debug
"
BDEPEND="${RDEPEND}"
