# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/client-s3"

inherit npm

DESCRIPTION="AWS SDK for JavaScript S3 Client for Node.js, Browser and React Native"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/clients/client-s3"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-sha1-browser
	dev-nodejs/aws-crypto-sha256-browser
	dev-nodejs/aws-crypto-sha256-js
	dev-nodejs/aws-sdk-core
	dev-nodejs/aws-sdk-credential-provider-node
	dev-nodejs/aws-sdk-middleware-bucket-endpoint
	dev-nodejs/aws-sdk-middleware-expect-continue
	dev-nodejs/aws-sdk-middleware-flexible-checksums
	dev-nodejs/aws-sdk-middleware-location-constraint
	dev-nodejs/aws-sdk-middleware-sdk-s3
	dev-nodejs/aws-sdk-middleware-ssec
	dev-nodejs/aws-sdk-signature-v4-multi-region
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-fetch-http-handler
	dev-nodejs/smithy-node-http-handler
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
