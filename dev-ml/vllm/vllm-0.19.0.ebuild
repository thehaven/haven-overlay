# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

DESCRIPTION="High-throughput LLM serving engine with PagedAttention"
HOMEPAGE="https://vllm.ai https://github.com/vllm-project/vllm"

VLLM_BASE="https://github.com/vllm-project/vllm/releases/download/v${PV}"
SRC_URI="
	!cuda? (
		amd64? ( ${VLLM_BASE}/${PN}-${PV}+cpu-cp38-abi3-manylinux_2_35_x86_64.whl -> ${P}-cpu-amd64.whl )
		arm64? ( ${VLLM_BASE}/${PN}-${PV}+cpu-cp38-abi3-manylinux_2_35_aarch64.whl -> ${P}-cpu-arm64.whl )
	)
	cuda? (
		amd64? ( ${VLLM_BASE}/${PN}-${PV}+cu130-cp38-abi3-manylinux_2_35_x86_64.whl -> ${P}-cuda-amd64.whl )
		arm64? ( ${VLLM_BASE}/${PN}-${PV}+cu130-cp38-abi3-manylinux_2_35_aarch64.whl -> ${P}-cuda-arm64.whl )
	)
"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="cuda"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# pip needs network for transitive deps
RESTRICT="network-sandbox test strip"

RDEPEND="
	${PYTHON_DEPS}
	cuda? ( dev-util/nvidia-cuda-toolkit )
"
BDEPEND="
	${PYTHON_DEPS}
"

QA_PREBUILT="opt/vllm/*"

src_compile() {
	:
}

src_install() {
	local instdir="/opt/${PN}"
	local wheel_suffix

	if use cuda; then
		use amd64 && wheel_suffix="cuda-amd64"
		use arm64 && wheel_suffix="cuda-arm64"
	else
		use amd64 && wheel_suffix="cpu-amd64"
		use arm64 && wheel_suffix="cpu-arm64"
	fi

	# Create virtualenv
	"${PYTHON}" -m venv --system-site-packages "${ED}${instdir}" || die "venv creation failed"

	# Install from pre-built wheel
	"${ED}${instdir}/bin/pip" install \
		--no-cache-dir \
		--disable-pip-version-check \
		"${DISTDIR}/${P}-${wheel_suffix}.whl" || die "pip install failed"

	# Fix paths baked during install
	find "${ED}${instdir}" -type f \( -name '*.py' -o -name '*.cfg' \) -exec \
		sed -i "s|${ED}||g" {} + 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/bin/"* 2>/dev/null || true
	sed -i "s|${ED}||g" "${ED}${instdir}/pyvenv.cfg" || true

	# Wrapper scripts
	dodir /opt/bin
	for cmd in vllm; do
		if [[ -f "${ED}${instdir}/bin/${cmd}" ]]; then
			cat <<-EOF > "${ED}/opt/bin/${cmd}" || die
				#!/bin/sh
				exec "${instdir}/bin/${cmd}" "\$@"
			EOF
			fperms a+x "/opt/bin/${cmd}"
		fi
	done

	# Service files
	newinitd "${FILESDIR}"/vllm.initd vllm
	newconfd "${FILESDIR}"/vllm.confd vllm

	insinto /usr/lib/systemd/system
	doins "${FILESDIR}"/vllm.service

	keepdir /var/lib/vllm
}

pkg_postinst() {
	einfo "vLLM inference engine installed."
	einfo ""
	einfo "Quick start:"
	einfo "  vllm serve <model-name>"
	einfo ""
	einfo "Example:"
	einfo "  vllm serve meta-llama/Llama-3-8B-Instruct"
	einfo ""
	einfo "OpenAI-compatible API: http://localhost:8000"
	einfo "Model cache: ~/.cache/huggingface/"
}
