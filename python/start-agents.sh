#!/bin/sh
set -e
echo "PORT environment variable: ${PORT}"
export ARCHON_AGENTS_PORT="${PORT:-8052}"
echo "Starting Agents service on port ${ARCHON_AGENTS_PORT}"
exec python -m uvicorn src.agents.server:app --host 0.0.0.0 --port "${ARCHON_AGENTS_PORT}" --workers 1
