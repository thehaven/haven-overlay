# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="Optimize prompts, code, and more with AI-powered Reflective Optimization"
HOMEPAGE="https://github.com/gepa-ai/gepa"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="full"

# Tests require the full optional extra and run against live LLM APIs.
RESTRICT="test"

# Core library is dependency-free. 0.1.1 only ships the `full` extra
# (confidence/langchain extras arrived in 0.1.4). datasets/mlflow/wandb
# (upstream `full` extra) are not packaged in ::gentoo (ML stack removed)
# or this overlay — see pkg_postinst. litellm capped at <1.92 because the
# overlay's 1.92+ ebuilds declare a poetry backend while upstream is
# maturin (build failure).
RDEPEND="
	full? (
		>=dev-python/litellm-1.81[${PYTHON_USEDEP}]
		<dev-python/litellm-1.92[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.66[${PYTHON_USEDEP}]
		>=dev-python/cloudpickle-3.0[${PYTHON_USEDEP}]
	)
"

pkg_postinst() {
	optfeature "datasets-based example workloads (upstream full extra)" dev-python/datasets
	optfeature "MLflow experiment tracking (upstream full extra)" dev-python/mlflow
	optfeature "Weights & Biases experiment tracking (upstream full extra)" dev-python/wandb
}
