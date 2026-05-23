# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-core-commonmark"

inherit npm

DESCRIPTION="The CommonMark markdown constructs"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/decode-named-character-reference
	dev-nodejs/devlop
	dev-nodejs/micromark-factory-destination
	dev-nodejs/micromark-factory-label
	dev-nodejs/micromark-factory-space
	dev-nodejs/micromark-factory-title
	dev-nodejs/micromark-factory-whitespace
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-chunked
	dev-nodejs/micromark-util-classify-character
	dev-nodejs/micromark-util-html-tag-name
	dev-nodejs/micromark-util-normalize-identifier
	dev-nodejs/micromark-util-resolve-all
	dev-nodejs/micromark-util-subtokenize
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
"
BDEPEND="${RDEPEND}"
