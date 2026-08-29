# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# npm publishes the dash version (2026.7.1-2); PMS normalises it to
# 2026.7.1_p2, so the tarball URL must use the upstream form.
MY_PV="2026.7.1-2"

DESCRIPTION="OpenClaw — modular AI agent framework"
HOMEPAGE="https://github.com/openclaw/openclaw"
SRC_URI="https://registry.npmjs.org/openclaw/-/openclaw-${MY_PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND=">=net-libs/nodejs-20"

src_compile() { :; }

src_install() {
	npm install --global --prefix "${ED}/usr" "${DISTDIR}/${A}" || die
	einstalldocs
}
