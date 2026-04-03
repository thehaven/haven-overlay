# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-single-r1

DESCRIPTION="AI Dev Agent Platform for Slack and Web"
HOMEPAGE="https://github.com/Blue-Book-Project/overload"
COMMIT="c7bba1ae03a93e98c7b615f3e74ab3fc5bb89d53"
SRC_URI="https://github.com/Blue-Book-Project/overload/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="network-sandbox"

RDEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	${PYTHON_DEPS}
"

src_compile() {
	:;
}

src_install() {
	local appdir="/opt/${PN}"
	dodir "${appdir}"
	cp -r "${S}/"* "${ED}${appdir}/" || die

	# Create a virtualenv
	"${PYTHON}" -m venv "${ED}${appdir}/venv" || die "Failed to create venv"

	# Install dependencies into the venv
	# PIP_CACHE_DIR is set to a temp dir to avoid polluting user/root cache
	PIP_CACHE_DIR="${T}/pip-cache" "${ED}${appdir}/venv/bin/pip" install \
		--no-cache-dir -r requirements.txt || die "Failed to install pip requirements"

	# Fix the absolute paths in the venv to reflect the live filesystem instead of ${D}
	sed -i -e "s|${D}||g" "${ED}${appdir}/venv/bin/"* || die "Failed to fix venv paths"

	# Create a launcher script
	dodir /usr/bin
	cat <<-EOF > "${ED}/usr/bin/${PN}" || die
		#!/bin/bash
		cd "${appdir}"
		exec "${appdir}/venv/bin/python" main.py "\$@"
	EOF
	fperms +x "/usr/bin/${PN}"
}
