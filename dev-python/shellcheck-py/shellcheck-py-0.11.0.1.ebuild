# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

DESCRIPTION="pip-installable shellcheck binary (Python wrapper around koalaman/shellcheck)"
HOMEPAGE="https://github.com/shellcheck-py/shellcheck-py
	https://pypi.org/project/shellcheck-py/"

# The upstream PyPI manylinux wheel for x86_64 contains the prebuilt
# shellcheck binary under `shellcheck_py-${PV}.data/scripts/shellcheck`.
# Distutils-r1's PEP 517 build does not run setuptools-download (the
# upstream hooks only fire on the legacy setup.py sdist path), so we ship
# the wheel directly and install the binary into /usr/bin ourselves. The
# Python wrapper itself carries no Python source — it is a pure bootstrap
# launcher; the wheel's role here is to provide the actual shellcheck
# binary in a known, checksum-verified layout.
SRC_URI="
	amd64? (
https://files.pythonhosted.org/packages/96/55/250e0e3367613a5c22bd82e33b16b889287d81ab0f7dda67e6514a4cccf4/shellcheck_py-${PV}-py2.py3-none-manylinux1_x86_64.manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_5_x86_64.whl
			-> ${P}-manylinux_x86_64.whl
	)
"

S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!dev-util/shellcheck-bin"
RESTRICT="mirror"

QA_PREBUILT="usr/bin/shellcheck"

src_unpack() {
	# The unpacker eclass does not handle .whl files, so we unzip manually
	# (a wheel is just a zip archive with a PEP 491 naming convention).
	local whl="${DISTDIR}/${P}-manylinux_x86_64.whl"
	[[ -f ${whl} ]] || whl="${DISTDIR}/$(echo ${A} | grep -o 'shellcheck_py.*\.whl')"

	mkdir -p "${WORKDIR}/wheel" || die
	cd "${WORKDIR}/wheel" || die
	unzip -qo "${whl}" || die "failed to unzip ${whl}"
}

src_install() {
	# Locate the extracted binary inside ${WORKDIR} (the unpacker eclass
	# extracts the wheel into a flat directory matching its internal layout).
	local bin
	bin=$(find "${WORKDIR}" -name shellcheck -type f -executable | head -n 1)
	[[ -x ${bin} ]] || die "shellcheck binary not found in extracted wheel"

	newbin "${bin}" shellcheck
	einstalldocs
}

pkg_postinst() {
	einfo "shellcheck ${PV} (shellcheck-py wrapper) installed to /usr/bin/shellcheck."
	einfo "This package exists to track the upstream shellcheck-py identity for"
	einfo "consumers that integrate shellcheck via Python packaging / pre-commit."
	einfo "For a host-build of shellcheck see dev-util/shellcheck."
}
