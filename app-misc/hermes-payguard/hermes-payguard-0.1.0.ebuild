# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit python-r1

DESCRIPTION="Safe spending layer for Hermes Agent via USDC/x402"
HOMEPAGE="https://github.com/nativ3ai/hermes-payguard"
SRC_URI="https://github.com/nativ3ai/hermes-payguard/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hermes-payguard-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="network-sandbox"

RDEPEND="
	${PYTHON_DEPS}
	app-misc/hermes
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/x402[${PYTHON_USEDEP}]
"

src_compile() { :; }

src_install() {
	install_plugin() {
		local sitedir
		sitedir=$(python_get_sitedir)
		insinto "${sitedir}/plugins"
		doins -r hermes_payguard
	}
	python_foreach_impl install_plugin
}
