"""Application configuration using Pydantic BaseSettings.

This module provides centralized configuration management for the backend application.
Settings are loaded from environment variables with sensible defaults for development.
"""

from enum import Enum
from functools import lru_cache
from pathlib import Path

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Environment(str, Enum):
    """Application environment enumeration."""

    DEVELOPMENT = "development"
    TESTING = "testing"
    PRODUCTION = "production"


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    Settings are loaded from:
    1. Environment variables
    2. .env file in project root (development)

    All settings have sensible defaults for local development.
    """

    model_config = SettingsConfigDict(
        env_file=Path(__file__).parent.parent.parent / ".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # Application settings
    environment: Environment = Field(
        default=Environment.DEVELOPMENT,
        alias="APP_ENV",
        description="Application environment (development, testing, production)",
    )
    debug: bool = Field(
        default=True,
        alias="DEBUG",
        description="Enable debug mode",
    )

    # Server settings
    backend_port: int = Field(
        default=6616,
        alias="BACKEND_PORT",
        description="Port for the backend server",
        ge=1,
        le=65535,
    )
    backend_host: str = Field(
        default="0.0.0.0",
        alias="BACKEND_HOST",
        description="Host for the backend server",
    )

    # Frontend settings (for CORS)
    frontend_port: int = Field(
        default=6166,
        alias="FRONTEND_PORT",
        description="Port for the frontend dev server",
        ge=1,
        le=65535,
    )
    frontend_url: str = Field(
        default="http://localhost:6166",
        alias="VITE_BACKEND_URL",
        description="Frontend URL for CORS",
    )

    # TypeDB settings
    typedb_host: str = Field(
        default="127.0.0.1",
        alias="TYPEDB_HOST",
        description="TypeDB server host",
    )
    typedb_port: int = Field(
        default=1729,
        alias="TYPEDB_PORT",
        description="TypeDB server port",
        ge=1,
        le=65535,
    )
    typedb_database_name: str = Field(
        default="kennisbaas",
        alias="TYPEDB_DATABASE_NAME",
        description="TypeDB database name",
    )
    typedb_admin_password: str = Field(
        default="password123",
        alias="TYPEDB_ADMIN_PASSWORD",
        description="TypeDB admin password",
    )
    typedb_user_name: str = Field(
        default="admin",
        alias="TYPEDB_USER_NAME",
        description="TypeDB username",
    )
    typedb_user_password: str = Field(
        default="password123",
        alias="TYPEDB_USER_PASSWORD",
        description="TypeDB user password",
    )
    typedb_tls_enabled: bool = Field(
        default=False,
        alias="TYPEDB_TLS_ENABLED",
        description="Enable TLS for TypeDB connection",
    )

    # API Keys (optional)
    openai_api_key: str | None = Field(
        default=None,
        alias="OPENAI_API_KEY",
        description="OpenAI API key for AI features",
    )
    jwt_secret_key: str = Field(
        default="dev-secret-key-change-in-production",
        alias="JWT_SECRET_KEY",
        description="Secret key for JWT token signing",
    )

    @field_validator("environment", mode="before")
    @classmethod
    def validate_environment(cls, v: str | Environment) -> Environment:
        """Validate and convert environment string to enum."""
        if isinstance(v, Environment):
            return v
        try:
            return Environment(v.lower())
        except ValueError:
            return Environment.DEVELOPMENT

    @property
    def typedb_address(self) -> str:
        """Get the full TypeDB address."""
        return f"{self.typedb_host}:{self.typedb_port}"

    @property
    def cors_origins(self) -> list[str]:
        """Get allowed CORS origins based on environment."""
        origins = [
            f"http://localhost:{self.frontend_port}",
            "http://localhost:5173",  # Vite default
            "http://localhost:3000",  # Common alternative
        ]
        if self.environment == Environment.DEVELOPMENT:
            origins.append("http://127.0.0.1:*")
        return origins

    @property
    def is_production(self) -> bool:
        """Check if running in production environment."""
        return self.environment == Environment.PRODUCTION

    @property
    def is_development(self) -> bool:
        """Check if running in development environment."""
        return self.environment == Environment.DEVELOPMENT

    @property
    def is_testing(self) -> bool:
        """Check if running in testing environment."""
        return self.environment == Environment.TESTING


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance.

    Uses lru_cache to ensure settings are only loaded once.
    Call get_settings.cache_clear() to reload settings.
    """
    return Settings()
