#!/bin/bash
# verify-git-uris.sh — verify every EGIT_REPO_URI in the overlay is fetchable
# by the portage user (the account builds actually run under, via userpriv).
#
# Why this exists (incident 2026-08-13): three ebuilds (mcp-mesh-0.19.1,
# mcp-forge-9999, better-brain-9999) died in src_unpack because their
# EGIT_REPO_URI pointed at file:///storage/home/haven/... — a directory
# chmod 700 owned by haven. Root-based gates (`sudo ebuild clean install`)
# traverse it fine, but the portage user cannot, so the tree looked healthy
# while real builds were broken.
#
# The gate probes every URI exactly as git-r3 would during a build:
#   https:// -> sudo -u portage git ls-remote <uri> HEAD
#   file:// or bare path -> sudo -u portage git -C <path> rev-parse HEAD
#   ssh://  -> SKIP (credentials; must be migrated to https or masked)
#
# ${PN} templates are expanded from the package directory, and commented
# EGIT_REPO_URI lines are ignored, so only real build-time URIs are probed.
#
# Exit status: 0 all URIs fetchable; 1 any probe failed.
# Usage: ./verify-git-uris.sh [overlay-path]

set -u
OVERLAY="${1:-/var/db/repos/haven-overlay}"

probe_https() {
	local uri="$1"
	if timeout 30 sudo -u portage git ls-remote "$uri" HEAD >/dev/null 2>&1; then
		printf 'OK   %s\n' "$uri"
		return 0
	fi
	printf 'FAIL %s (not fetchable by portage user)\n' "$uri"
	return 1
}

probe_local() {
	local path="$1"
	if timeout 30 sudo -u portage git -C "$path" rev-parse HEAD >/dev/null 2>&1; then
		printf 'OK   %s (local, readable by portage)\n' "$path"
		return 0
	fi
	printf 'FAIL %s (not readable by portage user)\n' "$path"
	return 1
}

uris=$(grep -rnE '^[[:space:]]*EGIT_REPO_URI="[^"]+"' "$OVERLAY" --include='*.ebuild' |
	sed -E 's/^([^:]+):[0-9]+:[[:space:]]*EGIT_REPO_URI="([^"]+)"/\2/' |
	while IFS= read -r u; do
		pn=$(basename "$(dirname "$(grep -rl "EGIT_REPO_URI=\"${u}\"" "$OVERLAY" --include='*.ebuild' | head -1)")")
		[ -n "$pn" ] && u="${u//\$\{PN\}/$pn}"
		printf '%s\n' "$u"
	done | sort -u)

[ -z "$uris" ] && {
	echo "no EGIT_REPO_URI found under $OVERLAY"
	exit 1
}

fail=0
while IFS= read -r uri; do
	case "$uri" in
	https://* | http://*)
		probe_https "$uri" || fail=1
		;;
	git://*)
		printf 'FAIL %s (git:// protocol dead; migrate to https or mask)\n' "$uri"
		fail=1
		;;
	ssh://* | *@*:*)
		printf 'SKIP %s (ssh:// requires credentials — portage cannot fetch; migrate or mask)\n' "$uri"
		fail=1
		;;
	file://*)
		probe_local "${uri#file://}" || fail=1
		;;
	/*)
		probe_local "$uri" || fail=1
		;;
	*)
		printf 'SKIP %s (unknown scheme — manual review)\n' "$uri"
		fail=1
		;;
	esac
done <<<"$uris"

if [ "$fail" -ne 0 ]; then
	echo "verify-git-uris: FAILURES FOUND (see above)" >&2
	exit 1
fi
echo "verify-git-uris: all $(printf '%s\n' "$uris" | wc -l) unique EGIT_REPO_URI values fetchable by portage user"
