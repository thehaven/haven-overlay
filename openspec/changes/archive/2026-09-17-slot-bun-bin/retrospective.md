## §0 Evidence

| Metric | Value |
|--------|-------|
| Packages slotted | 2 (`dev-lang/bun-bin:1.3`, `dev-lang/bun-bin:1.4`) |
| Modules added | 1 (`app-eselect/eselect-bun`) |
| Eclasses hardened | 1 (`eclass/bun.eclass`) |
| Tasks completed | 11 / 11 from `tasks.md` |
| Verification tests | 7 / 7 PASS |
| Verify result | PASS |

## §1 Wins

- Successfully decoupled Bun runtimes by minor version (`1.3` and `1.4`) using standard Portage slotting (`SLOT="$(ver_cut 1-2)"`).
- Avoided the "Eselect Trap" by implementing hermetic build isolation in `eclass/bun.eclass` via `${T}/bun-bin`, ensuring ebuild builds are immune to interactive system-wide `eselect` state.
- Preserved stability across all 55 existing packages inheriting `bun.eclass` in `haven-overlay` by defaulting `BUN_SLOT:=1.3`.
- Re-established full operational status for OpenCode v1 (`1.18.31`) after rebuilding against Bun 1.3.14 (confirmed via `opencode run --format json "say OK"`).
- Successfully built and validated OpenCode v2 (`2.0.6`) from source against Bun 1.4.2 without runtime or build conflicts.

## §2 Misses

- Upstream Bun 1.4.x introduced silent bundling regressions affecting OpenCode 1.18.x compiled outputs (chunk-splitting / module-resolution failures) while OpenCode 2.0.x explicitly mandated `bun@^1.4.2`. An earlier unslotted upgrade to Bun 1.4 broke v1 without warning.
- Solution: Portage slotting provides definitive isolation at the system package level.

## §3 Plan Deviations

- Task 1.1 & 1.2: Added `PDEPEND="app-eselect/eselect-bun"` and `eselect bun update ifunset` hooks to ensure symlinks remain valid automatically upon install and removal.

## §4 Skill Compliance

- Skill `openspec-propose` / `openspec-apply-change`: Loaded and followed strictly according to `infra` schema.
- Skill `gentoo-ebuild`: Loaded and applied for ebuild slotting, EAPI 8 compliance, and manifest generation.
- Skill `tdd-gate` & `verification-before-completion`: Applied with concrete terminal evidence before assertions.

## §5 Surprises

- `/usr/portage` (`::gentoo`) and `gitlab-overlay` have zero dependencies on Bun (`dev-lang/bun` or `dev-lang/bun-bin`), meaning slotting Bun in `haven-overlay` carries zero external collision or breakage risk across official Gentoo packages.
- OpenCode v2 default command execution model shifted towards server/daemon architecture (`serve`, `service`, `mini`, `run`, `--standalone`) rather than immediate interactive REPL.

## §6 Promote Candidates

- Candidate: Slotted Bun toolchain pattern with hermetic eclass wrapper → Action: `mem0_add` / vault note on Gentoo eclass hermetic toolchain isolation.
