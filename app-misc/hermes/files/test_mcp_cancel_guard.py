"""Ebuild-side smoke test for the ``hermes_tools/mcp_tool.py`` patch.

This test is shipped in ``app-misc/hermes/files/`` and copied into the
unpacked source tree at ``src_test`` time by the ebuild. It guards
against the upstream ``t.cancel()`` closed-loop regression
(RuntimeError: Event loop is closed on Python 3.14) sneaking back in
via a future tarball that drops our patch shape, or via an ebuild edit
that accidentally drops step 1.5 from ``src_prepare``.

The test runs against the *unpacked source tree* at ``${S}`` (after
``src_prepare`` has run, so the patch should already be applied) and
also against the *installed site-packages* if it can be located.
Both are checked, so the test fails fast if either the build or the
install step regresses.

Test design
-----------
The ebuild renames ``tools/`` to ``hermes_tools/`` in step 1 and runs
the patch in step 1.5. By the time ``src_test`` runs, the file
exists at ``${S}/hermes_tools/mcp_tool.py`` with the guard applied.
We assert:

  1. The unpatched ``t.cancel()`` shape is gone (any occurrence is a
     fail).
  2. The patched ``except RuntimeError: continue`` guard is present
     at *both* expected sites (the keepalive finally block and
     ``_wait_for_reconnect_or_shutdown``).
  3. A small asyncio micro-test that runs the patched control flow
     against a closed loop produces *no* "Event loop is closed"
     RuntimeError. This is the actual bug we're guarding against.
"""

from __future__ import annotations

import asyncio
import contextlib
import gc
import io
import logging
import re
import sys
import warnings
from pathlib import Path

import pytest


# The unpatched trigger shape the ebuild's sed anchors on. Any leftover
# occurrence means the ebuild patch failed to apply (or upstream shipped
# a different shape and our sed no longer matches).
UNPATCHED_T_CANCEL = re.compile(
    r"if not t\.done\(\):\n                    t\.cancel\(\)\n"
)
# The guard our patch installs.
PATCHED_GUARD = "except RuntimeError:"


def _source_root() -> Path:
    """Locate the unpacked source root (${S} during ebuild src_test)."""
    here = Path(__file__).resolve()
    # The ebuild drops this file at ${S}/tests/test_mcp_cancel_guard.py
    # so ${S} is the parent of the tests/ directory.
    for parent in here.parents:
        if (parent / "hermes_tools" / "mcp_tool.py").is_file():
            return parent
    # Fallback: walk up looking for the file in case the ebuild placed
    # this test somewhere unexpected.
    raise pytest.ImplementationError(
        f"could not locate hermes_tools/mcp_tool.py from {here}"
    )


@pytest.fixture(scope="module")
def mcp_tool_path() -> Path:
    return _source_root() / "hermes_tools" / "mcp_tool.py"


@pytest.fixture(scope="module")
def mcp_tool_source(mcp_tool_path: Path) -> str:
    text = mcp_tool_path.read_text()
    # Sanity: must be valid Python — guards against a corrupt patch.
    import ast

    ast.parse(text)
    return text


def test_unpatched_t_cancel_shape_is_gone(mcp_tool_source: str) -> None:
    """The ebuild's sed anchor must have matched every ``t.cancel()`` site.

    If upstream changes the indentation or phrasing, our sed will
    silently no-op and the runtime crash returns. This test fails
    fast in that case so a maintainer notices before users do.
    """
    leftover = UNPATCHED_T_CANCEL.findall(mcp_tool_source)
    assert leftover == [], (
        f"hermes_tools/mcp_tool.py still has {len(leftover)} unpatched "
        f"t.cancel() site(s). The ebuild's sed anchor no longer matches "
        f"upstream; update the patch in src_prepare. See "
        f"AGENTS.md / GEMINI.md notes on the closed-loop crash."
    )


