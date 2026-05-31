# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_13 python3_14 )

inherit distutils-r1 systemd git-r3

DESCRIPTION="Webhook listener for ZFS-aware Docker Compose updates"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/docker-updater"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/gentoo/docker-updater.git"
EGIT_COMMIT="4a65b9555ed1c3d72bf58656cb10572d2d15575a"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test" # System-wide omegaconf/hydra pytest plugin is broken due to missing antlr4

RDEPEND="
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/textual[${PYTHON_USEDEP}]
	acct-user/docker-updater
	acct-group/docker-updater
"
DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install


	# Install manual page
	doman docs/docker-updater.1

	# Install default config
	insinto /etc/docker-updater
	cat << 'EOF_INNER_CONFIG' > "${T}/config.toml"
enable_zfs_snapshots = true
enable_auto_rollback = true
enable_strict_opt_in = true
enable_notifications = false
zfs_dataset = "tank/docker"
zfs_base_dataset = "tank/docker"
max_snapshots = 5
health_check_timeout = 300
web_port = 8000
enable_web_interface = true
EOF_INNER_CONFIG
	doins "${T}/config.toml"

	# Install systemd service unit
	sed -e 's|/storage/docker/docker-updater/.venv/bin/python -m docker_updater.main|/usr/bin/docker-updater|' \
		templates/docker-updater.service > "${T}/docker-updater.service" || die
	systemd_dounit "${T}/docker-updater.service"

	# Install OpenRC init script
	sed -e 's|command="/storage/docker/docker-updater/.venv/bin/python"|command="/usr/bin/docker-updater"|' \
		-e 's|command_args="-m docker_updater.main |command_args="|' \
		templates/docker-updater.init > "${T}/docker-updater.init" || die
	newinitd "${T}/docker-updater.init" docker-updater

	# Install sudoers config (renamed to exclude extension)
	insinto /etc/sudoers.d
	newins templates/docker-updater.sudoers docker-updater
	fperms 0440 /etc/sudoers.d/docker-updater

	# Keep directory with appropriate permissions
	diropts -m0755 -o docker-updater -g docker-updater
	keepdir /storage/docker/docker-updater
}
