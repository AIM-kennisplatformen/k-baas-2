#!/bin/bash

# sync-github-status.sh
# Synchronizes status between local story files and GitHub Issues
# Usage: ./sync-github-status.sh <direction> [story-file-path]
# Direction: local-to-github | github-to-local | bidirectional

set -e

# Configuration
REPO="HAN-AIM-CMD-WG/k-baas-2"
PROJECT_BOARD="9"
STORIES_DIR="docs/stories"

# Status mapping
declare -A STATUS_TO_LABEL=(
    ["Draft"]="draft"
    ["Approved"]="approved"
    ["InProgress"]="in-progress"
    ["Review"]="review"
    ["Done"]="done"
)

declare -A LABEL_TO_STATUS=(
    ["draft"]="Draft"
    ["approved"]="Approved"
    ["in-progress"]="InProgress"
    ["review"]="Review"
    ["done"]="Done"
)

# Check if gh CLI is available and authenticated
check_gh_prerequisites() {
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
}

# Function to update local story from GitHub
sync_github_to_local() {
    local story_file="$1"
    local issue_number=$(grep "<!-- GitHub Issue: #" "$story_file" | grep -o '[0-9]\+' | head -1)
    
    if [ -z "$issue_number" ]; then
        echo "⚠️  No GitHub issue found for $story_file"
        return 1
    fi
    
    echo "🔄 Syncing GitHub Issue #$issue_number to $story_file"
    
    # Get issue status from GitHub
    if ! local gh_labels=$(gh issue view "$issue_number" --repo "$REPO" --json labels --jq '.labels[].name' 2>/dev/null | grep -E "draft|approved|in-progress|review|done" | head -1); then
        echo "Error: Failed to get status for GitHub issue #$issue_number"
        echo "Check if the issue exists and you have access to repository: $REPO"
        return 1
    fi
    local new_status="${LABEL_TO_STATUS[$gh_labels]}"
    
    if [ -n "$new_status" ]; then
        # Update status in story file
        local current_status=$(sed -n '4p' "$story_file")
        if [ "$current_status" != "$new_status" ]; then
            sed -i '' "4s/.*/$new_status/" "$story_file"
            echo "✅ Updated $story_file status: $current_status → $new_status"
            
            # Add change log entry
            local date=$(date '+%Y-%m-%d')
            local log_entry="| $date | 1.1 | Status updated from GitHub Issue #$issue_number: $new_status | GitHub Sync |"
            
            # Find change log table and add entry
            if grep -q "| Date | Version | Description | Author |" "$story_file"; then
                sed -i '' "/| Date | Version | Description | Author |/a\\
$log_entry" "$story_file"
            fi
        else
            echo "ℹ️  Status already synchronized"
        fi
    fi
}

# Function to update GitHub from local story
sync_local_to_github() {
    local story_file="$1"
    echo "🔄 Syncing $story_file to GitHub"
    ./scripts/github-sync/update-github-issue.sh "$story_file"
}

# Function to sync bidirectionally (prioritize GitHub)
sync_bidirectional() {
    local story_file="$1"
    echo "🔄 Bidirectional sync for $story_file"
    
    # First sync from GitHub (authoritative)
    sync_github_to_local "$story_file"
    
    # Then ensure GitHub has latest content
    sync_local_to_github "$story_file"
}

# Main execution
DIRECTION="$1"
STORY_FILE="$2"

# Check prerequisites first
check_gh_prerequisites

if [ $# -eq 0 ]; then
    echo "Usage: $0 <direction> [story-file-path]"
    echo ""
    echo "Directions:"
    echo "  local-to-github    - Update GitHub from local story files"
    echo "  github-to-local    - Update local story files from GitHub"
    echo "  bidirectional      - Sync both ways (GitHub takes precedence)"
    echo ""
    echo "Examples:"
    echo "  $0 bidirectional docs/stories/1.1a.basic-repository-structure-setup.md"
    echo "  $0 local-to-github  # Sync all story files"
    exit 1
fi

# Make scripts executable
chmod +x scripts/github-sync/*.sh

case "$DIRECTION" in
    "local-to-github")
        if [ -n "$STORY_FILE" ]; then
            sync_local_to_github "$STORY_FILE"
        else
            echo "🔄 Syncing all story files to GitHub..."
            for file in "$STORIES_DIR"/*.story.md "$STORIES_DIR"/*basic-repository-structure-setup.md; do
                if [ -f "$file" ]; then
                    sync_local_to_github "$file"
                fi
            done
        fi
        ;;
        
    "github-to-local")
        if [ -n "$STORY_FILE" ]; then
            sync_github_to_local "$STORY_FILE"
        else
            echo "🔄 Syncing all GitHub issues to local story files..."
            for file in "$STORIES_DIR"/*.story.md "$STORIES_DIR"/*basic-repository-structure-setup.md; do
                if [ -f "$file" ]; then
                    sync_github_to_local "$file"
                fi
            done
        fi
        ;;
        
    "bidirectional")
        if [ -n "$STORY_FILE" ]; then
            sync_bidirectional "$STORY_FILE"
        else
            echo "🔄 Bidirectional sync for all story files..."
            for file in "$STORIES_DIR"/*.story.md "$STORIES_DIR"/*basic-repository-structure-setup.md; do
                if [ -f "$file" ]; then
                    sync_bidirectional "$file"
                fi
            done
        fi
        ;;
        
    *)
        echo "Error: Invalid direction '$DIRECTION'"
        echo "Valid directions: local-to-github, github-to-local, bidirectional"
        exit 1
        ;;
esac

echo "✅ Synchronization complete!"