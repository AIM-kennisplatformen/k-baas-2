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
  - Parse the story's task structure and create sub-issues for each main task.
  - Link sub-issues to the parent story with proper cross-references.
  - Add both parent issue and sub-issues to the specified GitHub Project Board.
  - Store the GitHub Issue number and sub-issue numbers in the local story file for future reference.
- **If local story file updated**:
  - Find the corresponding GitHub Issue using the stored issue number.
  - Update the issue body, title, or labels as needed.
  - Synchronize sub-issues: create new ones for added tasks, update existing ones for modified tasks.
  - Sync status changes from the local file to both the GitHub Issue and its sub-issues.

### 4. GitHub-to-Local Synchronization
- **When GitHub Issue is updated** (e.g., via webhook):
  - Find the corresponding local story file.
  - Update the local file's status, assignee, or other metadata to match the GitHub Issue.
  - Sync sub-issue status changes back to local task completion status in the story file.
  - Aggregate sub-issue progress to determine overall story completion percentage.

### 5. Status Mapping
- Define a clear mapping between local story statuses and GitHub Issue labels/columns:
  - `Draft` -> `Draft` (Project Board Column)
  - `Approved` -> `To Do` / `Backlog`
  - `InProgress` -> `In Progress`
  - `Review` -> `In Review`
  - `Done` -> `Done` (and close issue)

### 6. Sub-Issue Management
- **Task Parsing**: Extract main tasks from story's "Tasks / Subtasks" section (### Task N: format)
- **Sub-Issue Creation**: Create individual GitHub issues for each main task with:
  - Title format: "[{parent_issue}] Task {number}: {task_title}"
  - Body containing parent story reference, AC mapping, and task details
  - Appropriate labels: `task`, `subtask`, epic labels, component labels
  - Cross-linking to parent story issue
- **Status Synchronization**: Bidirectional sync between local task checkboxes and GitHub sub-issue status
- **Progress Tracking**: Aggregate sub-issue completion to show overall story progress

### 7. Reporting
- Provide a summary of synchronization actions taken:
  - "Successfully created/updated GitHub Issue #{issue_number}"
  - "Created sub-issues: #{sub_issue_numbers}"
  - "Successfully synced status for story {story_id} from GitHub Issue #{issue_number}"
  - "Sub-issue progress: {completed}/{total} tasks completed"
