# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Media request and discovery manager for Jellyfin/Plex/Emby"
HOMEPAGE="https://github.com/seerr-team/seerr"

SRC_URI="https://github.com/seerr-team/seerr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

# pnpm install fetches the registry at build time — network-sandbox OPENS
# the network namespace for this package (it disables the default sandbox)
BDEPEND="
	>=net-libs/nodejs-22.19[npm] <net-libs/nodejs-23
	media-libs/vips
	sys-devel/gcc
	dev-build/make
"

# Runtime deps come from the pnpm-installed node_modules installed alongside
# the build output. The dev-nodejs/* atoms previously listed here point at
# packages that were never packaged in this overlay — they cannot resolve.
RDEPEND="
	>=net-libs/nodejs-22.19 <net-libs/nodejs-23
	>=media-libs/vips-8.12
"

DEPEND="${RDEPEND}"

# Source-based build: pnpm install --frozen-lockfile then pnpm build.
# Pin to upstream's declared packageManager (pnpm@10.24.0, lockfileVersion
# 9.0) — an unpinned npx --yes pnpm drifts and mismatches the lockfile.
src_compile() {
	einfo "Running pnpm install --frozen-lockfile"
	npx --yes pnpm@10.24.0 install --frozen-lockfile || die "pnpm install failed"

	einfo "Running pnpm build"
	npx --yes pnpm@10.24.0 build || die "pnpm build failed"
}

src_install() {
	insinto /usr/lib/node_modules/seerr
	doins -r dist .next public server package.json next.config.* tsconfig*.json seerr-api.yml

	# Install the pnpm-resolved node_modules so the server can resolve its
	# runtime imports (express, react, sharp, typeorm…)
	doins -r node_modules

	# Create bin wrapper
	exeinto /usr/bin
	newexe - seerr <<'EOF'
#!/usr/bin/env bash
exec /usr/bin/node /usr/lib/node_modules/seerr/dist/index.js "$@"
EOF
	fperms +x /usr/bin/seerr

	# Smoke test: bin present + key runtime deps resolved
	[[ -e "${ED}/usr/lib/node_modules/seerr/node_modules/express" ]] || \
		die "node_modules missing — seerr cannot run"
	[[ -e "${ED}/usr/lib/node_modules/seerr/node_modules/next" ]] || \
		die "next missing from node_modules"

	einstalldocs
}
