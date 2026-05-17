# Haven Overlay — AI Assistant Guide

This overlay contains personal and work projects for Haven (Simon Alman).

## Maintenance Standards

### 1. Keyword Policy
- Live ebuilds (`9999`) MUST have empty `KEYWORDS=""`.
- Released ebuilds SHOULD have `KEYWORDS="~amd64"`.
- Use `unmask_9999` script to generate `package.accept_keywords` entries.

### 2. Python Compatibility
- Standard: `PYTHON_COMPAT=( python3_{11..14} )`.
- Ensure `DISTUTILS_USE_PEP517` matches `pyproject.toml`.
- For Rust extensions, use `inherit cargo distutils-r1` and provide `CRATES`.

### 3. GitLab Integration
- Internal repositories are hosted at `https://gitlab-ee.thehavennet.org.uk`.
- For ebuild fetch to work without credentials, repositories must be set to **Public** visibility.

### 4. Verification Protocol
- After installing or updating any MCP server, run the systemic verification script:
  `sudo /var/db/repos/haven-overlay/scripts/verify-mcp.sh`
- All packaged binaries MUST pass the import check.
- Never commit an ebuild that results in a `ModuleNotFoundError` during verification.

## Stack Overview

### AI ML Stack
- `app-misc/ai-compressor`: Context compression agent.
- `dev-python/tiktoken`: BPE tokeniser (Rust/Python).
- `dev-python/mcp`: Model Context Protocol.

### Container & Cloud Native
- `app-admin/harbor`: Meta-package for Harbor registry.
- `app-admin/argo-*`: Full Argo CLI suite (CD, Workflows, Rollouts, Events).

## Known Blockers
- **Harbor**: requires Swagger code generation which is currently container-only upstream.
