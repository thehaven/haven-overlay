# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following 3 requirements in mind before adding external modules:
#   * alive upstream
#   * sane packaging
#   * builds cleanly
# - TODO: test the google-perftools module (included in vanilla tarball)

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

# http_passenger (http://www.modrails.com/, MIT license)
# TODO: currently builds some stuff in src_configure
PASSENGER_PV="4.0.48"
USE_RUBY="ruby19"
RUBY_OPTIONAL="yes"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.0"
HTTP_UPLOAD_PROGRESS_MODULE_P="ngx_upload_progress-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"
HTTP_UPLOAD_PROGRESS_MODULE_SHA1="a788dea"

# http_headers_more (http://github.com/openresty/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.25"
HTTP_HEADERS_MORE_MODULE_P="ngx-http-headers-more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_SHA1="0c6e05d"

# http_redis (http://wiki.nginx.org/HttpRedis)
#HTTP_REDIS_MODULE_P="ngx_http_redis-0.3.5"

# http_redis (https://github.com/openresty/redis2-nginx-module, BSD license)
HTTP_REDIS_MODULE_PV="0.11"
HTTP_REDIS_MODULE_P="ngx_redis-${HTTP_REDIS_MODULE_PV}"
HTTP_REDIS_MODULE_SHA1="828803d"
HTTP_REDIS_MODULE_URI="http://github.com/openresty/redis2-nginx-module/tarball/v${HTTP_REDIS_MODULE_PV}"

# http_push (http://pushmodule.slact.net/, MIT license)
HTTP_PUSH_MODULE_PV="0.692"
HTTP_PUSH_MODULE_P="nginx_http_push_module-${HTTP_PUSH_MODULE_PV}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="2.1"
HTTP_CACHE_PURGE_MODULE_P="ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"

# HTTP Upload module from Valery Kholodkov
# (http://www.grid.net.ru/nginx/upload.en.html, BSD license)
HTTP_UPLOAD_MODULE_PV="2.2.0"
HTTP_UPLOAD_MODULE_P="nginx_upload_module-${HTTP_UPLOAD_MODULE_PV}"

# ey-balancer/maxconn module (https://github.com/msva/nginx-ey-balancer, as-is)
HTTP_EY_BALANCER_MODULE_PV="0.0.8"
HTTP_EY_BALANCER_MODULE_P="nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_PV}"
#HTTP_EY_BALANCER_MODULE_SHA1="859b2ef"

# NginX DevKit module (https://github.com/simpl/ngx_devel_kit, BSD)
HTTP_NDK_MODULE_PV="0.2.19"
HTTP_NDK_MODULE_P="ngx_devel_kit-${HTTP_NDK_MODULE_PV}"
HTTP_NDK_MODULE_SHA1="8dd0df5"

# NginX Lua module (https://github.com/chaoslawful/lua-nginx-module, BSD)
#HTTP_LUA_MODULE_PV="0.3.1rc19"
#HTTP_LUA_MODULE_P="lua-nginx-module-${HTTP_LUA_MODULE_PV}"
#HTTP_LUA_MODULE_SHA1="b25d06b"

# http_lua (https://github.com/openresty/lua-nginx-module, BSD license)
HTTP_LUA_MODULE_PV="0.9.8"
HTTP_LUA_MODULE_P="ngx_lua-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_SHA1="73e831f"
HTTP_LUA_MODULE_URI="http://github.com/openresty/lua-nginx-module/tarball/v${HTTP_LUA_MODULE_PV}"

HTTP_DRIZZLE_MODULE_PV="0.1.2rc2"
HTTP_DRIZZLE_MODULE_P="drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_PV}"
HTTP_DRIZZLE_MODULE_SHA1="44f8593"

# NginX for-input module (https://github.com/calio/form-input-nginx-module, BSD)
HTTP_FORM_INPUT_MODULE_PV="0.07"
HTTP_FORM_INPUT_MODULE_P="form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_PV}"

# http_auth_pam (http://web.iti.upv.es/~sto/nginx/, BSD-2 license)
HTTP_AUTH_PAM_MODULE_PV="1.3"
HTTP_AUTH_PAM_MODULE_P="ngx_http_auth_pam-${HTTP_AUTH_PAM_MODULE_PV}"
HTTP_AUTH_PAM_MODULE_URI="http://web.iti.upv.es/~sto/nginx/ngx_http_auth_pam_module-${HTTP_AUTH_PAM_MODULE_PV}.tgz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/ngx_http_auth_pam_module-${HTTP_AUTH_PAM_MODULE_PV}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module, BSD license)
HTTP_UPSTREAM_CHECK_MODULE_PV="0.1.9"
HTTP_UPSTREAM_CHECK_MODULE_P="ngx_http_upstream_check-${HTTP_UPSTREAM_CHECK_MODULE_PV}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/yaoweibin/nginx_upstream_check_module/archive/v${HTTP_UPSTREAM_CHECK_MODULE_PV}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/nginx_upstream_check_module-${HTTP_UPSTREAM_CHECK_MODULE_PV}"

