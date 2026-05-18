# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="pendulum"

CRATES="
	autocfg@1.5.0
	cc@1.2.55
	find-msvc-tools@0.1.9
	heck@0.5.0
	indoc@2.0.7
	libc@0.2.180
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.13.0
	proc-macro2@1.0.106
	pyo3-build-config@0.27.2
	pyo3-ffi@0.27.2
	pyo3-macros-backend@0.27.2
	pyo3-macros@0.27.2
	pyo3@0.27.2
	python3-dll-a@0.2.14
	quote@1.0.44
	rustversion@1.0.22
	shlex@1.3.0
	syn@2.0.114
	target-lexicon@0.13.4
	unicode-ident@1.0.22
	unindent@0.2.4
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python datetimes made easy"
HOMEPAGE="https://pendulum.eustace.io"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/tzdata[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-util/maturin
"
