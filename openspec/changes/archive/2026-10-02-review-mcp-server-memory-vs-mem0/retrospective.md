# Retrospective: review-mcp-server-memory-vs-mem0

> **TIMING**: filled at apply-time, immediately before PR. All qualitative
> claims cite §0 metrics or commit hashes.

> To be completed at apply-time, after verify.md is filled.

## §0 Evidence (apply-time fill)

| Metric | Value |
|---|---|
| Commits | TBD |
| Diff size (lines) | TBD |
| Tasks-done ratio (from tasks.md) | TBD |
| Disk freed | TBD (~16 MiB) |
| `mcp-mesh doctor` warnings before → after | TBD → TBD |

## §1 What went well (apply-time fill)

- (Filled at apply-time)

## §2 What went badly (apply-time fill)

- (Filled at apply-time)

## §3 Process improvement (apply-time fill)

- (Filled at apply-time)

## §4 Cross-project signal

- The "two-package problem" (npm-server-memory + mem0-mcp) is a recurring
  pattern: an installed-but-broken package that should have been
  replaced as soon as a working alternative landed. Consider a
  pre-removal lint that flags installed ebuilds whose `.ebuild`
  declares `RESTRICT=test` + zero dependents.
