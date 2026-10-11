# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="google_re2"

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for Google's RE2 regular expression library"
HOMEPAGE="https://github.com/google/re2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/re2:="

# _re2.cc is a pybind11 binding against the system libre2 (the upstream
# setup.py links `libraries=['re2']` and uses pybind11 for the glue).
BDEPEND="
	dev-cpp/abseil-cpp:=
	dev-libs/re2:=
	dev-python/pybind11[${PYTHON_USEDEP}]
"

RESTRICT="test"
DISTUTILS_EXT=1

# ---------------------------------------------------------------------------
# Build-host workaround: `pathspec` vs this package's own `re2/` namespace.
#
# setuptools (>= 78) imports `pathspec` while building the wheel (via the
# `setuptools.finalize_distribution_options` entry point registered by
# scikit-build-core, which is always installed).  pathspec's optional RE2
# backend (`pathspec/_backends/re2/_base.py`) does a bare `import re2` and
# only catches ModuleNotFoundError.  Because the PEP 517 build runs with the
# unpacked source directory on sys.path, that import resolves to
# google-re2's own, not-yet-built `re2/` package
# (re2/__init__.py: `from . import _re2`), which raises ImportError:
#
#   ImportError: cannot import name '_re2' from partially initialized module
#   're2' (most likely due to a circular import)
#
# Patch: wrap the `from . import _re2` in re2/__init__.py in a try/except
# that re-raises as ModuleNotFoundError.  pathspec's guard then catches it
# and falls back to its pure-Python `simple` backend.  At install time
# _re2.so is present alongside __init__.py, the try succeeds, and the rest
# of the module (Options, error, compile, etc.) loads normally.  Idempotent
# (no-op if already patched).
# ---------------------------------------------------------------------------
python_prepare_all() {
	local re2_init="re2/__init__.py"
	if [[ ! -f ${re2_init} ]]; then
		die "${re2_init} not found in ${PWD}; upstream layout changed?"
	fi
	if ! grep -q 're2 C++ extension not yet built' "${re2_init}"; then
		python3 - <<-PYEOF || die "re2/__init__.py patch failed"
		import pathlib
		p = pathlib.Path("${re2_init}")
		src = p.read_text()
		old = "from . import _re2\n"
		new = (
		    "try:\n"
		    "    from . import _re2\n"
		    "except ImportError:\n"
		    "    # During the build the _re2 extension has not been compiled\n"
		    "    # yet.  pathspec does 'import re2' while loading setuptools\n"
		    "    # entry points; the bare ImportError Python raises here is\n"
		    "    # 'cannot import name _re2 from partially initialized module\n"
		    "    # re2', which pathspec does NOT catch.  Re-raise as\n"
		    "    # ModuleNotFoundError so pathspec falls back to its\n"
		    "    # pure-Python simple backend.  At install time _re2 is\n"
		    "    # present and this branch is never taken.\n"
		    "    raise ModuleNotFoundError('re2 C++ extension not yet built') from None\n"
		)
		if old not in src:
		    raise SystemExit("needle not found in re2/__init__.py")
		p.write_text(src.replace(old, new, 1))
		PYEOF
	fi
	distutils-r1_python_prepare_all
}
