# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 systemd

DESCRIPTION="Web UI for Hermes Agent"
HOMEPAGE="https://github.com/nesquena/hermes-webui"
SRC_URI="https://github.com/nesquena/hermes-webui/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	app-misc/hermes[${PYTHON_USEDEP}]
	acct-user/hermes-webui
	acct-group/hermes-webui
"

BDEPEND="
	dev-python/hatchling[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${P}"

src_prepare() {
	distutils-r1_src_prepare

	# 1. Rename 'api' to 'hermes_webui_api' to avoid top-level collision
	mv api hermes_webui_api || die
	find . -name "*.py" -exec sed -i \
		-e 's/\bfrom api\b/from hermes_webui_api/g' \
		-e 's/\bimport api\b/import hermes_webui_api/g' \
		{} + || die

	# 2. Patch references to hermes-agent modules which were renamed in our overlay
	local hermes_mods=( "cli" "utils" "tools" "agent" "gateway" "tui_gateway" "cron" "plugins" "providers" "acp_adapter" "run_agent" "model_tools" "trajectory_compressor" "batch_runner" )
	for mod in "${hermes_mods[@]}"; do
		find . -name "*.py" -exec sed -i \
			-e "s/\bfrom ${mod}\b/from hermes_${mod}/g" \
			-e "s/\bimport ${mod}\b/import hermes_${mod}/g" \
			-e "s/\"${mod}\"/\"hermes_${mod}\"/g" \
			{} + || die
	done

	# 3. Patch agent discovery to support system-installed hermes
	# We force _HERMES_FOUND to True and _AGENT_DIR to a dummy path that doesn't trigger errors
	sed -i 's/_AGENT_DIR = _discover_agent_dir()/_AGENT_DIR = Path("\/usr\/lib\/hermes")/' hermes_webui_api/config.py || die
	sed -i 's/_HERMES_FOUND, _, _ = verify_hermes_imports()/_HERMES_FOUND = True/' hermes_webui_api/config.py || die

	# Create pyproject.toml for PEP517 build
	cat > pyproject.toml <<-EOF
		[build-system]
		requires = ["hatchling"]
		build-backend = "hatchling.build"

		[project]
		name = "hermes-webui"
		version = "${PV}"
		dependencies = [
		    "pyyaml>=6.0",
		]

		[project.scripts]
		hermes-webui = "server:main"

		[tool.hatch.build.targets.wheel]
		packages = ["hermes_webui_api"]

		[tool.hatch.build.targets.wheel.force-include]
		"server.py" = "server.py"
		"static" = "static"
	EOF
}

src_install() {
	distutils-r1_src_install

	systemd_dounit "${FILESDIR}/hermes-webui.service"

	insinto /etc/hermes
	newins "${FILESDIR}/hermes-webui.conf" webui.conf
	newins "${FILESDIR}/hermes-webui.conf" webui.conf.example
}

pkg_postinst() {
	elog "Hermes Web UI has been installed."
	elog "To configure the service, edit /etc/hermes/webui.conf"
	elog "To start the service using systemd, run:"
	elog "  systemctl enable --now hermes-webui"
}
