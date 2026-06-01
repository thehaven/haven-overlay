# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="open"
inherit npm

DESCRIPTION="Open stuff like URLs, files, executables. Cross-platform."
HOMEPAGE="https://github.com/sindresorhus/open#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/default-browser
	dev-nodejs/define-lazy-prop
	dev-nodejs/is-in-ssh
	dev-nodejs/is-inside-container
	dev-nodejs/powershell-utils
	dev-nodejs/wsl-utils
"
BDEPEND="${RDEPEND}"
