# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="OpenAPI Generator allows generation of API client libraries, server stubs"
HOMEPAGE="https://openapi-generator.tech/ https://github.com/OpenAPITools/openapi-generator"
SRC_URI="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/${PV}/openapi-generator-cli-${PV}.jar -> ${P}.jar"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=virtual/jre-11:*
"

src_unpack() {
	cp "${DISTDIR}/${P}.jar" "${S}/" || die
}

src_compile() {
	:;
}

src_install() {
	java-pkg_newjar "${P}.jar" "openapi-generator.jar"
	java-pkg_dolauncher openapi-generator --jar openapi-generator.jar
}
