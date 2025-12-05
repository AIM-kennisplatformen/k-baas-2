"""Application configuration using Pydantic BaseSettings.

This module provides centralized configuration management for the backend application.
Settings are loaded from environment variables with sensible defaults for development.

Environment Variable Sources (in order of precedence):
1. Host environment variables (highest priority)
2. Docker Compose `environment:` section
3. Docker Compose `env_file:` (.env file)
4. Default values in this file (lowest priority)

Docker Compatibility:
- TYPEDB_HOST defaults to "127.0.0.1" for local development
- In Docker, set TYPEDB_HOST=typedb to use container hostname
- Authentik settings support both internal (container) and external (browser) URLs
"""

import logging
import warnings
from enum import Enum
from functools import lru_cache
from pathlib import Path

from pydantic import Field, field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

logger = logging.getLogger(__name__)

# Default values that should never be used in production
_INSECURE_DEFAULT_PASSWORDS = frozenset({"password123", "password", "admin", "secret"})
_INSECURE_DEFAULT_JWT_SECRET = "dev-secret-key-change-in-production"


class Environment(str, Enum):
    """Application environment enumeration."""

    DEVELOPMENT = "development"
    TESTING = "testing"
    PRODUCTION = "production"


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    Settings are loaded from:
    1. Environment variables (including Docker Compose environment)
    2. .env file in project root (development)

    All settings have sensible defaults for local development.
    In Docker, environment variables from docker-compose.yml override these defaults.
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
        alias="FRONTEND_URL",
        description="Frontend URL for CORS configuration",
    )

    # TypeDB settings
    # Note: In Docker, TYPEDB_HOST should be set to "typedb" (container hostname)
    # For local development outside Docker, use "127.0.0.1"
    typedb_host: str = Field(
        default="127.0.0.1",
        alias="TYPEDB_HOST",
        description="TypeDB server host (use 'typedb' in Docker, '127.0.0.1' locally)",
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

    # Authentik OAuth2/OIDC settings
    # These enable integration with Authentik identity provider
    authentik_url: str = Field(
        default="http://localhost:9000",
        alias="AUTHENTIK_URL",
        description="Authentik server URL (internal Docker URL or external URL)",
    )
    authentik_client_id: str = Field(
        default="",
        alias="AUTHENTIK_CLIENT_ID",
        description="OAuth2 client ID from Authentik",
    )
    authentik_client_secret: str = Field(
        default="",
        alias="AUTHENTIK_CLIENT_SECRET",
        description="OAuth2 client secret from Authentik",
    )
    authentik_issuer: str = Field(
        default="http://localhost:9000/application/o/k-baas-2/",
        alias="AUTHENTIK_ISSUER",
        description="OIDC issuer URL for token validation",
    )
    authentik_app_slug: str = Field(
        default="k-baas-2",
        alias="AUTHENTIK_APP_SLUG",
        description="Application slug in Authentik",
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

    @model_validator(mode="after")
    def validate_production_security(self) -> "Settings":
        """Validate that insecure defaults are not used in production.

        In production mode, using default passwords or secrets will cause
        the application to fail startup to prevent security vulnerabilities.
        In development/testing, warnings are logged instead.
        """
        insecure_settings: list[str] = []

        # Check TypeDB passwords
        if self.typedb_admin_password in _INSECURE_DEFAULT_PASSWORDS:
            insecure_settings.append(
                f"TYPEDB_ADMIN_PASSWORD (current: '{self.typedb_admin_password}')"
            )
        if self.typedb_user_password in _INSECURE_DEFAULT_PASSWORDS:
            insecure_settings.append(
                f"TYPEDB_USER_PASSWORD (current: '{self.typedb_user_password}')"
            )

        # Check JWT secret
        if self.jwt_secret_key == _INSECURE_DEFAULT_JWT_SECRET:
            insecure_settings.append("JWT_SECRET_KEY (using development default)")

        if insecure_settings:
            message = (
                "Insecure default values detected for the following settings:\n"
                + "\n".join(f"  - {s}" for s in insecure_settings)
            )

            if self.environment == Environment.PRODUCTION:
                # In production, fail startup to prevent security vulnerabilities
                raise ValueError(
                    f"SECURITY ERROR: {message}\n\n"
                    "Production deployments MUST use secure, unique values. "
                    "Set these environment variables in your deployment platform "
                    "(e.g., Dokploy, Portainer) or in .env.production.\n\n"
                    "Generate secure values with: openssl rand -base64 32"
                )
            else:
                # In development/testing, log a warning
                warnings.warn(
                    f"SECURITY WARNING: {message}\n"
                    "This is acceptable for development but MUST be changed for production.",
                    UserWarning,
                    stacklevel=2,
                )
                logger.warning(
                    "Insecure default values in use: %s. "
                    "Ensure these are changed before deploying to production.",
                    ", ".join(insecure_settings),
                )

        return self

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
    def authentik_jwks_url(self) -> str:
        """Get the JWKS URL for Authentik token validation."""
        return f"{self.authentik_url}/application/o/{self.authentik_app_slug}/jwks/"

    @property
    def authentik_openid_config_url(self) -> str:
        """Get the OpenID Connect discovery URL."""
        return f"{self.authentik_url}/application/o/{self.authentik_app_slug}/.well-known/openid-configuration"

    @property
    def is_authentik_configured(self) -> bool:
        """Check if Authentik is properly configured."""
        return bool(self.authentik_client_id and self.authentik_client_secret)

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