# http_metrics (https://github.com/zenops/ngx_metrics, BSD license)
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="ngx_metrics-${HTTP_METRICS_MODULE_PV}"
HTTP_METRICS_MODULE_URI="https://github.com/madvertise/ngx_metrics/archive/v${HTTP_METRICS_MODULE_PV}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/ngx_metrics-${HTTP_METRICS_MODULE_PV}"

# naxsi-core (https://github.com/nbs-system/naxsi, GPLv2+)
HTTP_NAXSI_MODULE_PV="0.53-2"
HTTP_NAXSI_MODULE_P="ngx_http_naxsi-${HTTP_NAXSI_MODULE_PV}"
HTTP_NAXSI_MODULE_URI="https://github.com/nbs-system/naxsi/archive/${HTTP_NAXSI_MODULE_PV}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/naxsi-${HTTP_NAXSI_MODULE_PV}/naxsi_src"

# nginx-rtmp-module (http://github.com/arut/nginx-rtmp-module, BSD license)
RTMP_MODULE_PV="1.1.4"
RTMP_MODULE_P="ngx_rtmp-${RTMP_MODULE_PV}"
RTMP_MODULE_URI="http://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_PV}.tar.gz"
RTMP_MODULE_WD="${WORKDIR}/nginx-rtmp-module-${RTMP_MODULE_PV}"

# nginx-dav-ext-module (http://github.com/arut/nginx-dav-ext-module, BSD license)
HTTP_DAV_EXT_MODULE_PV="0.0.3"
HTTP_DAV_EXT_MODULE_P="ngx_http_dav_ext-${HTTP_DAV_EXT_MODULE_PV}"
HTTP_DAV_EXT_MODULE_URI="http://github.com/arut/nginx-dav-ext-module/archive/v${HTTP_DAV_EXT_MODULE_PV}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/nginx-dav-ext-module-${HTTP_DAV_EXT_MODULE_PV}"

# NginX echo module (https://github.com/openresty/echo-nginx-module, BSD)
HTTP_ECHO_MODULE_PV="0.37rc7"
HTTP_ECHO_MODULE_P="echo-nginx-module-${HTTP_ECHO_MODULE_PV}"

# NginX Featured mecached module (https://github.com/openresty/memc-nginx-module, BSD)
HTTP_MEMC_MODULE_PV="0.15"
HTTP_MEMC_MODULE_P="memc-nginx-module-${HTTP_MEMC_MODULE_PV}"
HTTP_MEMC_MODULE_SHA1="1518da4"

# NginX RDS-JSON module (https://github.com/openresty/rds-json-nginx-module, BSD)
HTTP_RDS_JSON_MODULE_PV="0.13"
HTTP_RDS_JSON_MODULE_P="rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_PV}"

# NginX SRCache module (https://github.com/openresty/srcache-nginx-module, BSD)
HTTP_SRCACHE_MODULE_PV="0.28"
HTTP_SRCACHE_MODULE_P="srcache-nginx-module-${HTTP_SRCACHE_MODULE_PV}"
HTTP_SRCACHE_MODULE_SHA1="ffa9ab7"

# NginX Set-Misc module (https://github.com/openresty/set-misc-nginx-module, BSD)
HTTP_SET_MISC_MODULE_PV="0.24"
HTTP_SET_MISC_MODULE_P="set-misc-nginx-module-${HTTP_SET_MISC_MODULE_PV}"
HTTP_SET_MISC_MODULE_URI="http://github.com/openresty/set-misc-nginx-module/tarball/v${HTTP_SET_MISC_MODULE_PV}"

# NginX XSS module (https://github.com/openresty/xss-nginx-module, BSD)
HTTP_XSS_MODULE_PV="0.04"
HTTP_XSS_MODULE_P="xss-nginx-module-${HTTP_XSS_MODULE_PV}"

# NginX Array-Var module (https://github.com/openresty/array-var-nginx-module, BSD)
HTTP_ARRAY_VAR_MODULE_PV="0.03"
HTTP_ARRAY_VAR_MODULE_P="array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_PV}"

# NginX Iconv module (https://github.com/calio/iconv-nginx-module, BSD)
HTTP_ICONV_MODULE_PV="0.10"
HTTP_ICONV_MODULE_P="iconv-nginx-module-${HTTP_ICONV_MODULE_PV}"

