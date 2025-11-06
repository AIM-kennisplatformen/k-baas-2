# Frontend

React + Vite frontend for the K-BAAS-2 Knowledge Graph Wiki Tool.

## Setup

1. Make sure you have Node.js installed
2. Install dependencies:
   ```bash
   cd frontend
   npm install
   ```

## Running the Development Server

```bash
npm run dev
```

The application will be available at http://localhost:6166

> **Note:** The port is configured in the root `.env` file as `FRONTEND_PORT` (default: 6166)

## Building for Production

```bash
npm run build
```

## Preview Production Build

```bash
npm run preview
```

## Tech Stack

- **React 19** - UI framework
- **Vite** - Build tool and dev server
- **Tailwind CSS 4** - Utility-first CSS framework
- **Lucide React** - Icon library
- **React Compiler** - Automatic React optimization (enabled via Babel plugin)

## Project Structure

```
frontend/
├── src/              # Source code
│   ├── App.jsx      # Main app component
│   ├── main.jsx     # App entry point
│   └── assets/      # Static assets
├── public/          # Public static files
├── .env             # Environment variables
├── vite.config.js   # Vite configuration
└── package.json     # Dependencies and scripts
```

## React Compiler

The React Compiler is enabled on this template. See [this documentation](https://react.dev/learn/react-compiler) for more information.

Note: This will impact Vite dev & build performances.
