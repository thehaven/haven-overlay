# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Command line utility foroperations on container images and image repositories"
HOMEPAGE="https://github.com/jfrog/jfrog-cli"

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/VividCortex/ewma v1.1.1"
	"github.com/VividCortex/ewma v1.1.1/go.mod"
	"github.com/alcortesm/tgz v0.0.0-20161220082320-9c5fe88206d7"
	"github.com/alcortesm/tgz v0.0.0-20161220082320-9c5fe88206d7/go.mod"
	"github.com/anmitsu/go-shlex v0.0.0-20161002113705-648efa622239"
	"github.com/anmitsu/go-shlex v0.0.0-20161002113705-648efa622239/go.mod"
	"github.com/buger/jsonparser v0.0.0-20180910192245-6acdf747ae99"
	"github.com/buger/jsonparser v0.0.0-20180910192245-6acdf747ae99/go.mod"
	"github.com/c-bata/go-prompt v0.2.3"
	"github.com/c-bata/go-prompt v0.2.3/go.mod"
	"github.com/chzyer/logex v1.1.10"
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
	"github.com/codegangsta/cli v1.20.0"
	"github.com/codegangsta/cli v1.20.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dsnet/compress v0.0.1"
	"github.com/dsnet/compress v0.0.1/go.mod"
	"github.com/dsnet/golib v0.0.0-20171103203638-1ea166775780/go.mod"
	"github.com/emirpasic/gods v1.12.0"
	"github.com/emirpasic/gods v1.12.0/go.mod"
	"github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568"
	"github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568/go.mod"
	"github.com/frankban/quicktest v1.7.2"
	"github.com/frankban/quicktest v1.7.2/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/gliderlabs/ssh v0.1.1"
	"github.com/gliderlabs/ssh v0.1.1/go.mod"
	"github.com/golang/snappy v0.0.1"
	"github.com/golang/snappy v0.0.1/go.mod"
	"github.com/google/go-cmp v0.3.1"
	"github.com/google/go-cmp v0.3.1/go.mod"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/hashicorp/hcl v1.0.0/go.mod"
	"github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99"
	"github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99/go.mod"
	"github.com/jfrog/gocmd v0.1.15"
	"github.com/jfrog/gocmd v0.1.15/go.mod"
	"github.com/jfrog/gofrog v1.0.6"
	"github.com/jfrog/gofrog v1.0.6/go.mod"
	"github.com/jfrog/jfrog-client-go v0.10.0/go.mod"
	"github.com/jfrog/jfrog-client-go v0.12.0"
	"github.com/jfrog/jfrog-client-go v0.12.0/go.mod"
	"github.com/kevinburke/ssh_config v0.0.0-20180830205328-81db2a75821e"
	"github.com/kevinburke/ssh_config v0.0.0-20180830205328-81db2a75821e/go.mod"
	"github.com/klauspost/compress v1.4.1/go.mod"
	"github.com/klauspost/cpuid v1.2.0/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/magiconair/properties v1.8.0"
	"github.com/magiconair/properties v1.8.0/go.mod"
	"github.com/mattn/go-colorable v0.1.4/go.mod"
	"github.com/mattn/go-colorable v0.1.6"
	"github.com/mattn/go-colorable v0.1.6/go.mod"
	"github.com/mattn/go-isatty v0.0.8/go.mod"
	"github.com/mattn/go-isatty v0.0.10/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-runewidth v0.0.6/go.mod"
	"github.com/mattn/go-runewidth v0.0.9"
	"github.com/mattn/go-runewidth v0.0.9/go.mod"
	"github.com/mattn/go-shellwords v1.0.3"
	"github.com/mattn/go-shellwords v1.0.3/go.mod"
	"github.com/mattn/go-tty v0.0.3"
	"github.com/mattn/go-tty v0.0.3/go.mod"
	"github.com/mholt/archiver v2.1.0+incompatible"
	"github.com/mholt/archiver v2.1.0+incompatible/go.mod"
	"github.com/mitchellh/go-homedir v1.0.0"
	"github.com/mitchellh/go-homedir v1.0.0/go.mod"
	"github.com/mitchellh/mapstructure v1.0.0"
	"github.com/mitchellh/mapstructure v1.0.0/go.mod"
	"github.com/nwaples/rardecode v1.0.0"
	"github.com/nwaples/rardecode v1.0.0/go.mod"
	"github.com/pelletier/go-buffruneio v0.2.0"
	"github.com/pelletier/go-buffruneio v0.2.0/go.mod"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/pelletier/go-toml v1.2.0/go.mod"
	"github.com/pierrec/lz4 v2.3.0+incompatible"
	"github.com/pierrec/lz4 v2.3.0+incompatible/go.mod"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/pkg/errors v0.8.1"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/term v0.0.0-20190109203006-aa71e9d9e942"
	"github.com/pkg/term v0.0.0-20190109203006-aa71e9d9e942/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/sergi/go-diff v1.0.0"
	"github.com/sergi/go-diff v1.0.0/go.mod"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/afero v1.1.2/go.mod"
	"github.com/spf13/cast v1.2.0"
	"github.com/spf13/cast v1.2.0/go.mod"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/jwalterweatherman v1.0.0/go.mod"
	"github.com/spf13/pflag v1.0.2"
	"github.com/spf13/pflag v1.0.2/go.mod"
	"github.com/spf13/viper v1.2.1"
	"github.com/spf13/viper v1.2.1/go.mod"
	"github.com/src-d/gcfg v1.3.0"
	"github.com/src-d/gcfg v1.3.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/ulikunitz/xz v0.5.6"
	"github.com/ulikunitz/xz v0.5.6/go.mod"
	"github.com/vbauerster/mpb/v4 v4.7.0"
	"github.com/vbauerster/mpb/v4 v4.7.0/go.mod"
	"github.com/xanzy/ssh-agent v0.2.0"
	"github.com/xanzy/ssh-agent v0.2.0/go.mod"
	"golang.org/x/crypto v0.0.0-20181001203147-e3636079e1a4/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190426145343-a29dc8fdc734"
	"golang.org/x/crypto v0.0.0-20190426145343-a29dc8fdc734/go.mod"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
	"golang.org/x/mod v0.1.0"
	"golang.org/x/mod v0.1.0/go.mod"
	"golang.org/x/net v0.0.0-20180926154720-4dfa2610cdf3"
	"golang.org/x/net v0.0.0-20180926154720-4dfa2610cdf3/go.mod"
	"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a"
	"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sys v0.0.0-20180903190138-2b024373dcd9/go.mod"
	"golang.org/x/sys v0.0.0-20180906133057-8cf3aee42992"
	"golang.org/x/sys v0.0.0-20180906133057-8cf3aee42992/go.mod"
	"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5"
	"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190429190828-d89cdac9e872"
	"golang.org/x/sys v0.0.0-20190429190828-d89cdac9e872/go.mod"
	"golang.org/x/sys v0.0.0-20191008105621-543471e840be/go.mod"
	"golang.org/x/sys v0.0.0-20191120155948-bd437916bb0e/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae"
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/src-d/go-billy.v4 v4.3.0"
	"gopkg.in/src-d/go-billy.v4 v4.3.0/go.mod"
	"gopkg.in/src-d/go-git-fixtures.v3 v3.1.1"
	"gopkg.in/src-d/go-git-fixtures.v3 v3.1.1/go.mod"
	"gopkg.in/src-d/go-git.v4 v4.7.0"
	"gopkg.in/src-d/go-git.v4 v4.7.0/go.mod"
	"gopkg.in/warnings.v0 v0.1.2"
	"gopkg.in/warnings.v0 v0.1.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/jfrog/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	./build/build.sh || die
}

src_install() {
	dobin jfrog
	einstalldocs
}
