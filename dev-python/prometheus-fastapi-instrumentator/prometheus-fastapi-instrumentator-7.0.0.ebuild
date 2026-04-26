EAPI=8
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..13} )
inherit distutils-r1 pypi
DESCRIPTION="Instrument your FastAPI with Prometheus metrics"
HOMEPAGE="https://github.com/trallnag/prometheus-fastapi-instrumentator"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
    dev-python/fastapi[${PYTHON_USEDEP}]
    dev-python/prometheus-client[${PYTHON_USEDEP}]
"
