# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="is-ssh"
inherit npm

DESCRIPTION="Check if an input value is a ssh url or not."
HOMEPAGE="https://github.com/IonicaBizau/node-is-ssh"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/protocols
"
BDEPEND="${RDEPEND}"
