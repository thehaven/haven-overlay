EAPI=8

DESCRIPTION="Factory.io Droid CLI Tool"
HOMEPAGE="https://factory.ai/"
SRC_URI="
	amd64? (
		https://downloads.factory.ai/factory-cli/releases/0.22.3/linux/x64/droid -> droid-0.22.3-amd64.bin
		https://downloads.factory.ai/factory-cli/releases/0.22.3/linux/x64/droid.sha256 -> droid-0.22.3-amd64.sha256
	)
	arm64? (
		https://downloads.factory.ai/factory-cli/releases/0.22.3/linux/arm64/droid -> droid-0.22.3-arm64.bin
		https://downloads.factory.ai/factory-cli/releases/0.22.3/linux/arm64/droid.sha256 -> droid-0.22.3-arm64.sha256
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="sys-apps/ripgrep"

S="${WORKDIR}"

src_unpack() {
	if use amd64; then
		cp "${DISTDIR}/droid-0.22.3-amd64.bin" "${WORKDIR}/droid-0.22.3-amd64.bin" || die
		cp "${DISTDIR}/droid-0.22.3-amd64.sha256" "${WORKDIR}/droid-0.22.3-amd64.sha256" || die
	elif use arm64; then
		cp "${DISTDIR}/droid-0.22.3-arm64.bin" "${WORKDIR}/droid-0.22.3-arm64.bin" || die
		cp "${DISTDIR}/droid-0.22.3-arm64.sha256" "${WORKDIR}/droid-0.22.3-arm64.sha256" || die
	fi
}

src_prepare() {
	eapply_user
}

src_install() {
	local binary droid_sha

	if use amd64; then
		binary="${S}/droid-0.22.3-amd64.bin"
		droid_sha=$(<"${S}/droid-0.22.3-amd64.sha256")
	elif use arm64; then
		binary="${S}/droid-0.22.3-arm64.bin"
		droid_sha=$(<"${S}/droid-0.22.3-arm64.sha256")
	fi

	einfo "Verifying binary checksum..."
	[[ $(sha256sum "$binary" | awk '{print $1}') == "$droid_sha" ]] || die "droid checksum mismatch"

	newbin "$binary" "droid"
}

pkg_pretend() {
	local missing_flags=""
	local required_flags="avx2 bmi1 bmi2 fma movbe"

	for flag in ${required_flags}; do
		if ! grep -qw ${flag} /proc/cpuinfo; then
			missing_flags="${missing_flags} ${flag}"
		fi
	done

	if [[ -n "${missing_flags}" ]]; then
		eerror "Factory Droid requires x86-64-v3 CPU support (Intel Haswell 2013+ or AMD Excavator 2015+)"
		eerror "Your CPU is missing required instruction sets:${missing_flags}"
		eerror ""
		eerror "Required flags: ${required_flags}"
		eerror "Your CPU supports: x86-64-v2 (Sandy Bridge/Ivy Bridge era)"
		eerror ""
		eerror "Please contact Factory.ai to request an x86-64-v2 or x86-64-v1 compatible build"
		die "Incompatible CPU: missing x86-64-v3 support"
	fi
}


pkg_postinst() {
	einfo "Factory Droid CLI installed as 'droid'. Run 'droid' to get started."
}
