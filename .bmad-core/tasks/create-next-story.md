<!-- Powered by BMAD™ Core -->

# Create Next Story Task

## Purpose

To identify the next logical story based on project progress and epic definitions, and then to prepare a comprehensive, self-contained, and actionable story file using the `Story Template`. This task ensures the story is enriched with all necessary technical context, requirements, and acceptance criteria, making it ready for efficient implementation by a Developer Agent with minimal need for additional research or finding its own context.

## SEQUENTIAL Task Execution (Do not proceed until current Task is complete)

### 0. Load Core Configuration and Check Workflow

- Load `{root}/core-config.yaml` from the project root
- If the file does not exist, HALT and inform the user: "core-config.yaml not found. This file is required for story creation. You can either: 1) Copy it from GITHUB bmad-core/core-config.yaml and configure it for your project OR 2) Run the BMad installer against your project to upgrade and add the file automatically. Please add and configure core-config.yaml before proceeding."
- Extract key configurations: `github.*`, `prd.*`, `architecture.*`, `workflow.*`
- **GitHub Validation**: Ensure `github.repo` is configured. If not, HALT and inform the user: "GitHub repo not configured in core-config.yaml. Please set github.repo to your repository (e.g., 'myorg/myproject') before proceeding."
- **GitHub CLI Check**: Verify `gh` CLI is installed and authenticated by running `gh auth status`. If not authenticated, HALT and inform the user: "GitHub CLI not authenticated. Please run 'gh auth login' first."

### 1. Identify Next Story for Preparation

#### 1.1 Locate Epic Issues and Review Existing Stories

- Based on `prdSharded` from config, locate epic files (sharded location/pattern or monolithic PRD sections)
- **List Existing Stories**: Execute `scripts/github/list-stories.sh "label:story state:all"` to get all story issues
- Parse story issues to find the highest `{epicNum}.{storyNum}` format in issue titles
- **If highest story exists:**
  - Check story issue state and labels to determine status (open/closed, labels like "done", "in-progress", etc.)
  - If status is not 'Done', alert user: "ALERT: Found incomplete story! Issue: #{issueNum} - {storyTitle} Status: [current status] You should fix this story first, but would you like to accept risk & override to create the next story in draft?"
  - If proceeding, select next sequential story in the current epic
  - If epic is complete, prompt user: "Epic {epicNum} Complete: All stories in Epic {epicNum} have been completed. Would you like to: 1) Begin Epic {epicNum + 1} with story 1 2) Select a specific story to work on 3) Cancel story creation"
  - **CRITICAL**: NEVER automatically skip to another epic. User MUST explicitly instruct which story to create.
- **If no story issues exist:** The next story is ALWAYS 1.1 (first story of first epic)
- Announce the identified story to the user: "Identified next story for preparation: {epicNum}.{storyNum} - {Story Title}"

### 2. Gather Story Requirements and Previous Story Context

- Extract story requirements from the identified epic file
- **Find Parent Epic Issue**: Use `scripts/github/list-stories.sh "label:epic"` to locate the epic issue for this story
- If previous story exists, use `gh issue view {previousStoryIssueNum}` to review:
  - Issue comments containing Dev Agent Records
  - Implementation notes and decisions in issue comments
  - Challenges encountered and lessons learned from issue history
- Extract relevant insights that inform the current story's preparation

### 3. Gather Architecture Context

#### 3.1 Determine Architecture Reading Strategy

- **If `architectureVersion: >= v4` and `architectureSharded: true`**: Read `{architectureShardedLocation}/index.md` then follow structured reading order below
- **Else**: Use monolithic `architectureFile` for similar sections

#### 3.2 Read Architecture Documents Based on Story Type

**For ALL Stories:** tech-stack.md, unified-project-structure.md, coding-standards.md, testing-strategy.md

**For Backend/API Stories, additionally:** data-models.md, database-schema.md, backend-architecture.md, rest-api-spec.md, external-apis.md

**For Frontend/UI Stories, additionally:** frontend-architecture.md, components.md, core-workflows.md, data-models.md

