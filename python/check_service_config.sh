#!/bin/bash
# Railway doesn't have a direct CLI command to view/set builder config
# We need to use the Railway dashboard or create separate configurations

# Option 1: Remove railway.toml and configure each service via dashboard
# Option 2: Use separate root directories for each service
# Option 3: Use Railway API to configure services programmatically

echo "Current railway.toml configuration:"
cat railway.toml

echo ""
echo "Backend service needs:"
echo "  - Builder: DOCKERFILE"
echo "  - Dockerfile: Dockerfile.server"
echo ""
echo "MCP service needs:"
echo "  - Builder: DOCKERFILE"  
echo "  - Dockerfile: Dockerfile.mcp"
