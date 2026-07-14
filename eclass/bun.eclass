# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

#@ECLASS: bun.eclass
#@MAINTAINER:
#   Simon Alman <base-system@gentoo.org>
#@BLURB: Common functions for Node.js packages built with Bun
#@DESCRIPTION:
#   Provides default src_compile and src_install phases for packages
#   that use Bun as their build tool. Supports two dependency strategies:
#   vendor tarballs (preferred) and bun install --ignore-scripts.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI 8 only" ;;
esac

# @ECLASS-VARIABLE: BUN_MODULE_DIR
#: Installation target directory for the Node.js module.
#: Default: /usr/$(get_libdir)/node_modules/${PN}
#: Resolved lazily to avoid get_libdir() in global scope.

# @ECLASS-VARIABLE: BUN_DOCS
#: Array of documentation files to install via einstalldocs.
#: Set to "skip" to disable automatic documentation installation.
: "${BUN_DOCS:=()}"

# @ECLASS-VARIABLE: BUN_INSTALL_BINS
#: Associative array of bin_name -> source_path for executable symlinks.
#: Example: BUN_INSTALL_BINS=( ["mytool"]="dist/bin/mytool.js" )
: "${BUN_INSTALL_BINS:=()}"

# @ECLASS-VARIABLE: BUN_INSTALL_WRAPPER
#: If set, install a node wrapper script to /usr/bin/${BUN_INSTALL_WRAPPER}
#: that execs the main entry point. Use when upstream has no bin field
#: and you need a direct CLI entry point.
: "${BUN_INSTALL_WRAPPER:=}"

# @ECLASS-VARIABLE: BUN_SKIP_COMPILE
#: If non-empty, skip the default src_compile (bun install + bun run build).
#: Useful for pre-built vendor tarballs that only need installation.
: "${BUN_SKIP_COMPILE:=}"

BDEPEND+=" || ( dev-lang/bun-bin dev-lang/bun )"

# @FUNCTION: bun_src_compile
# @DESCRIPTION:
#   Default src_compile: runs bun install --frozen-lockfile --ignore-scripts
#   then bun run build. Override in ebuild if using vendor tarballs.
bun_src_compile() {
	if [[ -n ${BUN_SKIP_COMPILE} ]]; then
		return 0
	fi

	if [[ ! -d node_modules ]]; then
		bun install --frozen-lockfile --ignore-scripts || die "bun install failed"
	fi

	bun run build || die "bun run build failed"
}

# @FUNCTION: _bun_get_module_dir
# @INTERNAL
# @DESCRIPTION:
#   Resolve BUN_MODULE_DIR lazily to avoid get_libdir() in global scope.
_bun_get_module_dir() {
	: "${BUN_MODULE_DIR:=/usr/$(get_libdir)/node_modules/${PN}}"
	echo "${BUN_MODULE_DIR}"
}

# @FUNCTION: bun_src_install
# @DESCRIPTION:
#   Default src_install: copies all files to BUN_MODULE_DIR, sets up
#   binary symlinks via BUN_INSTALL_BINS and BUN_INSTALL_WRAPPER.
bun_src_install() {
	local module_dir
	module_dir=$(_bun_get_module_dir)

	insinto "${module_dir}"
	doins -r .

	local bin_name bin_path
	if [[ ${#BUN_INSTALL_BINS[@]} -gt 0 ]]; then
		for bin_name in "${!BUN_INSTALL_BINS[@]}"; do
			bin_path="${BUN_INSTALL_BINS[${bin_name}]}"
			bun_install_bin "${bin_name}" "${bin_path}"
		done
	fi

	if [[ -n ${BUN_INSTALL_WRAPPER} ]]; then
		dosym "${module_dir}/node_modules/${PN}/dist/index.js" \
			"/usr/bin/${BUN_INSTALL_WRAPPER}" \
			|| die "dosym wrapper failed"
	fi

	bun_einstalldocs
}

# @FUNCTION: bun_install_bin
# @USAGE: <bin_name> <source_path>
# @DESCRIPTION:
#   Create a /usr/bin/<bin_name> symlink pointing to
#   BUN_MODULE_DIR/<source_path>.
bun_install_bin() {
	local bin_name=$1
	local src_path=$2
	local module_dir
	module_dir=$(_bun_get_module_dir)

	[[ -z ${bin_name} ]] && die "bun_install_bin: bin_name required"
	[[ -z ${src_path} ]] && die "bun_install_bin: source_path required"

	dosym "${module_dir}/${src_path}" "/usr/bin/${bin_name}" \
		|| die "dosym ${bin_name} failed"
}

# @FUNCTION: bun_einstalldocs
# @DESCRIPTION:
#   Install documentation files listed in BUN_DOCS array.
#   Falls back to einstalldocs for standard DOCS/HTML_DOCS.
bun_einstalldocs() {
	if [[ ${BUN_DOCS[*]} == "skip" ]]; then
		return 0
	fi

	if [[ ${#BUN_DOCS[@]} -gt 0 ]]; then
		local doc
		for doc in "${BUN_DOCS[@]}"; do
			[[ -f ${doc} ]] && dodoc "${doc}"
		done
	else
		einstalldocs
	fi
}

EXPORT_FUNCTIONS src_compile src_install
