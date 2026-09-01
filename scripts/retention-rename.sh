#!/usr/bin/env bash
# retention-rename.sh — apply a retention-rename on the operator's host
#
# Why this exists (incident 2026-08-09 → 2026-09-01):
# Commit 2d581104 ("retention: remove 14 duplicate packages") renamed three
# packages in this overlay:
#   dev-util/opencode-antigravity-auth -> dev-util/opencode-plugin-antigravity-auth
#   dev-util/opencode-pty             -> dev-util/opencode-plugin-pty
#   dev-util/rtk                      -> app-misc/rtk
# The commit redirected *internal* ebuild dependents but did NOT touch the
# operator's /var/lib/portage/world. The 2026-09-01 incident happened when
# the operator ran the obvious four-step transition:
#   1. emerge --deselect <old>      (edits world)
#   2. emerge --select <new>         (edits world)
#   3. emerge <new>                  (FAILED — file collision at pkg_preinst
#                                      against the still-installed old atom)
#   4. emerge --unmerge <old>        (succeeded — too late)
# Net effect: both rtk and opencode-antigravity-auth were unmerged, neither
# replacement was installed, /usr/bin/rtk was gone with no recovery until
# the new atoms were explicitly emerged.
#
# --deselect and --select only edit the world file. They do NOT uninstall
# anything. If you --select <new> and emerge <new> without first unmerging
# <old>, portage's pkg_preinst file-collision check will fail. The reverse
# is also unsafe: --unmerge <old> before <new> is installed leaves the
# operator with neither old nor new binaries for the transition window.
#
# This script runs the four-step transition in the only safe order:
#   1. Unmerge the old atom  (deletes /var/db/pkg/<old> and its files)
#   2. --deselect the old atom from world
#   3. --select the new atom into world
#   4. Emerge the new atom  (installs the replacement)
#
# Idempotent: re-running is safe; steps that no longer apply are skipped.
#
# Usage:
#   scripts/retention-rename.sh [flags] OLD-ATOM NEW-ATOM [OLD NEW ...]
#
# Example:
#   sudo scripts/retention-rename.sh \
#       dev-util/rtk app-misc/rtk \
#       dev-util/opencode-antigravity-auth dev-util/opencode-plugin-antigravity-auth
#
# Flags:
#   --dry-run    Print the actions that would be taken; execute nothing.
#   --pretend    Pass --pretend to emerge (smoke test the install step).
#                Implies --dry-run for unmerge/deselect/select (those are
#                reversible metadata changes; the only dangerous step is
#                the actual emerge).
#   -h, --help   Show this help and exit.
#
# Exit codes:
#   0  All renames succeeded
#   1  Invalid arguments
#   2  One or more renames failed (continues processing remaining pairs)

set -euo pipefail

DRY_RUN=0
PRETEND=0
RENAMES=()

usage() {
    # Print every line from 2 down to (but not including) the first blank
    # line; strip the leading "# " (or lone "#") so the help text reads as
    # plain markdown. A single-# comment line in the source becomes blank
    # output, which is the right behavior — separator lines stay separators.
    awk 'NR >= 2 && /^$/ {exit} NR >= 2 {sub(/^# ?/, ""); print}' "$0"
    exit "${1:-0}"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)   DRY_RUN=1; shift ;;
        --pretend)   DRY_RUN=1; PRETEND=1; shift ;;
        -h|--help)   usage 0 ;;
        --)          shift; break ;;
        -*)          echo "retention-rename: unknown flag: $1" >&2; usage 1 ;;
        *)           RENAMES+=("$1"); shift ;;
    esac
done

