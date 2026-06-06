# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for Hermes Agent plugins"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"

LICENSE="MIT"
SLOT="0"
S="${WORKDIR}/hermes-agent-${PV}/plugins/."
KEYWORDS="~amd64"

IUSE="+dashboard +memory +spotify +web context-engine disk-cleanup google-meet achievements image-gen kanban model-providers observability platforms strike-freedom-cockpit otel paperclip"

RDEPEND="
	app-misc/hermes[cli,mcp,web?]
	dashboard? ( app-misc/hermes-plugin-dashboard )
	memory? ( app-misc/hermes-plugin-memory )
	spotify? ( app-misc/hermes-plugin-spotify )
	web? ( app-misc/hermes-plugin-web )
	context-engine? ( app-misc/hermes-plugins-context_engine )
	disk-cleanup? ( app-misc/hermes-plugins-disk-cleanup )
	google-meet? ( app-misc/hermes-plugins-google_meet )
	achievements? ( app-misc/hermes-plugins-achievements )
	image-gen? ( app-misc/hermes-plugins-image_gen )
	kanban? ( app-misc/hermes-plugins-kanban )
	model-providers? ( app-misc/hermes-plugins-model-providers )
	observability? ( app-misc/hermes-plugins-observability )
	platforms? ( app-misc/hermes-plugins-platforms )
	strike-freedom-cockpit? ( app-misc/hermes-plugins-strike-freedom-cockpit )
	otel? ( app-misc/hermes-otel )
	paperclip? ( app-misc/hermes-paperclip-adapter )
"

pkg_postinst() {
	einfo "Hermes plugins meta-package installed."
	einfo ""
	einfo "This package provides optional dependencies for various Hermes Agent plugins."
	einfo "Use individual package USE flags to install specific plugins:"
	einfo "  emerge app-misc/hermes-plugins[dashboard,memory,spotify]"
	einfo ""
	einfo "Available plugins:"
	use dashboard && einfo "  - dashboard: Hermes Dashboard plugin"
	use memory && einfo "  - memory: Memory management plugin"
	use spotify && einfo "  - spotify: Spotify integration plugin"
	use web && einfo "  - web: Web interface plugin"
	use context-engine && einfo "  - context-engine: Context engine plugin"
	use disk-cleanup && einfo "  - disk-cleanup: Disk cleanup plugin"
	use google-meet && einfo "  - google-meet: Google Meet integration"
	use achievements && einfo "  - achievements: Achievements plugin"
	use image-gen && einfo "  - image-gen: Image generation plugin"
	use kanban && einfo "  - kanban: Kanban board plugin"
	use model-providers && einfo "  - model-providers: Model providers plugin"
	use observability && einfo "  - observability: Observability plugin"
	use platforms && einfo "  - platforms: Platform integrations plugin"
	use strike-freedom-cockpit && einfo "  - strike-freedom-cockpit: Strike Freedom Cockpit plugin"
	use otel && einfo "  - otel: OpenTelemetry plugin"
	use paperclip && einfo "  - paperclip: Paperclip adapter plugin"
	einfo ""
	einfo "For more information, see individual package descriptions."
}
