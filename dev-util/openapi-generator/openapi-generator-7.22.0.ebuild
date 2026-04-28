# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="OpenAPI Generator allows generation of API client libraries, server stubs"
HOMEPAGE="https://openapi-generator.tech/ https://github.com/OpenAPITools/openapi-generator"
SRC_URI="https://github.com/OpenAPITools/openapi-generator/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

RDEPEND="
	>=virtual/jre-11:*
"
DEPEND="
	>=virtual/jdk-11:*
"

src_compile() {
	# We use the included Maven wrapper to build the project from source.
	# We restrict the build to the cli module and its dependencies to significantly speed up compilation.
	./mvnw clean package -pl modules/openapi-generator-cli -am -DskipTests || die "Maven build failed"
}

src_install() {
	# Find the built executable jar in the target directory of the cli module
	local jar_file="modules/openapi-generator-cli/target/openapi-generator-cli.jar"
	
	java-pkg_newjar "${jar_file}" "openapi-generator.jar"
	java-pkg_dolauncher openapi-generator --jar openapi-generator.jar
}
