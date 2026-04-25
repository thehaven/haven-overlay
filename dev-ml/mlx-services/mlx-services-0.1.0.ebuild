# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3

DESCRIPTION="SRE-grade MLX model lifecycle management for Apple Silicon"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/mlx-services"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/mlx.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="-* ~arm64 ~arm64-macos"
else
	KEYWORDS="-*"
fi

LICENSE="Proprietary"
SLOT="0"

RESTRICT="test"

RDEPEND="
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/huggingface-hub[${PYTHON_USEDEP}]
	dev-python/mlx-embeddings[${PYTHON_USEDEP}]
	dev-python/mlx-lm[${PYTHON_USEDEP}]
	dev-python/mlx-vlm[${PYTHON_USEDEP}]
	dev-python/plotext[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
"

pkg_pretend() {
	local is_apple_silicon=0
	if [[ ${CHOST} == *apple-darwin* ]]; then
		if sysctl -n machdep.cpu.brand_string 2>/dev/null | grep -q "Apple M"; then
			is_apple_silicon=1
		fi
	elif [[ ${CHOST} == *linux* ]]; then
		if grep -qi "apple" /proc/cpuinfo 2>/dev/null || grep -q "M[1-9]" /proc/cpuinfo 2>/dev/null; then
			is_apple_silicon=1
		fi
	fi
	
	if [[ ${is_apple_silicon} -eq 0 ]]; then
		eerror "mlx-services heavily depends on the MLX framework."
		eerror "This requires Apple Silicon (M-series) hardware to function properly."
		die "Unsupported hardware: Apple Silicon required."
	fi
}
