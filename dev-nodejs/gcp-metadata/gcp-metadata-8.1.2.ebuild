# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="gcp-metadata"

inherit npm

DESCRIPTION="Get the metadata from a Google Cloud Platform environment"
HOMEPAGE="https://github.com/googleapis/google-cloud-node-core/tree/main/packages/gcp-metadata"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/gaxios
	dev-nodejs/google-logging-utils
	dev-nodejs/json-bigint
"
BDEPEND=""
