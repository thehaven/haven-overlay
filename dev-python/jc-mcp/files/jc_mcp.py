"""MCP server wrapping jc for structured CLI output parsing."""

import subprocess
import shlex

import jc
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("jc")


@mcp.tool()
def run_command(command: str, parser: str) -> dict:
    """
    Run a shell command and parse its output into JSON using jc.

    Args:
        command: The shell command to run (e.g., "ls -l", "ifconfig", "ps aux").
        parser: The jc parser to use (e.g., "ls", "ifconfig", "ps").
    """
    try:
        result = subprocess.check_output(
            shlex.split(command), stderr=subprocess.STDOUT
        ).decode()
        return jc.parse(parser, result)
    except subprocess.CalledProcessError as e:
        return {"error": f"Command failed: {e.output.decode()}"}
    except Exception as e:
        return {"error": str(e)}


@mcp.tool()
def list_parsers() -> list:
    """List all available jc parsers."""
    return jc.parser_mod_list()


def main():
    mcp.run()


if __name__ == "__main__":
    main()
