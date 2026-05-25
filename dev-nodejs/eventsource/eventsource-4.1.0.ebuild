# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="eventsource"
inherit npm

DESCRIPTION="WhatWG/W3C compliant EventSource client for Node.js and browsers"
HOMEPAGE="https://github.com/EventSource/eventsource#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/eventsource-parser
"
BDEPEND="${RDEPEND}"
