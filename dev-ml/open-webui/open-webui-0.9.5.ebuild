# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

DESCRIPTION="ChatGPT-style web UI for Ollama and OpenAI-compatible APIs"
HOMEPAGE="https://openwebui.com https://github.com/open-webui/open-webui"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# pip needs network to resolve deps
RESTRICT="network-sandbox test"

RDEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	${PYTHON_DEPS}
	net-misc/curl
"

PATCHES=()

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
		"open-webui==${PV}" || die "pip install failed"

	# Fix shebangs and paths baked during install
	find "${ED}${instdir}" -type f -name '*.py' -exec \
		sed -i "s|${ED}||g" {} + 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/bin/"* 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/pyvenv.cfg" || true

	# Wrapper script
	dodir /opt/bin
	cat <<-EOF > "${ED}/opt/bin/open-webui" || die
		#!/bin/sh
		exec "${instdir}/bin/open-webui" "\$@"
	EOF
	fperms a+x /opt/bin/open-webui

	# Service files
	newinitd "${FILESDIR}"/open-webui.initd open-webui
	newconfd "${FILESDIR}"/open-webui.confd open-webui

	insinto /usr/lib/systemd/system
	doins "${FILESDIR}"/open-webui.service

	keepdir /var/lib/open-webui
}

pkg_postinst() {
	einfo "Open WebUI installed."
	einfo ""
	einfo "Quick start:"
	einfo "  open-webui serve"
	einfo ""
	einfo "Default URL: http://localhost:8080"
	einfo "Data directory: /var/lib/open-webui"
	einfo ""
	einfo "Connects to Ollama at http://localhost:11434 by default."
	einfo "Set OLLAMA_BASE_URL to change the Ollama endpoint."
}