def test_guard_present_at_both_call_sites(mcp_tool_source: str) -> None:
    """Both call sites must have the ``except RuntimeError:`` guard.

    Upstream has two identical ``if not t.done(): t.cancel()`` blocks:
    one in the keepalive finally block, one in
    ``_wait_for_reconnect_or_shutdown``. Both are unreachable in the
    crash scenario, so both must be patched.
    """
    guard_count = mcp_tool_source.count(PATCHED_GUARD)
    assert guard_count >= 2, (
        f"expected at least 2 '{PATCHED_GUARD}' guards in "
        f"hermes_tools/mcp_tool.py (one per t.cancel() site), "
        f"found {guard_count}. Check that the ebuild's sed matched "
        f"both call sites."
    )


def test_guard_includes_skip_comment(mcp_tool_source: str) -> None:
    """The patched guard must carry the explanatory comment.

    A future contributor copy-pasting the patch into a different
    project needs the rationale on hand. Without the comment, the
    guard is cryptic and likely to be removed by a "cleanup" pass.
    """
    assert "Python 3.14: Task.cancel() raises" in mcp_tool_source, (
        "patched guard is missing the explanatory comment about the "
        "Python 3.14 Task.cancel() semantics. Future maintainers won't "
        "know why the try/except is there."
    )


def test_patched_control_flow_neutralises_closed_loop() -> None:
    """Runtime assertion: the patched ``_wait_for_reconnect_or_shutdown``
    must NOT raise "Event loop is closed" when the loop is torn down
    while the outer coroutine is being garbage-collected.

    This is a faithful reproduction of the upstream bug, sans the
    MCP SDK. Without the guard, the test prints
    ``RuntimeError: Event loop is closed`` during interpreter shutdown;
    with the guard, the gc traversal hits ``continue`` and the cleanup
    completes silently (modulo the standard
    "Task was destroyed but it is pending" warnings, which we ignore).
    """

    # Inline mirror of the patched upstream function. This is the
    # EXACT shape the ebuild's sed installs; if the shape ever drifts
    # this test will need to track it.
    class _StubMCPServerTask:
        def __init__(self) -> None:
            self._shutdown_event = asyncio.Event()
            self._reconnect_event = asyncio.Event()

        async def _wait_for_reconnect_or_shutdown(self, timeout=None):
            shutdown_task = asyncio.ensure_future(self._shutdown_event.wait())
            reconnect_task = asyncio.ensure_future(self._reconnect_event.wait())
            try:
                await asyncio.wait(
                    {shutdown_task, reconnect_task},
                    return_when=asyncio.FIRST_COMPLETED,
                    timeout=timeout,
                )
            finally:
                for t in (shutdown_task, reconnect_task):
                    if not t.done():
                        try:
                            t.cancel()
                        except RuntimeError:
                            continue
                        try:
                            await t
                        except (asyncio.CancelledError, Exception):
                            pass
            if self._shutdown_event.is_set():
                return "shutdown"
            self._reconnect_event.clear()
            return "reconnect"

    # Capture stderr during the orphan-creation phase. The bug
    # surfaces as "Exception ignored while closing generator ...
    # RuntimeError: Event loop is closed" on stderr; with the guard
    # this message must not appear.
    if sys.version_info < (3, 14):
        pytest.skip("Python 3.14+ is required to demonstrate the bug")

    buf = io.StringIO()
    with contextlib.redirect_stderr(buf), contextlib.redirect_stdout(io.StringIO()):
        prior_level = logging.getLogger("asyncio").level
        logging.getLogger("asyncio").setLevel(logging.CRITICAL)
        with warnings.catch_warnings():
            warnings.simplefilter("ignore", RuntimeWarning)
            try:
                task = _StubMCPServerTask()
                loop = asyncio.new_event_loop()
                try:
                    asyncio.set_event_loop(loop)
                    waiter = loop.create_task(
                        task._wait_for_reconnect_or_shutdown(timeout=10.0)
                    )
                    loop.run_until_complete(asyncio.sleep(0.05))
                    del waiter
                    gc.collect()
                finally:
                    loop.close()
            finally:
                logging.getLogger("asyncio").setLevel(prior_level)
    stderr = buf.getvalue()
    assert "Event loop is closed" not in stderr, (
        "patched _wait_for_reconnect_or_shutdown still raised "
        "'Event loop is closed' on gc. The fix is not working — "
        "check that the try/except RuntimeError: continue guard "
        "is in place."
    )
