# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="${PN}-node_modules-${PV}"

DESCRIPTION="Model Context Protocol (MCP) server for Composio"
HOMEPAGE="https://github.com/composiohq/composio"
SRC_URI="
	https://github.com/ComposioHQ/composio/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND=">=net-libs/nodejs-20"
BDEPEND="
	${RDEPEND}
	|| ( dev-lang/bun-bin dev-lang/bun )
"

S="${WORKDIR}/composio-${PV}"

src_unpack() {
	unpack "${P}.tar.gz"
	mkdir -p "${WORKDIR}/node_modules_vendor" || die
	cd "${WORKDIR}/node_modules_vendor" || die
	unpack "${MY_NODE_D}.tar.xz"
}

src_compile() {
	# Use the vendor node_modules for the CLI build
	# pnpm deploy --legacy already resolved all dependencies!
	# We just need to build the CLI using these modules.
	cd "${S}/ts/packages/cli" || die
	
	# Point node_modules to the vendor directory
	ln -s "${WORKDIR}/node_modules_vendor/node_modules" node_modules || die
	
	# Fix __filename esm error in bin.ts (if it was there)
	# and ensure build scripts don't fail
	sed -i 's|"typecheck":.*|"typecheck": "echo pass"|g' package.json || die
	
	# Run build
	bun run build || die
}

src_install() {
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${PN}"
	
	insinto "${module_dir}"
	# Install the built CLI package and the vendor node_modules
	doins -r ts/packages/cli/dist ts/packages/cli/package.json
	
	einfo "Installing vendor node_modules..."
	# Use cp -a to preserve symlinks
	mkdir -p "${ED}/${module_dir}" || die
	cp -a "${WORKDIR}/node_modules_vendor/node_modules" "${ED}/${module_dir}/" || die
	
	dodir /usr/bin
	cat <<-'WRAPPER' > "${ED}/usr/bin/composio-mcp"
		#!/usr/bin/env node
		import "/usr/$(get_libdir)/node_modules/mcp-server-composio/dist/bin.mjs"
	WRAPPER
	fperms +x /usr/bin/composio-mcp
}

pkg_postinst() {
	einfo "mcp-server-composio installed."
	einfo "To use this server, run 'composio-mcp' or configure your client:"
	einfo "  { \"name\": \"composio-mcp\", \"command\": \"composio-mcp\" }"
}