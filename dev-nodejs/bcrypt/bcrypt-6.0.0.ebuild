# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="A bcrypt library for NodeJS."
HOMEPAGE="https://github.com/kelektiv/node.bcrypt.js#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT='*.node'
RESTRICT='strip'

RDEPEND=""
BDEPEND="${RDEPEND}"
