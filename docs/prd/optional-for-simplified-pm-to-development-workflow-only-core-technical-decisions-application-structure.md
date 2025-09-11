# [OPTIONAL: For Simplified PM-to-Development Workflow Only] Core Technical Decisions & Application Structure

## Technology Stack Selections

- **Primary Backend Language/Framework:** Python 3.14 with FastAPI
- **Primary Frontend Language/Framework:** JavaScript with React 19
- **Database:** TypeDB 3.3
- **Key Libraries/Services (Backend):**
  - python-socketio for WebSocket communication
  - Pydantic for schema definition and validation
  - uv as Python package manager
  - Custom TypeDB connection code (to be provided)
- **Key Libraries/Services (Frontend):**
  - Tailwind 4 for styling
  - Shadcn/ui for UI components
  - Lexical for rich text editing
  - React Flow for graph visualization
  - Jotai for state management
  - Socket.io client for real-time communication
- **Deployment Platform/Environment:** Docker containers (specific hosting platform TBD)
- **Version Control System:** Git with GitHub

## Proposed Application Structure

```
/
├── README.md                    # Project documentation
├── package.json                 # Root package.json for JavaScript dependencies
├── requirements.txt             # Python dependencies
├── docker-compose.yml           # Local development environment
├── .github/                     # GitHub Actions workflows
│   └── workflows/
│       ├── ci.yml               # CI workflow
│       └── deploy.yml           # Deployment workflow
├── frontend/                    # React frontend application
│   │   ├── public/              # Static assets
│   │   ├── src/                 # Source code
│   │   │   ├── components/      # Reusable UI components
│   │   │   ├── hooks/           # Custom React hooks
│   │   │   ├── pages/           # Page components
│   │   │   ├── store/           # Jotai state management
│   │   │   ├── utils/           # Utility functions
│   │   │   ├── services/        # API and service integrations
│   │   │   └── App.js           # Main application component
│   └── package.json             # Frontend dependencies
├── backend/                     # FastAPI backend application
│       ├── app/                 # Application code
│       │   ├── api/             # API endpoints
│       │   ├── core/            # Core functionality
│       │   ├── db/              # Database interactions
│       │   ├── models/          # Data models
│       │   ├── schemas/         # Pydantic schemas
│       │   └── services/        # Business logic services
│       ├── tests/               # Backend tests
│   └── main.py                  # Application entry point
└── scripts/                     # Development and build tools
```

- **Repository Structure:** Single repository containing both frontend and backend applications with standard directory organization. This approach simplifies development, testing, and deployment while maintaining clear separation of concerns.

- **Key Modules/Components and Responsibilities:**
  - **Frontend Application:** Responsible for the user interface, including the wiki editor, graph visualization, and user interactions.
  - **Backend API:** Provides data access, authentication, and business logic services to the frontend.
  - **Shared Code:** Common utilities and configurations shared between frontend and backend where appropriate.
  - **TypeDB Integration:** Manages the connection to TypeDB and provides data access methods.
  - **Real-time Collaboration:** Handles WebSocket connections and real-time updates between users.
  - **Document Processing:** Manages document uploads and knowledge extraction.

- **Data Flow Overview (Conceptual):**
  1. User interacts with the frontend application (React)
  2. Frontend makes API requests to the backend (FastAPI)
  3. Backend processes requests and interacts with TypeDB
  4. Real-time updates are propagated via Socket.io
  5. Data is returned to the frontend and displayed to the user
