"""FastAPI application entry point with Socket.IO integration."""

import logging
from typing import Any

import socketio
import uvicorn
from fastapi import FastAPI, Request, Response
from fastapi.middleware.cors import CORSMiddleware

from app.config import get_settings
from app.db import get_db_client

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Load settings
settings = get_settings()

# Create FastAPI app
fastapi_app = FastAPI(
    title="K-BAAS-2 API",
    description="Knowledge Graph Wiki Tool API",
    version="0.1.0",
    debug=settings.debug,
)

# Add CORS middleware for REST endpoints
fastapi_app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
    allow_headers=["*"],
)


@fastapi_app.middleware("http")
async def add_security_headers(request: Request, call_next: Any) -> Response:
    """Add security headers to all responses."""
    response: Response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    if settings.is_production:
        response.headers["Strict-Transport-Security"] = (
            "max-age=31536000; includeSubDomains"
        )
    return response


# Create Socket.IO server with CORS enabled for frontend
sio = socketio.AsyncServer(
    async_mode="asgi",
    cors_allowed_origins=settings.cors_origins,
)

# Wrap with ASGI application (this becomes the main app)
app = socketio.ASGIApp(sio, fastapi_app)


@fastapi_app.get("/")
def read_root() -> dict[str, Any]:
    """Root endpoint."""
    try:
        db = get_db_client()
        # Simple query to check connection and get some data
        # We'll try to match any entity, limit 6
        results = db.execute_read_query(
            "match entity $entType; $ent isa $entType; limit 6;"
        )

        # Convert results to string representation for demonstration
        data = [str(r) for r in results]

        return {
            "Hello": "World",
            "socketio": "enabled",
            "typedb_status": "connected",
            "data_sample": data,
        }
    except Exception as e:
        return {
            "Hello": "World",
            "socketio": "enabled",
            "typedb_status": f"error: {e!s}",
        }


@fastapi_app.get("/health")
def health_check() -> dict[str, str]:
    """Health check endpoint."""
    return {"status": "healthy"}


# Socket.IO event handlers
@sio.event
async def connect(sid: str, _environ: dict[str, Any]) -> None:
    """Handle client connection."""
    logger.debug("Client connected: %s", sid)
    await sio.emit("message", {"data": "Connected to server!"}, room=sid)


@sio.event
async def disconnect(sid: str) -> None:
    """Handle client disconnection."""
    logger.debug("Client disconnected: %s", sid)


@sio.event
async def message(sid: str, data: dict[str, Any]) -> None:
    """Handle incoming message from client and broadcast to all."""
    logger.debug("Message from %s: %s", sid, data)
    # Broadcast to all connected clients
    await sio.emit(
        "message", {"data": data.get("data", ""), "from": sid[:8]}, room=None
    )


@sio.event
async def ping(sid: str) -> None:
    """Handle ping from client."""
    logger.debug("Ping from %s", sid)
    await sio.emit("pong", {"timestamp": "server_timestamp"}, room=sid)


if __name__ == "__main__":
    uvicorn.run(app, host=settings.backend_host, port=settings.backend_port)
