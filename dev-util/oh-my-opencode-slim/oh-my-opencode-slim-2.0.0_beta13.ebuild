# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="Slim agent harness for OpenCode with TUI and CLI"
HOMEPAGE="https://github.com/alvinunreal/oh-my-opencode-slim"
SRC_URI="https://github.com/alvinunreal/${PN}/archive/refs/tags/v${PV/_beta/-beta.}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies from package.json
RDEPEND="
	dev-nodejs/ast-grep-cli
	dev-nodejs/modelcontextprotocol-sdk
	dev-nodejs/mozilla-readability
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/opencode-ai-sdk
	dev-nodejs/jsdom
	dev-nodejs/lru-cache
	dev-nodejs/turndown
	dev-nodejs/zod
"
BDEPEND="
	${RDEPEND}
	dev-nodejs/typescript
	dev-nodejs/bun-types
	|| ( dev-lang/bun-bin dev-lang/bun )
"

S="${WORKDIR}/${PN}-${PV/_beta/-beta.}"

src_compile() {
	local libdir=$(get_libdir)
	local node_modules_dir="/usr/${libdir}/node_modules"

	# Strictly source-based: link dependencies from /usr/lib/node_modules
	# instead of running 'bun install'
	mkdir -p node_modules || die
	
	# Symlink all installed node modules into local node_modules
	# This ensures all dependencies (including scoped ones) are available
	# and correctly resolved by tsc/bun.
	local mod pkg
	while IFS= read -r -d "" mod; do
		local name="${mod##*/}"
		if [[ "${name}" == @* ]]; then
			# Scope directory: link packages within it
			while IFS= read -r -d "" pkg; do
				local pkg_name="${pkg##*/}"
				mkdir -p "node_modules/${name}" || die
				ln -s "${pkg}" "node_modules/${name}/${pkg_name}" || die
			done < <(find "${mod}" -mindepth 1 -maxdepth 1 -type d -not -path '*/.*' -print0)
		else
			# Regular package
			ln -s "${mod}" "node_modules/${name}" || die
		fi
	done < <(find "${node_modules_dir}" -mindepth 1 -maxdepth 1 -type d -not -path '*/.*' -print0 2>/dev/null)
	
	# Run the build using local dependencies
	bun run build || die
}

src_install() {
	npm_src_install
	npm_install_bin dist/cli/index.js oh-my-opencode-slim
}

pkg_postinst() {
	einfo "oh-my-opencode-slim installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/dist/index.js\" }"
}
