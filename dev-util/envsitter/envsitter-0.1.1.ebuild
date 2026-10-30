# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="envsitter"
NPM_AUTO_BIN=1
inherit npm

DESCRIPTION="Safely inspect and match .env secrets without exposing values"
HOMEPAGE="https://github.com/boxpositron/envsitter#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
