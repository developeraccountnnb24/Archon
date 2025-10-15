"""
Minimaler HTTP Health Check Wrapper für Railway.

Railway erwartet einen /health Endpoint. Da FastMCP keinen direkten Zugriff
auf die FastAPI App bietet, starten wir einen separaten Mini-Server.
"""

import asyncio
import logging
from typing import Optional

from fastapi import FastAPI
import uvicorn

logger = logging.getLogger(__name__)


class HealthCheckServer:
    """Lightweight health check server that runs alongside MCP"""

    def __init__(self, port: int = 8080):
        self.port = port
        self.app = FastAPI()
        self.server: Optional[uvicorn.Server] = None

        @self.app.get("/health")
        async def health():
            return {"status": "healthy", "service": "archon-mcp"}

        @self.app.get("/")
        async def root():
            return {"message": "Archon MCP Server", "mcp_endpoint": "/mcp"}

    async def start(self):
        """Start the health check server in background"""
        config = uvicorn.Config(
            self.app, host="0.0.0.0", port=self.port, log_level="error"
        )
        self.server = uvicorn.Server(config)

        # Run in background task
        asyncio.create_task(self.server.serve())
        logger.info(f"✓ Health check server started on port {self.port}")

    async def stop(self):
        """Stop the health check server"""
        if self.server:
            self.server.should_exit = True
            logger.info("✓ Health check server stopped")
