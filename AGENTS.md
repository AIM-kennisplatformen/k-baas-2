# AGENTS.md

This file provides guidance to AI coding agents, like Claude Code (claude.ai/code) and Roo, when working with code in this repository.

## Project Overview

This is the K-BAAS-2 (Knowledge Graph Wiki Tool) repository - a web-based platform that enables non-technical domain experts to collaboratively build, visualize, and share interconnected knowledge through an integrated wiki and knowledge graph interface. The tool combines rich wiki content capabilities with knowledge graph relationship modeling using TypeDB as the backend.

## Development Environment & Tools

### BMAD (Business Modeling & Agent Development) Framework
This repository uses the BMAD framework extensively for project management and development workflows:

- **Core Configuration**: `.bmad-core/core-config.yaml` defines project structure and development paths
- **Agent Personas**: Located in `.bmad-core/agents/` - specialized roles like developer, architect, QA, etc.
- **Task Workflows**: Structured tasks in `.bmad-core/tasks/` for guided development processes
- **Templates & Checklists**: Standardized templates in `.bmad-core/templates/` and quality checklists in `.bmad-core/checklists/`
- **Claude Commands**: Custom slash commands available in `.claude/commands/BMad/`

### Key BMAD Configuration
Based on `.bmad-core/core-config.yaml`:
- **Story Location**: `docs/stories/` - Development stories and tasks
- **Architecture Docs**: `docs/architecture/` - Sharded architecture documentation
- **PRD Documentation**: `docs/prd/` - Sharded product requirements
- **QA Location**: `docs/qa/` - Quality assurance documentation
- **Debug Log**: `.ai/debug-log.md` - Development debugging information

### Required Development Files
The BMAD configuration specifies these files must be loaded for development:
- `docs/architecture/coding-standards.md`
- `docs/architecture/tech-stack.md` 
- `docs/architecture/source-tree.md`

## Project Structure

```
k-baas-2/
├── .bmad-core/              # BMAD framework (v4.43.1)
│   ├── core-config.yaml     # Project configuration
│   ├── agents/              # Agent persona definitions
│   ├── tasks/               # Structured workflow tasks
│   ├── templates/           # Document templates
│   ├── checklists/          # Quality assurance checklists
│   ├── workflows/           # Development workflows
│   └── data/                # Reference data and knowledge base
├── .claude/                 # Claude Code configuration
│   ├── settings.local.json  # Local permissions (allows Bash grep)
│   └── commands/BMad/       # Custom BMad slash commands
├── .ai/                     # AI development artifacts
└── docs/                    # Project documentation
    ├── knowledge-graph-wiki-prd.md        # Product Requirements Document
    ├── knowledge-graph-wiki-project-brief.md
    ├── knowledge-graph-wiki-ui-ux-spec.md
    ├── User-Stories-Acceptance-Criteria-Deliverables.md
    ├── stories/             # Development stories (per BMAD config)
    ├── architecture/        # Sharded architecture docs
    ├── prd/                 # Sharded PRD documents
    └── qa/                  # QA documentation
```

## Development Process

### BMAD Agent System
The repository includes multiple specialized agent personas:
- **dev.md**: Full Stack Developer for implementation
- **architect.md**: System architecture and design
- **qa.md**: Test Architect & Quality Advisor
- **po.md**: Product Owner for requirements
- **pm.md**: Product Manager for strategy
- **analyst.md**: Business Analyst for analysis
- **ux-expert.md**: UX Expert for design

### Story-Driven Development
Based on BMAD configuration:
1. **Stories are located** in `docs/stories/` directory
2. **Development follows** structured agent workflows
3. **Quality gates** enforced through checklists in `.bmad-core/checklists/`
4. **Debug information** tracked in `.ai/debug-log.md`

## Technical Architecture

### Backend Technology Stack
- **Database**: TypeDB (knowledge graph database)
- **API Framework**: FastAPI (Python)
- **Real-time Communication**: Socket.IO

### Frontend Technology Stack
- **Framework**: React 19
- **Build System**: Vite
- **Rich Text Editor**: Lexical
- **Graph Visualization**: React Flow
- **Real-time Features**: Socket.IO client

### Key Integration Points
- **TypeDB Integration**: Complex relationship modeling with properties
- **Bidirectional Sync**: Wiki content ↔ Knowledge graph visualization
- **AI Assistance**: LLM integration for relationship suggestions
- **Real-time Collaboration**: Multi-user editing capabilities

## Important Development Guidelines

### BMAD Compliance
- Follow agent persona guidelines when activated
- Use structured task workflows from `.bmad-core/tasks/`
- Reference templates from `.bmad-core/templates/` for consistency
- Complete checklists from `.bmad-core/checklists/` before task completion
- Load required development files specified in `core-config.yaml`

### Code Standards
- Refer to `docs/architecture/coding-standards.md` (when available)
- Check `docs/architecture/tech-stack.md` for technology decisions
- Follow `docs/architecture/source-tree.md` for project organization
- Maintain security best practices (no exposed secrets/keys)

### Quality Assurance
- Use QA documentation in `docs/qa/` directory
- Follow story definition of done checklists
- Execute comprehensive testing before task completion
- Document debugging information in `.ai/debug-log.md`

## Commands and Development

### Available BMAD Tasks
The `.bmad-core/tasks/` directory contains structured workflows for:
- Story creation and validation
- Architecture documentation
- QA gates and testing
- Code review processes
- Requirement elicitation

### Custom Claude Commands
Check `.claude/commands/BMad/` for project-specific slash commands that integrate with the BMAD framework.

## Testing & Validation

Follow BMAD quality processes:
- Use test frameworks defined in `.bmad-core/data/test-levels-framework.md`
- Apply test priorities from `.bmad-core/data/test-priorities-matrix.md`
- Execute validation tasks from `.bmad-core/tasks/`
- Complete quality checklists before marking work as done

# MCP use
* Whenever you're instructed to 'remember' something, use the 'memory' mcp server to store the information. Use the recent context to determine what to store. If it is not very clear what should be included for storage, ask the user.

# First Thing
When the session starts, say "Hi There!" to the user.