# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="All-in-one LLM CLI tool: chat, execute, RAG, and more"
HOMEPAGE="https://github.com/sigoden/aichat"

SRC_URI="
	amd64? ( https://github.com/sigoden/aichat/releases/download/v${PV}/${PN}-v${PV}-x86_64-unknown-linux-musl.tar.gz )
	arm64? ( https://github.com/sigoden/aichat/releases/download/v${PV}/${PN}-v${PV}-aarch64-unknown-linux-musl.tar.gz )
"
S="${WORKDIR}"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/aichat"

src_install() {
	dobin aichat
}

pkg_postinst() {
	einfo "Configure aichat by running: aichat --init"
	einfo "Supports: OpenAI, Anthropic, Google Gemini, Ollama, and many more"
	einfo "See https://github.com/sigoden/aichat for full provider list"
}
