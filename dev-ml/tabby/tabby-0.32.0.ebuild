# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Self-hosted AI coding assistant with code completion and chat"
HOMEPAGE="https://tabby.tabbyml.com https://github.com/TabbyML/tabby"

TABBY_BASE="https://github.com/TabbyML/tabby/releases/download/v${PV}"
SRC_URI="
	!cuda? (
		!vulkan? (
			amd64? ( ${TABBY_BASE}/tabby_x86_64-manylinux_2_28.tar.gz -> ${P}-cpu-amd64.tar.gz )
		)
		vulkan? (
			amd64? ( ${TABBY_BASE}/tabby_x86_64-manylinux_2_28-vulkan.tar.gz -> ${P}-vulkan-amd64.tar.gz )
		)
	)
	cuda? (
		amd64? ( ${TABBY_BASE}/tabby_x86_64-manylinux_2_28-cuda123.tar.gz -> ${P}-cuda-amd64.tar.gz )
	)
"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda vulkan"

REQUIRED_USE="?? ( cuda vulkan )"

RESTRICT="mirror strip"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	vulkan? ( media-libs/vulkan-loader )
"

QA_PREBUILT="usr/bin/tabby usr/bin/llama-server"

src_install() {
	dobin tabby
	# llama-server is bundled for model serving
	[[ -f llama-server ]] && dobin llama-server

	newinitd "${FILESDIR}"/tabby.initd tabby
	newconfd "${FILESDIR}"/tabby.confd tabby

	insinto /usr/lib/systemd/system
	doins "${FILESDIR}"/tabby.service

	keepdir /var/lib/tabby
}

pkg_postinst() {
	einfo "Tabby self-hosted AI coding assistant installed."
	einfo ""
	einfo "Quick start:"
	einfo "  tabby serve --model StarCoder-1B --device cpu"
	einfo ""
	einfo "With GPU:"
	if use cuda; then
		einfo "  tabby serve --model StarCoder-7B --device cuda"
	fi
	if use vulkan; then
		einfo "  tabby serve --model StarCoder-3B --device vulkan"
	fi
	einfo ""
	einfo "Dashboard: http://localhost:8080"
	einfo "Data directory: /var/lib/tabby"
	einfo ""
	einfo "IDE plugins: VSCode, IntelliJ, Vim/Neovim"
	einfo "See https://tabby.tabbyml.com/docs/extensions/"
}
