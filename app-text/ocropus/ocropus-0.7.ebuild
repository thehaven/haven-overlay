# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit mercurial python
DESCRIPTION="OCRopus is a state-of-the-art document analysis and OCR system."
HOMEPAGE="http://code.google.com/p/ocropus/"
#SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
EHG_REPO_URI="https://code.google.com/p/ocropus"
EHG_REVISION=${PN}-${PV}
WORKDIR=${PORTAGE_BUILDDIR}/work/${EHG_REVISION}/ocropy

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=app-text/tesseract-1.04b
	app-text/aspell
	media-libs/tiff
	media-libs/libpng
	virtual/jpeg"
DEPEND="${RDEPEND}
	dev-util/ftjam"


src_compile() {
	python setup.py download_models
	python setup.py install
}

src_test() {
	cd "${S}/testing"
	./test-compile || die "Tests failed to compile"
	./test-run || die "At least one test failed"
}

src_install() {
	dobin ocropus-cmd/ocropus
	dodoc README DIRS
}
