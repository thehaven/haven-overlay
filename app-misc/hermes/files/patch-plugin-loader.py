#!/usr/bin/env python3
"""Patch hermes_cli/plugins.py to prefer the real hermes_plugins namespace.

The upstream loader's _load_directory_module injects a synthetic
hermes_plugins module with __path__=[] into sys.modules whenever the
real namespace package is not imported yet. That stub shadows the real
on-disk package for every later `from hermes_plugins.<x>` statement,
breaking sibling plugin imports such as browser_tool.py:168
(`from hermes_plugins.browser.browserbase.provider import ...`) whenever
a user-installed plugin (e.g. ~/.hermes/plugins/<name>/) triggers
discovery before any other code has imported the real namespace package.

Insert a try/importlib.import_module(_NS_PARENT) before the fake-
injection guard so the real package wins when importable, with a fallback
to the synthetic stub for environments where hermes_plugins is genuinely
unimportable.

Idempotent: skips insertion if the marker is already present.
"""
import sys
from pathlib import Path

MARKER = "        # Gentoo-overlay fix: prefer the real on-disk hermes_plugins\n"
ANCHOR = "        # Ensure the namespace parent package exists\n"

INSERT = (
    MARKER
    + "        # namespace package over the synthetic empty-path stub the\n"
    + "        # loader would otherwise inject. The stub shadows the real\n"
    + "        # package in sys.modules and breaks sibling imports such as\n"
    + "        # `from hermes_plugins.browser.<vendor>.provider import ...`\n"
    + "        # (browser_tool.py) whenever a user-installed plugin (e.g.\n"
    + "        # ~/.hermes/plugins/<name>/) triggers discovery before any\n"
    + "        # other code has imported the real namespace package. Falls\n"
    + "        # back to the stub if hermes_plugins is genuinely unimportable.\n"
    + "        try:\n"
    + "            importlib.import_module(_NS_PARENT)\n"
    + "        except ImportError:\n"
    + "            pass\n"
)

target = Path(sys.argv[1])
text = target.read_text()

if MARKER in text:
    print(f"already patched: {target}")
    sys.exit(0)
if ANCHOR not in text:
    sys.exit(f"anchor not found in {target}")
new = text.replace(ANCHOR, ANCHOR + INSERT, 1)
target.write_text(new)
print(f"patched: {target}")
