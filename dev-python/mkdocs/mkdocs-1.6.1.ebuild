# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Project documentation with Markdown."
HOMEPAGE="
	https://www.mkdocs.org/
	https://github.com/mkdocs/mkdocs
	https://pypi.org/project/mkdocs/
"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/ghp-import-1.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.3.6[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/mergedeep-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.5[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.11.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-env-tag-0.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-2.0[${PYTHON_USEDEP}]
"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	local tmpdir
	tmpdir="$(mktemp -d)" || die "mktemp failed"
	cat > "${tmpdir}/mkdocs.yml" <<-EOF_YML
	site_name: Test
	EOF_YML
	mkdir -p "${tmpdir}/docs" || die "mkdir failed"
	printf '# Hello\n\nWorld.\n' > "${tmpdir}/docs/index.md" || die "printf failed"
	python -m mkdocs build -q -f "${tmpdir}/mkdocs.yml" -d "${tmpdir}/site" \
		|| die "mkdocs site build failed"
	grep -q 'Hello' "${tmpdir}/site/index.html" \
		|| die "built site missing content"
	rm -rf "${tmpdir}"
}