## NginX Set-CConv module (https://github.com/liseen/set-cconv-nginx-module, BSD)
#HTTP_SET_CCONV_MODULE_PV=""
#HTTP_SET_CCONV_MODULE_P="set-cconv-nginx-module-${HTTP_SET_CCONV_MODULE_PV}"
#HTTP_SET_CCONV_MODULE_SHA1=""

# NginX Featured mecached module (http://labs.frickle.com/nginx_ngx_postgres, BSD-2)
HTTP_POSTGRES_MODULE_PV="1.0rc3"
HTTP_POSTGRES_MODULE_P="ngx_postgres-${HTTP_POSTGRES_MODULE_PV}"
HTTP_POSTGRES_MODULE_SHA1="a9b4dd6"

# NginX coolkit module (http://labs.frickle.com/nginx_ngx_coolkit/, BSD-2)
HTTP_COOLKIT_MODULE_PV="1.0"
HTTP_COOLKIT_MODULE_P="ngx_coolkit-${HTTP_COOLKIT_MODULE_PV}"

# # NginX Supervisord module (http://labs.frickle.com/nginx_ngx_supervisord/, BSD-2)
# HTTP_SUPERVISORD_MODULE_PV="1.4"
# HTTP_SUPERVISORD_MODULE_P="ngx_supervisord-${HTTP_SUPERVISORD_MODULE_PV}"

# NginX Auth Request module (BSD)
HTTP_AUTH_REQUEST_MODULE_PV="0.2"
HTTP_AUTH_REQUEST_MODULE_P="ngx_http_auth_request_module-${HTTP_AUTH_REQUEST_MODULE_PV}"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"

inherit eutils user ssl-cert toolchain-funcs perl-module ruby-ng flag-o-matic systemd

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://sysoev.ru/nginx/
	http://www.modrails.com/
	http://tengine.taobao.org/
	http://labs.frickle.com/nginx_ngx_cache_purge/"
