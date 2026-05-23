# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Lightweight static analysis for many languages"
HOMEPAGE="https://semgrep.dev"

WHEEL_AMD64="semgrep-1.163.0-cp310.cp311.cp312.cp313.cp314.py310.py311.py312.py313.py314-none-manylinux_2_35_x86_64.whl"
WHEEL_URL="https://files.pythonhosted.org/packages/15/c6/757caf53312b5be2e429864d1c9e8ed59fc32106620039beef60c9eb0a74/${WHEEL_AMD64}"

SRC_URI="https://github.com/semgrep/semgrep/archive/v${PV}.tar.gz -> ${P}.tar.gz
	amd64? ( ${WHEEL_URL} -> ${P}-amd64.whl )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/boltons[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-option-group[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/glom[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/peewee[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/semantic-version[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/wcmatch[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	dev-python/opentelemetry-instrumentation[${PYTHON_USEDEP}]
	dev-python/opentelemetry-instrumentation-requests[${PYTHON_USEDEP}]
	dev-python/opentelemetry-instrumentation-threading[${PYTHON_USEDEP}]
	dev-python/opentelemetry-util-http[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-libs/tree-sitter
	net-misc/curl
	dev-libs/libpcre
"
BDEPEND="
	app-arch/unzip
	dev-util/patchelf
"

S="${WORKDIR}/semgrep-${PV}/cli"

src_unpack() {
	unpack ${P}.tar.gz
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	if use amd64; then
		einfo "Extracting semgrep-core binary from wheel..."
		mkdir -p "${S}/src/semgrep/bin" || die
		unzip -j "${DISTDIR}/${P}-amd64.whl" "semgrep-${PV}.data/purelib/semgrep/bin/semgrep-core" -d "${S}/src/semgrep/bin" || die
		chmod +x "${S}/src/semgrep/bin/semgrep-core" || die
	fi
}

src_install() {
	distutils-r1_src_install

	if use amd64; then
		local libdir="/usr/$(get_libdir)/semgrep"
		dodir "${libdir}"

		# Find system libraries
		local ts_lib=$(ls /usr/$(get_libdir)/libtree-sitter.so.[0-9]* | head -n 1)
		local curl_lib=$(ls /usr/$(get_libdir)/libcurl.so.[0-9]* | head -n 1)
		local pcre_lib=$(ls /usr/$(get_libdir)/libpcre.so.[0-9]* | head -n 1)

		# Symlink them to expected names
		dosym "${ts_lib#${EPREFIX}}" "${libdir}/libtree-sitter.so.0.22"
		dosym "${curl_lib#${EPREFIX}}" "${libdir}/libcurl-gnutls.so.4"
		dosym "${pcre_lib#${EPREFIX}}" "${libdir}/libpcre.so.3"

		# Patch RPATH for each installed python implementation
		local py_impl
		for py_impl in ${PYTHON_TARGETS}; do
			local impl_name="${py_impl/_/.}"
			local bin_path="${ED}/usr/lib/${impl_name}/site-packages/semgrep/bin/semgrep-core"
			if [[ -f "${bin_path}" ]]; then
				einfo "Patching RPATH for ${impl_name}"
				patchelf --set-rpath "${EPREFIX}${libdir}" "${bin_path}" || die
			fi
		done
	fi
}

pkg_postinst() {
	elog "Semgrep has been installed with bundled core binary."
	elog "To run a scan:"
	elog "  semgrep scan --config auto"
}
