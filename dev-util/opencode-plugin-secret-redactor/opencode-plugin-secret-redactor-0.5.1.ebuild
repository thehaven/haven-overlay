# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin that redacts secrets from tool outputs before agent context"
HOMEPAGE="https://github.com/casonadams/opencode-secret-redactor"
SRC_URI="https://registry.npmjs.org/opencode-secret-redactor/-/opencode-secret-redactor-0.5.1.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Local patch: credit_card detection false-positives on long digit runs
# (e.g. SolarEdge Modbus float32-max sentinel). Adds Luhn validation and
# requires complete digit runs ((?<!\d)...(?!\d)). Upstream PR:
# https://github.com/casonadams/opencode-secret-redactor/pull/2
PATCHES=(
	"${FILESDIR}/opencode-plugin-secret-redactor-0.5.1-luhn-credit-card.patch"
	# Dual V1/V2 entrypoint: upstream dist/plugin.js default-exports the
	# SecretRedactor function (V1-only). OpenCode V2 requires the default
	# export to be an object with { id, setup|effect }, so this patch adds a
	# `setup(ctx)` that ports the V1 hooks onto the V2 hook API while keeping
	# the V1 function reachable via the `server` export.
	"${FILESDIR}/opencode-plugin-secret-redactor-0.5.1-dual-entrypoint.patch"
)

src_install() {
	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r dist package.json
	fperms 0755 "/usr/$(get_libdir)/node_modules/${PN}/dist/plugin.cjs"

	# Root entrypoint shim. OpenCode V2 resolves a plugin *directory* by
	# require.resolve()-ing "<dir>/server" then "<dir>/index" (the `x0`
	# resolver in the opencode2 binary), then reading that module's
	# `default`; it does NOT fall back to the nested dist/ entrypoint for
	# a bare directory, so without this the package is silently dropped
	# from the V2 plugin set. The shim re-exports the dual V1/V2
	# entrypoint; V2 reads `default`, V1 behaviour is unchanged.
	newins "${FILESDIR}/${P}-server-shim.js" server.js
}
