# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="abortcontroller-polyfill"
inherit npm

DESCRIPTION="Polyfill/ponyfill for the AbortController DOM API + optional patching of fetch (stub that calls catch, doesn't actually abort request)."
HOMEPAGE="https://github.com/mo/abortcontroller-polyfill#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
