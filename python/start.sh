#!/bin/sh
set -e
echo "PORT environment variable: ${PORT}"
echo "Starting uvicorn on port ${PORT:-8181}"
exec python -m uvicorn src.server.main:app --host 0.0.0.0 --port "${PORT:-8181}" --workers 1
