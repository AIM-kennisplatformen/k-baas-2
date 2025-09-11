#!/bin/bash

# create-labels.sh
# Creates all necessary labels for the GitHub repository
# Usage: ./create-labels.sh

set -e

REPO="HAN-AIM-CMD-WG/k-baas-2"

echo "Creating GitHub labels for repository: $REPO"

# Check if gh CLI is available and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated"
    exit 1
fi

# Function to create label if it doesn't exist
create_label() {
    local name="$1"
    local description="$2"
    local color="$3"
    
    if gh label view "$name" --repo "$REPO" &> /dev/null; then
        echo "✓ Label '$name' already exists"
    else
        if gh label create "$name" --description "$description" --color "$color" --repo "$REPO" 2>/dev/null; then
            echo "✅ Created label: $name"
        else
            echo "⚠️  Failed to create label: $name"
        fi
    fi
}

# Story Type Labels
create_label "user-story" "Standard user stories" "0052CC"
create_label "task" "Technical tasks without user value" "1F77B4"
create_label "subtask" "Sub-tasks of user stories" "87CEEB"
create_label "bug" "Bug fixes" "D73027"
create_label "documentation" "Documentation updates" "0E8A16"
create_label "chore" "Maintenance tasks" "FEF2C0"

# Epic Labels
create_label "epic-1-foundation" "Project Foundation & Infrastructure" "FF7F0E"
create_label "epic-2-auth" "User Authentication Management" "2CA02C"
create_label "epic-3-schema" "Knowledge Base Creation & Schema Management" "D62728"
create_label "epic-4-wiki" "Wiki Content Management" "9467BD"
create_label "epic-5-graph-viz" "Knowledge Graph Visualization & Editing" "8C564B"
create_label "epic-6-sync" "Bidirectional Synchronization & Property Editing" "E377C2"
create_label "epic-7-ai" "AI Assistance & Knowledge Quality" "7F7F7F"
create_label "epic-8-collab" "Real-time Collaboration" "BCBD22"
create_label "epic-9-publish" "Publishing & Sharing" "17BECF"
create_label "epic-10-admin" "System Administration & Monitoring" "AEC7E8"
create_label "epic-11-discuss" "Commenting and Discussion" "FFBB78"
create_label "epic-12-ux" "User Experience & Accessibility" "98DF8A"

# Status Labels
create_label "draft" "Story is in draft state" "C5DEF5"
create_label "approved" "Story approved for development" "0052CC"
create_label "in-progress" "Currently being developed" "FBCA04"
create_label "review" "Ready for review" "FF9500"
create_label "done" "Completed and verified" "0E8A16"

# Component Labels
create_label "frontend" "React/UI components" "1D76DB"
create_label "backend" "Python/FastAPI components" "0E8A16"
create_label "database" "TypeDB/data layer" "D73027"
create_label "infrastructure" "DevOps/deployment" "5319E7"
create_label "testing" "Test-related work" "FBCA04"
create_label "security" "Security-related work" "D73027"

# Size Labels
create_label "size-xs" "Very small (< 2 hours)" "C2E0C6"
create_label "size-s" "Small (2-8 hours)" "BFDBFE"
create_label "size-m" "Medium (1-2 days)" "FEF3C7"
create_label "size-l" "Large (3-5 days)" "FECACA"
create_label "size-xl" "Very large (> 1 week)" "F4CCCC"

# Priority Labels
create_label "priority-critical" "Must be done immediately" "B60205"
create_label "priority-high" "Should be done soon" "D93F0B"
create_label "priority-medium" "Normal priority" "FBCA04"
create_label "priority-low" "Can be deferred" "0E8A16"

# Special Markers
create_label "blocked" "Cannot proceed due to dependency" "D73027"
create_label "dependency" "Other stories depend on this" "FF9500"
create_label "external-dependency" "Waiting on external resource" "FBCA04"
create_label "breaking-change" "Introduces breaking changes" "B60205"
create_label "needs-design" "Requires design work" "E4E669"
create_label "needs-research" "Requires investigation" "C5DEF5"
create_label "good-first-issue" "Good for new contributors" "7057FF"

echo ""
echo "✅ Label creation complete!"
echo "📋 Repository: https://github.com/$REPO/labels"