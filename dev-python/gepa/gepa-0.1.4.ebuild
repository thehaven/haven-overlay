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

IUSE="confidence full langchain"

# Tests require dspy (not packaged in ::gentoo or this overlay) and the
# full optional extra; upstream runs them against live LLM APIs.
RESTRICT="test"

# Core library is dependency-free; all deps below are for optional extras.
# datasets/mlflow/wandb (upstream `full` extra) are not yet packaged in
# ::gentoo (ML stack removed) or this overlay — see pkg_postinst.
RDEPEND="
	full? (
		>=dev-python/litellm-1.83[${PYTHON_USEDEP}]
		<dev-python/litellm-1.92[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.66[${PYTHON_USEDEP}]
		>=dev-python/cloudpickle-3.0[${PYTHON_USEDEP}]
	)
	confidence? (
		>=dev-python/llm-structured-confidence-0.4.5[${PYTHON_USEDEP}]
		>=dev-python/litellm-1.64[${PYTHON_USEDEP}]
		<dev-python/litellm-1.92[${PYTHON_USEDEP}]
	)
	langchain? (
		>=dev-python/langchain-1.0[${PYTHON_USEDEP}]
		>=dev-python/langchain-core-1.0[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.66[${PYTHON_USEDEP}]
	)
"

pkg_postinst() {
	optfeature "datasets-based example workloads (upstream full extra)" dev-python/datasets
	optfeature "MLflow experiment tracking (upstream full extra)" dev-python/mlflow
	optfeature "Weights & Biases experiment tracking (upstream full extra)" dev-python/wandb
}
