# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of shell scripts for local utilities"
HOMEPAGE="https://github.com/haven/codex"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="/storage/home/haven/projects/personal/codex"

src_install() {
	# Install scripts from codex-raw
	exeinto /usr/bin
	doexe codex-raw/*.sh
	
	# Install scripts from codex-windprompt with prefix if needed or just as is
	# For now, following current structure
	newbin codex-windprompt/worldtime.sh codex-worldtime
}
