# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="Vault knowledge agent — search, RAG, and ingestion for Obsidian"
HOMEPAGE="https://github.com/PFPT-Internal/salman-cortex"
EGIT_REPO_URI="https://github.com/PFPT-Internal/salman-cortex.git"

KEYWORDS="~amd64"
LICENSE="Proprietary"
SLOT="0"

RDEPEND="
	acct-group/cortex
	acct-user/cortex
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pydantic-settings[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tiktoken[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	
	systemd_dounit "${FILESDIR}/cortex.service"
	
	if [[ -f docs/cortex.1 ]]; then
		doman docs/cortex.1
	fi
}

pkg_config() {
	local env_file="${EROOT}/etc/cortex/cortex.env"
	if [[ ! -f "${env_file}" ]]; then
		einfo "Generating default configuration in ${env_file}"
		mkdir -p "$(dirname "${env_file}")"
		cat > "${env_file}" <<-EOF
			CORTEX_VAULT_PATH=/path/to/your/obsidian/vault
			CORTEX_DB_PATH=/var/lib/cortex/cortex.db
			LOG_LEVEL=info
		EOF
		chown cortex:cortex "${env_file}"
		chmod 0600 "${env_file}"
	fi
}
