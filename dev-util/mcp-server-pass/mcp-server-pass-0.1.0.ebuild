# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

DESCRIPTION="MCP server for Pass (password store)"
HOMEPAGE="https://www.passwordstore.org/"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-admin/pass
	$(python_gen_cond_dep '
		dev-python/fastmcp[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir -p "${S}" || die
	cp "/storage/home/haven/.gemini/scripts/mcp-setup/pass_mcp.py" "${S}/" || die
	cp "/storage/home/haven/.gemini/scripts/mcp-setup/cli_wrapper.py" "${S}/" || die
}

src_prepare() {
	default
	# Add shebang if missing to satisfy python_fix_shebang
	sed -i '1i#!/usr/bin/env python' pass_mcp.py || die
}

src_install() {
	insinto /usr/share/${PN}
	doins pass_mcp.py cli_wrapper.py

	python_fix_shebang "${ED}/usr/share/${PN}/pass_mcp.py"

	# Create launcher
	python_export PYTHON
	cat <<- binEOF > "${T}/${PN}"
		#!/bin/sh
		exec ${PYTHON} /usr/share/${PN}/pass_mcp.py "\$@"
	binEOF
	dobin "${T}/${PN}"
}
