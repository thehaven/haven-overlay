# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="renovate"

inherit npm

DESCRIPTION="Automated dependency updates. Flexible so you don't need to be."
HOMEPAGE="https://renovatebot.com"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ae-cvss-calculator
	dev-nodejs/agentkeepalive
	dev-nodejs/async-mutex
	dev-nodejs/aws-sdk-client-codecommit
	dev-nodejs/aws-sdk-client-ec2
	dev-nodejs/aws-sdk-client-ecr
	dev-nodejs/aws-sdk-client-eks
	dev-nodejs/aws-sdk-client-rds
	dev-nodejs/aws-sdk-client-s3
	dev-nodejs/aws-sdk-credential-providers
	dev-nodejs/aws4
	dev-nodejs/azure-devops-node-api
	dev-nodejs/baszalmstra-rattler
	dev-nodejs/breejs-later
	dev-nodejs/bunyan
	dev-nodejs/cacache
	dev-nodejs/cdktf-hcl2json
	dev-nodejs/changelog-filename-regex
	dev-nodejs/clean-git-ref
	dev-nodejs/commander
	dev-nodejs/croner
	dev-nodejs/cronstrue
	dev-nodejs/deepmerge
	dev-nodejs/dequal
	dev-nodejs/detect-indent
	dev-nodejs/diff
	dev-nodejs/editorconfig
	dev-nodejs/email-addresses
	dev-nodejs/emoji-regex
	dev-nodejs/emojibase
	dev-nodejs/emojibase-regex
	dev-nodejs/execa
	dev-nodejs/extract-zip
	dev-nodejs/find-packages
	dev-nodejs/find-up
	dev-nodejs/fs-extra
	dev-nodejs/git-url-parse
	dev-nodejs/github-url-from-git
	dev-nodejs/glob
	dev-nodejs/global-agent
	dev-nodejs/google-auth-library
	dev-nodejs/got
	dev-nodejs/graph-data-structure
	dev-nodejs/handlebars
	dev-nodejs/ignore
	dev-nodejs/ini
	dev-nodejs/json-dup-key-validator
	dev-nodejs/json-stringify-pretty-compact
	dev-nodejs/json5
	dev-nodejs/jsonata
	dev-nodejs/jsonc-weaver
	dev-nodejs/klona
	dev-nodejs/lru-cache
	dev-nodejs/luxon
	dev-nodejs/markdown-it
	dev-nodejs/markdown-table
	dev-nodejs/minimatch
	dev-nodejs/moo
	dev-nodejs/ms
	dev-nodejs/neotraverse
	dev-nodejs/node-html-parser
	dev-nodejs/opentelemetry-api
	dev-nodejs/opentelemetry-context-async-hooks
	dev-nodejs/opentelemetry-exporter-trace-otlp-http
	dev-nodejs/opentelemetry-instrumentation
	dev-nodejs/opentelemetry-instrumentation-bunyan
	dev-nodejs/opentelemetry-instrumentation-http
	dev-nodejs/opentelemetry-instrumentation-redis
	dev-nodejs/opentelemetry-resource-detector-aws
	dev-nodejs/opentelemetry-resource-detector-azure
	dev-nodejs/opentelemetry-resource-detector-gcp
	dev-nodejs/opentelemetry-resource-detector-github
	dev-nodejs/opentelemetry-resources
	dev-nodejs/opentelemetry-sdk-trace-base
	dev-nodejs/opentelemetry-sdk-trace-node
	dev-nodejs/opentelemetry-semantic-conventions
	dev-nodejs/p-all
	dev-nodejs/p-map
	dev-nodejs/p-queue
	dev-nodejs/p-throttle
	dev-nodejs/parse-link-header
	dev-nodejs/pnpm-parse-overrides
	dev-nodejs/prettier
	dev-nodejs/protobufjs
	dev-nodejs/punycode
	dev-nodejs/qnighy-marshal
	dev-nodejs/redis-client
	dev-nodejs/remark
	dev-nodejs/remark-gfm
	dev-nodejs/remark-github
	dev-nodejs/renovatebot-detect-tools
	dev-nodejs/renovatebot-good-enough-parser
	dev-nodejs/renovatebot-osv-offline
	dev-nodejs/renovatebot-pep440
	dev-nodejs/renovatebot-pgp
	dev-nodejs/renovatebot-ruby-semver
	dev-nodejs/safe-stable-stringify
	dev-nodejs/sax
	dev-nodejs/semver
	dev-nodejs/semver-stable
	dev-nodejs/semver-utils
	dev-nodejs/shlex
	dev-nodejs/simple-git
	dev-nodejs/sindresorhus-is
	dev-nodejs/slugify
	dev-nodejs/source-map-support
	dev-nodejs/strip-json-comments
	dev-nodejs/toml-eslint-parser
	dev-nodejs/tslib
	dev-nodejs/upath
	dev-nodejs/url-join
	dev-nodejs/validate-npm-package-name
	dev-nodejs/xmldoc
	dev-nodejs/yaml
	dev-nodejs/yarnpkg-core
	dev-nodejs/yarnpkg-parsers
	dev-nodejs/zod
"
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin dist/renovate.js renovate
	npm_install_bin dist/config-validator.js renovate-config-validator
}

pkg_postinst() {
	elog "Renovate ${PV} has been installed!"
	elog ""
	elog "To run Renovate locally or self-hosted, you typically need a platform token."
	elog "For GitHub:"
	elog "  export RENOVATE_TOKEN=ghp_your_personal_access_token"
	elog "  renovate --token \$RENOVATE_TOKEN your/repo"
	elog ""
	elog "For GitLab:"
	elog "  export RENOVATE_TOKEN=glpat-your_personal_access_token"
	elog "  renovate --token \$RENOVATE_TOKEN your/repo"
	elog ""
	elog "For full documentation on self-hosting, see:"
	elog "  https://docs.renovatebot.com/self-hosted-configuration/"
	elog ""
	elog "Configuration files are usually named renovate.json or renovate.config.js."
	elog "To set a global cache directory (highly recommended):"
	elog "  export RENOVATE_CACHE_DIR=/var/cache/renovate"
}
