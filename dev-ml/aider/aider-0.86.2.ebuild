# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

MY_PN="aider-chat"
DESCRIPTION="AI pair programmer - edit code with LLMs from your terminal"
HOMEPAGE="https://aider.chat https://github.com/Aider-AI/aider"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# pip needs network to resolve deps
RESTRICT="network-sandbox test"

RDEPEND="
	${PYTHON_DEPS}
	dev-vcs/git
"
BDEPEND="
	${PYTHON_DEPS}
"

src_unpack() {
	mkdir -p "${S}" || die
}

src_compile() {
	:
}

src_install() {
	local instdir="/opt/${PN}"

	# Create virtualenv
	"${PYTHON}" -m venv --system-site-packages "${ED}${instdir}" || die "venv creation failed"

	# Install into venv
	"${ED}${instdir}/bin/pip" install \
		--no-cache-dir \
		--disable-pip-version-check \
		"aider-chat==${PV}" || die "pip install failed"

	# Fix paths baked during install
	find "${ED}${instdir}" -type f \( -name '*.py' -o -name '*.cfg' \) -exec \
		sed -i "s|${ED}||g" {} + 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/bin/"* 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/pyvenv.cfg" || true

	# Wrapper script
	dodir /opt/bin
	cat <<-EOF > "${ED}/opt/bin/aider" || die
		#!/bin/sh
		exec "${instdir}/bin/aider" "\$@"
	EOF
	fperms a+x /opt/bin/aider
}

pkg_postinst() {
	einfo "Aider AI pair programmer installed."
	einfo ""
	einfo "Quick start:"
	einfo "  cd /your/project && aider"
	einfo ""
	einfo "Models: Uses Claude, GPT-4, or any OpenAI-compatible API."
	einfo "Set ANTHROPIC_API_KEY or OPENAI_API_KEY to get started."
	einfo ""
	einfo "With local Ollama:"
	einfo "  aider --model ollama/llama3"
}
