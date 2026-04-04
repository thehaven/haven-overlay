# Specification: Claude Code Overlay Ebuild with "Unlocked" Mode

## 1. Story & Context
Anthropic's `claude-code` CLI tool was inadvertently leaked via sourcemaps. Analysis of this leak revealed several internal, undocumented environment variables (e.g., "God Mode" via `USER_TYPE='ant'`, disabling telemetry, and optimizing for terminal multiplexers like tmux).

The goal is to create a custom Gentoo ebuild in the `haven-overlay` that provides the standard `claude-code` binary but adds an optional `unlocked` USE flag. When this flag is enabled, the ebuild will generate a specialized wrapper script (`/usr/bin/claude`) that automatically injects these powerful internal variables, providing an enhanced, telemetry-free, and highly optimized developer experience.

## 2. Uncertainty Matrix

| # | Category  | Question                                    | Status   | Resolution          |
|---|-----------|---------------------------------------------|----------|---------------------|
| 1 | Technical | How do we apply the environment variables?   | RESOLVED | Generate a bash wrapper script in `/usr/bin/claude` instead of a direct symlink. |
| 2 | Domain    | What specific variables should be unlocked? | RESOLVED | `USER_TYPE='ant'`, `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY='1'`, `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS='1'`, `CLAUDE_CODE_DISABLE_VIRTUAL_SCROLL='1'`. |
| 3 | Upstream  | Will this break standard functionality?     | RESOLVED | No, the core `cli.js` remains unmodified. The wrapper simply sets the environment prior to execution. |

## 3. Brownfield Change Matrix

| Touchpoint          | Type     | Risk Level | Existing Tests | Implicit Contract              |
|---------------------|----------|------------|----------------|--------------------------------|
| `haven-overlay`      | New      | LOW        | N/A            | Ebuilds must pass `pkgcheck`.  |
| `/usr/bin/claude`    | Modified | LOW        | N/A            | Must correctly pass `"$@"` to the underlying Node.js script. |

## 4. Rules, Examples, and Decision Tables

**Rule 1: Wrapper Script Generation based on USE flag**
The ebuild must check for the `unlocked` USE flag during the `src_install` phase.

**Examples:**
| # | USE flag state | Expected Result |
|---|----------------|-----------------|
| 1 | `USE="-unlocked"` | `/usr/bin/claude` is a standard symlink to `/opt/claude-code/cli.js`. |
| 2 | `USE="unlocked"`  | `/usr/bin/claude` is a bash script exporting `USER_TYPE="ant"` and executing `/opt/claude-code/cli.js`. |

## 5. Invariants and Properties

1. **Dependency Integrity**: The package must always depend on `>=net-libs/nodejs-18` and `sys-apps/ripgrep` regardless of the USE flag.
2. **License Compliance**: The package must retain the `all-rights-reserved` license and the `RESTRICT="bindist strip"` constraints from the official ebuild.
3. **Argument Passing**: The wrapper script MUST pass all command-line arguments perfectly to the underlying CLI (`"$@"`).

## 6. Architectural Constraints and Anti-Constraints

- **Constraint**: Use the `SRC_URI` pointing to the official NPM registry tarball (`https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${PV}.tgz`).
- **Constraint**: Do not attempt to build the package from the leaked source code; rely on the official compiled distribution.
- **Anti-Constraint**: Do NOT modify the `cli.js` file directly using `sed` or `patch`. All behavioral modifications must be achieved purely through environment variable injection in the wrapper script.

## 7. Test List

### Smoke Tests
- [ ] `ebuild manifest` succeeds without errors.
- [ ] `ebuild clean install` succeeds without sandbox violations.
- [ ] Wrapper script `/usr/bin/claude` is executable and contains the correct exported variables when `USE="unlocked"` is set.

## 8. Adversarial Quality Gate

| #  | Check                                              | Status |
|----|----------------------------------------------------|--------|
| 1  | Any uncertainty matrix row is BLOCKED               | ✅     |
| 2  | Any decision table cell is blank or contains "TBD"  | ✅     |
| 3  | Any rule has fewer than 2 concrete examples          | ✅     |
| 4  | Spec contains vague adjectives without metrics       | ✅     |
| 5  | No negative examples exist (only happy path)         | ✅     |
| 6  | Brownfield change matrix is missing for non-greenfield| ✅     |
| 7  | No architectural constraints specified               | ✅     |
| 8  | No test list generated                               | ✅     |
| 9  | No invariants/properties identified                  | ✅     |
| 10 | Spec uses "should handle errors" without specifying how | ✅     |
