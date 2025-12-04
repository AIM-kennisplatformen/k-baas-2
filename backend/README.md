# Backend

FastAPI backend for the K-BAAS-2 Knowledge Graph Wiki Tool.

## Setup

1. Make sure you have Python 3.13+ installed
2. Install dependencies using uv:
   ```bash
   cd backend
   uv sync
   ```

## Running the Development Server

**Recommended: Using uv scripts**
```bash
uv run dev         # Start dev server with auto-reload
uv run start       # Start on port 6616 (configured)
```

**Alternative: Using uvicorn directly**
```bash
uvicorn app.main:app --reload --port 6616
```

**Alternative: Using Python module (reads BACKEND_PORT from root .env)**
```bash
python -m app.main
```

The API will be available at http://localhost:6616

> **Note:** The port is configured in the root `.env` file as `BACKEND_PORT` (default: 6616)

## API Documentation

Once the server is running:
- Interactive API docs (Swagger UI): http://localhost:6616/docs
- Alternative API docs (ReDoc): http://localhost:6616/redoc

## Development Scripts

All scripts are configured in [`pyproject.toml`](pyproject.toml) and run via `uv run`:

### Running the App
```bash
uv run dev           # Start dev server with auto-reload
uv run start         # Start on configured port (6616)
```

### Testing
```bash
uv run test          # Run all tests with pytest
pytest -v            # Run with verbose output (configured by default)
pytest -m unit       # Run only unit tests
pytest -m integration # Run only integration tests
pytest -m "not slow" # Skip slow tests
```

### Code Quality
```bash
uv run lint          # Check for linting issues
uv run lint-fix      # Auto-fix linting issues
uv run format        # Format code with ruff
uv run format-check  # Check formatting without changes
uv run typecheck     # Run mypy type checking
uv run check         # Run all checks (lint + format + types)
```

## Code Quality & Formatting

This project uses [Ruff](https://github.com/astral-sh/ruff) for linting and formatting, and [mypy](https://mypy.readthedocs.io/) for static type checking.

### Using Ruff

**Check for linting issues:**
```bash
ruff check .
```

**Auto-fix linting issues:**
```bash
ruff check --fix .
```

**Format code:**
```bash
ruff format .
```

**Check formatting without changes:**
```bash
ruff format --check .
```

**Run both linting and formatting:**
```bash
ruff check --fix . && ruff format .
```

### Type Checking with mypy

**Check types:**
```bash
mypy .
```

**Check specific file or directory:**
```bash
mypy app/
```

### Configuration

**Ruff:**

Ruff is configured with:
- **Line length**: 88 characters (Black-compatible)
- **Target version**: Python 3.13
- **Style**: Black-compatible formatting with Google docstring convention
- **Rules**: PEP 8, pyflakes, isort, and many flake8 plugins

**mypy:**
- **Python version**: 3.13
- **Strictness**: Requires type hints on function definitions
- **Error reporting**: Shows error codes and column numbers
- See [`pyproject.toml`](pyproject.toml:113-145) for complete configuration

For detailed development guidelines, see [`DEVELOPMENT.md`](DEVELOPMENT.md).

## Project Structure

```
backend/
├── app/               # Application code
│   ├── __init__.py
│   └── main.py       # FastAPI app entry point
├── tests/            # Test files
│   ├── __init__.py
│   └── test_main.py
├── pyproject.toml    # Project dependencies
└── README.md         # This file