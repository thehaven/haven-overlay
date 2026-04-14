# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

DESCRIPTION="LLM API gateway - unified interface for 100+ LLM providers"
HOMEPAGE="https://litellm.ai https://github.com/BerriAI/litellm"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+proxy"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# pip needs network to resolve deps
RESTRICT="network-sandbox test"

RDEPEND="
	${PYTHON_DEPS}
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
	local extras=""
	use proxy && extras="[proxy]"

	# Create virtualenv
	"${PYTHON}" -m venv --system-site-packages "${ED}${instdir}" || die "venv creation failed"

	# Install into venv
	"${ED}${instdir}/bin/pip" install \
		--no-cache-dir \
		--disable-pip-version-check \
		"litellm${extras}==${PV}" || die "pip install failed"

	# Fix paths baked during install
	find "${ED}${instdir}" -type f \( -name '*.py' -o -name '*.cfg' \) -exec \
		sed -i "s|${ED}||g" {} + 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/bin/"* 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/pyvenv.cfg" || true

	# Wrapper script
	dodir /opt/bin
	cat <<-EOF > "${ED}/opt/bin/litellm" || die
		#!/bin/sh
		exec "${instdir}/bin/litellm" "\$@"
	EOF
	fperms a+x /opt/bin/litellm

	# Config directory
	insinto /etc/litellm
	doins "${FILESDIR}"/config.yaml

	# Service files
	newinitd "${FILESDIR}"/litellm.initd litellm
	newconfd "${FILESDIR}"/litellm.confd litellm

	insinto /usr/lib/systemd/system
	doins "${FILESDIR}"/litellm.service

	keepdir /var/lib/litellm
	keepdir /var/log/litellm
}

pkg_postinst() {
	einfo "LiteLLM installed."
	einfo ""
	einfo "Quick start:"
	einfo "  litellm --model ollama/llama3"
	einfo ""
	einfo "Proxy server:"
	einfo "  litellm --config /etc/litellm/config.yaml"
	einfo ""
	einfo "Default URL: http://localhost:4000"
	einfo "Edit /etc/litellm/config.yaml to configure models."
}
