# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Media request and discovery manager for Jellyfin/Plex/Emby"
HOMEPAGE="https://github.com/seerr-team/seerr"

SRC_URI="https://github.com/seerr-team/seerr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Build-time: pnpm + Node + native compile toolchain + vips headers
BDEPEND="
	sys-apps/pnpm-bin
	>=net-libs/nodejs-22.19
	media-libs/vips
	sys-devel/gcc
	dev-build/make

"

# Runtime: all 77 npm deps + Node + vips runtime.
# Scoped packages use the bare PN form (portage atoms cannot contain @).
RDEPEND="
	${BDEPEND}
	>=net-libs/nodejs-22.19
	>=media-libs/vips-8.12
	dev-nodejs/bcrypt
	dev-nodejs/bowser
	dev-nodejs/connect-typeorm
	dev-nodejs/cookie-parser
	dev-nodejs/copy-to-clipboard
	dev-nodejs/country-flag-icons
	dev-nodejs/cronstrue
	dev-nodejs/dns-caching
	dev-nodejs/email-templates
	dev-nodejs/express
	dev-nodejs/express-openapi-validator
	dev-nodejs/express-rate-limit
	dev-nodejs/express-session
	dev-nodejs/formik
	dev-nodejs/gravatar-url
	dev-nodejs/http-proxy-agent
	dev-nodejs/https-proxy-agent
	dev-nodejs/humanize-duration
	dev-nodejs/js-yaml
	dev-nodejs/lodash
	dev-nodejs/mime
	dev-nodejs/nanoid
	dev-nodejs/next
	dev-nodejs/node-cache
	dev-nodejs/node-gyp
	dev-nodejs/node-schedule
	dev-nodejs/nodemailer
	dev-nodejs/openpgp
	dev-nodejs/pg
	dev-nodejs/pug
	dev-nodejs/react
	dev-nodejs/react-ace
	dev-nodejs/react-animate-height
	dev-nodejs/react-aria
	dev-nodejs/react-dom
	dev-nodejs/react-hot-toast
	dev-nodejs/react-intersection-observer
	dev-nodejs/react-intl
	dev-nodejs/react-markdown
	dev-nodejs/react-popper-tooltip
	dev-nodejs/react-select
	dev-nodejs/react-transition-group
	dev-nodejs/react-truncate-markup
	dev-nodejs/react-use-clipboard
	dev-nodejs/reflect-metadata
	dev-nodejs/semver
	dev-nodejs/sharp
	dev-nodejs/sqlite3
	dev-nodejs/swagger-ui-express
	dev-nodejs/swr
	dev-nodejs/tailwind-merge
	dev-nodejs/typeorm
	dev-nodejs/ua-parser-js
	dev-nodejs/undici
	dev-nodejs/validator
	dev-nodejs/web-push
	dev-nodejs/wink-jaro-distance
	dev-nodejs/winston
	dev-nodejs/winston-daily-rotate-file
	dev-nodejs/xml2js
	dev-nodejs/yup
	dev-nodejs/zod
	dev-nodejs/axios
	dev-nodejs/axios-rate-limit
	dev-nodejs/dr-pogodin-csurf
	dev-nodejs/fontsource-variable-inter
	dev-nodejs/formatjs-intl
	dev-nodejs/formatjs-intl-locale
	dev-nodejs/headlessui-react
	dev-nodejs/heroicons-react
	dev-nodejs/react-spring-web
	dev-nodejs/seerr-team-react-tailwindcss-datepicker
	dev-nodejs/supercharge-request-ip
	dev-nodejs/svgr-webpack
	dev-nodejs/tanem-react-nprogress
	dev-nodejs/ace-builds
"

DEPEND="${RDEPEND}"

# Source-based build: pnpm install --frozen-lockfile then pnpm build
src_compile() {
	einfo "Running pnpm install --frozen-lockfile"
	pnpm install --frozen-lockfile || die "pnpm install failed"

	einfo "Running pnpm build"
	pnpm build || die "pnpm build failed"
}

src_install() {
	insinto /usr/lib/node_modules/seerr
	doins -r dist .next public server package.json next.config.* tsconfig*.json seerr-api.yml

	# Create bin wrapper
	exeinto /usr/bin
	newexe - seerr <<'EOF'
#!/usr/bin/env bash
exec /usr/bin/node /usr/lib/node_modules/seerr/dist/index.js "$@"
EOF
	fperms +x /usr/bin/seerr

	einstalldocs
}
