# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm.eclass
# @MAINTAINER:
# Simon Alman <haven@thehavennet.org.uk>
# @BLURB: Modern Eclass for NodeJS packages following strict source-based patterns.
# @DESCRIPTION:
# This eclass contains functions to package NodeJS modules from the npm registry
# WITHOUT invoking the "npm" binary during build or install phases.
# It implements a strict "Extract-Only" pattern suitable for system-wide auditing
# and Portage-managed dependency trees.
# Requires EAPI=8.

case ${EAPI} in
    8) : ;;
    *) die "npm.eclass: unsupported EAPI=${EAPI:-0} (EAPI 8 required)" ;;
esac

inherit multilib

# @ECLASS-VARIABLE: NPM_MODULE
# @DESCRIPTION:
# Name of the NodeJS/npm module (e.g. "@renovatebot/pep440").
# Defaults to ${PN}.
: "${NPM_MODULE:=${PN}}"

# @ECLASS-VARIABLE: NPM_FILES
# @DESCRIPTION:
# Files and directories to install to the module directory.
# Defaults to common source files.
: "${NPM_FILES:=index.js lib dist package.json ${NPM_MODULE}.js}"

# @ECLASS-VARIABLE: NPM_DOCS
# @DESCRIPTION:
# Document files to be installed with dodoc.
# Defaults to standard README and license files.
: "${NPM_DOCS:=README* LICENSE* HISTORY* CHANGELOG*}"

HOMEPAGE="https://www.npmjs.com/package/${PN}"

# Use bash variable expansion to remove scope prefix for the tarball filename part
SRC_URI="https://registry.npmjs.org/${NPM_MODULE}/-/${NPM_MODULE##*/}-${PV}.tgz -> ${P}.tgz"

# @FUNCTION: npm_src_unpack
# @DESCRIPTION:
# Unpacks the npm tarball and renames the resulting "package" directory to ${S}.
npm_src_unpack() {
	unpack "${A}"
	if [[ -d "${WORKDIR}/package" ]]; then
		mv "${WORKDIR}/package" "${S}" || die
	fi
}

# @FUNCTION: npm_src_compile
# @DESCRIPTION:
# No-op for JavaScript source packages.
npm_src_compile() {
	:
}

# @FUNCTION: npm_src_install
# @DESCRIPTION:
# Installs the module files to /usr/lib/node_modules/${NPM_MODULE}.
# Also handles symlinking executables defined in package.json if requested.
npm_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${NPM_MODULE}"

	insinto "${module_dir}"
	
	# Install source files
	local f
	for f in ${NPM_FILES}; do
		if [[ -e "${S}/${f}" ]]; then
			doins -r "${S}/${f}"
		fi
	done

	# Install documentation
	local d
	for d in ${NPM_DOCS}; do
		# find files matching the pattern and dodoc them
		# we use a loop to avoid shell expansion issues
		while IFS= read -r -d "" file; do
			[[ -s "${file}" ]] && dodoc -r "${file}"
		done < <(find "${S}" -maxdepth 1 -name "${d}" -print0 2>/dev/null)
	done
}

# @FUNCTION: npm_install_bin
# @USAGE: <script_path> [alias]
# @DESCRIPTION:
# Helper to install a script as a system binary and symlink it correctly
# to the node_modules location.
npm_install_bin() {
	[[ -z $1 ]] && die "Usage: ${FUNCNAME} <script_path> [alias]"
	local script_path="$1"
	local alias="${2:-${PN}}"
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${NPM_MODULE}"
	
	# Ensure the script is executable in the image
	fperms +x "${module_dir}/${script_path}"
	
	# Create a symlink in /usr/bin
	dosym "${module_dir}/${script_path}" "/usr/bin/${alias}"
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
