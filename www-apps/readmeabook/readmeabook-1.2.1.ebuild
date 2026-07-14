# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Self-hosted audiobook library management system with Plex integration"
HOMEPAGE="https://github.com/readmeabook/readmeabook"
SRC_URI="
	https://github.com/readmeabook/readmeabook/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.delivery.haven.pw/gentoo-distfiles/${PN}-node_modules-${PV}.tar.xz
	https://artifactory.delivery.haven.pw/gentoo-distfiles/${PN}-fonts-${PV}.tar.xz
"
S="${WORKDIR}/ReadMeABook-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-db/postgresql-15
	>=dev-libs/redis-7.0
"

BDEPEND=">=dev-util/bun-1.0"

src_prepare() {
	python3 "${FILESDIR}/patch-layout.py" \
		"${S}/src/app/layout.tsx" \
		"${WORKDIR}/fonts" \
		|| die "Failed to patch layout.tsx"

	mkdir -p "${S}/public/fonts" || die
	cp "${WORKDIR}"/fonts/*.woff2 "${S}/public/fonts/" 2>/dev/null || die "Failed to copy font files"

	default
}

src_compile() {
	export DATABASE_URL="postgresql://placeholder:placeholder@localhost:5432/placeholder"

	bun install --frozen-lockfile --production=false || die "bun install failed"

	npx prisma generate || die "prisma generate failed"

	bun run build || die "next build failed"
}

src_install() {
	local standalone_dir="${S}/.next/standalone"
	if [[ -d "${standalone_dir}" ]]; then
		insinto "/usr/lib/${PN}"
		doins -r "${standalone_dir}/"*

		if [[ -d "${S}/.next/static" ]]; then
			insinto "/usr/lib/${PN}/.next"
			doins -r "${S}/.next/static"
		fi

		if [[ -d "${S}/public" ]]; then
			insinto "/usr/lib/${PN}"
			doins -r "${S}/public"
		fi

		if [[ -d "${S}/prisma" ]]; then
			insinto "/usr/lib/${PN}/prisma"
			doins -r "${S}/prisma"/*
		fi
	fi

	newinitd "${FILESDIR}/${PN}.initd" "${PN}" || die

	dodir "/etc/${PN}"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"
}
