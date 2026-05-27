# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin that redacts secrets from tool outputs before agent context"
HOMEPAGE="https://github.com/casonadams/opencode-secret-redactor"
SRC_URI="https://registry.npmjs.org/opencode-secret-redactor/-/opencode-secret-redactor-0.5.1.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r dist package.json
	fperms 0755 "/usr/$(get_libdir)/node_modules/${PN}/dist/plugin.cjs"
}
