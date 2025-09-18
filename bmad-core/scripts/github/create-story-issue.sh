#!/bin/bash
# Create story issue as sub-issue of epic, add to project board (Backlog column)

if [ $# -lt 4 ]; then
  echo '{"error": "Usage: $0 <epic_num> <title> <body> <parent_epic_num>"}' >&2
  exit 1
fi

EPIC_NUM="$1"
TITLE="$2"
BODY="$3"
PARENT_EPIC_NUM="$4"

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

# Enhance body with parent epic reference
ENHANCED_BODY="$BODY

Parent Epic: #$PARENT_EPIC_NUM
Epic: $EPIC_NUM"

# Create story issue and capture the issue number directly
ISSUE_OUTPUT=$(gh issue create --repo "$REPO" --title "$TITLE" --body "$ENHANCED_BODY" --label "story,epic-$EPIC_NUM" --json number)
if [ $? -ne 0 ]; then
  echo '{"error": "Failed to create story issue"}' >&2
  exit 1
fi

STORY_NUM=$(echo "$ISSUE_OUTPUT" | jq -r '.number')
if [ -z "$STORY_NUM" ] || [ "$STORY_NUM" = "null" ]; then
  echo '{"error": "Failed to parse story issue number"}' >&2
  exit 1
fi

# Assign to milestone if it exists - get epic title from parent epic issue
if [ -n "$PARENT_EPIC_NUM" ] && [ "$PARENT_EPIC_NUM" != "" ]; then
  EPIC_TITLE=$(gh issue view "$PARENT_EPIC_NUM" --repo "$REPO" --json title 2>/dev/null | jq -r '.title // empty')
  if [ -n "$EPIC_TITLE" ] && [ "$EPIC_TITLE" != "null" ]; then
    MILESTONE_NUM=$(gh api "repos/$REPO/milestones" | jq -r --arg title "$EPIC_TITLE" '[.[] | select(.title == $title)] | .[0].number // empty')
    if [ -n "$MILESTONE_NUM" ]; then
      gh issue edit "$STORY_NUM" --milestone "$MILESTONE_NUM" --repo "$REPO"
      if [ $? -ne 0 ]; then
        echo '{"warning": "Failed to assign milestone"}' >&2
      fi
    else
      echo '{"warning": "Epic milestone not found: '$EPIC_TITLE'"}' >&2
    fi
  else
    echo '{"warning": "Could not get epic title for milestone assignment"}' >&2
  fi
else
  echo '{"info": "No parent epic specified, skipping milestone assignment"}' >&2
fi

# Add to project board (Backlog column)
BACKLOG_COL_ID=$(gh api "repos/$REPO/projects/$BOARD_ID/columns" | jq -r --arg name "Backlog" '[.[] | select(.name == $name)] | .[0].id // empty')
if [ -n "$BACKLOG_COL_ID" ]; then
  # Add to board using projects API
  gh api --method POST "repos/$REPO/projects/$BOARD_ID/columns/$BACKLOG_COL_ID/cards" \
    -f content_id="$STORY_NUM" -f content_type="Issue" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo '{"success": "Story added to board"}'
  else
    echo '{"warning": "Failed to add to board, manual addition needed"}' >&2
  fi
else
  echo '{"error": "Backlog column not found"}' >&2
  exit 1
fi

# Add comment to parent epic linking this story (only if parent epic exists)
if [ -n "$PARENT_EPIC_NUM" ] && [ "$PARENT_EPIC_NUM" != "" ]; then
  gh issue comment "$PARENT_EPIC_NUM" --body "Story created: #$STORY_NUM - $TITLE" --repo "$REPO" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo '{"warning": "Failed to add comment to parent epic"}' >&2
  fi
fi

echo "{\"story_number\": $STORY_NUM}"