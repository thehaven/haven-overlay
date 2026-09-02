"""Regression test: PEP517 backend drift audit returns zero mismatches post-fix.

The 2026-09-02 audit found 47 DISTUTILS_USE_PEP517 mismatches across 11
dev-python packages in haven-overlay (face, stripe, b2sdk, copier,
httpx-retries, langfuse, litellm, pagerduty, phx-class-registry,
pyacoustid, solana). The per-package fix commits pushed 2026-09-02 are
expected to reduce the count to zero for every ebuild whose tarball is
cached locally. Tarballs that haven't been fetched yet are skipped by
the audit (no false positive).

The openspec change ``add-pep517-backend-drift-scan`` proposes to wire this
into ebuild-updater cleanup scan; this pytest is the regression guard
while the wiring lands.
"""

import json
import subprocess
import sys
from pathlib import Path

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
SCRIPT = OVERLAY_ROOT / "scripts" / "audit_pep517_backend_drift.py"


def test_audit_runs_clean_after_fixes():
    """After the 11 fix commits, the audit must report MISMATCHES: 0."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--overlay", str(OVERLAY_ROOT), "--quiet"],
        capture_output=True, text=True, timeout=300,
    )
    assert result.returncode == 0, (
        f"audit reports {result.returncode} mismatches; "
        f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}"
    )


def test_audit_json_shape():
    """JSON output must contain the documented keys for downstream tooling."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--overlay", str(OVERLAY_ROOT),
         "--json", "--quiet"],
        capture_output=True, text=True, timeout=300,
    )
    payload = json.loads(result.stdout)
    for key in ("ebuilds_scanned", "pyproject_found", "mismatches", "skipped"):
        assert key in payload, f"missing key {key!r} in audit JSON"
    assert isinstance(payload["mismatches"], list)
    assert isinstance(payload["skipped"], list)
    if payload["mismatches"]:
        sample = payload["mismatches"][0]
        for key in ("ebuild", "tarball", "member", "upstream_backend",
                    "ebuild_pep517", "should_be"):
            assert key in sample, f"mismatch missing key {key!r}"
