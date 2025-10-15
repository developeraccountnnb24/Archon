#!/bin/sh
set -e
echo "PORT environment variable: ${PORT}"
export ARCHON_MCP_PORT="${PORT:-8051}"
echo "Starting MCP server on port ${ARCHON_MCP_PORT}"
exec python -m src.mcp_server.mcp_server --host 0.0.0.0 --port "${ARCHON_MCP_PORT}"
