# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="OpenCode tmux integration: automatically opens subagent panes"
HOMEPAGE="https://github.com/AnganSamadder/opentmux"
SRC_URI="https://github.com/AnganSamadder/opentmux/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/opentmux-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test strip"

src_prepare() {
	default
	sed -i \
		-e 's/"version": "1.5.6"/"version": "'"${PV}"'"/' \
		-e '/"types": "dist\/index.d.ts",/a \  "exports": {\n    ".": "./dist/index.js",\n    "./server": "./server.js",\n    "./package.json": "./package.json"\n  },' \
		package.json || die "failed to patch package.json"
}

src_compile() {
	# Source-based deps (replaces the former MY_NODE_D mirror tarball).
	rm -f package-lock.json
	bun install --ignore-scripts || die "bun install failed"
	bun run build || die "bun run build failed"
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json node_modules
	newins "${FILESDIR}/server-shim.js" server.js
	cat >> "${ED}/usr/$(get_libdir)/node_modules/${PN}/dist/index.js" <<-'EOF' || die
	async function __v2_setup(ctx) {
	  const hooks = await OpencodeAgentTmux({
	    client: ctx.client,
	    directory: ctx.location?.directory ?? ctx.directory,
	    serverUrl: ctx.server?.url ?? ctx.serverUrl,
	  });
	  if (hooks?.event && ctx.event?.subscribe) {
	    void (async () => {
	      try {
	        for await (const event of await ctx.event.subscribe()) {
	          await hooks.event({ event });
	        }
	      } catch {}
	    })();
	  }
	}
	const __v2_plugin = {
	  id: "opentmux",
	  setup: __v2_setup,
	  server: OpencodeAgentTmux,
	};
	export { OpencodeAgentTmux as server, __v2_setup as setup };
	export default __v2_plugin;
	EOF
}

pkg_postinst() {
	einfo "opencode-plugin-tmux installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\" }"
}
