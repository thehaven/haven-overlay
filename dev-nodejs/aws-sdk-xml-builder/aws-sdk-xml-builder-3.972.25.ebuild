# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/xml-builder"
inherit npm

DESCRIPTION="XML utilities for the AWS SDK"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/xml-builder"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fast-xml-parser
	dev-nodejs/nodable-entities
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
