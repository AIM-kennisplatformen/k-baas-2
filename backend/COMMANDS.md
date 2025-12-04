# Backend Commands Reference

Since uv doesn't support `[tool.uv.scripts]` in pyproject.toml, use these direct commands instead:

## Development Commands

```bash
# Start server on port 6616 with auto-reload
uv run uvicorn app.main:app --reload --port 6616

# Start server with default settings (port 8000)
uv run uvicorn app.main:app --reload

# Run tests
uv run pytest

# Linting
uv run ruff check .

# Linting with auto-fix
uv run ruff check --fix .

# Format code
uv run ruff format .

# Check formatting (without applying)
uv run ruff format --check .

# Type checking
uv run mypy .

# Run all checks (lint + format + typecheck)
uv run ruff check . && uv run ruff format --check . && uv run mypy .
```

## Package Management

```bash
# Install all dependencies
uv sync

# Add a new dependency
uv add package-name

# Add a development dependency
uv add --dev package-name

# Update dependencies
uv lock --upgrade