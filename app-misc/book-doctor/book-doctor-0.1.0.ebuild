# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 optfeature

DESCRIPTION="Layered book fingerprinting, validation and metadata repair for ebook libraries"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/haven/book-doctor"
SRC_URI="https://gitlab-ee.thehavennet.org.uk/haven/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/imagehash-4.3[${PYTHON_USEDEP}]
		>=dev-python/pillow-10.0[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-3.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-retries-0.5.0[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	sys-apps/texinfo
	test? (
		$(python_gen_cond_dep '
			>=dev-python/pytest-8.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-5.0[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

src_compile() {
	distutils-r1_src_compile
	# Build GNU info from texinfo source
	if [[ -f doc/bookdoctor.texi ]]; then
		makeinfo doc/bookdoctor.texi -o doc/bookdoctor.info || die
	fi
}

src_install() {
	distutils-r1_src_install
	# Man pages
	if [[ -f man/man1/bookdoctor.1 ]]; then
		doman man/man1/bookdoctor.1
	fi
	if [[ -f man/man5/bookdoctor-config.5 ]]; then
		doman man/man5/bookdoctor-config.5
	fi
	# GNU info
	if [[ -f doc/bookdoctor.info ]]; then
		doinfo doc/bookdoctor.info
	fi
	einstalldocs
	# Config example (never overwrite existing config.toml)
	if [[ -f etc/bookdoctor/config.toml.example ]]; then
		insinto /etc/bookdoctor
		newins etc/bookdoctor/config.toml.example config.toml.example
	fi
}

python_test() {
	# Run unit tests only; skip slow/integration/network/smoke markers.
	# Override pyproject addopts (coverage + fail_under) and filterwarnings=error
	# which are fragile in the ebuild sandbox.
	#
	# Deselect 3 slot-protection tests on py3.12 only: CPython 3.12 has a
	# bug in @dataclass(frozen=True, slots=True) where assigning a
	# non-existent field raises TypeError (from super().__setattr__) instead
	# of FrozenInstanceError (subclass of AttributeError). Fixed in 3.13+.
	local deselect=()
	if [[ ${EPYTHON} == python3.12 ]]; then
		deselect+=(
			--deselect tests/sources/test_base.py::test_source_result_slots_prevent_arbitrary_attrs
			--deselect tests/retry/test_retry.py::test_retry_config_slots_prevent_arbitrary_attrs
			--deselect tests/delta/test_delta.py::TestScoreDeltaInvariants::test_score_delta_slots_protect_attributes
		)
	fi
	epytest \
		-m "not slow and not integration and not network and not smoke" \
		-p no:hydra_pytest \
		--override-ini="addopts=" \
		--override-ini="filterwarnings=" \
		"${deselect[@]}" \
		|| die "tests failed"
}

pkg_postinst() {
	elog "book-doctor ships a config example at /etc/bookdoctor/config.toml.example"
	elog "Copy it to /etc/bookdoctor/config.toml to customise behaviour."
	elog ""
	elog "Optional runtime features:"
	optfeature "Calibre backend (ebook library management)" app-text/calibre
}
