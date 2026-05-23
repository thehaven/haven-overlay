# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@smithy/credential-provider-imds"
inherit npm

DESCRIPTION="AWS credential provider that sources credentials from the EC2 instance metadata service and ECS container metadata service"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/credential-provider-imds"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
