# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ink-spinner"
inherit npm

DESCRIPTION="Spinner component for Ink"
HOMEPAGE="https://github.com/vadimdemedes/ink-spinner#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/cli-spinners
"
BDEPEND="${RDEPEND}"
