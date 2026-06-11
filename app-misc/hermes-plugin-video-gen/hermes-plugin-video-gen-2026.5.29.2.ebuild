# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit python-r1

DESCRIPTION="Hermes Agent Plugin: video_gen"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/v2026.5.7.tar.gz -> hermes-agent-2026.5.29.2.tar.gz"
S="${WORKDIR}/hermes-agent-2026.5.7"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-misc/hermes
"

src_unpack() {
	default
}

src_prepare() {
	default
}

src_compile() { :; }

src_install() {
	install_plugin() {
		local sitedir
		sitedir=$(python_get_sitedir)
		insinto "${sitedir}/plugins/video_gen"
		doins -r "plugins/video_gen/"*
	}
	python_foreach_impl install_plugin
}
