# GitHub Synchronization Task

## Purpose

To provide two-way synchronization between local story files and GitHub Issues, allowing for centralized task management in GitHub while maintaining detailed local story context.

## GitHub CLI Integration
- **Primary Tool**: All interactions with GitHub Issues and Project Boards will be handled through the `gh` CLI tool.
- **Shell Scripts**: Reusable shell scripts will be created to encapsulate `gh` commands for common operations such as:
    - `create-github-issue.sh`: To create a new GitHub issue from a local story file.
    - `update-github-issue.sh`: To update an existing GitHub issue with new information.
    - `sync-github-status.sh`: To synchronize status changes between local files and GitHub.
- **Authentication**: The `gh` CLI will handle authentication with GitHub, ensuring secure and reliable access.

## Task Execution

### 1. Load Configuration
- Load `{root}/core-config.yaml` to get GitHub repository and project board information.
- If GitHub configuration is missing, HALT and inform the user to configure it.

### 2. Determine Sync Direction
- The task can be triggered in two ways:
  - **Local-to-GitHub**: When a local story file is created or updated.
  - **GitHub-to-Local**: When a GitHub Issue is updated.

### 3. Local-to-GitHub Synchronization
- **If new local story file created**:
  - Create a new GitHub Issue with title, story content, and acceptance criteria.
  - Assign labels based on story metadata (epic, version, etc.).
  - Add the new issue to the specified GitHub Project Board.
  - Store the GitHub Issue number in the local story file for future reference.
- **If local story file updated**:
  - Find the corresponding GitHub Issue using the stored issue number.
  - Update the issue body, title, or labels as needed.
  - Sync status changes from the local file to the GitHub Issue.

### 4. GitHub-to-Local Synchronization
- **When GitHub Issue is updated** (e.g., via webhook):
  - Find the corresponding local story file.
  - Update the local file's status, assignee, or other metadata to match the GitHub Issue.

### 5. Status Mapping
- Define a clear mapping between local story statuses and GitHub Issue labels/columns:
  - `Draft` -> `Draft` (Project Board Column)
  - `Approved` -> `To Do` / `Backlog`
  - `InProgress` -> `In Progress`
  - `Review` -> `In Review`
  - `Done` -> `Done` (and close issue)

### 6. Reporting
- Provide a summary of synchronization actions taken:
  - "Successfully created/updated GitHub Issue #{issue_number}"
  - "Successfully synced status for story {story_id} from GitHub Issue #{issue_number}"
