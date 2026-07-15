# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# opentelemetry-exporter-otlp — source-build notes
# ------------------------------------------------------------------
# Upstream uses hatchling with a static path-based version (no VCS).
# The sdist ships PKG-INFO with the version baked in.
#
# This umbrella package pulls in both the gRPC and HTTP proto
# sub-packages (opentelemetry-exporter-otlp-proto-grpc,
# opentelemetry-exporter-otlp-proto-http). Neither is yet packaged in
# this overlay or ::gentoo, so emerge will fail until they are added.
# Run `grep -A4 'dependencies' pyproject.toml` after each upstream
# release to refresh this comment.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="OpenTelemetry Collector Exporters"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# TODO: package opentelemetry-exporter-otlp-proto-grpc and
# opentelemetry-exporter-otlp-proto-http (both ==1.43.0) so this
# RDEPEND resolves.
RDEPEND="
	>=dev-python/opentelemetry-api-1.43.0[${PYTHON_USEDEP}]
"
