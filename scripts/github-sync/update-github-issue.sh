#!/bin/bash

# update-github-issue.sh
# Updates an existing GitHub issue from a local story file
# Usage: ./update-github-issue.sh <story-file-path> [issue-number]

set -e

# Configuration
REPO="HAN-AIM-CMD-WG/k-baas-2"

# Check if story file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <story-file-path> [issue-number]"
    echo "Example: $0 docs/stories/1.1a.basic-repository-structure-setup.md"
    echo "Example: $0 docs/stories/1.1a.basic-repository-structure-setup.md 123"
    exit 1
fi

STORY_FILE="$1"
ISSUE_NUMBER="$2"

# Check if file exists
if [ ! -f "$STORY_FILE" ]; then
    echo "Error: Story file '$STORY_FILE' not found"
    exit 1
fi

# Extract issue number from file if not provided
if [ -z "$ISSUE_NUMBER" ]; then
    ISSUE_NUMBER=$(grep "<!-- GitHub Issue: #" "$STORY_FILE" | grep -o '[0-9]\+' | head -1)
    if [ -z "$ISSUE_NUMBER" ]; then
        echo "Error: No issue number provided and none found in story file"
        echo "Use: $0 $STORY_FILE <issue-number>"
        exit 1
    fi
fi

# Check if gh CLI is available and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated"
    echo "Run: gh auth login"
    exit 1
fi

echo "Updating GitHub Issue #$ISSUE_NUMBER from $STORY_FILE"

# Extract existing sub-issues from story file
EXISTING_SUB_ISSUES=$(grep "<!-- Sub-Issues: #" "$STORY_FILE" | sed 's/.*#\([0-9,]*\).*/\1/' 2>/dev/null || echo "")

# Extract story information
STORY_TITLE=$(grep "^# Story" "$STORY_FILE" | sed 's/^# Story //' | head -1)
STORY_STATUS=$(grep "^Draft\|^Approved\|^InProgress\|^Review\|^Done" "$STORY_FILE" | head -1)
STORY_CONTENT=$(sed -n '/^## Story/,/^## Acceptance Criteria/p' "$STORY_FILE" | sed '$d')
ACCEPTANCE_CRITERIA=$(sed -n '/^## Acceptance Criteria/,/^## Tasks/p' "$STORY_FILE" | sed '$d')
TASKS=$(sed -n '/^## Tasks \/ Subtasks/,/^## Dev Notes/p' "$STORY_FILE" | sed '$d')

# Generate labels based on story content (same function as create script)
generate_labels() {
    local labels="user-story"
    
    # Epic detection from filename or title
    if [[ "$STORY_FILE" =~ 1\. ]] || [[ "$STORY_TITLE" =~ 1\. ]]; then
        labels="$labels,epic-1-foundation"
    elif [[ "$STORY_FILE" =~ 2\. ]] || [[ "$STORY_TITLE" =~ 2\. ]]; then
        labels="$labels,epic-2-auth"
    elif [[ "$STORY_FILE" =~ 3\. ]] || [[ "$STORY_TITLE" =~ 3\. ]]; then
        labels="$labels,epic-3-schema"
    elif [[ "$STORY_FILE" =~ 4\. ]] || [[ "$STORY_TITLE" =~ 4\. ]]; then
        labels="$labels,epic-4-wiki"
    elif [[ "$STORY_FILE" =~ 5\. ]] || [[ "$STORY_TITLE" =~ 5\. ]]; then
        labels="$labels,epic-5-graph-viz"
    elif [[ "$STORY_FILE" =~ 6\. ]] || [[ "$STORY_TITLE" =~ 6\. ]]; then
        labels="$labels,epic-6-sync"
    elif [[ "$STORY_FILE" =~ 7\. ]] || [[ "$STORY_TITLE" =~ 7\. ]]; then
        labels="$labels,epic-7-ai"
    elif [[ "$STORY_FILE" =~ 8\. ]] || [[ "$STORY_TITLE" =~ 8\. ]]; then
        labels="$labels,epic-8-collab"
    elif [[ "$STORY_FILE" =~ 9\. ]] || [[ "$STORY_TITLE" =~ 9\. ]]; then
        labels="$labels,epic-9-publish"
    elif [[ "$STORY_FILE" =~ 10\. ]] || [[ "$STORY_TITLE" =~ 10\. ]]; then
        labels="$labels,epic-10-admin"
    elif [[ "$STORY_FILE" =~ 11\. ]] || [[ "$STORY_TITLE" =~ 11\. ]]; then
        labels="$labels,epic-11-discuss"
    elif [[ "$STORY_FILE" =~ 12\. ]] || [[ "$STORY_TITLE" =~ 12\. ]]; then
        labels="$labels,epic-12-ux"
    fi
    
    # Status label
    case "$STORY_STATUS" in
        "Draft") labels="$labels,draft" ;;
        "Approved") labels="$labels,approved" ;;
        "InProgress") labels="$labels,in-progress" ;;
        "Review") labels="$labels,review" ;;
        "Done") labels="$labels,done" ;;
        *) labels="$labels,draft" ;;  # Default to draft
    esac
    
    # Component detection based on content
    if grep -q -i "react\|frontend\|ui\|component\|tailwind\|shadcn" "$STORY_FILE"; then
        labels="$labels,frontend"
    fi
    
    if grep -q -i "python\|fastapi\|backend\|api\|server" "$STORY_FILE"; then
        labels="$labels,backend"
    fi
    
    if grep -q -i "typedb\|database\|schema\|query" "$STORY_FILE"; then
        labels="$labels,database"
    fi
    
    if grep -q -i "docker\|deploy\|ci/cd\|github actions\|infrastructure" "$STORY_FILE"; then
        labels="$labels,infrastructure"
    fi
    
    if grep -q -i "test\|testing\|spec\|jest\|pytest" "$STORY_FILE"; then
        labels="$labels,testing"
    fi
    
    if grep -q -i "auth\|security\|permission\|login" "$STORY_FILE"; then
        labels="$labels,security"
    fi
    
    # Size estimation based on task count
    local task_count=$(grep -c "^- \[ \]" "$STORY_FILE" 2>/dev/null || echo "0")
    if [ "$task_count" -le 5 ]; then
        labels="$labels,size-s"
    elif [ "$task_count" -le 15 ]; then
        labels="$labels,size-m"
    elif [ "$task_count" -le 25 ]; then
        labels="$labels,size-l"
    else
        labels="$labels,size-xl"
    fi
    
    # Special markers
    if grep -q -i "breaking\|break" "$STORY_FILE"; then
        labels="$labels,breaking-change"
    fi
    
    if grep -q -i "research\|investigate\|spike" "$STORY_FILE"; then
        labels="$labels,needs-research"
    fi
    
    echo "$labels"
}

