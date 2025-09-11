# GitHub Sync Scripts

These scripts provide two-way synchronization between local story files and GitHub Issues, enabling centralized task management in GitHub while maintaining detailed local story context.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Access to the HAN-AIM-CMD-WG/k-baas-2 repository
- Proper permissions for GitHub Project Board #9

## Scripts Overview

### 1. create-github-issue.sh
Creates a new GitHub issue from a local story file.

**Usage:**
```bash
./scripts/github-sync/create-github-issue.sh <story-file-path>
```

**Example:**
```bash
./scripts/github-sync/create-github-issue.sh docs/stories/1.1a.basic-repository-structure-setup.md
```

**Features:**
- Extracts story title, content, acceptance criteria, and tasks
- Creates GitHub issue with appropriate labels
- Automatically creates sub-issues for each main task (### Task N: format)
- Links sub-issues to parent story with cross-references
- Adds both parent issue and sub-issues to Project Board #9
- Stores issue number and sub-issue numbers in story file for future reference

### 2. update-github-issue.sh
Updates an existing GitHub issue from a local story file.

**Usage:**
```bash
./scripts/github-sync/update-github-issue.sh <story-file-path> [issue-number]
```

**Examples:**
```bash
# Auto-detect issue number from story file
./scripts/github-sync/update-github-issue.sh docs/stories/1.1a.basic-repository-structure-setup.md

# Specify issue number explicitly
./scripts/github-sync/update-github-issue.sh docs/stories/1.1a.basic-repository-structure-setup.md 123
```

**Features:**
- Updates issue title, body, and labels
- Synchronizes sub-issues: creates new ones for added tasks, updates existing ones
- Manages status transitions via labels for both parent and sub-issues
- Closes issues when status is "Done"
- Maintains task-to-sub-issue mapping
- Timestamps updates

### 3. sync-github-status.sh
Synchronizes status between local story files and GitHub Issues.

**Usage:**
```bash
./scripts/github-sync/sync-github-status.sh <direction> [story-file-path]
```

**Directions:**
- `local-to-github` - Update GitHub from local story files
- `github-to-local` - Update local story files from GitHub
- `bidirectional` - Sync both ways (GitHub takes precedence)

**Examples:**
```bash
# Sync specific story bidirectionally
./scripts/github-sync/sync-github-status.sh bidirectional docs/stories/1.1a.basic-repository-structure-setup.md

# Sync all stories to GitHub
./scripts/github-sync/sync-github-status.sh local-to-github

# Update all local stories from GitHub
./scripts/github-sync/sync-github-status.sh github-to-local
```

## Intelligent Label Management

Scripts automatically apply comprehensive labels based on story content analysis:

### Status Mapping

| Local Status | GitHub Label | GitHub State |
|--------------|--------------|--------------|
| Draft        | draft        | Open         |
| Approved     | approved     | Open         |
| InProgress   | in-progress  | Open         |
| Review       | review       | Open         |
| Done         | done         | Closed       |

### Automatic Label Detection

**Epic Labels** (from filename/title):
- `epic-1-foundation` - Project Foundation & Infrastructure
- `epic-2-auth` - User Authentication Management
- `epic-3-schema` - Knowledge Base Creation & Schema Management
- `epic-4-wiki` - Wiki Content Management
- `epic-5-graph-viz` - Knowledge Graph Visualization & Editing
- `epic-6-sync` - Bidirectional Synchronization & Property Editing
- `epic-7-ai` - AI Assistance & Knowledge Quality
- `epic-8-collab` - Real-time Collaboration
- `epic-9-publish` - Publishing & Sharing
- `epic-10-admin` - System Administration & Monitoring
- `epic-11-discuss` - Commenting and Discussion
- `epic-12-ux` - User Experience & Accessibility

**Component Labels** (from content analysis):
- `frontend` - React/UI components (detects: react, frontend, ui, component, tailwind, shadcn)
- `backend` - Python/FastAPI components (detects: python, fastapi, backend, api, server)
- `database` - TypeDB/data layer (detects: typedb, database, schema, query)
- `infrastructure` - DevOps/deployment (detects: docker, deploy, ci/cd, github actions)
- `testing` - Test-related work (detects: test, testing, spec, jest, pytest)
- `security` - Security-related work (detects: auth, security, permission, login)

**Size Labels** (from task count):
- `size-s` - Small (≤5 tasks, 2-8 hours)
- `size-m` - Medium (6-15 tasks, 1-2 days)
- `size-l` - Large (16-25 tasks, 3-5 days)
- `size-xl` - Very large (>25 tasks, >1 week)

**Special Markers** (from content):
- `breaking-change` - Introduces breaking changes (detects: breaking, break)
- `needs-research` - Requires investigation (detects: research, investigate, spike)

### Label Management Features

- **Dynamic Updates**: Labels are recalculated and updated on every story change
- **Content Analysis**: Keywords in story content automatically trigger relevant component labels
- **Size Estimation**: Task count automatically determines story size
- **Complete Replacement**: Old labels are removed and replaced with current analysis
- **Consistent Application**: Same labeling logic across create and update operations

## Workflow Integration

### Creating a New Story
1. Create story file using Scrum Master tools with structured tasks (### Task N: format)
2. Run `create-github-issue.sh` to create GitHub issue and sub-issues
3. Use `sync-github-status.sh` for ongoing status management of parent and sub-issues

### Updating Existing Stories
1. Modify local story file (add/update tasks, change status, etc.)
2. Run `update-github-issue.sh` to sync changes to GitHub and manage sub-issues
3. Use `sync-github-status.sh bidirectional` for full synchronization

### Status Management
- Use `sync-github-status.sh github-to-local` when GitHub is updated externally
- Use `sync-github-status.sh local-to-github` when local files are updated
- Use `sync-github-status.sh bidirectional` for complete synchronization

## Sub-Issue Management

The scripts automatically create and manage sub-issues for granular task tracking:

### Task Structure Requirements
Stories must use this format for automatic sub-issue creation:
```markdown
### Task 1: Create Root Directory Structure (AC: 1, 4)
- [ ] Create `frontend/` directory for React 19 application
- [ ] Create `backend/` directory for Python FastAPI application
- [ ] Create `docs/` directory for project documentation

### Task 2: Setup Documentation Structure (AC: 5)
- [ ] Create `docs/architecture/` directory with placeholder index.md
- [ ] Create `docs/api/` directory for API documentation
```

### Sub-Issue Features
- **Automatic Creation**: Each `### Task N:` becomes a GitHub sub-issue
- **Cross-Linking**: Sub-issues reference parent story and AC numbers
- **Labeling**: Sub-issues get `task`, `subtask`, epic, and component labels
- **Synchronization**: Local task updates sync to GitHub sub-issue changes
- **Progress Tracking**: Parent issue shows progress based on sub-issue completion

### Sub-Issue Title Format
`[{parent_issue}] Task {number}: {task_title}`

Example: `[#38] Task 1: Create Root Directory Structure`

## Project Board Integration

All scripts automatically integrate with GitHub Project Board #9:
- New issues and sub-issues are added to the board
- Status changes update board columns for both parent and sub-issues
- Labels provide additional organization and filtering

## Error Handling

All scripts use `set -e` and exit with non-zero codes on errors. Comprehensive error checking includes:

- **Prerequisites**: GitHub CLI installation and authentication
- **File validation**: Missing or invalid story files
- **GitHub operations**: Issue creation, updates, and status changes
- **Permission checks**: Repository and project board access
- **Network issues**: API connectivity and rate limits
- **Data validation**: Issue number extraction and status mapping

**Exit Codes:**
- `0` - Success
- `1` - Error (missing files, auth issues, GitHub API failures, etc.)

**Error Recovery:**
- Authentication errors provide clear `gh auth login` instructions
- Missing GitHub CLI provides installation link
- Permission errors include repository context
- Project board failures are non-fatal warnings for issue creation

## Security Notes

- Scripts use GitHub CLI authentication
- No credentials are stored in script files
- Repository and project board IDs are configurable
- All operations respect GitHub API rate limits