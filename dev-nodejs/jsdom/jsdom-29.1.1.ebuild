# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="jsdom"
inherit npm

DESCRIPTION="A JavaScript implementation of many web standards"
HOMEPAGE="https://github.com/jsdom/jsdom#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/asamuzakjp-css-color
	dev-nodejs/asamuzakjp-dom-selector
	dev-nodejs/bramus-specificity
	dev-nodejs/css-tree
	dev-nodejs/csstools-css-syntax-patches-for-csstree
	dev-nodejs/data-urls
	dev-nodejs/decimal-js
	dev-nodejs/exodus-bytes
	dev-nodejs/html-encoding-sniffer
	dev-nodejs/is-potential-custom-element-name
	dev-nodejs/lru-cache
	dev-nodejs/parse5
	dev-nodejs/saxes
	dev-nodejs/symbol-tree
	dev-nodejs/tough-cookie
	dev-nodejs/undici
	dev-nodejs/w3c-xmlserializer
	dev-nodejs/webidl-conversions
	dev-nodejs/whatwg-mimetype
	dev-nodejs/whatwg-url
	dev-nodejs/xml-name-validator
"
BDEPEND="${RDEPEND}"
