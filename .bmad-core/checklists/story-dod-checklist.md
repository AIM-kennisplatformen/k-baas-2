<!-- Powered by BMAD™ Core -->

# Story Definition of Done (DoD) Checklist

## Instructions for Developer Agent

Before marking a story issue as 'Review' (using project board status or labels), please go through each item in this checklist. Report the status of each item (e.g., [x] Done, [ ] Not Done, [N/A] Not Applicable) and provide brief comments if necessary.

**Add DoD results as a comment to the story issue using**: `gh issue comment {issue_number} --body "DoD Checklist Results..."`

[[LLM: INITIALIZATION INSTRUCTIONS - STORY DOD VALIDATION

This checklist is for DEVELOPER AGENTS to self-validate their work before marking a story complete.

IMPORTANT: This is a self-assessment. Be honest about what's actually done vs what should be done. It's better to identify issues now than have them found in review.

EXECUTION APPROACH:

1. Go through each section systematically
2. Mark items as [x] Done, [ ] Not Done, or [N/A] Not Applicable
3. Add brief comments explaining any [ ] or [N/A] items
4. Be specific about what was actually implemented
5. Flag any concerns or technical debt created

The goal is quality delivery, not just checking boxes.]]

## Checklist Items

1. **Requirements Met:**

   [[LLM: Be specific - list each requirement and whether it's complete]]
   - [ ] All functional requirements specified in the story issue are implemented.
   - [ ] All acceptance criteria defined in the story issue are met.
   - [ ] All task sub-issues are completed and closed.

2. **Coding Standards & Project Structure:**

   [[LLM: Code quality matters for maintainability. Check each item carefully]]
   - [ ] All new/modified code strictly adheres to `Operational Guidelines`.
   - [ ] All new/modified code aligns with `Project Structure` (file locations, naming, etc.).
   - [ ] Adherence to `Tech Stack` for technologies/versions used (if story introduces or modifies tech usage).
   - [ ] Adherence to `Api Reference` and `Data Models` (if story involves API or data model changes).
   - [ ] Basic security best practices (e.g., input validation, proper error handling, no hardcoded secrets) applied for new/modified code.
   - [ ] No new linter errors or warnings introduced.
   - [ ] Code is well-commented where necessary (clarifying complex logic, not obvious statements).

3. **Testing:**

   [[LLM: Testing proves your code works. Be honest about test coverage]]
   - [ ] All required unit tests as per the story and `Operational Guidelines` Testing Strategy are implemented.
   - [ ] All required integration tests (if applicable) as per the story and `Operational Guidelines` Testing Strategy are implemented.
   - [ ] All tests (unit, integration, E2E if applicable) pass successfully.
   - [ ] Test coverage meets project standards (if defined).

4. **Gherkin/BDD Requirements (MANDATORY for User-Facing Stories):**

   [[LLM: CRITICAL - All Gherkin scenarios must pass before story can be marked "Review". This overrides ALL priority classifications.]]
   - [ ] Feature file exists for all acceptance criteria with user-observable consequences.
   - [ ] Gherkin scenarios cover ALL required scenario types:
     - [ ] Happy path scenarios (primary user journeys)
     - [ ] Unhappy path scenarios (validation failures, error handling)
     - [ ] Edge case scenarios (boundary conditions, empty inputs)
     - [ ] Security scenarios (malicious input protection)
   - [ ] All Cucumber step definitions are implemented with Playwright integration.
   - [ ] ALL Gherkin scenarios pass successfully (no failing scenarios allowed).
   - [ ] Step definitions use proper Playwright patterns for browser automation.
   - [ ] Security scenarios properly test malicious input rejection.
   - [ ] Feature files follow project gherkin-standards.md conventions.
   - [ ] Step definitions follow cucumber-integration.md patterns.

5. **Functionality & Verification:**

   [[LLM: Did you actually run and test your code? Be specific about what you tested]]
   - [ ] Functionality has been manually verified by the developer (e.g., running the app locally, checking UI, testing API endpoints).
   - [ ] Edge cases and potential error conditions considered and handled gracefully.

6. **Story Administration:**

   [[LLM: Documentation helps the next developer. What should they know?]]
   - [ ] All task sub-issues are marked as complete (closed).
   - [ ] Any clarifications or decisions made during development are documented in issue comments.
   - [ ] A development summary comment has been added with notes of changes or information relevant to the next story or overall project, the agent model that was primarily used during development, and the changelog of any changes.
   - [ ] File list of modified/created files is documented in issue comments.

7. **Dependencies, Build & Configuration:**

   [[LLM: Build issues block everyone. Ensure everything compiles and runs cleanly]]
   - [ ] Project builds successfully without errors.
   - [ ] Project linting passes
   - [ ] Any new dependencies added were either pre-approved in the story requirements OR explicitly approved by the user during development (approval documented in issue comments).
   - [ ] If new dependencies were added, they are recorded in the appropriate project files (e.g., `package.json`, `requirements.txt`) with justification.
   - [ ] No known security vulnerabilities introduced by newly added and approved dependencies.
   - [ ] If new environment variables or configurations were introduced by the story, they are documented and handled securely.

8. **Documentation (If Applicable):**

   [[LLM: Good documentation prevents future confusion. What needs explaining?]]
   - [ ] Relevant inline code documentation (e.g., JSDoc, TSDoc, Python docstrings) for new public APIs or complex logic is complete.
   - [ ] User-facing documentation updated, if changes impact users.
   - [ ] Technical documentation (e.g., READMEs, system diagrams) updated if significant architectural changes were made.

## Final Confirmation

[[LLM: FINAL DOD SUMMARY

After completing the checklist:

1. Summarize what was accomplished in this story
2. List any items marked as [ ] Not Done with explanations
3. Identify any technical debt or follow-up work needed
4. Note any challenges or learnings for future stories
5. **CRITICAL**: Confirm ALL Gherkin scenarios pass (mandatory for user-facing stories)
6. Confirm whether the story is truly ready for review

Add this summary as a comment to the story issue, then update issue status:
- If ready: `github-issue-manager.sh update-status {issue_number} "Review"` and add "ready-for-review" label
- If not ready: Keep current status and add "dev-incomplete" label

**GHERKIN ENFORCEMENT**: Stories with user-observable functionality CANNOT be marked "Review" with failing Gherkin scenarios, regardless of other completion status.

Be honest - it's better to flag issues now than have them discovered later.]]

- [ ] I, the Developer Agent, confirm that all applicable items above have been addressed.
- [ ] **CRITICAL**: All Gherkin scenarios pass (for user-facing stories) - this overrides ALL other considerations.
- [ ] DoD checklist results have been added as an issue comment.
- [ ] Issue status and labels have been updated appropriately.
