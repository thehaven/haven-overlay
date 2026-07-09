# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature systemd

MY_NODE_D="${PN}-node_modules-${PV}"

DESCRIPTION="Web-based workspace for Hermes Agent with chat, terminal, skills manager"
HOMEPAGE="https://github.com/outsourc-e/hermes-workspace"
SRC_URI="
	https://github.com/outsourc-e/hermes-workspace/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

S="${WORKDIR}/${PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# Runtime: Node.js 22+ (enforced by upstream install.sh); optional
# python3 for the in-browser terminal feature (pty-helper.py).
RDEPEND="
	>=net-libs/nodejs-22
	acct-user/hermes-workspace
	acct-group/hermes-workspace
"
BDEPEND="
	>=net-libs/nodejs-22
	test? ( >=net-libs/nodejs-22 )
"

# node_modules tarball extracts to ${WORKDIR}/node_modules (pnpm layout).
# Symlink it into ${S} so vite/vitest resolve from the source dir.
src_unpack() {
	default
	ln -s "${WORKDIR}/node_modules" "${S}/node_modules" || die
}

src_compile() {
	NODE_OPTIONS="--max-old-space-size=2048" \
		node node_modules/vite/bin/vite.js build || die "vite build failed"
}

src_test() {
	# 6 upstream test files at v2.3.0 reference functions that were
	# removed/renamed (getTrailingToolOnlyTurnSummary,
	# estimateContextTokensFromMessages, etc.) — pre-existing upstream
	# bugs, not ebuild issues. Excluded so the gate catches regressions
	# in the remaining 84 passing test files (588 tests).
	node node_modules/vitest/vitest.mjs run \
		--exclude src/lib/i18n.test.ts \
		--exclude src/routes/api/-context-usage.test.ts \
		--exclude src/routes/api/mcp/-hub-search.test.ts \
		--exclude src/screens/swarm2/swarm2-screen.test.ts \
		--exclude src/screens/chat/components/chat-composer-context-controls.test.ts \
		--exclude src/screens/chat/components/chat-message-list.test.tsx \
		|| die "vitest run failed"
}

src_install() {
	# Install the application to /usr/share (web app, not a node module)
	insinto /usr/share/${PN}
	doins -r dist
	doins server-entry.js package.json

	# Bundled Hermes Agent skills
	if [[ -d skills ]]; then
		doins -r skills
	fi

	# Default config
	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}.env ${PN}.env

	# Systemd unit
	systemd_dounit "${FILESDIR}"/${PN}.service

	# Runtime state and log directories
	keepdir /var/lib/${PN}
	keepdir /var/log/${PN}
	fowners hermes-workspace:hermes-workspace /var/lib/${PN} /var/log/${PN}
}

pkg_postinst() {
	elog "Hermes Workspace has been installed to /usr/share/${PN}."
	elog ""
	elog "IMPORTANT: The workspace is a UI shell only — it has NO built-in"
	elog "LLM backend. It requires an external service to function:"
	elog "  - a Hermes Agent gateway (recommended), OR"
	elog "  - any OpenAI-compatible HTTP server (Ollama, LM Studio, vLLM, ...)"
	elog ""
	elog "Before starting the service:"
	elog "  1. Edit /etc/${PN}/${PN}.env and set at least one of:"
	elog "       HERMES_API_URL=http://127.0.0.1:8642   (Hermes Agent gateway)"
	elog "       OPENAI_BASE_URL=http://127.0.0.1:1234/v1 (OpenAI-compat server)"
	elog "     or an LLM provider key (ANTHROPIC_API_KEY, OPENAI_API_KEY, ...)"
	elog "     Without one of these the UI will start but every chat will fail."
	elog ""
	elog "  2. For remote (non-loopback) access, set in the env file:"
	elog "       HOST=0.0.0.0"
	elog "       HERMES_PASSWORD=<your-password>"
	elog "     The workspace refuses to start on non-loopback without a password."
	elog ""
	elog "  3. Enable and start the service:"
	elog "       systemctl enable --now ${PN}.service"
	elog ""
	elog "  4. Verify:"
	elog "       systemctl status ${PN}.service"
	elog "       curl -fsS http://127.0.0.1:3000/"
	elog ""
	elog "Bundled Hermes Agent skills are in /usr/share/${PN}/skills/."
	elog "Symlink any you want your local Hermes Agent to discover into"
	elog "~/.hermes/skills/ (or /var/lib/hermes/.hermes/skills/ for a"
	elog "system Hermes Agent)."
	elog ""
	elog "Default listen: http://127.0.0.1:3000"
	elog "State dir:      /var/lib/${PN}/"
	elog "Log dir:        /var/log/${PN}/"
	elog ""
	elog "Optional runtime features:"
	# Hermes Agent gateway — the canonical backend. Needs USE=web for the
	# HTTP gateway server (fastapi/uvicorn). See pkg_postinst of
	# app-misc/hermes for gateway setup (`hermes gateway run`).
	optfeature "Hermes Agent gateway backend (recommended)" \
		"app-misc/hermes[web]"
	# In-browser terminal feature uses a pure-stdlib python3 helper.
	optfeature "in-browser terminal feature (pty-helper.py)" \
		"dev-lang/python"
}