SRC_URI="http://tengine.taobao.org/download/${P}.tar.gz
	nginx_modules_http_headers_more? ( https://github.com/openresty/headers-more-nginx-module/tarball/v${HTTP_HEADERS_MORE_MODULE_PV} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_passenger? ( https://github.com/FooBarWidget/passenger/tarball/master -> passenger-git-${PASSENGER_PV}.tar.gz )
	nginx_modules_http_redis? ( ${HTTP_REDIS_MODULE_URI} ->	${HTTP_REDIS_MODULE_P}.tar.gz )
	nginx_modules_http_push? ( http://pushmodule.slact.net/downloads/${HTTP_PUSH_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( http://labs.frickle.com/files/${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_upload? ( http://www.grid.net.ru/nginx/download/${HTTP_UPLOAD_MODULE_P}.tar.gz )
	nginx_modules_http_ey_balancer? ( https://github.com/msva/nginx-ey-balancer/tarball/v${HTTP_EY_BALANCER_MODULE_PV} -> ${HTTP_EY_BALANCER_MODULE_P}.tar.gz )
	nginx_modules_http_ndk? ( https://github.com/simpl/ngx_devel_kit/tarball/v${HTTP_NDK_MODULE_PV} -> ${HTTP_NDK_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( https://github.com/openresty/lua-nginx-module/tarball/v${HTTP_LUA_MODULE_PV} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_drizzle? ( https://github.com/chaoslawful/drizzle-nginx-module/tarball/v${HTTP_DRIZZLE_MODULE_PV} -> ${HTTP_DRIZZLE_MODULE_P}.tar.gz )
	nginx_modules_http_form_input? ( https://github.com/calio/form-input-nginx-module/tarball/v${HTTP_FORM_INPUT_MODULE_PV} -> ${HTTP_FORM_INPUT_MODULE_P}.tar.gz )
    nginx_modules_http_auth_pam? ( ${HTTP_AUTH_PAM_MODULE_URI} -> ${HTTP_AUTH_PAM_MODULE_P}.tar.gz )
    nginx_modules_http_upstream_check? ( ${HTTP_UPSTREAM_CHECK_MODULE_URI} -> ${HTTP_UPSTREAM_CHECK_MODULE_P}.tar.gz )
    nginx_modules_http_metrics? ( ${HTTP_METRICS_MODULE_URI} -> ${HTTP_METRICS_MODULE_P}.tar.gz )
    nginx_modules_http_naxsi? ( ${HTTP_NAXSI_MODULE_URI} -> ${HTTP_NAXSI_MODULE_P}.tar.gz )
    rtmp? ( ${RTMP_MODULE_URI} -> ${RTMP_MODULE_P}.tar.gz )
    nginx_modules_http_dav_ext? ( ${HTTP_DAV_EXT_MODULE_URI} -> ${HTTP_DAV_EXT_MODULE_P}.tar.gz )
	nginx_modules_http_echo? ( https://github.com/openresty/echo-nginx-module/tarball/v${HTTP_ECHO_MODULE_PV} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_rds_json? ( https://github.com/openresty/rds-json-nginx-module/tarball/v${HTTP_RDS_JSON_MODULE_PV} -> ${HTTP_RDS_JSON_MODULE_P}.tar.gz )
	nginx_modules_http_srcache? ( https://github.com/openresty/srcache-nginx-module/tarball/v${HTTP_SRCACHE_MODULE_PV} -> ${HTTP_SRCACHE_MODULE_P}.tar.gz )
	nginx_modules_http_set_misc? ( ${HTTP_SET_MISC_MODULE_URI} -> ${HTTP_SET_MISC_MODULE_P}.tar.gz )
	nginx_modules_http_xss? ( https://github.com/openresty/xss-nginx-module/tarball/v${HTTP_XSS_MODULE_PV} -> ${HTTP_XSS_MODULE_P}.tar.gz )
	nginx_modules_http_array_var? ( https://github.com/openresty/array-var-nginx-module/tarball/v${HTTP_ARRAY_VAR_MODULE_PV} -> ${HTTP_ARRAY_VAR_MODULE_P}.tar.gz )
	nginx_modules_http_iconv? ( https://github.com/calio/iconv-nginx-module/tarball/v${HTTP_ICONV_MODULE_PV} -> ${HTTP_ICONV_MODULE_P}.tar.gz )
	nginx_modules_http_memc? ( https://github.com/openresty/memc-nginx-module/tarball/v${HTTP_MEMC_MODULE_PV} -> ${HTTP_MEMC_MODULE_P}.tar.gz )
	nginx_modules_http_postgres? ( https://codeload.github.com/FRiCKLE/ngx_postgres/tar.gz/${HTTP_POSTGRES_MODULE_PV} -> ${HTTP_POSTGRES_MODULE_P}.tar.gz )
	nginx_modules_http_coolkit? ( http://labs.frickle.com/files/${HTTP_COOLKIT_MODULE_P}.tar.gz )
	nginx_modules_http_upload_progress? ( https://github.com/masterzen/nginx-upload-progress-module/tarball/v${HTTP_UPLOAD_PROGRESS_MODULE_PV} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_auth_request? ( http://mdounin.ru/files/${HTTP_AUTH_REQUEST_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( http://labs.frickle.com/files/${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	rrd? ( http://wiki.nginx.org/images/9/9d/Mod_rrd_graph-0.2.0.tar.gz )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif fastcgi
geo gzip limit_req limit_zone map memcached proxy referer rewrite scgi ssi
split_clients upstream_ip_hash userid uwsgi "
NGINX_MODULES_OPT="addition concat sysguard spdy dav degradation flv geoip gzip_static image_filter
mp4 perl random_index realip secure_link stub_status sub xslt"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="
		http_cache_purge
		http_headers_more
		http_passenger
		http_redis
		http_push
		http_upload
		http_ey_balancer
		http_slowfs_cache
		http_ndk http_lua
		http_form_input
		http_echo
		http_memc
		http_drizzle
		http_rds_json
		http_postgres
		http_coolkit
		http_auth_request
		http_set_misc
		http_srcache
		http_array_var
		http_xss
		http_iconv
		http_upload_progress
		http_auth_pam
		http_upstream_check
		http_metrics
		http_naxsi
	    http_dav_ext
		http_syslog"
# http_set_cconv"

REQUIRED_USE="	nginx_modules_http_lua? ( nginx_modules_http_ndk )
		nginx_modules_http_rds_json? ( || ( nginx_modules_http_drizzle nginx_modules_http_postgres ) )
		nginx_modules_http_form_input? ( nginx_modules_http_ndk )
    	nginx_modules_http_naxsi? ( pcre )
	    nginx_modules_http_dav_ext? ( nginx_modules_http_dav )
		nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
		nginx_modules_http_set_misc? ( nginx_modules_http_ndk )
		nginx_modules_http_iconv? ( nginx_modules_http_ndk )
		nginx_modules_http_array_var? ( nginx_modules_http_ndk )"
#		nginx_modules_http_set_cconv? ( nginx_modules_http_ndk )

IUSE="aio debug +http +http-cache ipv6 libatomic pam +pcre perftools rrd rtmp ssl vim-syntax +luajit"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

CDEPEND="
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	http-cache? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_geo? ( dev-libs/geoip )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_syslog? ( virtual/logger )
	nginx_modules_http_image_filter? ( media-libs/gd )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_http_drizzle? ( dev-db/drizzle )
	nginx_modules_http_lua? ( luajit? ( dev-lang/luajit:2 ) !luajit? ( >=dev-lang/lua-5.1 ) )
    nginx_modules_http_auth_pam? ( virtual/pam )
	nginx_modules_http_metrics? ( dev-libs/yajl )
	nginx_modules_http_dav_ext? ( dev-libs/expat )
	nginx_modules_http_passenger? (
		$(ruby_implementation_depend ruby19)
		>=dev-ruby/rubygems-0.9.0
		>=dev-ruby/rake-0.8.1
		>=dev-ruby/fastthread-1.0.1
		>=dev-ruby/rack-1.0.0
		dev-libs/libev
		!!www-apache/passenger
	)
	perftools? ( dev-util/google-perftools )
	rrd? ( >=net-analyzer/rrdtool-1.3.8 )
"
RDEPEND="${CDEPEND} !www-servers/nginx"
DEPEND="${CDEPEND}
	libatomic? ( dev-libs/libatomic_ops )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

S="${WORKDIR}/${PN}-${PV}"
MY_NAME="nginx"
pkg_setup() {

	NGINX_HOME="/var/lib/nginx"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating nginx user and group"
	enewgroup ${MY_NAME}
	enewuser ${MY_NAME} -1 -1 "${NGINX_HOME}" ${MY_NAME}
	eend $?

	if use libatomic; then
		ewarn ""
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn ""
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is not supported!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use nginx_modules_http_passenger; then
		ruby-ng_pkg_setup
		use debug && append-flags -DPASSENGER_DEBUG
	fi

	if use !http; then
		ewarn ""
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
	use rrd && unpack "Mod_rrd_graph-0.2.0.tar.gz"
}

src_prepare() {
	sed -i -e 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make

	sed -i -e "s|\(NGX_MAX_ERROR_STR\)   2048|\1 4096|" "${S}"/src/core/ngx_log.h

	if use nginx_modules_http_ey_balancer; then
		epatch "${FILESDIR}"/nginx-1.x-ey-balancer.patch
	fi

	if use nginx_modules_http_passenger; then
		mv "${WORKDIR}/phusion-passenger-09abf16" "${WORKDIR}"/passenger-"${PASSENGER_PV}";
		cd "${WORKDIR}"/passenger-"${PASSENGER_PV}";

		##epatch "${FILESDIR}"/passenger-3.0.9-gentoo.patch
		##epatch "${FILESDIR}"/passenger-3.0.12-ldflags.patch
		# epatch "${FILESDIR}"/passenger-3.0.9-math.patch
		# epatch "${FILESDIR}"/boost_config_stdlib_libstdcpp3.hpp.patch

		sed -i -e "s:/usr/share/doc/phusion-passenger:/usr/share/doc/${P}:" \
		-e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/passenger/agents:" lib/phusion_passenger.rb || die
		sed -i -e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/passenger/agents:" ext/common/ResourceLocator.h || die
		sed -i -e '/passenger-install-apache2-module/d' -e "/passenger-install-nginx-module/d" lib/phusion_passenger/packaging.rb || die
		rm -f bin/passenger-install-apache2-module bin/passenger-install-nginx-module || die "Unable to remove unneeded install script."
	fi
}

src_configure() {
	local myconf= http_enabled= mail_enabled=

	use aio && myconf+=" --with-file-aio --with-aio_module"
	use debug && myconf+=" --with-debug"
	use ipv6 && myconf+=" --with-ipv6"
	use libatomic && myconf+=" --with-libatomic"
	use pcre && myconf+=" --with-pcre"

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf+=" --without-http_${mod}_module"
		fi
	done

	for mod in $NGINX_MODULES_OPT; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
			myconf+=" --with-http_${mod}_module"
		fi
	done

	if use nginx_modules_http_fastcgi; then
		myconf+=" --with-http_realip_module"
	fi

	# third-party modules
	# WARNING!!! Modules (that checked with "(**)" comment) adding order IS IMPORTANT!
# (**) http_ndk
	if use nginx_modules_http_ndk; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/simpl-ngx_devel_kit-${HTTP_NDK_MODULE_SHA1}"
	fi

# (**) http_set_misc
	if use nginx_modules_http_set_misc; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-set-misc-nginx-module-${HTTP_SET_MISC_MODULE_SHA1}"
	fi

# (**)http_ auth_request
	if use nginx_modules_http_auth_request; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_AUTH_REQUEST_MODULE_P}"
	fi

# (**) http_echo
	if use nginx_modules_http_echo; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-echo-nginx-module-${HTTP_ECHO_MODULE_SHA1}"
	fi

# (**) http_memc
	if use nginx_modules_http_memc; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-memc-nginx-module-${HTTP_MEMC_MODULE_SHA1}"
	fi

# (**) http_lua
	if use nginx_modules_http_lua; then
		http_enabled=1
		if use luajit; then
			export LUAJIT_LIB=$(pkg-config --variable libdir luajit)
			export LUAJIT_INC=$(pkg-config --variable includedir luajit)
		else
			export LUA_LIB=$(pkg-config --variable libdir lua)
			export LUA_INC=$(pkg-config --variable includedir lua)
		fi
		myconf+=" --add-module=${WORKDIR}/openresty-lua-nginx-module-${HTTP_LUA_MODULE_SHA1}"
	fi

# (**) http_headers_more
	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_SHA1}"
	fi

# (**) http_srcache
	if use nginx_modules_http_srcache; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-srcache-nginx-module-${HTTP_SRCACHE_MODULE_SHA1}"
	fi


# (**) http_drizzle
	if use nginx_modules_http_drizzle; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/chaoslawful-drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_SHA1}"
	fi

# (**) http_rds_json
	if use nginx_modules_http_rds_json; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_SHA1}"
	fi

# http_postgres
	if use nginx_modules_http_postgres; then
		http_enabled=1
		#myconf+=" --add-module=${WORKDIR}/FRiCKLE-ngx_postgres-${HTTP_POSTGRES_MODULE_SHA1}"
		myconf+=" --add-module=${WORKDIR}/${HTTP_POSTGRES_MODULE_P}"
	fi

# http_auth_pam
    if use nginx_modules_http_auth_pam; then
        http_enabled=1
        myconf+=" --add-module=${HTTP_AUTH_PAM_MODULE_WD}"
    fi

# http_upstream_check
    if use nginx_modules_http_upstream_check; then
        http_enabled=1
        myconf+=" --add-module=${HTTP_UPSTREAM_CHECK_MODULE_WD}"
    fi

# http_metrics
    if use nginx_modules_http_metrics; then
        http_enabled=1
        myconf+=" --add-module=${HTTP_METRICS_MODULE_WD}"
    fi

# http_naxsi
    if use nginx_modules_http_naxsi ; then
        http_enabled=1
        myconf+=" --add-module=${HTTP_NAXSI_MODULE_WD}"
    fi

# http_rtmp
    if use rtmp ; then
        http_enabled=1
        myconf+=" --add-module=${RTMP_MODULE_WD}"
    fi

# http_dav_ext
    if use nginx_modules_http_dav_ext ; then
        http_enabled=1
        myconf+=" --add-module=${HTTP_DAV_EXT_MODULE_WD}"
    fi

# http_coolkit
	if use nginx_modules_http_coolkit; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_COOLKIT_MODULE_P}"
	fi

# http_passenger
	if use nginx_modules_http_passenger; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/passenger-${PASSENGER_PV}/ext/nginx"
	fi

# http_push
	if use nginx_modules_http_push; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_PUSH_MODULE_P}"
	fi

# http_supervisord
	# if use nginx_modules_http_supervisord; then
	# 	http_enabled=1
	# 	myconf+=" --add-module=${WORKDIR}/${HTTP_SUPERVISORD_MODULE_P}"
	# fi

# http_xss
	if use nginx_modules_http_xss; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/openresty-xss-nginx-module-${HTTP_XSS_MODULE_SHA1}"
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/openresty-array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_SHA1}"
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/calio-form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_SHA1}"
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/calio-iconv-nginx-module-${HTTP_ICONV_MODULE_SHA1}"
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/masterzen-nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_SHA1}"
	fi

# http_set-cconv
#	if use nginx_modules_http_set_cconv; then
#		http_enabled=1
#		myconf+=" --add-module=${WORKDIR}/liseen-set-cconv-nginx-module-${HTTP_SET_CCONV_MODULE_SHA1}"
#	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_CACHE_PURGE_MODULE_P}"
	fi

# http_upload
	if use nginx_modules_http_upload; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_UPLOAD_MODULE_P}"
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/msva-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1}"
	fi

# http_slowfs_cache
	if use nginx_modules_http_slowfs_cache; then
		http_enabled=1
		myconf+=" --add-module=${WORKDIR}/${HTTP_SLOWFS_CACHE_MODULE_P}"
	fi

# http_redis
	if use nginx_modules_http_redis; then
		http_enabled=1
		#myconf+=" --add-module=${WORKDIR}/${HTTP_REDIS_MODULE_P}"
		myconf+=" --add-module=${WORKDIR}/openresty-redis2-nginx-module-${HTTP_REDIS_MODULE_SHA1}"
	fi

	if use http || use http-cache; then
		http_enabled=1
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=" --without-http-cache"
		use ssl && myconf+=" --with-http_ssl_module"
	else
		myconf+=" --without-http --without-http-cache"
	fi

	use perftools && myconf+=" --with-google_perftools_module"
	use rrd && myconf+=" --add-module=${WORKDIR}/mod_rrd_graph-0.2.0"
	use nginx_modules_http_syslog && myconf+=" --with-syslog"

	# MAIL modules
	for mod in $NGINX_MODULES_MAIL; do
		if use nginx_modules_mail_${mod}; then
			mail_enabled=1
		else
			myconf+=" --without-mail_${mod}_module"
		fi
	done

	if [ $mail_enabled ]; then
		myconf+=" --with-mail"
		use ssl && myconf+=" --with-mail_ssl_module"
	fi

	# custom modules
	for mod in $NGINX_ADD_MODULES; do
		myconf+=" --add-module=${mod}"
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

	./configure \
		--prefix=/usr \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/"${MY_NAME}"/"${MY_NAME}".conf \
		--error-log-path=/var/tmp/"${MY_NAME}"/error_log \
		--pid-path=/var/run/"${MY_NAME}".pid \
		--lock-path=/var/lock/nginx.lock \
		--user="${MY_NAME}" --group="${MY_NAME}" \
		--with-cc-opt="-I${ROOT}usr/include" \
		--with-ld-opt="-L${ROOT}usr/lib" \
		--http-log-path=/var/tmp/"${MY_NAME}"/access_log \
		--http-client-body-temp-path=/var/tmp/"${MY_NAME}"/client \
		--http-proxy-temp-path=/var/tmp/"${MY_NAME}"/proxy \
		--http-fastcgi-temp-path=/var/tmp/"${MY_NAME}"/fastcgi \
		--http-scgi-temp-path=/var/tmp/"${MY_NAME}"/scgi \
		--http-uwsgi-temp-path=/var/tmp/"${MY_NAME}"/uwsgi \
		${myconf} || die "configure failed"
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	keepdir /var/log/"${MY_NAME}" /var/tmp/"${MY_NAME}"/{client,proxy,fastcgi,scgi,uwsgi}

	dosbin objs/nginx
	newinitd "${FILESDIR}"/nginx.initd-r2 nginx

	systemd_newunit "${FILESDIR}"/nginx.service-r1 nginx.service

	cp "${FILESDIR}"/nginx.conf conf/nginx.conf
	rm conf/win-utf conf/koi-win conf/koi-utf

	dodir /etc/"${MY_NAME}"
	insinto /etc/"${MY_NAME}"
	doins conf/*

	doman man/nginx.8
	dodoc CHANGES* README

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate nginx

# http_perl
	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
		fixlocalpod
	fi

# http_push
	if use nginx_modules_http_push; then
		docinto "${HTTP_PUSH_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_PUSH_MODULE_P}"/{changelog.txt,protocol.txt,README}
	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		docinto "${HTTP_CACHE_PURGE_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_CACHE_PURGE_MODULE_P}"/{CHANGES,README.md}
	fi

# http_upload
	if use nginx_modules_http_upload; then
		docinto "${HTTP_UPLOAD_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_UPLOAD_MODULE_P}"/{Changelog,README}
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		docinto "${HTTP_UPLOAD_PROGRESS_MODULE_P}"
		dodoc "${WORKDIR}"/"masterzen-nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_SHA1}"/README
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		docinto "${HTTP_EY_BALANCER_MODULE_P}"
		dodoc "${WORKDIR}"/"msva-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1}"/README
	fi

# http_ndk
	if use nginx_modules_http_ndk; then
		docinto "${HTTP_NDK_MODULE_P}"
		dodoc "${WORKDIR}"/"simpl-ngx_devel_kit-${HTTP_NDK_MODULE_SHA1}"/README
	fi

# http_lua
	if use nginx_modules_http_lua; then
		docinto "${HTTP_LUA_MODULE_P}"
		dodoc "${WORKDIR}"/"openresty-lua-nginx-module-${HTTP_LUA_MODULE_SHA1}"/{Changes,README.markdown}
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		docinto "${HTTP_FORM_INPUT_MODULE_P}"
		dodoc "${WORKDIR}"/"calio-form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_SHA1}"/README
	fi

# http_echo
	if use nginx_modules_http_echo; then
		docinto "${HTTP_ECHO_MODULE_P}"
		dodoc "${WORKDIR}"/"openresty-echo-nginx-module-${HTTP_ECHO_MODULE_SHA1}"/README
	fi

    if use nginx_modules_http_auth_pam; then
        docinto ${HTTP_AUTH_PAM_MODULE_P}
        dodoc "${HTTP_AUTH_PAM_MODULE_WD}"/{README,ChangeLog}
    fi

    if use nginx_modules_http_upstream_check; then
        docinto ${HTTP_UPSTREAM_CHECK_MODULE_P}
        dodoc "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/{README,CHANGES}
    fi

    if use nginx_modules_http_metrics; then
        docinto ${HTTP_METRICS_MODULE_P}
        dodoc "${HTTP_METRICS_MODULE_WD}"/README.md
    fi

    if use nginx_modules_http_naxsi; then
        insinto /etc/nginx
        doins "${HTTP_NAXSI_MODULE_WD}"/../naxsi_config/naxsi_core.rules
    fi

    if use rtmp; then
        docinto ${RTMP_MODULE_P}
        dodoc "${RTMP_MODULE_WD}"/{AUTHORS,README.md,stat.xsl}
    fi

    if use nginx_modules_http_dav_ext; then
        docinto ${HTTP_DAV_EXT_MODULE_P}
        dodoc "${HTTP_DAV_EXT_MODULE_WD}"/README
    fi

# http_srcache
	if use nginx_modules_http_srcache; then
		docinto "${HTTP_SRCACHE_MODULE_P}"
	fi

# http_memc
	if use nginx_modules_http_memc; then
		docinto "${HTTP_MEMC_MODULE_P}"
	fi

# http_drizzle
	if use nginx_modules_http_drizzle; then
		docinto "${HTTP_DRIZZLE_MODULE_P}"
		dodoc "${WORKDIR}"/"chaoslawful-drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_SHA1}"/README
	fi

# http_rds_json
	if use nginx_modules_http_rds_json; then
		docinto "${HTTP_RDS_JSON_MODULE_P}"
		dodoc "${WORKDIR}"/"openresty-rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_SHA1}"/README
	fi

# http_postgres
	if use nginx_modules_http_postgres; then
		docinto "${HTTP_POSTGRES_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_POSTGRES_MODULE_P}"/README.md
	fi

# http_coolkit
	if use nginx_modules_http_coolkit; then
		docinto "${HTTP_COOLKIT_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_COOLKIT_MODULE_P}"/README
	fi

# http_set_misc
	if use nginx_modules_http_set_misc; then
		docinto "${HTTP_SET_MISC_MODULE_P}"
		dodoc "${WORKDIR}"/"openresty-set-misc-nginx-module-${HTTP_SET_MISC_MODULE_SHA1}"/README
	fi

# http_xss
	if use nginx_modules_http_xss; then
		docinto "${HTTP_XSS_MODULE_P}"
		dodoc "${WORKDIR}"/"openresty-xss-nginx-module-${HTTP_XSS_MODULE_SHA1}"/README
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		docinto "${HTTP_ARRAY_VAR_MODULE_P}"
		dodoc "${WORKDIR}"/"openresty-array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_SHA1}"/README
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		docinto "${HTTP_ICONV_MODULE_P}"
		dodoc "${WORKDIR}"/"calio-iconv-nginx-module-${HTTP_ICONV_MODULE_SHA1}"/README
	fi

# http_set_cconv
#	if use nginx_modules_http_set_cconv; then
#		docinto "${HTTP_SET_CCONV_MODULE_P}"
#		dodoc "${WORKDIR}"/"${HTTP_SET_CCONV_MODULE_P}"/README
#	fi

# http_supervisord
	# if use nginx_modules_http_supervisord; then
	# 	docinto "${HTTP_SUPERVISORD_MODULE_P}"
	# 	dodoc "${WORKDIR}"/"${HTTP_SUPERVISORD_MODULE_P}"/README
	# fi

# http_slowfs_cache
	if use nginx_modules_http_slowfs_cache; then
		docinto "${HTTP_SLOWFS_CACHE_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_SLOWFS_CACHE_MODULE_P}"/{CHANGES,README.md}
	fi

# http_passenger
	if use nginx_modules_http_passenger; then
		cd "${WORKDIR}"/passenger-"${PASSENGER_PV}"
		rake fakeroot
	fi

}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${ROOT}"/etc/ssl/"${MY_NAME}"/"${MY_NAME}".key ]; then
			install_cert /etc/ssl/"${MY_NAME}"/"${MY_NAME}"
			chown "${MY_NAME}":"${MY_NAME}" "${ROOT}"/etc/ssl/"${MY_NAME}"/"${MY_NAME}".{crt,csr,key,pem}
		fi
	fi
}
