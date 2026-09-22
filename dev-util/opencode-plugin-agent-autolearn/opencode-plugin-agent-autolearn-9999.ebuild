# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Self-improvement engine for OpenCode: captures corrections, escalates rules"
HOMEPAGE="https://github.com/ericmjl/agent-autolearn"

# Upstream has not yet cut a tag. Tracking main matches the one-liner
# install the README recommends (curl .../main/install.sh | bash), so a
# live ebuild is the correct model until the first release tag appears.
EGIT_REPO_URI="https://github.com/ericmjl/agent-autolearn.git"

inherit git-r3

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

# Plugin core imports only Node/Bun builtins (no package.json deps, no
# external packages), so no build step. Skill-bundle Python helpers use
# PEP 723 inline-script-metadata and rely on `uv run` for runtime dep
# resolution; uv is operator-supplied and not an ebuild dep.
RESTRICT="test"

# git-r3_src_unpack needs network to clone; omitting "network-sandbox"
# allows the clone (network is allowed for the package, global sandbox
# stays on; verify with `man 5 ebuild`).

RDEPEND="dev-util/opencode"

# Upstream ships four installer pieces plus a skill bundle; sync-server
# and sync-convex are separate sub-projects and intentionally omitted.
#   plugin/autolearn.js         - OpenCode v1 shell entry
#   plugin/autolearn-v2.js      - OpenCode v2 shell entry
#   plugin/autolearn-core.mjs   - shared logic for both shells (+ pi)
#   plugin/autolearn-pi.ts      - pi extension
#   skills/autolearn/SKILL.md + references/ + scripts/

src_compile() {
	# Plugin is plain JS/TS/MJS using only Node builtins. Skill scripts
	# are PEP 723 inline-metadata CLI tools run via `uv` at user time.
	:;
}

src_install() {
	# Install plugin entry files + skill bundle under the shared OpenCode
	# module dir, mirroring the npm-registry plugin layout used by
	# dev-util/opencode-plugin-pty and dev-util/opencode-plugin-notify.
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r plugin skills

	# Self-documenting install layout for operators debugging `ls`.
	local rd="${ED}/usr/$(get_libdir)/node_modules/${PN}"
	cat > "${rd}/INSTALL_LAYOUT.txt" <<-DOC
		${PN} ships two sub-trees:

		  plugin/ - OpenCode v1 + v2 + pi adapters + shared core
		            Reference absolute paths from opencode.json:
		              /usr/$(get_libdir)/node_modules/${PN}/plugin/autolearn.js
		              /usr/$(get_libdir)/node_modules/${PN}/plugin/autolearn-v2.js
		            The shared core is imported by both and never referenced
		            from opencode.json directly.

		  skills/ - Reusable skill bundle (SKILL.md + references/ + scripts/).
		            Copy or symlink skills/autolearn/ into ~/.agents/skills/
		            (or any path your harness auto-discovers).

		Skill scripts are PEP 723 inline-metadata Python CLIs; resolve their
		deps at runtime with uv, e.g.:

		  uv run /usr/$(get_libdir)/node_modules/${PN}/skills/autolearn/scripts/autolearn.py init

		See ${HOMEPAGE} for the canonical install procedure.
	DOC
}

pkg_postinst() {
	einfo "${PN} installed at /usr/$(get_libdir)/node_modules/${PN}/"
	einfo ""
	einfo "Plugin files (reference absolute paths in opencode.json):"
	einfo "  /usr/$(get_libdir)/node_modules/${PN}/plugin/autolearn.js      (OpenCode v1)"
	einfo "  /usr/$(get_libdir)/node_modules/${PN}/plugin/autolearn-v2.js   (OpenCode v2)"
	einfo ""
	einfo "Extension for pi:"
	einfo "  /usr/$(get_libdir)/node_modules/${PN}/plugin/autolearn-pi.ts   (copy to ~/.pi/agent/extensions/)"
	einfo ""
	einfo "Skill bundle:"
	einfo "  /usr/$(get_libdir)/node_modules/${PN}/skills/autolearn/        (copy or symlink into ~/.agents/skills/)"
	einfo ""
	einfo "CLI scripts are PEP 723 inline-metadata tools; resolve deps at runtime via uv:"
	einfo "  uv run /usr/$(get_libdir)/node_modules/${PN}/skills/autolearn/scripts/autolearn.py init"
	einfo ""
	einfo "The upstream one-liner automates the above end-to-end:"
	einfo "  curl -fsSL ${HOMEPAGE}/raw/main/install.sh | bash"
}
