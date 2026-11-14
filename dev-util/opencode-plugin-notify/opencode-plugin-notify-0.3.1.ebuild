# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="opencode-notify"

DESCRIPTION="Native OS notifications for OpenCode — know when tasks complete"
HOMEPAGE="https://github.com/kdcokenny/opencode-notify"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die
	# Smoke test: plugin entry present with resolved deps
	# (catches the extract-only anti-pattern — deps must come from npm,
	# not bogus dev-nodejs/* atoms)
	local mod="/usr/$(get_libdir)/node_modules/${NPM_PKG}"
	[[ -f "${ED}${mod}/dist/index.js" ]] || die "plugin entry dist/index.js missing"
	# v2 root entrypoint shim: upstream dist/index.js exports a V1 function
	# default; v2's directory resolver looks for root <pkg>/server.js.
	insinto "${mod}"
	newins "${FILESDIR}/${P}-server-shim.js" server.js
	sed -i \
		-e '/"types": "dist\/index.d.ts",/a \  "exports": {\n    ".": "./server.js",\n    "./server": "./server.js",\n    "./package.json": "./package.json"\n  },' \
		"${ED}${mod}/package.json" || die "failed to patch package.json"
	cat >> "${ED}${mod}/dist/index.js" <<-'EOF' || die
	async function __v2_setup(ctx) {
	  const hooks = await opencodeNotifyPlugin({
	    client: ctx.client,
	  });
	  if (hooks?.["tool.execute.before"] && ctx.tool?.hook) {
	    await ctx.tool.hook("execute.before", async (event) => {
	      if (!event) return;
	      await hooks["tool.execute.before"](
	        { tool: event.tool, sessionID: event.sessionID, callID: event.callID },
	        { args: event.input }
	      );
	    });
	  }
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
	  id: "opencode-notify",
	  setup: __v2_setup,
	  server: opencodeNotifyPlugin,
	};
	export { opencodeNotifyPlugin as server, __v2_setup as setup };
	export default __v2_plugin;
	EOF
}
pkg_postinst() {
	einfo "OpenCode Notify plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  "/usr/$(get_libdir)/node_modules/opencode-notify/dist/index.js""
}
