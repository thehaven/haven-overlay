# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gemini CLI - a command-line AI workflow tool by Google"
HOMEPAGE="https://github.com/google-gemini/gemini-cli"

# The GitHub release gemini.js is broken in v0.35.0+ — it uses code splitting
# and imports chunk-*.js files that are NOT shipped as release assets.
# We use the official npm tarballs instead, which contain the full dist tree.
SRC_URI="
	https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-${PV}.tgz
		-> ${P}.tgz
	https://registry.npmjs.org/@google/gemini-cli-core/-/gemini-cli-core-${PV}.tgz
		-> ${PN}-core-${PV}.tgz
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

# net-libs/nodejs[npm] is required; npm is used at install time to fetch
# the remaining runtime dependency tree into the package libdir.
RDEPEND="
	>=net-libs/nodejs-20[npm]
"
BDEPEND="
	>=net-libs/nodejs-20[npm]
"

# npm fetches deps at install time — restrict network-dependent checks
RESTRICT="network-sandbox"

src_unpack() {
	# npm tarballs extract to a directory named 'package/'
	unpack "${P}.tgz"
	mv package "${P}" || die

	# Unpack core alongside cli so we can place it in node_modules
	mkdir -p "${P}/node_modules/@google" || die
	unpack "${PN}-core-${PV}.tgz"
	mv package "${P}/node_modules/@google/gemini-cli-core" || die
}

src_compile() {
	# Fetch all remaining runtime dependencies via npm.
	# --ignore-scripts: skip lifecycle hooks (postinstall etc.) from untrusted deps
	# --omit=dev: production deps only
	cd "${S}/${P}" || die
	npm install \
		--ignore-scripts \
		--omit=dev \
		--no-audit \
		--no-fund \
		|| die "npm install failed"
}

src_install() {
	local LIBDIR="/usr/lib/${P}"

	# Install the full package tree (dist/ + node_modules/)
	insinto "${LIBDIR}"
	doins -r "${P}/dist"
	doins -r "${P}/node_modules"
	doins "${P}/package.json"

	# Wrapper script: invokes node with the correct working directory so that
	# Node's ESM resolver can find node_modules as siblings of dist/index.js.
	# --no-warnings=DEP0040 suppresses the punycode deprecation warning that
	# upstream silences by default in their published shebang.
	# --no-deprecation is kept for parity with the previous ebuild behaviour.
	cat > "${T}/gemini" <<EOF
#!/bin/sh
exec node --no-warnings=DEP0040 --no-deprecation "${LIBDIR}/dist/index.js" "\$@"
EOF
	dobin "${T}/gemini"

	# Optional: install the JSON settings schema for IDE/editor integration
	if [[ -f "${P}/node_modules/@google/gemini-cli-core/dist/src/config/settings.schema.json" ]]; then
		insinto /usr/share/${PN}
		doins "${P}/node_modules/@google/gemini-cli-core/dist/src/config/settings.schema.json"
	fi
}

pkg_postinst() {
	elog "Gemini CLI has been installed to /usr/bin/gemini."
	elog ""
	elog "Runtime dependencies were fetched via npm during installation."
	elog "If you are running in a network-restricted environment, pre-populate"
	elog "your npm cache or use FEATURES=-network-sandbox."
	elog ""
	elog "On first run, 'gemini' will prompt you to authenticate with Google."
}
