# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 git-r3 systemd

DESCRIPTION="Dynamic MCP gateway: just-in-time tool mounting and policy-aware proxy"
HOMEPAGE="https://github.com/haven/mcp-mesh"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/mcp-mesh.git"

LICENSE="MIT"
SLOT="0"
# v0.19.1: 9999 is opt-in only. Operators must explicitly accept keywords
# (echo "=app-admin/mcp-mesh-9999 **" >> /etc/portage/package.accept_keywords)
# to install the live-source build. Stable tags remain the supported path.
KEYWORDS=""
RESTRICT="network-sandbox"

python_test() {
	# Auto-generated import check
	local mod candidates
	local norm_pn="${PN//-/_}"
	local suffix="${PN#mcp-server-}"
	suffix="${suffix#mcp-}"
	local norm_suffix="${suffix//-/_}"

	candidates=(
		"${norm_pn}"
		"mcp_server_${norm_suffix}"
		"${norm_suffix}"
	)

	for mod in "${candidates[@]}"; do
		einfo "Checking import of ${mod}..."
		if ${EPYTHON} -c "import ${mod}" 2>/dev/null; then
			einfo "Import successful: ${mod}"
			return 0
		fi
	done
	die "Import test failed: none of (${candidates[*]}) could be imported"
}

RDEPEND="
	acct-user/mcp
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/opentelemetry-sdk[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-http[${PYTHON_USEDEP}]
	dev-python/opentelemetry-instrumentation[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/python-socks[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/python-multipart[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	# --- systemd unit + confd (from contrib/systemd/) ---
	systemd_dounit "${S}/contrib/systemd/mcp-mesh.service"
	newconfd "${S}/contrib/systemd/mcp-mesh.confd" mcp-mesh

	# --- Fleet-shared registry template (from contrib/mcp-forge/) ---
	# Installed to /etc/mcp-forge/registry.yaml.example; operators opt in
	# by copying it to /etc/mcp-forge/registry.yaml. Ships with
	# `servers: []` so the service starts cleanly even if nothing is
	# activated.
	insinto /etc/mcp-forge
	newins "${S}/contrib/mcp-forge/registry.yaml.example" registry.yaml.example

	# --- Operator documentation (from contrib/) ---
	docinto contrib
	dodoc "${S}/contrib/README.md"
}

distutils_enable_tests pytest

pkg_postinst() {
	elog "mcp-mesh has been installed. Operator opt-in steps:"
	elog ""
	elog "  1. Enable and start the daemon (Gentoo):"
	elog "       systemctl daemon-reload"
	elog "       systemctl enable --now mcp-mesh"
	elog "       systemctl status mcp-mesh"
	elog ""
	elog "  2. Choose a registry strategy (three-tier precedence):"
	elog "       a. --registry CLI flag (highest)"
	elog "       b. ~/.config/mcp-forge/registry.yaml (per-user)"
	elog "       c. /etc/mcp-forge/registry.yaml    (system-wide)"
	elog ""
	elog "     To activate the fleet-shared template:"
	elog "       cp /etc/mcp-forge/registry.yaml.example \\"
	elog "          /etc/mcp-forge/registry.yaml"
	elog "       \${EDITOR:-vi} /etc/mcp-forge/registry.yaml"
	elog "       systemctl restart mcp-mesh"
	elog ""
	elog "  3. Verify:"
	elog "       uv run mcp-mesh doctor"
	elog "       curl -sS http://127.0.0.1:7780/health"
	elog "       curl -sS http://127.0.0.1:7780/ready"
	elog ""
	elog "Full guide: /usr/share/doc/${PF}/contrib/README.md"
	elog ""
	elog "v0.19.1 hardening note: the systemd unit uses a deny-list"
	elog "seccomp filter (~@cpu-emulation @debug @module @mount"
	elog "@obsolete @raw-io @reboot @swap @clock) because Python 3.14"
	elog "+ cryptography + uvicorn triggered SIGSYS under the previous"
	elog "~@system-service allow-list. See FINDINGS.md for details."
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		systemctl try-restart mcp-mesh.service 2>/dev/null || true
	fi
}
