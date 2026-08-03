# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Pinned at 9.5.0 to match /storage/docker/solr/start.sh. Auto-bumping
# would silently drop this ebuild and replace it with a newer release;
# the haven-overlay/ebuild-updater.toml [pipeline].hold pins this
# category/package to keep 9.5.0 stable.

EAPI=8

inherit systemd

DESCRIPTION="Apache Solr — blazing-fast open source search platform built on Lucene"
HOMEPAGE="https://solr.apache.org/"
SRC_URI="https://archive.apache.org/dist/solr/solr/${PV}/solr-${PV}.tgz"
S="${WORKDIR}/solr-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"
RESTRICT="strip"

# Apache Solr 9.5.0 ships its bundled binary distribution. We install
# it as-is under /usr/share/solr rather than re-building from the
# gradle source tree, because:
#   1. The upstream solr-9.5.0.tgz is the same artifact the official
#      Docker image (solr:9.5.0) installs in /opt/solr.
#   2. The binary distribution is signed + checksummed upstream;
#      rebuilding would diverge from what /storage/docker/solr runs.
#   3. The bundled start.jar + Jetty config is what production uses.
#
# The gradle-based source build remains available via solr-src ebuilds
# in main portage for development environments.

RDEPEND="
	acct-user/solr
	acct-group/solr
	|| (
		>=dev-java/openjdk-bin-17
		>=virtual/jdk-17
	)
	systemd? ( sys-apps/systemd )
"

# Upstream wants at least JDK 17 at runtime; we don't need to build
# anything from source, so no BDEPEND entry beyond what acct-user/-group
# provides transitively.
src_unpack() {
	default

	# Drop the upstream Dockerfile — it's not useful inside a package
	# and would otherwise be installed into /usr/share/solr/docker/.
	rm -rf "${S}"/docker || die

	# Drop the docs/ tree to keep the install small (~10 MB). Users who
	# want the upstream PDF docs can fetch them from solr.apache.org.
	rm -rf "${S}"/docs || die
}

src_install() {
	local solr_dir="/usr/share/solr"

	# Tree-install everything except contrib/ (mostly external CLI
	# tools that don't belong on a server install).
	insinto "${solr_dir}"
	doins -r bin lib server modules prometheus-exporter example
	use systemd || rmdir "${ED}/${solr_dir}/docker" 2>/dev/null

	# Bin/ has shell scripts that need to be executable.
	fperms -R 0755 "${solr_dir}/bin"

	# Make the CLI reachable on PATH.
	dosym "${solr_dir}/bin/solr" "/usr/bin/solr"

	# Drop the upstream-bundled init.d script — we ship our own.
	rm -f "${ED}/${solr_dir}/bin/init.d/solr" || die

	# /etc/solr/solr.in.sh: configuration template. The upstream
	# bin/solr script searches /usr/share/solr/solr.in.sh first, then
	# /etc/default/solr.in.sh — we install to /etc/solr which upstream
	# also searches. We do NOT enable any of the commented defaults;
	# the operator uncomments what they need.
	insinto /etc/solr
	newins bin/solr.in.sh solr.in.sh
	fperms 0644 /etc/solr/solr.in.sh

	# /var/solr/{data,logs,}: runtime-owned dirs.
	keepdir /var/solr/data
	keepdir /var/solr/logs
	fowners solr:solr /var/solr/{data,logs}
	fperms 0750 /var/solr/{data,logs}

	# Init + service files.
	newinitd "${FILESDIR}"/solr.initd solr

	if use systemd; then
		systemd_dounit "${FILESDIR}"/solr.service
	fi

	# Documentation: ship the README + CHANGES. License is huge; we
	# only ship NOTICE.txt and a pointer to LICENSE.txt (the upstream
	# archive bundles all per-dep licenses under licenses/).
	dodoc README.txt CHANGES.txt
	insinto /usr/share/solr
	doins NOTICE.txt LICENSE.txt
}

pkg_postinst() {
	elog "Apache Solr ${PV} installed under /usr/share/solr."
	elog "Configuration: /etc/solr/solr.in.sh"
	elog "Runtime data:   /var/solr/data"
	elog "Runtime logs:   /var/solr/logs"
	elog ""
	elog "Start with:  rc-service solr start   (or: systemctl start solr)"
	elog "Create a core: solr create_core -c mycore -d basic_configs"
}
