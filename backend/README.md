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

**Option 1: Using uvicorn directly**
```bash
uvicorn app.main:app --reload --port 6616
```

**Option 2: Using Python module (reads BACKEND_PORT from root .env)**
```bash
python -m app.main
```

The API will be available at http://localhost:6616

> **Note:** The port is configured in the root `.env` file as `BACKEND_PORT` (default: 6616)

## API Documentation

Once the server is running:
- Interactive API docs (Swagger UI): http://localhost:6616/docs
- Alternative API docs (ReDoc): http://localhost:6616/redoc

## Running Tests

```bash
pytest
```

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