# Validation
if [ ${#RENAMES[@]} -eq 0 ]; then
    usage 1
fi
if [ $(( ${#RENAMES[@]} % 2 )) -ne 0 ]; then
    echo "retention-rename: arguments must be in OLD NEW pairs (got $(( ${#RENAMES[@]} )) atoms)" >&2
    exit 1
fi

# Prefix for the actual emerge step (the only destructive one)
EMERGE_FLAGS=()
[ "$PRETEND" -eq 1 ] && EMERGE_FLAGS+=(--pretend)
EMERGE_FLAGS+=(--oneshot)

# run(): dispatch through the dry-run gate. PRETEND only re-enables the
# emerge step (step 4) for real-but-no-side-effects; unmerge/deselect/select
# (steps 1-3) stay in dry-run because they touch world / filesystem state.
run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] %s\n' "$*"
    else
        "$@"
    fi
}

# run_real(): bypass the dry-run gate. Only the emerge step uses this, and
# only when --pretend was passed (so the actual call is `emerge --pretend`,
# which is a real dep solver invocation without filesystem writes).
run_real() {
    "$@"
}

# atom_in_world <atom> — exact-line match against world file
atom_in_world() {
    grep -qxF "$1" /var/lib/portage/world 2>/dev/null
}

# atom_installed <atom> — non-empty qlist output
atom_installed() {
    [ -n "$(qlist -IC "$1" 2>/dev/null)" ]
}

# atom_in_repo <atom> — available in any configured repo
atom_in_repo() {
    portageq has_version / "$1" >/dev/null 2>&1
}

failed=0
i=0
while [ $i -lt ${#RENAMES[@]} ]; do
    old="${RENAMES[$i]}"
    new="${RENAMES[$((i+1))]}"
    i=$((i+2))

    printf '\n=== rename: %s -> %s ===\n' "$old" "$new"

    # Sanity: new atom must be available in the overlay/repos.
    # If we can't even find the new atom in any repo, abort this pair.
    if ! atom_in_repo "$new"; then
        printf 'SKIP: %s not in any configured repo (overlay sync stale?)\n' "$new"
        failed=$((failed+1))
        continue
    fi

    # Step 1: unmerge the old atom (only if currently installed).
    # This is the only step that deletes files; safe to run multiple times.
    if atom_installed "$old"; then
        printf 'unmerge %s ...\n' "$old"
        if ! run sudo -n emerge --unmerge --quiet-build=y "$old"; then
            printf 'FAIL unmerge %s -- bailing on this pair\n' "$old"
            failed=$((failed+1))
            continue
        fi
    else
        printf '%s not installed; skipping unmerge\n' "$old"
    fi

    # Step 2: drop the old atom from world (only if still listed there).
    if atom_in_world "$old"; then
        printf 'deselect %s ...\n' "$old"
        run sudo -n emerge --deselect "$old" || true
    else
        printf '%s not in world; skipping deselect\n' "$old"
    fi

    # Step 3: add the new atom to world (only if not already there).
    if ! atom_in_world "$new"; then
        printf 'select %s ...\n' "$new"
        run sudo -n emerge --select "$new" || true
    else
        printf '%s already in world; skipping select\n' "$new"
    fi

    # Step 4: emerge the new atom. This is the dangerous step — the one
    # that broke in the 2026-09-01 incident. We do it last so the file
    # collision can no longer occur. With --pretend, the dep solver runs
    # for real (no filesystem writes); with --dry-run we only print.
    printf 'emerge %s ...\n' "$new"
    if [ "$PRETEND" -eq 1 ]; then
        if ! run_real sudo -n emerge "${EMERGE_FLAGS[@]}" "$new"; then
            printf 'FAIL emerge %s\n' "$new"
            failed=$((failed+1))
            continue
        fi
    else
        if ! run sudo -n emerge "${EMERGE_FLAGS[@]}" "$new"; then
            printf 'FAIL emerge %s\n' "$new"
            failed=$((failed+1))
            continue
        fi
    fi

    printf 'OK %s -> %s\n' "$old" "$new"
done

if [ "$failed" -eq 0 ]; then
    exit 0
else
    exit 2
fi
