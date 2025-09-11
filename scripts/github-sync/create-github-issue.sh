#!/bin/bash

# create-github-issue.sh
# Creates a new GitHub issue from a local story file
# Usage: ./create-github-issue.sh <story-file-path>

set -e

# Configuration
REPO="HAN-AIM-CMD-WG/k-baas-2"
PROJECT_BOARD="9"

# Check if story file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <story-file-path>"
    echo "Example: $0 docs/stories/1.1a.basic-repository-structure-setup.md"
    exit 1
fi

STORY_FILE="$1"

# Check if file exists
if [ ! -f "$STORY_FILE" ]; then
    echo "Error: Story file '$STORY_FILE' not found"
    exit 1
fi

# Extract story information
STORY_TITLE=$(grep "^# Story" "$STORY_FILE" | sed 's/^# Story //' | head -1)
STORY_CONTENT=$(sed -n '/^## Story/,/^## Acceptance Criteria/p' "$STORY_FILE" | sed '$d')
ACCEPTANCE_CRITERIA=$(sed -n '/^## Acceptance Criteria/,/^## Tasks/p' "$STORY_FILE" | sed '$d')
TASKS=$(sed -n '/^## Tasks \/ Subtasks/,/^## Dev Notes/p' "$STORY_FILE" | sed '$d')
STORY_STATUS=$(grep "^Draft\|^Approved\|^InProgress\|^Review\|^Done" "$STORY_FILE" | head -1)

# Generate labels based on story content
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

# Create issue body
ISSUE_BODY="$STORY_CONTENT

$ACCEPTANCE_CRITERIA

$TASKS

---
**Story File:** \`$STORY_FILE\`
**Epic:** 1 - Project Foundation & Infrastructure
**Project Board:** #$PROJECT_BOARD"

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

# Create the issue
echo "Creating GitHub issue for: $STORY_TITLE"
echo "📋 Applying labels: $STORY_LABELS"
if ! ISSUE_URL=$(gh issue create \
    --repo "$REPO" \
    --title "$STORY_TITLE" \
    --body "$ISSUE_BODY" \
    --label "$STORY_LABELS" \
    --assignee "@me" 2>/dev/null); then
    echo "Error: Failed to create GitHub issue"
    echo "Check your permissions for repository: $REPO"
    exit 1
fi

# Extract issue number from URL
ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -o '[0-9]\+$')
if [ -z "$ISSUE_NUMBER" ]; then
    echo "Error: Could not extract issue number from: $ISSUE_URL"
    exit 1
fi

echo "✅ Created GitHub Issue #$ISSUE_NUMBER"
echo "📋 URL: $ISSUE_URL"

# Add to project board
echo "Adding issue to project board..."
if ! gh project item-add "$PROJECT_BOARD" --owner "HAN-AIM-CMD-WG" --url "$ISSUE_URL" 2>/dev/null; then
    echo "⚠️  Warning: Created issue but failed to add to project board #$PROJECT_BOARD"
    echo "   You may need to add it manually: $ISSUE_URL"
fi

# Extract and create sub-issues for tasks
echo "📋 Creating sub-issues for tasks..."
create_sub_issues() {
    local parent_issue="$1"
    local story_file="$2"
    local sub_issues=""
    
    # Extract main tasks (### level headers under Tasks/Subtasks)
    local task_number=1
    while IFS= read -r line; do
        if [[ "$line" =~ ^###[[:space:]]*Task[[:space:]]*[0-9]+:.* ]]; then
            # Extract task title and AC reference
            local task_title=$(echo "$line" | sed 's/^### Task [0-9]*: //' | sed 's/ (AC: [^)]*)$//')
            local ac_ref=$(echo "$line" | grep -o '(AC: [^)]*)' | sed 's/[()]//g')
            
            # Get task subtasks (everything until next ### or ##)
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
            
            # Create sub-issue
            local sub_issue_body="**Parent Story:** #$parent_issue - $STORY_TITLE

**Acceptance Criteria Reference:** $ac_ref

**Task Details:**
$task_content

---
**Story File:** \`$story_file\`
**Task Number:** $task_number"

            echo "  Creating sub-issue: $task_title"
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
                
                # Track sub-issues
                if [ -n "$sub_issues" ]; then
                    sub_issues="$sub_issues,$sub_issue_number"
                else
                    sub_issues="$sub_issue_number"
                fi
            else
                echo "    ⚠️  Failed to create sub-issue for: $task_title"
            fi
            
            task_number=$((task_number + 1))
        fi
    done < "$story_file"
    
    echo "$sub_issues"
}

SUB_ISSUES=$(create_sub_issues "$ISSUE_NUMBER" "$STORY_FILE")

# Store issue number and sub-issues in story file
echo "" >> "$STORY_FILE"
echo "<!-- GitHub Issue: #$ISSUE_NUMBER -->" >> "$STORY_FILE"
if [ -n "$SUB_ISSUES" ]; then
    echo "<!-- Sub-Issues: #$SUB_ISSUES -->" >> "$STORY_FILE"
fi

echo "✅ Successfully created and linked GitHub Issue #$ISSUE_NUMBER to $STORY_FILE"
if [ -n "$SUB_ISSUES" ]; then
    echo "📋 Created sub-issues: #$SUB_ISSUES"
fi
echo "🔗 Next steps: Run sync-github-status.sh to manage status updates"