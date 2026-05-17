# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1

DESCRIPTION="Web UI Dashboard for Hermes Agent"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/v2026.5.7.tar.gz -> hermes-agent-0.13.0.tar.gz"
S="${WORKDIR}/hermes-agent-2026.5.7"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="network-sandbox"

BDEPEND="
	>=net-libs/nodejs-20[npm]
"
RDEPEND="
	${PYTHON_DEPS}
	app-misc/hermes
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
"

src_compile() {
	cd web || die
	npm install || die
	npm run build || die
}

src_install() {
	install_dashboard() {
		local sitedir
		sitedir=$(python_get_sitedir)
		insinto "${sitedir}/hermes_cli/web_dist"
		doins -r web/dist/*
	}
	python_foreach_impl install_dashboard
}
