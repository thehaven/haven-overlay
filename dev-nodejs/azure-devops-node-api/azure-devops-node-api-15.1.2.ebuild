# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="azure-devops-node-api"

inherit npm

DESCRIPTION="Node client for Azure DevOps and TFS REST APIs"
HOMEPAGE="https://github.com/Microsoft/azure-devops-node-api#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tunnel
	dev-nodejs/typed-rest-client
"
BDEPEND=""
