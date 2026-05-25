# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm.eclass
# @MAINTAINER:
# Simon Alman <haven@thehavennet.org.uk>
# @BLURB: Modern Eclass for NodeJS packages following strict source-based patterns.
# @DESCRIPTION:
# This eclass contains functions to package NodeJS modules from the npm registry
# WITHOUT invoking the "npm" binary during build or install phases.

case ${EAPI} in
    8) : ;;
    *) die "npm.eclass: unsupported EAPI=${EAPI:-0} (EAPI 8 required)" ;;
esac

inherit multilib

: "${NPM_MODULE:=${PN}}"
: "${NPM_FILES:=.}"
: "${NPM_DOCS:=README* LICENSE* HISTORY* CHANGELOG*}"

HOMEPAGE="https://www.npmjs.com/package/${PN}"

# NPM versions use - instead of _ and often have dots in pre-release parts
# We implement a robust mapping for common Gentoo -> NPM version patterns
_NPM_PV="${PV//_beta/-beta.}"
_NPM_PV="${_NPM_PV//_alpha/-alpha.}"
_NPM_PV="${_NPM_PV//_rc/-rc.}"
_NPM_PV="${_NPM_PV//_p/-}"

SRC_URI="https://registry.npmjs.org/${NPM_MODULE}/-/${NPM_MODULE##*/}-${_NPM_PV}.tgz -> ${P}.tgz"

npm_src_unpack() {
	unpack "${A}"
	if [[ -d "${WORKDIR}/package" ]]; then
		mv "${WORKDIR}/package" "${S}" || die
	elif [[ -d "${WORKDIR}/${NPM_MODULE##*/}" ]]; then
		mv "${WORKDIR}/${NPM_MODULE##*/}" "${S}" || die
	fi
}

npm_src_compile() {
	:
}

npm_src_install() {
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${NPM_MODULE}"

	insinto "${module_dir}"
	
	local f
	for f in ${NPM_FILES}; do
		if [[ -e "${S}/${f}" ]]; then
			doins -r "${S}/${f}"
		fi
	done

	# Install documentation
	local d
	while IFS= read -r -d "" file; do
		[[ -s "${file}" ]] && dodoc -r "${file}"
	done < <(find "${S}" -maxdepth 1 \( -name "README*" -o -name "LICENSE*" -o -name "HISTORY*" -o -name "CHANGELOG*" \) -print0 2>/dev/null)
}

npm_install_bin() {
	[[ -z $1 ]] && die "Usage: ${FUNCNAME} <script_path> [alias]"
	local script_path="$1"
	local alias="${2:-${PN}}"
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${NPM_MODULE}"
	
	fperms +x "${module_dir}/${script_path}"
	dosym "../../${libdir}/node_modules/${NPM_MODULE}/${script_path}" "/usr/bin/${alias}"
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
