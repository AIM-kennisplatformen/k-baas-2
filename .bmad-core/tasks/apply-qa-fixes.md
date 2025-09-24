<!-- Powered by BMAD™ Core -->

# apply-qa-fixes

Implement fixes based on QA results (gate and assessments) for a specific story. This task is for the Dev agent to systematically consume QA outputs and apply code/test changes while only updating allowed sections in the story file.

## Purpose

- Read QA outputs for a story (gate YAML + assessment markdowns)
- Create a prioritized, deterministic fix plan
- Apply code and test changes to close gaps and address issues
- Update only the allowed story sections for the Dev agent

## Inputs

```yaml
required:
  - story_issue_number: GitHub issue number for the story (e.g., 42)
  - qa_root: from `.bmad-core/core-config.yaml` key `qa.qaLocation` (e.g., `docs/project/qa`)
  - github_repo: from `.bmad-core/core-config.yaml` key `github.repo` (e.g., "username/project")

optional:
  - story_title: '{title}' # derive from issue title if missing
  - story_slug: '{slug}' # derive from title (lowercase, hyphenated) if missing
```

## QA Sources to Read

- Gate (YAML): `{qa_root}/gates/{epic}.{story}-*.yml`
  - If multiple, use the most recent by modified time
- Assessments (Markdown):
  - Test Design: `{qa_root}/assessments/{epic}.{story}-test-design-*.md`
  - Traceability: `{qa_root}/assessments/{epic}.{story}-trace-*.md`
  - Risk Profile: `{qa_root}/assessments/{epic}.{story}-risk-*.md`
  - NFR Assessment: `{qa_root}/assessments/{epic}.{story}-nfr-*.md`

## Prerequisites

- Repository builds and tests run locally (Deno 2)
- Lint and test commands available:
  - `deno lint`
  - `deno test -A`

## Process (Do not skip steps)

### 0) Load Core Config & Locate Story Issue

- Read `.bmad-core/core-config.yaml` and resolve `qa_root` and GitHub configuration
- **Verify GitHub CLI**: Ensure `gh` CLI is authenticated and configured
- **Locate story issue**: Use `gh issue view {story_issue_number} --json body,title,labels,milestone` to get story details
  - HALT if missing and ask for correct story issue number
- **Extract story ID**: Get epic.story format from issue milestone or labels for QA file naming

### 1) Collect QA Findings

- Parse the latest gate YAML:
  - `gate` (PASS|CONCERNS|FAIL|WAIVED)
  - `top_issues[]` with `id`, `severity`, `finding`, `suggested_action`
  - `nfr_validation.*.status` and notes
  - `trace` coverage summary/gaps
  - `test_design.coverage_gaps[]`
  - `risk_summary.recommendations.must_fix[]` (if present)
- Read any present assessment markdowns and extract explicit gaps/recommendations

### 2) Build Deterministic Fix Plan (Priority Order)

Apply in order, highest priority first:

1. High severity items in `top_issues` (security/perf/reliability/maintainability)
2. NFR statuses: all FAIL must be fixed → then CONCERNS
3. Test Design `coverage_gaps` (prioritize P0 scenarios if specified)
4. Trace uncovered requirements (AC-level)
5. Risk `must_fix` recommendations
6. Medium severity issues, then low

Guidance:

- Prefer tests closing coverage gaps before/with code changes
- Keep changes minimal and targeted; follow project architecture and TS/Deno rules

### 3) Apply Changes

- Implement code fixes per plan
- Add missing tests to close coverage gaps (unit first; integration where required by AC)
- **TDD Requirement**: For user-facing stories, implement and update Gherkin step definitions to ensure all scenarios pass
- **TDD Requirement**: Execute Cucumber tests and fix any failing Gherkin scenarios
- Keep imports centralized via `deps.ts` (see `docs/project/typescript-rules.md`)
- Follow DI boundaries in `src/core/di.ts` and existing patterns</search>
</search_and_replace>

### 4) Validate

- Run `deno lint` and fix issues
- Run `deno test -A` until all tests pass
- **TDD Requirement**: Run Cucumber tests to ensure all Gherkin scenarios pass
- **TDD Requirement**: Verify step definitions are fully implemented and executing correctly
- Iterate until clean

### 5) Update Story Issue (Via Comments ONLY)

CRITICAL: Dev agent is ONLY authorized to add comments to the story issue. Do not modify issue body, title, or core metadata:

**Add Progress Comment**: Use `gh issue comment {story_issue_number} --body "Dev Agent Progress Update..."` to document:
- **Task Sub-Issues**: Close completed task sub-issues using `gh issue close {task_issue_number}`
- **Debug Log References**: Commands/results (e.g., lint/tests) in comment
- **Completion Notes**: What changed, why, how in comment
- **File List**: All added/modified/deleted files documented in comment
- **Change Log**: New dated entry describing applied fixes in comment

**Status Rule**:
- If gate was PASS and all identified gaps are closed → Add 'ready-for-done' label and move to 'Done' column using `github-issue-manager.sh update-status {story_issue_number} "Done"`
- Otherwise → Add 'ready-for-review' label and move to 'Review' column using `github-issue-manager.sh update-status {story_issue_number} "Review"` and notify QA to re-run the review

### 6) Do NOT Edit Gate Files

- Dev does not modify gate YAML. If fixes address issues, request QA to re-run `review-story` task to update the gate and add new QA comments to the story issue

## Blocking Conditions

- Missing `.bmad-core/core-config.yaml`
- Story file not found for `story_id`
- No QA artifacts found (neither gate nor assessments)
  - HALT and request QA to generate at least a gate file (or proceed only with clear developer-provided fix list)

## Completion Checklist

- deno lint: 0 problems
- deno test -A: all tests pass
- All high severity `top_issues` addressed
- NFR FAIL → resolved; CONCERNS minimized or documented
- Coverage gaps closed or explicitly documented with rationale
- Story issue updated via comments including File List and Change Log
- Issue status and labels updated according to Status Rule using GitHub scripts

## Example: Story Issue #42

Given gate `docs/project/qa/gates/2.2-*.yml` shows

- `coverage_gaps`: Back action behavior untested (AC2)
- `coverage_gaps`: Centralized dependencies enforcement untested (AC4)

Fix plan:

- Add a test ensuring the Toolkit Menu "Back" action returns to Main Menu
- Add a static test verifying imports for service/view go through `deps.ts`
- Re-run lint/tests and add progress comment to issue #42 with Dev Agent Record + File List
- Close completed task sub-issues and update issue status via GitHub scripts

## Key Principles

- Deterministic, risk-first prioritization
- Minimal, maintainable changes
- Tests validate behavior and close gaps
- Strict adherence to allowed story issue comment areas
- Gate ownership remains with QA; Dev signals readiness via issue labels and status
