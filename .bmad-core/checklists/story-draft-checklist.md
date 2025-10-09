<!-- Powered by BMAD™ Core -->

# Story Draft Checklist

The Scrum Master should use this checklist to validate that each story issue contains sufficient context for a developer agent to implement it successfully, while assuming the dev agent has reasonable capabilities to figure things out.

[[LLM: INITIALIZATION INSTRUCTIONS - STORY DRAFT VALIDATION

Before proceeding with this checklist, ensure you have access to:

1. The story issue being validated (use `gh issue view {issue_number}` to access content)
2. The parent epic issue context (use `gh issue view {epic_issue_number}` for parent epic)
3. Any referenced architecture or design documents
4. Previous related story issues if this builds on prior work
5. Associated task sub-issues (use `gh issue list --label "story-{story_num}"` to find related tasks)

IMPORTANT: This checklist validates individual story issues BEFORE implementation begins.

VALIDATION PRINCIPLES:

1. Clarity - A developer should understand WHAT to build
2. Context - WHY this is being built and how it fits
3. Guidance - Key technical decisions and patterns to follow
4. Testability - How to verify the implementation works
5. Self-Contained - Most info needed is in the story itself

REMEMBER: We assume competent developer agents who can:

- Research documentation and codebases
- Make reasonable technical decisions
- Follow established patterns
- Ask for clarification when truly stuck

We're checking for SUFFICIENT guidance, not exhaustive detail.]]

## 1. GOAL & CONTEXT CLARITY

[[LLM: Without clear goals, developers build the wrong thing. Verify:

1. The story issue states WHAT functionality to implement
2. The business value or user benefit is clear
3. How this fits into the larger epic/product is explained
4. Dependencies are explicit ("requires Story X to be complete")
5. Success looks like something specific, not vague]]

- [ ] Story goal/purpose is clearly stated in issue description
- [ ] Relationship to epic goals is evident (linked to parent epic issue)
- [ ] How the story fits into overall system flow is explained
- [ ] Dependencies on previous story issues are identified (if applicable)
- [ ] Business context and value are clear

## 2. TECHNICAL IMPLEMENTATION GUIDANCE

[[LLM: Developers need enough technical context to start coding. Check:

1. Key files/components to create or modify are mentioned in issue description
2. Technology choices are specified where non-obvious
3. Integration points with existing code are identified
4. Data models or API contracts are defined or referenced
5. Non-standard patterns or exceptions are called out
6. Task sub-issues provide adequate breakdown

Note: We don't need every file listed - just the important ones.]]

- [ ] Key files to create/modify are identified in issue description (not necessarily exhaustive)
- [ ] Technologies specifically needed for this story are mentioned
- [ ] Critical APIs or interfaces are sufficiently described
- [ ] Necessary data models or structures are referenced
- [ ] Required environment variables are listed (if applicable)
- [ ] Any exceptions to standard coding patterns are noted
- [ ] Task sub-issues exist and provide proper implementation breakdown

## 3. REFERENCE EFFECTIVENESS

[[LLM: References should help, not create a treasure hunt. Ensure:

1. References point to specific sections, not whole documents
2. The relevance of each reference is explained
3. Critical information is summarized in the story issue
4. References are accessible (not broken links or unavailable issues)
5. Previous story context is summarized if needed]]

- [ ] References to external documents point to specific relevant sections
- [ ] Critical information from previous story issues is summarized (not just referenced by issue number)
- [ ] Context is provided for why references are relevant
- [ ] References use consistent format (e.g., `docs/filename.md#section` or `#issue_number`)

## 4. SELF-CONTAINMENT ASSESSMENT

[[LLM: Stories should be mostly self-contained to avoid context switching. Verify:

1. Core requirements are in the story issue, not just in references
2. Domain terms are explained or obvious from context
3. Assumptions are stated explicitly
4. Edge cases are mentioned (even if deferred)
5. The story issue could be understood without reading 10 other documents]]

- [ ] Core information needed is included in issue description (not overly reliant on external docs)
- [ ] Implicit assumptions are made explicit
- [ ] Domain-specific terms or concepts are explained
- [ ] Edge cases or error scenarios are addressed

## 5. TESTING GUIDANCE

[[LLM: Testing ensures the implementation actually works. Check:

1. Test approach is specified (unit, integration, e2e)
2. Key test scenarios are listed
3. Success criteria are measurable
4. Special test considerations are noted
5. Acceptance criteria in the story issue are testable
6. **Infrastructure Exemption**: Development infrastructure stories focus on functional verification rather than comprehensive testing]]

- [ ] Required testing approach is outlined in issue description
- [ ] Key test scenarios are identified
- [ ] Success criteria are defined and measurable
- [ ] Special testing considerations are noted (if applicable)
- [ ] For infrastructure stories: Functional verification approach is specified instead of comprehensive test coverage

## VALIDATION RESULT

[[LLM: FINAL STORY VALIDATION REPORT

Generate a concise validation report and add it as a comment to the story issue:

1. Quick Summary
   - Story readiness: READY / NEEDS REVISION / BLOCKED
   - Clarity score (1-10)
   - Major gaps identified

2. Fill in the validation table with:
   - PASS: Requirements clearly met
   - PARTIAL: Some gaps but workable
   - FAIL: Critical information missing

3. Specific Issues (if any)
   - List concrete problems to fix
   - Suggest specific improvements
   - Identify any blocking dependencies

4. Developer Perspective
   - Could YOU implement this story issue as written?
   - What questions would you have?
   - What might cause delays or rework?

5. Issue Status Update
   - If READY: Add "draft-validated" label and move to "Ready" column: `github-issue-manager.sh update-status {issue_number} "Ready"`
   - If NEEDS REVISION: Add "draft-needs-revision" label and assign back to story creator
   - If BLOCKED: Add "draft-blocked" label and list blocking dependencies

Add validation results as issue comment: `gh issue comment {issue_number} --body "Draft Validation Results..."`

Be pragmatic - perfect documentation doesn't exist, but it must be enough to provide the extreme context a dev agent needs to get the work down and not create a mess.]]

| Category                             | Status | Issues |
| ------------------------------------ | ------ | ------ |
| 1. Goal & Context Clarity            | _TBD_  |        |
| 2. Technical Implementation Guidance | _TBD_  |        |
| 3. Reference Effectiveness           | _TBD_  |        |
| 4. Self-Containment Assessment       | _TBD_  |        |
| 5. Testing Guidance                  | _TBD_  |        |

**Final Assessment:**

- READY: The story issue provides sufficient context for implementation
- NEEDS REVISION: The story issue requires updates (see issues)
- BLOCKED: External information required (specify what information)

**Post-Validation Actions:**
- [ ] Validation report added as issue comment
- [ ] Issue labels updated appropriately
- [ ] Issue status/column updated if ready
