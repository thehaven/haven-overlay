"""Regression tests for package masking in haven-overlay.

Guards against over-broad package masks (e.g. unbounded `>=` masks on security
incidents where only a specific compromised release should be masked).
"""

from dataclasses import dataclass
from pathlib import Path
import re
import pytest

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
PACKAGE_MASK_PATH = OVERLAY_ROOT / "profiles" / "package.mask"


@dataclass
class MaskEntry:
    atom: str
    comments: list[str]
    line_number: int

    @property
    def is_security(self) -> bool:
        return any(
            re.search(r"#\s*SECURITY:", c, re.IGNORECASE) for c in self.comments
        )

    @property
    def allows_open_ended(self) -> bool:
        return any("ALLOW_OPEN_ENDED_MASK" in c for c in self.comments)

    @property
    def is_unbounded_gte(self) -> bool:
        return self.atom.startswith(">=")


def parse_package_mask(mask_path: Path) -> list[MaskEntry]:
    """Parse profiles/package.mask associating preceding comments with mask atoms."""
    entries: list[MaskEntry] = []
    current_comments: list[str] = []

    for idx, raw_line in enumerate(mask_path.read_text().splitlines(), start=1):
        line = raw_line.strip()
        if not line:
            current_comments = []
            continue

        if line.startswith("#"):
            current_comments.append(line)
            continue

        # Non-comment line containing a package atom, possibly with inline comment
        atom_part, _, inline_comment = line.partition("#")
        atom = atom_part.strip()
        comments = list(current_comments)
        if inline_comment:
            comments.append(f"# {inline_comment.strip()}")

        if atom:
            entries.append(
                MaskEntry(
                    atom=atom,
                    comments=comments,
                    line_number=idx,
                )
            )

    return entries


def _vsplit(ver: str) -> list[int | str]:
    """Split version string into integer and string components for comparison."""
    # Split by standard separators
    tokens = re.split(r"([0-9]+|[a-zA-Z]+)", ver)
    parts: list[int | str] = []
    for t in tokens:
        if not t or t in ".-_":
            continue
        if t.isdigit():
            parts.append(int(t))
        else:
            parts.append(t)
    return parts


def _ver_compare(v1: str, v2: str) -> int:
    """Compare two version strings. Returns -1, 0, or 1."""
    try:
        from portage.versions import vercmp
        res = vercmp(v1, v2)
        if res is not None:
            return res
    except Exception:
        pass

    p1, p2 = _vsplit(v1), _vsplit(v2)
    for c1, c2 in zip(p1, p2):
        if isinstance(c1, int) and isinstance(c2, int):
            if c1 != c2:
                return 1 if c1 > c2 else -1
        else:
            s1, s2 = str(c1), str(c2)
            if s1 != s2:
                return 1 if s1 > s2 else -1
    if len(p1) != len(p2):
        return 1 if len(p1) > len(p2) else -1
    return 0


def atom_matches(atom: str, category_pkg: str, version: str) -> bool:
    """Check if a Gentoo package atom matches the given category/package and version."""
    m = re.match(
        r"^(?P<op>>=|<=|>|<|=|~)?(?P<cp>[a-zA-Z0-9+_.-]+/[a-zA-Z0-9+_.-]+?)(?:-(?P<ver>[0-9].*?))?(?P<star>\*)?$",
        atom,
    )
    if not m:
        return atom == category_pkg

    op = m.group("op") or ""
    cp = m.group("cp")
    atom_ver = m.group("ver")
    star = bool(m.group("star"))

    if cp != category_pkg:
        return False

    if not atom_ver:
        return True

    cmp = _ver_compare(version, atom_ver)

    if op == "=":
        if star:
            return version.startswith(atom_ver)
        return cmp == 0
    elif op == ">=":
        return cmp >= 0
    elif op == ">":
        return cmp > 0
    elif op == "<=":
        return cmp <= 0
    elif op == "<":
        return cmp < 0
    elif op == "~":
        v_base = version.split("-r")[0]
        a_base = atom_ver.split("-r")[0]
        return _ver_compare(v_base, a_base) == 0

    return cmp == 0


def test_litellm_mask_exact_version() -> None:
    """profiles/package.mask must mask =dev-python/litellm-1.107.0 and NOT >=dev-python/litellm-1.107.0."""
    entries = parse_package_mask(PACKAGE_MASK_PATH)
    litellm_entries = [e for e in entries if "dev-python/litellm" in e.atom]

    assert litellm_entries, "dev-python/litellm must be masked in profiles/package.mask"

    litellm_atoms = [e.atom for e in litellm_entries]

    assert ">=dev-python/litellm-1.107.0" not in litellm_atoms, (
        "Found unbounded '>=dev-python/litellm-1.107.0' in profiles/package.mask; "
        "only the compromised release '=dev-python/litellm-1.107.0' should be masked."
    )

    assert "=dev-python/litellm-1.107.0" in litellm_atoms, (
        "Expected '=dev-python/litellm-1.107.0' in profiles/package.mask"
    )

    for entry in litellm_entries:
        assert not entry.is_unbounded_gte, (
            f"Line {entry.line_number}: litellm mask '{entry.atom}' must not use unbounded '>='"
        )


@pytest.mark.parametrize(
    "version",
    [
        "1.106.5",
        "1.107.1",
        "1.108.0",
        "1.109.0-dev.1",
    ],
)
def test_litellm_mask_does_not_match_other_versions(version: str) -> None:
    """Versions like 1.106.5, 1.107.1, 1.108.0, and 1.109.0-dev.1 must NOT be matched."""
    entries = parse_package_mask(PACKAGE_MASK_PATH)
    litellm_entries = [e for e in entries if "dev-python/litellm" in e.atom]

    matching_atoms = [
        e.atom
        for e in litellm_entries
        if atom_matches(e.atom, "dev-python/litellm", version)
    ]
    assert not matching_atoms, (
        f"dev-python/litellm-{version} should NOT be masked, but was matched by: {matching_atoms}"
    )


def test_litellm_compromised_version_is_matched() -> None:
    """Version 1.107.0 (compromised supply-chain release) must be matched by the litellm mask."""
    entries = parse_package_mask(PACKAGE_MASK_PATH)
    litellm_entries = [e for e in entries if "dev-python/litellm" in e.atom]

    assert any(
        atom_matches(e.atom, "dev-python/litellm", "1.107.0") for e in litellm_entries
    ), "dev-python/litellm-1.107.0 must be matched by the mask in profiles/package.mask"


def test_security_entries_no_unbounded_gte() -> None:
    """Any entry marked with '# SECURITY:' must not use unbounded '>=' without ALLOW_OPEN_ENDED_MASK."""
    entries = parse_package_mask(PACKAGE_MASK_PATH)
    violations: list[str] = []

    for entry in entries:
        if entry.is_security and entry.is_unbounded_gte and not entry.allows_open_ended:
            violations.append(
                f"Line {entry.line_number}: '{entry.atom}' uses unbounded '>=' under "
                f"# SECURITY: without explicit '# ALLOW_OPEN_ENDED_MASK' annotation"
            )

    assert not violations, (
        "Security mask entries must not use open-ended '>=' without explicit annotation:\n"
        + "\n".join(violations)
    )
