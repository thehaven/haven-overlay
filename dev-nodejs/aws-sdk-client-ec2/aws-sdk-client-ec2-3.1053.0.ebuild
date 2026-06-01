# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@aws-sdk/client-ec2"


DESCRIPTION="AWS SDK for JavaScript Ec2 Client for Node.js, Browser and React Native"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/clients/client-ec2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-sha256-browser
	dev-nodejs/aws-crypto-sha256-js
	dev-nodejs/aws-sdk-core
	dev-nodejs/aws-sdk-credential-provider-node
	dev-nodejs/aws-sdk-middleware-sdk-ec2
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-fetch-http-handler
	dev-nodejs/smithy-node-http-handler
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
