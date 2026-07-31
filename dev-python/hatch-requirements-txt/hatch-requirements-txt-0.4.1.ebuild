# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Hatchling plugin to read project dependencies from requirements.txt"
HOMEPAGE="
	https://github.com/repo-helper/hatch-requirements-txt
	https://pypi.org/project/hatch-requirements-txt/
"
S="${WORKDIR}/hatch_requirements_txt-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/hatchling-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	python - <<-EOF_TEST || die "hatch-requirements-txt hook test failed"
import tempfile
from pathlib import Path

from hatch_requirements_txt import RequirementsMetadataHook

root = Path(tempfile.mkdtemp())
(root / "requirements.txt").write_text("requests\nclick>=8.0\n")
# hook resolves files relative to CWD, so pass an absolute path
hook = RequirementsMetadataHook(root, {"files": [str(root / "requirements.txt")]})
metadata = {"dynamic": ["dependencies"]}
hook.update(metadata)
assert metadata.get("dependencies") == ["requests", "click>=8.0"]
EOF_TEST
}
