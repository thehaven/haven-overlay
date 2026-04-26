# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="Context & Safety Proxy for LLM requests"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/ai-compressor"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/ai-compressor.git"

KEYWORDS="~amd64"
LICENSE="Proprietary"
SLOT="0"

IUSE="ner"

RDEPEND="
	acct-group/ai-compressor
	acct-user/ai-compressor
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tiktoken[${PYTHON_USEDEP}]
	dev-python/rank-bm25[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
	dev-python/prometheus-fastapi-instrumentator[${PYTHON_USEDEP}]
	dev-python/presidio-analyzer[${PYTHON_USEDEP}]
	dev-python/presidio-anonymizer[${PYTHON_USEDEP}]
	ner? ( dev-python/spacy[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	systemd_dounit "${FILESDIR}/ai-compressor.service"
	
	if [[ -f docs/ai-compressor.1 ]]; then
		doman docs/ai-compressor.1
	fi
}

pkg_config() {
	local env_file="${EROOT}/etc/ai-compressor/ai-compressor.env"
	if [[ ! -f "${env_file}" ]]; then
		einfo "Generating default configuration in ${env_file}"
		mkdir -p "$(dirname "${env_file}")"
		cat > "${env_file}" <<-EOF
			HOST=0.0.0.0
			PORT=8000
			REDIS_HOST=localhost
			REDIS_PORT=6380
			LOG_LEVEL=info
		EOF
		chown ai-compressor:ai-compressor "${env_file}"
		chmod 0600 "${env_file}"
	fi
}