**For Full-Stack Stories:** Read both Backend and Frontend sections above

#### 3.3 Extract Story-Specific Technical Details

Extract ONLY information directly relevant to implementing the current story. Do NOT invent new libraries, patterns, or standards not in the source documents.

Extract:

- Specific data models, schemas, or structures the story will use
- API endpoints the story must implement or consume
- Component specifications for UI elements in the story
- File paths and naming conventions for new code
- Testing requirements specific to the story's features
- Security or performance considerations affecting the story

ALWAYS cite source documents: `[Source: architecture/{filename}.md#{section}]`

### 4. Verify Project Structure Alignment

- Cross-reference story requirements with Project Structure Guide from `docs/architecture/unified-project-structure.md`
- Ensure file paths, component locations, or module names align with defined structures
- Document any structural conflicts in "Project Structure Notes" section within the story draft

### 5. Populate Story Template and Create GitHub Issue

- **Render Story Body**: Using Story Template, prepare the full story content with:
  - Title: "Story {epicNum}.{storyNum}: {Story Title}"
  - Story statement (As a... I want... so that...)
  - Acceptance Criteria from Epic
  - **`Dev Notes` section (CRITICAL):**
    - CRITICAL: This section MUST contain ONLY information extracted from architecture documents. NEVER invent or assume technical details.
    - Include ALL relevant technical details from Steps 2-3, organized by category:
      - **Previous Story Insights**: Key learnings from previous story
      - **Data Models**: Specific schemas, validation rules, relationships [with source references]
      - **API Specifications**: Endpoint details, request/response formats, auth requirements [with source references]
      - **Component Specifications**: UI component details, props, state management [with source references]
      - **File Locations**: Exact paths where new code should be created based on project structure
      - **Testing Requirements**: Specific test cases or strategies from testing-strategy.md
      - **Technical Constraints**: Version requirements, performance considerations, security rules
    - Every technical detail MUST include its source reference: `[Source: architecture/{filename}.md#{section}]`
    - If information for a category is not found in the architecture docs, explicitly state: "No specific guidance found in architecture docs"
  - **`Tasks / Subtasks` section:**
    - Generate detailed, sequential list of technical tasks based ONLY on: Epic Requirements, Story AC, Reviewed Architecture Information
    - Each task must reference relevant architecture documentation
    - Include unit testing as explicit subtasks based on the Testing Strategy
    - Link tasks to ACs where applicable (e.g., `Task 1 (AC: 1, 3)`)
  - Add notes on project structure alignment or discrepancies found in Step 4

- **Create Story Issue**: Execute `scripts/github/create-story-issue.sh {epicNum} "Story {epicNum}.{storyNum}: {Story Title}" "{rendered_story_body}" {epic_issue_number}`
- **Create Task Sub-Issues**: For each main task identified in the Tasks/Subtasks section, create sub-issues using `scripts/github/create-task-issue.sh {storyNum} "{task_title}" "{task_description}" {story_issue_number}`

### 6. Story Draft Completion and Review

- Review all sections for completeness and accuracy
- Verify all source references are included for technical details
- Ensure tasks align with both epic requirements and architecture constraints
- **Add to Project Board**: Story issue is automatically added to "Backlog" column by the create-story-issue.sh script
- Execute `{root}/tasks/execute-checklist` `{root}/checklists/story-draft-checklist`
- Provide summary to user including:
  - Story created: GitHub Issue #{story_issue_number} - "Story {epicNum}.{storyNum}: {Story Title}"
  - Status: Draft (label applied to issue)
  - Parent Epic: Issue #{epic_issue_number}
  - Task sub-issues created: [list of task issue numbers]
  - Project Board: Added to Backlog column
  - Key technical components included from architecture docs
  - Any deviations or conflicts noted between epic and architecture
  - Checklist Results
  - Next steps: For Complex stories, suggest the user carefully review the story issue and also optionally have the PO run the task `{root}/tasks/validate-next-story` with the issue number
