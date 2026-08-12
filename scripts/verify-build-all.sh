#!/usr/bin/env bash
# verify-build-all.sh — build-test every ebuild in the overlay.
#
# Runs `ebuild clean install` per package to catch breakages that static
# gates miss (stale CRATES, missing runtime deps, broken src_install).
# Supports a deterministic per-category rotation mode for scheduled runs:
#   verify-build-all.sh [overlay]            # build all ebuilds (default)
#   verify-build-all.sh [overlay] --category # one ebuild per category, rotating
#   verify-build-all.sh [overlay] --list     # print what would be built
#
# Exit non-zero if any ebuild fails to build.
set -euo pipefail

overlay="/var/db/repos/haven-overlay"
mode="all"
for arg in "$@"; do
	case "${arg}" in
		--category) mode="category" ;;
		--list) mode="list" ;;
		*) overlay="${arg}" ;;
	esac
done
cd "${overlay}"

# Deterministic ordering: ebuilds sorted by (category, package, version).
mapfile -t ebuilds < <(find . -name '*.ebuild' -not -path './metadata/*' \
	-not -name '*-9999.ebuild' | sort)

case "${mode}" in
	list)
		printf '%s\n' "${ebuilds[@]}"
		exit 0
		;;
	category)
		# One ebuild per category, rotating by mtime: pick the least-recently
		# tested ebuild in each category for fair coverage over time.
		selected=()
		for cat in $(printf '%s\n' "${ebuilds[@]}" | cut -d/ -f2 | sort -u); do
			cand=$(printf '%s\n' "${ebuilds[@]}" | grep "^\./${cat}/" \
				| xargs -r ls -t 2>/dev/null | tail -1)
			[[ -n ${cand} ]] && selected+=("${cand}")
		done
		ebuilds=("${selected[@]}")
		;;
esac

echo "=== verify-build-all: ${#ebuilds[@]} ebuilds ($(date +%F_%T)) ==="
failures=0
for e in "${ebuilds[@]}"; do
	echo "--- ${e}"
	if ! sudo -n ebuild "${e}" clean install >/tmp/verify-build-all.log 2>&1; then
		echo "FAIL: ${e}"
		tail -20 /tmp/verify-build-all.log
		failures=$((failures + 1))
	else
		echo "ok: ${e}"
	fi
done

if [[ ${failures} -gt 0 ]]; then
	echo "=== FAILED: ${failures} ebuild(s) failed to build ==="
	exit 1
fi
echo "=== ALL PASSED (${#ebuilds[@]} ebuilds) ==="