STORY_LABELS=$(generate_labels)

# Create updated issue body
ISSUE_BODY="$STORY_CONTENT

$ACCEPTANCE_CRITERIA

$TASKS

---
**Story File:** \`$STORY_FILE\`
**Status:** $STORY_STATUS
**Epic:** 1 - Project Foundation & Infrastructure
**Last Updated:** $(date '+%Y-%m-%d %H:%M:%S')"

# Update the issue
if ! gh issue edit "$ISSUE_NUMBER" \
    --repo "$REPO" \
    --title "$STORY_TITLE" \
    --body "$ISSUE_BODY" 2>/dev/null; then
    echo "Error: Failed to update GitHub issue #$ISSUE_NUMBER"
    echo "Check if the issue exists and you have permissions for repository: $REPO"
    exit 1
fi

# Clear existing labels and apply new ones
echo "📋 Updating labels to: $STORY_LABELS"

# First, get current labels to remove
CURRENT_LABELS=$(gh issue view "$ISSUE_NUMBER" --repo "$REPO" --json labels --jq '.labels[].name' | tr '\n' ',' | sed 's/,$//')

if [ -n "$CURRENT_LABELS" ]; then
    gh issue edit "$ISSUE_NUMBER" --repo "$REPO" --remove-label "$CURRENT_LABELS" 2>/dev/null || true
fi

# Add new labels
gh issue edit "$ISSUE_NUMBER" --repo "$REPO" --add-label "$STORY_LABELS" 2>/dev/null || true

# Close issue if status is Done
if [ "$STORY_STATUS" = "Done" ]; then
    gh issue close "$ISSUE_NUMBER" --repo "$REPO"
    echo "🔒 Issue closed (status: Done)"
fi

# Synchronize sub-issues
echo "📋 Synchronizing sub-issues..."
sync_sub_issues() {
    local parent_issue="$1"
    local story_file="$2"
    local existing_subs="$3"
    local new_sub_issues=""
    
    # Extract current tasks from story
    local task_number=1
    while IFS= read -r line; do
        if [[ "$line" =~ ^###[[:space:]]*Task[[:space:]]*[0-9]+:.* ]]; then
            local task_title=$(echo "$line" | sed 's/^### Task [0-9]*: //' | sed 's/ (AC: [^)]*)$//')
            local ac_ref=$(echo "$line" | grep -o '(AC: [^)]*)' | sed 's/[()]//g')
            
            # Check if sub-issue already exists for this task
            local existing_sub_issue=""
            if [ -n "$existing_subs" ]; then
                # Find existing sub-issue by task number in title
                for sub_num in $(echo "$existing_subs" | tr ',' ' '); do
                    local sub_title=$(gh issue view "$sub_num" --repo "$REPO" --json title --jq '.title' 2>/dev/null || echo "")
                    if [[ "$sub_title" =~ \[.*\][[:space:]]*Task[[:space:]]*$task_number: ]]; then
                        existing_sub_issue="$sub_num"
                        break
                    fi
                done
            fi
            
            if [ -n "$existing_sub_issue" ]; then
                # Update existing sub-issue
                echo "  Updating sub-issue #$existing_sub_issue: $task_title"
                
                # Get task content
                local task_content=""
                local collecting=false
                while IFS= read -r task_line; do
                    if [[ "$task_line" =~ ^###[[:space:]]*Task ]]; then
                        if [ "$collecting" = true ]; then
                            break
                        elif [[ "$task_line" == "$line" ]]; then
                            collecting=true
                            continue
                        fi
                    elif [[ "$task_line" =~ ^##[[:space:]] ]]; then
                        if [ "$collecting" = true ]; then
                            break
                        fi
                    elif [ "$collecting" = true ]; then
                        task_content="$task_content$task_line\n"
                    fi
                done < "$story_file"
                
                local sub_issue_body="**Parent Story:** #$parent_issue - $STORY_TITLE

**Acceptance Criteria Reference:** $ac_ref

**Task Details:**
$task_content

---
**Story File:** \`$story_file\`
**Task Number:** $task_number
**Last Updated:** $(date '+%Y-%m-%d %H:%M:%S')"

                gh issue edit "$existing_sub_issue" \
                    --repo "$REPO" \
                    --title "[$parent_issue] Task $task_number: $task_title" \
                    --body "$sub_issue_body" 2>/dev/null || true
                
                # Track updated sub-issue
                if [ -n "$new_sub_issues" ]; then
                    new_sub_issues="$new_sub_issues,$existing_sub_issue"
                else
                    new_sub_issues="$existing_sub_issue"
                fi
            else
                # Create new sub-issue (similar to create script)
                echo "  Creating new sub-issue: $task_title"
                
                local task_content=""
                local collecting=false
                while IFS= read -r task_line; do
                    if [[ "$task_line" =~ ^###[[:space:]]*Task ]]; then
                        if [ "$collecting" = true ]; then
                            break
                        elif [[ "$task_line" == "$line" ]]; then
                            collecting=true
                            continue
                        fi
                    elif [[ "$task_line" =~ ^##[[:space:]] ]]; then
                        if [ "$collecting" = true ]; then
                            break
                        fi
                    elif [ "$collecting" = true ]; then
                        task_content="$task_content$task_line\n"
                    fi
                done < "$story_file"
                
                local sub_issue_body="**Parent Story:** #$parent_issue - $STORY_TITLE

**Acceptance Criteria Reference:** $ac_ref

**Task Details:**
$task_content

---
**Story File:** \`$story_file\`
**Task Number:** $task_number"

                if SUB_ISSUE_URL=$(gh issue create \
                    --repo "$REPO" \
                    --title "[$parent_issue] Task $task_number: $task_title" \
                    --body "$sub_issue_body" \
                    --label "task,epic-1-foundation,draft,subtask" \
                    2>/dev/null); then
                    
                    local sub_issue_number=$(echo "$SUB_ISSUE_URL" | grep -o '[0-9]\+$')
                    echo "    ✅ Created sub-issue #$sub_issue_number"
                    
                    # Add to project board
                    gh project item-add "$PROJECT_BOARD" --owner "HAN-AIM-CMD-WG" --url "$SUB_ISSUE_URL" 2>/dev/null || true
                    
                    # Track new sub-issue
                    if [ -n "$new_sub_issues" ]; then
                        new_sub_issues="$new_sub_issues,$sub_issue_number"
                    else
                        new_sub_issues="$sub_issue_number"
                    fi
                fi
            fi
            
            task_number=$((task_number + 1))
        fi
    done < "$story_file"
    
    echo "$new_sub_issues"
}

NEW_SUB_ISSUES=$(sync_sub_issues "$ISSUE_NUMBER" "$STORY_FILE" "$EXISTING_SUB_ISSUES")

# Update sub-issues reference in story file if changed
if [ "$NEW_SUB_ISSUES" != "$EXISTING_SUB_ISSUES" ]; then
    if [ -n "$EXISTING_SUB_ISSUES" ]; then
        # Replace existing sub-issues comment
        sed -i '' "s/<!-- Sub-Issues: #$EXISTING_SUB_ISSUES -->/<!-- Sub-Issues: #$NEW_SUB_ISSUES -->/" "$STORY_FILE"
    else
        # Add new sub-issues comment after main issue comment
        sed -i '' "/<!-- GitHub Issue: #$ISSUE_NUMBER -->/a\\
<!-- Sub-Issues: #$NEW_SUB_ISSUES -->" "$STORY_FILE"
    fi
fi

echo "✅ Successfully updated GitHub Issue #$ISSUE_NUMBER"
echo "📋 URL: https://github.com/$REPO/issues/$ISSUE_NUMBER"
echo "📊 Status: $STORY_STATUS"
if [ -n "$NEW_SUB_ISSUES" ]; then
    echo "📋 Sub-issues: #$NEW_SUB_ISSUES"
fi