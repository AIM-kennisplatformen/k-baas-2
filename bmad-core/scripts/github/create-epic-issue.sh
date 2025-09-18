#!/bin/bash
# Create epic issue, set milestone, add to project board (Backlog column)

if [ $# -lt 2 ]; then
  echo '{"error": "Usage: $0 <title> <body>"}' >&2
  exit 1
fi

TITLE="$1"
BODY="$2"

source load-config.sh
if [ "$?" -ne 0 ]; then
  echo '{"error": "Failed to load config"}' >&2
  exit 1
fi

source ensure-project-board.sh
if [ "$?" -ne 0 ]; then
  echo '{"error": "Failed to ensure board"}' >&2
  exit 1
fi

# Create issue and capture the issue number directly
ISSUE_OUTPUT=$(gh issue create --repo "$REPO" --title "$TITLE" --body "$BODY" --label "epic" --json number)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to create epic issue"}' >&2
  exit 1
fi

EPIC_NUM=$(echo "$ISSUE_OUTPUT" | jq -r '.number')
if [ -z "$EPIC_NUM" ] || [ "$EPIC_NUM" = "null" ]; then
  echo '{"error": "Failed to parse epic issue number"}' >&2
  exit 1
fi

# Create milestone for epic (check if exists first)
MILESTONE_NUM=$(gh api "repos/$REPO/milestones" | jq -r --arg title "$TITLE" '[.[] | select(.title == $title)] | .[0].number // empty')
if [ -z "$MILESTONE_NUM" ]; then
  gh milestone create --title "$TITLE" --repo "$REPO" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    MILESTONE_NUM=$(gh api "repos/$REPO/milestones" | jq -r --arg title "$TITLE" '[.[] | select(.title == $title)] | .[0].number // empty')
  else
    echo '{"warning": "Milestone creation failed, continuing"}' >&2
  fi
fi

if [ -n "$MILESTONE_NUM" ]; then
  gh issue edit "$EPIC_NUM" --milestone "$MILESTONE_NUM" --repo "$REPO"
  if [ $? -ne 0 ]; then
    echo '{"warning": "Failed to assign milestone"}' >&2
  fi
fi

# Add to project board (Backlog column) - Use classic projects API for simplicity
BACKLOG_COL_ID=$(gh api "repos/$REPO/projects/$BOARD_ID/columns" | jq -r --arg name "Backlog" '[.[] | select(.name == $name)] | .[0].id // empty')
if [ -n "$BACKLOG_COL_ID" ]; then
  # Add card to column using classic projects API
  CARD_RESPONSE=$(gh api --method POST "repos/$REPO/projects/$BOARD_ID/columns/$BACKLOG_COL_ID/cards" \
    -f content_id="$EPIC_NUM" -f content_type="Issue" 2>/dev/null)
  if [ $? -eq 0 ]; then
    echo '{"success": "Epic added to board"}'
  else
    echo '{"warning": "Failed to add to board, manual addition needed"}' >&2
  fi
else
  echo '{"error": "Backlog column not found"}' >&2
  exit 1
fi

echo "{\"epic_number\": $EPIC_NUM}"