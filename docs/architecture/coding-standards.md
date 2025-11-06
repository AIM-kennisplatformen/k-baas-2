# Coding Standards

This document outlines the coding standards and style guidelines for the K-BAAS-2 project across both frontend (JavaScript/React) and backend (Python/FastAPI) codebases.

## Table of Contents

- [JavaScript/Frontend Standards](#javascriptfrontend-standards)
- [Python/Backend Standards](#pythonbackend-standards)
- [Common Standards](#common-standards)

---

## JavaScript/Frontend Standards

### Overview

The frontend follows **Standard JS** conventions with modern tooling for consistency and code quality.

### Style Guide: Standard JS

We follow the [Standard JS](https://standardjs.com/) style guide, which is a zero-configuration JavaScript style guide that enforces consistent code style.

**Key Principles:**
- **No semicolons** - Automatic Semicolon Insertion (ASI)
- **Single quotes** for strings
- **2-space indentation**
- **No trailing commas**
- **Space after keywords** (`if (condition)`)
- **Space before function parentheses** (anonymous functions only)

**References:**
- [Standard JS Rules](https://standardjs.com/rules.html)
- [Standard JS GitHub](https://github.com/standard/standard)

### Tooling

#### ESLint

Configuration: [`frontend/eslint.config.js`](../../frontend/eslint.config.js)

We use ESLint v9 with:
- Standard JS rule set (implemented via individual rules)
- React-specific rules (hooks, refresh)
- Prettier integration for formatting

**Key ESLint Rules:**
```javascript
{
  'semi': ['error', 'never'],
  'quotes': ['error', 'single', { avoidEscape: true }],
  'comma-dangle': ['error', 'never'],
  'indent': ['error', 2],
  'space-before-function-paren': ['error', {
    anonymous: 'always',
    named: 'never',
    asyncArrow: 'always'
  }]
}
```

**References:**
- [ESLint Documentation](https://eslint.org/docs/latest/)
- [ESLint Rules](https://eslint.org/docs/latest/rules/)

#### Prettier

Configuration: [`frontend/.prettierrc`](../../frontend/.prettierrc)

Prettier is configured to align with Standard JS:

```json
{
  "semi": false,
  "singleQuote": true,
  "trailingComma": "none",
  "tabWidth": 2,
  "printWidth": 100,
  "arrowParens": "avoid"
}
```

**References:**
- [Prettier Documentation](https://prettier.io/docs/en/)
- [Prettier Options](https://prettier.io/docs/en/options.html)

#### EditorConfig

Configuration: [`frontend/.editorconfig`](../../frontend/.editorconfig)

Ensures consistent editor settings across different IDEs:
- UTF-8 encoding
- LF line endings
- 2-space indentation for JS/JSX/JSON/CSS
- Trim trailing whitespace
- Insert final newline

**References:**
- [EditorConfig](https://editorconfig.org/)

### React Best Practices

- Use **functional components** with hooks
- Follow **React Hooks rules** (enforced by ESLint)
- Use **PascalCase** for component names
- Use **camelCase** for props and variables
- Prefer **named exports** for components

**References:**
- [React Documentation](https://react.dev/)
- [React Hooks Rules](https://react.dev/reference/rules/rules-of-hooks)

### Usage

```bash
# Check for linting errors
npm run lint

# Auto-fix linting errors
npm run lint:fix

# Format code
npm run format

# Check formatting
npm run format:check
```

---

## Python/Backend Standards

### Overview

The backend follows **PEP 8** with **Black-compatible** formatting enforced by Ruff, and **mypy** for static type checking.

### Style Guide: PEP 8

We follow [PEP 8](https://peps.python.org/pep-0008/), Python's official style guide, with Black-compatible modifications.

**Key Principles:**
- **4-space indentation**
- **88 character line length** (Black default)
- **Double quotes** for strings
- **snake_case** for functions and variables
- **PascalCase** for classes
- **UPPER_CASE** for constants
- **Google-style docstrings**

**References:**
- [PEP 8 - Style Guide for Python Code](https://peps.python.org/pep-0008/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)

### Tooling

#### Ruff

Configuration: [`backend/pyproject.toml`](../../backend/pyproject.toml) (lines 21-110)

[Ruff](https://github.com/astral-sh/ruff) is an extremely fast Python linter and formatter written in Rust. It replaces multiple tools (Black, isort, Flake8, etc.) with a single tool.

**Enabled Rule Sets:**
- **E, W** - pycodestyle (PEP 8 compliance)
- **F** - Pyflakes (logical errors)
- **I** - isort (import sorting)
- **N** - pep8-naming (naming conventions)
- **UP** - pyupgrade (modern Python syntax)
- **B** - flake8-bugbear (bug patterns)
- **C4** - flake8-comprehensions
- **DTZ** - flake8-datetimez
- **PL** - Pylint
- **RUF** - Ruff-specific rules

**Formatting:**
- Black-compatible
- 88 character line length
- Double quotes for strings
- Google-style docstrings

**References:**
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Ruff Rules](https://docs.astral.sh/ruff/rules/)
- [Black Code Style](https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html)

#### mypy

Configuration: [`backend/pyproject.toml`](../../backend/pyproject.toml) (lines 113-145)

[mypy](https://mypy.readthedocs.io/) is a static type checker for Python.

**Configuration:**
- Python version: 3.13
- **Requires type hints** on function definitions
- Warns about return types
- Checks untyped definitions
- Enforces strict equality checks
- Shows error codes and column numbers

**Type Hints:**
```python
from typing import Optional

def greet(name: str) -> str:
    return f"Hello, {name}!"

def process(value: str | None = None) -> str:
    if value is None:
        return "default"
    return value
```

**References:**
- [mypy Documentation](https://mypy.readthedocs.io/)
- [PEP 484 - Type Hints](https://peps.python.org/pep-0484/)
- [typing Module](https://docs.python.org/3/library/typing.html)

### FastAPI Best Practices

- Use **Pydantic models** for request/response validation
- Add **type hints** to all route handlers
- Use **async/await** for I/O operations
- Document endpoints with **docstrings**
- Use **dependency injection** for shared dependencies

**References:**
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Pydantic Documentation](https://docs.pydantic.dev/)

### Usage

```bash
# Check for linting errors
ruff check .

# Auto-fix linting errors
ruff check --fix .

# Format code
ruff format .

# Check types
mypy .

# Run all checks
ruff check --fix . && ruff format . && mypy .
```

---

## Common Standards

### Version Control

- Write **clear, descriptive commit messages**
- Use **conventional commits** format when appropriate
- Keep commits **atomic** (one logical change per commit)
- Reference issue numbers in commit messages

**References:**
- [Conventional Commits](https://www.conventionalcommits.org/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

### Documentation

- Add **docstrings** to all public functions and classes
- Keep **README files** up to date
- Document **API endpoints** clearly
- Include **examples** in documentation

### Testing

- Write **unit tests** for business logic
- Aim for **high code coverage** (minimum 80%)
- Use **descriptive test names**
- Follow **AAA pattern** (Arrange, Act, Assert)

**References:**
- [pytest Documentation](https://docs.pytest.org/)
- [Jest Documentation](https://jestjs.io/)

### Code Review

- Review for **correctness** and **clarity**
- Check **test coverage**
- Verify **style compliance** (automated by CI)
- Provide **constructive feedback**

---

## Tools Summary

### Frontend
- **ESLint** - Linting
- **Prettier** - Code formatting
- **EditorConfig** - Editor consistency

### Backend
- **Ruff** - Linting and formatting
- **mypy** - Static type checking
- **pytest** - Testing

---

## References

### JavaScript
- [Standard JS](https://standardjs.com/)
- [ESLint](https://eslint.org/)
- [Prettier](https://prettier.io/)
- [React](https://react.dev/)

### Python
- [PEP 8](https://peps.python.org/pep-0008/)
- [Ruff](https://docs.astral.sh/ruff/)
- [mypy](https://mypy.readthedocs.io/)
- [Black](https://black.readthedocs.io/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [FastAPI](https://fastapi.tiangolo.com/)

### General
- [EditorConfig](https://editorconfig.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

*Last updated: 2025-11-06*